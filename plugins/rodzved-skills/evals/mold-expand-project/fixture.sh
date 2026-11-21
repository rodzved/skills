#!/usr/bin/env bash
set -e
mkdir -p deploykit/roles app
cat > README.md <<'MD'
# Notes app

A small notes web app. The server it runs on is set up by `deploykit/`.
MD
cat > app/main.py <<'PY'
def handler(request):
    return {"notes": []}
PY
cat > deploykit/README.md <<'MD'
# deploykit

Sets up the one VPS the app runs on. Run `./apply.sh` from a laptop.

- `roles/firewall.yml`: opens ports 22, 80 and 443.
- `roles/quillgate.yml`: the quillgate reverse proxy in front of the app.
- `roles/users.yml`: the deploy user and its SSH key.
MD
cat > deploykit/inventory.ini <<'INI'
[app]
vps-01 ansible_host=203.0.113.10
INI
cat > deploykit/roles/firewall.yml <<'YML'
- name: allow ssh, http and https
  ufw: { rule: allow, port: "{{ item }}" }
  loop: [22, 80, 443]
YML
cat > deploykit/roles/quillgate.yml <<'YML'
- name: install the quillgate reverse proxy
  copy: { src: quillgate.conf, dest: /etc/quillgate/quillgate.conf }
YML
cat > deploykit/roles/users.yml <<'YML'
- name: create the deploy user
  user: { name: deploy, groups: sudo }
YML
printf '#!/usr/bin/env bash\nansible-playbook -i inventory.ini roles/*.yml\n' > deploykit/apply.sh
chmod +x deploykit/apply.sh
git init -q
