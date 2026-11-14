#!/usr/bin/env bash
set -e
mkdir -p src
cat > src/users.py <<'PY'
from src.db import query


def get_user(user_id):
    return query("select * from users where id = ?", user_id)
PY
cat > src/db.py <<'PY'
def query(sql, *args):
    raise NotImplementedError
PY
cat > src/api.py <<'PY'
from src.users import get_user


def profile(user_id):
    return get_user(user_id)
PY
git init -q
