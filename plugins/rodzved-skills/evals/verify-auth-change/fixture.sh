#!/usr/bin/env bash
set -e
mkdir -p app/routes tests
cat > README.md <<'MD'
# Orders API

Clients send `X-Api-Key`. A key is valid while it is in `API_KEYS`. Support revokes a
leaked key by adding it to `REVOKED_KEYS`.

Run the tests with `uv run python -m unittest`.
MD
cat > app/__init__.py <<'PY'
PY
cat > app/config.py <<'PY'
API_KEYS = {"k-live-1", "k-live-2", "k-old-9"}
REVOKED_KEYS = {"k-old-9"}
PY
cat > app/auth.py <<'PY'
from app.config import API_KEYS


class Unauthorized(Exception):
    pass


def require_api_key(headers):
    key = headers.get("X-Api-Key")
    if key is None or key not in API_KEYS:
        raise Unauthorized
    return key
PY
cat > app/routes/__init__.py <<'PY'
PY
cat > app/routes/orders.py <<'PY'
from app.auth import require_api_key

ORDERS = {"k-live-1": [{"id": 1, "total": 40}], "k-old-9": [{"id": 2, "total": 15}]}


def list_orders(headers):
    return ORDERS.get(require_api_key(headers), [])
PY
cat > tests/__init__.py <<'PY'
PY
cat > tests/test_auth.py <<'PY'
import unittest

from app.auth import Unauthorized, require_api_key


class RequireApiKeyTest(unittest.TestCase):
    def test_known_key_passes(self):
        self.assertEqual(require_api_key({"X-Api-Key": "k-live-1"}), "k-live-1")

    def test_missing_key_is_rejected(self):
        with self.assertRaises(Unauthorized):
            require_api_key({})

    def test_unknown_key_is_rejected(self):
        with self.assertRaises(Unauthorized):
            require_api_key({"X-Api-Key": "k-nope"})
PY
git init -q
git add .
git -c user.name=fixture -c user.email=fixture@example.invalid -c commit.gpgsign=false \
  commit -q -m "Orders API"
