#!/usr/bin/env bash
set -e
mkdir -p app/http app/services app/domain app/storage app/events
cat > app/http/routes.py <<'PY'
from app.http.handlers import create_order

ROUTES = {"POST /orders": create_order}
PY
cat > app/http/handlers.py <<'PY'
from app.services.checkout import place


def create_order(request):
    return place(request["cart"], request["customer"])
PY
cat > app/services/checkout.py <<'PY'
from app.domain.pricing import total
from app.events.bus import publish
from app.services.inventory import reserve


def place(cart, customer):
    reserve(cart)
    amount = total(cart)
    publish("order.placed", {"customer": customer, "amount": amount})
PY
cat > app/services/inventory.py <<'PY'
from app.storage.stock import decrement


def reserve(cart):
    for item in cart:
        decrement(item["sku"], item["qty"])
PY
cat > app/domain/pricing.py <<'PY'
def total(cart):
    return sum(item["price"] * item["qty"] for item in cart)
PY
cat > app/events/bus.py <<'PY'
from app.events.subscribers import SUBSCRIBERS


def publish(topic, payload):
    for handler in SUBSCRIBERS.get(topic, []):
        handler(payload)
PY
cat > app/events/subscribers.py <<'PY'
from app.storage.orders import insert_order

SUBSCRIBERS = {"order.placed": [insert_order]}
PY
cat > app/storage/orders.py <<'PY'
from app.storage.db import execute


def insert_order(payload):
    execute("insert into orders (customer, amount) values (?, ?)", payload["customer"], payload["amount"])
PY
cat > app/storage/stock.py <<'PY'
from app.storage.db import execute


def decrement(sku, qty):
    execute("update stock set qty = qty - ? where sku = ?", qty, sku)
PY
cat > app/storage/db.py <<'PY'
def execute(sql, *args):
    raise NotImplementedError
PY
git init -q
