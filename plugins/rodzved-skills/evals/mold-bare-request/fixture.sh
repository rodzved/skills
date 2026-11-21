#!/usr/bin/env bash
set -e
mkdir -p src
cat > src/todos.py <<'PY'
import json

TODOS_FILE = "todos.json"


def load():
    with open(TODOS_FILE) as f:
        return json.load(f)


def add(title):
    todos = load()
    todos.append({"title": title, "done": False})
    with open(TODOS_FILE, "w") as f:
        json.dump(todos, f)
PY
cat > src/cli.py <<'PY'
import sys

from src.todos import add, load


def main():
    if sys.argv[1] == "add":
        add(sys.argv[2])
    elif sys.argv[1] == "list":
        for todo in load():
            print(("[x] " if todo["done"] else "[ ] ") + todo["title"])


if __name__ == "__main__":
    main()
PY
printf '[]\n' > todos.json
git init -q
