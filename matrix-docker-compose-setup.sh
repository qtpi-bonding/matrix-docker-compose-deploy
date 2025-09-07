ansible-playbook -i inventory/hosts setup.yml --tags=install-all,ensure-matrix-users-created

ansible-playbook -i inventory/hosts setup.yml --tags=stop

rm -f /etc/systemd/system/matrix*.{service,timer}

systemctl daemon-reload

sed -i 's/network: traefik/network: traefik_network/' /matrix/traefik/config/traefik.yml
