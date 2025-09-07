# Matrix Docker Compose Deploy

## Overview

This project provides a Docker Compose-based deployment for a Matrix homeserver, refactoring the setup originally derived from the [Matrix Ansible Docker Deploy](https://github.com/spantaleev/matrix-docker-ansible-deploy) project. We leverage the upstream project as a submodule for historical tracking and its robust configuration capabilities, while specifically translating its established functionality into a simplified Docker Compose architecture.

The goal is to streamline the deployment process and enhance the user experience for setting up a Matrix homeserver with a more direct Docker-native approach via Docker Compose.

## Purpose

The primary purpose of this project is to transition running Matrix homeserver from systemd to docker compose.

**Important Note:** This repository is a specialized derivative of the general-purpose `matrix-docker-ansible-deploy` project. While it uses the upstream project for initial configuration generation, this repository specifically provides Docker Compose files tailored for a particular set of services, rather than supporting all the options in the entire `matrix-docker-ansible-deploy` project.

## License

This project is licensed under the AGPL-3.0 license. You are free to use, modify, and distribute this project under the terms of the AGPL-3.0 license. Please refer to the LICENSE file for more details.

---

## Getting Started

To get started with this Docker Compose deployment of the Matrix homeserver, follow these steps:

1.  **Clone the Repository**:
    ```bash
    git clone [https://github.com/qtpi-bonding/matrix-docker-compose-deploy.git](https://github.com/qtpi-bonding/matrix-docker-compose-deploy.git)
    cd matrix-docker-compose-deploy
    ```

2.  **Clone and Configure the Upstream Ansible Playbook**:
    This project relies on the `matrix-docker-ansible-deploy` repository to generate the necessary configuration files for your Matrix homeserver components.

    * First, clone the upstream repository to a sibling directory and check out the specific commit this project is based on:
        ```bash
        cd .. # Go up one directory from matrix-docker-compose-deploy
        git clone [https://github.com/spantaleev/matrix-docker-ansible-deploy.git](https://github.com/spantaleev/matrix-docker-ansible-deploy.git)
        cd matrix-docker-ansible-deploy
        git checkout 2a9cf7de9748177809352f5d253d440f849dbf60 # Check out the specific tested commit
        ```
    * **Configure the Ansible playbook** using the upstream project's comprehensive documentation. You will primarily interact with the `inventory/host_vars/matrix.{DOMAIN_NAME}/vars.yml` file:
        **Refer to the official configuration guide:** [https://github.com/spantaleev/matrix-docker-ansible-deploy/blob/master/docs/configuring-playbook.md](https://github.com/spantaleev/matrix-docker-ansible-deploy/blob/master/docs/configuring-playbook.md)

    * **Crucially, note that this Docker Compose setup currently supports only the following Matrix services:**
        * `matrix-coturn`
        * `matrix-client-element`
        * `matrix-postgres`
        * `matrix-synapse`
        * `matrix-static-files`
        * `matrix-sygnal`
        * `matrix-synapse-admin`
        * `matrix-traefik-certs-dumper`
        * `matrix-traefik`
        * `matrix-container-socket-proxy`

        Ensure your `vars.yml` configuration (especially `matrix_homeserver_services_enabled` and similar options) aligns with these supported services to avoid generating unnecessary configurations for components not included in this Docker Compose setup.

**NOTE**: May need to change `network: traefik` to `network: traefik_network` in `/matrix/traefik/config/traefik.yml`

```yaml
providers:
  docker:
    endpoint: tcp://matrix-container-socket-proxy:2375
    exposedByDefault: false
    network: traefik_network   
```

3.  **Replace placeholder in docker-compose.yml and vars.yml with your domain name**
    * Replace `{DOMAIN_NAME}` with your domain (e.g. `example.com`).
        ```bash
        sed -i 's/{DOMAIN_NAME}/example.com/' docker-compose.yml
        sed -i 's/{DOMAIN_NAME}/example.com/' vars.yml
        ```

4.  **Replace placeholder in vars.yml with your app bundle id**
    * Replace `app_bundle_id` with your app bundle id (e.g. `app.example`).
        ```bash
        sed -i 's/app_bundle_id/app.example/' vars.yml
        ```

5.  **Replace placeholder in vars.yml with your keycloak realm name**
    * Replace `{realm_name}` with your app bundle id (e.g. `realm0`).
        ```bash
        sed -i 's/{realm_name}/realm0/' vars.yml
        ```
6.  **Move firebase-admin-sdk.json into /matrix/sygnal/config/ **
---

## Deployment Steps using `matrix-docker-compose-setup.sh`

All the necessary Ansible configuration generation and `systemd` cleanup steps are automated in the `matrix-docker-compose-setup.sh` script provided in this repository.

1.  **Run the Setup Script**:
    ```bash
    ./matrix-docker-compose-setup.sh
    ```
    This script will perform the following actions:
    * Run `ansible-playbook -i inventory/hosts setup.yml --tags=install-all,ensure-matrix-users-created` to generate all configuration files and ensure necessary host users are created.
    * Run `ansible-playbook -i inventory/hosts setup.yml --tags=stop` to stop any Matrix services that Ansible might have started or left running.
    * Remove all `matrix*.{service,timer}` unit files from `/etc/systemd/system/` to prevent `systemd` from interfering with Docker Compose.
    * Run `systemctl daemon-reload` to reload the `systemd` daemon.
    * Run `sed -i 's/network: traefik/network: traefik_network/' /matrix/traefik/config/traefik.yml` to change `network: traefik` to `network: traefik_network` in `/matrix/traefik/config/traefik.yml`

```yaml
providers:
  docker:
    endpoint: tcp://matrix-container-socket-proxy:2375
    exposedByDefault: false
    network: traefik_network   
```

2.  **Deploy with Docker Compose**:
    * Finally, run `docker compose up -d` to start your Matrix homeserver stack using Docker Compose.

3.  **Monitor Your Deployment**:
    Once the script finishes, you can check the status of your services with:
    ```bash
    docker compose ps
    ```
    And view their logs with:
    ```bash
    docker compose logs -f
    ```

---

## OIDC Configuration 

Matrix-Authentication-Service is not configured on its own subdomain but rather its own path (/auth).

Therefore the OIDC URIs are:
* `redirect_uri`: `https://<auth-service-domain>/auth/upstream/callback/<id>`
* `backchannel_logout_uri` (optional): `https://<auth-service-domain>/auth/upstream/backchannel-logout/<id>`

---

This README provides an overview of the Matrix Docker Compose Deployment project, ensuring compliance with the AGPL-3.0 license while guiding users through the setup and usage of the project.





Tested on commit: 2a9cf7de9748177809352f5d253d440f849dbf60
