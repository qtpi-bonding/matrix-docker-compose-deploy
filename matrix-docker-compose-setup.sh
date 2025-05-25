ansible-playbook -i inventory/hosts setup.yml --tags=install-all,ensure-matrix-users-created

ansible-playbook -i inventory/hosts setup.yml --tags=stop

rm -f /etc/systemd/system/matrix*.{service,timer}

systemctl daemon-reload