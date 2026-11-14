#!/usr/bin/env bash
set -e
mkdir -p app/routes app/services app/storage tests
cat > README.md <<'MD'
# Shop API

Flask app. Production runs two instances behind a load balancer, four gunicorn
workers each. There is no shared cache or Redis; Postgres is the only service.

Clients send `X-Api-Key`. Search and health also accept anonymous requests.
MD
printf 'web: gunicorn app.wsgi:application --workers 4\n' > Procfile
printf 'flask\ngunicorn\npsycopg\n' > requirements.txt
cat > app/__init__.py <<'PY'
from flask import Flask

from app.middleware import log_requests
from app.routes import health, orders, search


def create_app():
    app = Flask(__name__)
    log_requests(app)
    for module in (health, orders, search):
        app.register_blueprint(module.blueprint)
    return app
PY
cat > app/wsgi.py <<'PY'
from app import create_app

application = create_app()
PY
cat > app/config.py <<'PY'
import os

API_KEYS = set(os.environ["API_KEYS"].split(","))
DATABASE_URL = os.environ["DATABASE_URL"]
PY
cat > app/auth.py <<'PY'
from flask import abort, request

from app.config import API_KEYS


def api_key():
    key = request.headers.get("X-Api-Key")
    if key is not None and key not in API_KEYS:
        abort(401)
    return key


def require_api_key():
    key = api_key()
    if key is None:
        abort(401)
    return key
PY
cat > app/middleware.py <<'PY'
import logging

from flask import request

log = logging.getLogger("shop")


def log_requests(app):
    @app.before_request
    def _log():
        log.info("%s %s", request.method, request.path)
PY
cat > app/routes/__init__.py <<'PY'
PY
cat > app/routes/health.py <<'PY'
from flask import Blueprint

blueprint = Blueprint("health", __name__)


@blueprint.get("/health")
def health():
    return {"ok": True}
PY
cat > app/routes/search.py <<'PY'
from flask import Blueprint, request

from app.auth import api_key
from app.services.search import find_products

blueprint = Blueprint("search", __name__)


@blueprint.get("/search")
def search():
    api_key()
    return {"results": find_products(request.args.get("q", ""))}
PY
cat > app/routes/orders.py <<'PY'
from flask import Blueprint, request

from app.auth import require_api_key
from app.services.orders import create_order, list_orders

blueprint = Blueprint("orders", __name__)


@blueprint.get("/orders")
def index():
    return {"orders": list_orders(require_api_key())}


@blueprint.post("/orders")
def create():
    return create_order(require_api_key(), request.get_json()), 201
PY
cat > app/services/__init__.py <<'PY'
PY
cat > app/services/search.py <<'PY'
from app.storage.db import fetch_all


def find_products(term):
    return fetch_all("select id, name from products where name ilike %s", f"%{term}%")
PY
cat > app/services/orders.py <<'PY'
from app.storage.db import execute, fetch_all


def list_orders(key):
    return fetch_all("select id, total from orders where api_key = %s", key)


def create_order(key, body):
    execute("insert into orders (api_key, total) values (%s, %s)", key, body["total"])
    return {"total": body["total"]}
PY
cat > app/storage/__init__.py <<'PY'
PY
cat > app/storage/db.py <<'PY'
import psycopg

from app.config import DATABASE_URL


def fetch_all(sql, *args):
    with psycopg.connect(DATABASE_URL) as conn:
        return conn.execute(sql, args).fetchall()


def execute(sql, *args):
    with psycopg.connect(DATABASE_URL) as conn:
        conn.execute(sql, args)
PY
cat > tests/test_health.py <<'PY'
from app import create_app


def test_health():
    assert create_app().test_client().get("/health").json == {"ok": True}
PY
git init -q
