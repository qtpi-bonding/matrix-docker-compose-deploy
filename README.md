# Matrix Docker Compose Deploy

## Overview

This project utilizes the Matrix Ansible Docker Deploy project as a submodule for history tracking while refactoring the existing functionality to convert the setup from a Docker + systemd configuration to a Docker Compose-based deployment. The goal is to simplify the deployment process and enhance the user experience for setting up a Matrix homeserver.

## Purpose

The purpose of this project is to provide an easy-to-use Docker Compose configuration for running your own Matrix homeserver. This allows you to join the Matrix network with your own user ID (e.g., @alice:example.com), all hosted on your own server. The Docker Compose setup ensures a predictable and up-to-date environment across various supported distributions and architectures.

## License

This project is licensed under the AGPL-3.0 license. You are free to use, modify, and distribute this project under the terms of the AGPL-3.0 license. Please refer to the [LICENSE](LICENSE) file for more details.

## Getting Started

To get started with this Docker Compose deployment of the Matrix homeserver, follow these steps:

1. **Clone the Repository**: 
   ```bash
   git clone https://github.com/yourusername/matrix-docker-compose-deploy.git
   cd matrix-docker-compose-deploy
   ```

2. **Configure Environment Variables**: 
   Create a `.env` file based on the provided `.env.example` file and customize it according to your needs.

3. **Start the Services**: 
   Use Docker Compose to start the services:
   ```bash
   docker-compose up -d
   ```

4. **Access the Matrix Server**: 
   Once the services are up and running, you can access your Matrix server at the specified URL.

## Supported Services

This Docker Compose setup supports various services related to Matrix, including:

- **Homeserver**: 
  - Synapse

- **Clients**: 
  - Element Web

- **Server Components**: 
  - PostgreSQL
  - coturn
  - Traefik
  - Let's Encrypt

- **Administration**:
  - Synapse Admin

- **Push Notifications**:
  - Sygnal

---

This README provides an overview of the Matrix Docker Compose Deployment project, ensuring compliance with the AGPL-3.0 license while guiding users through the setup and usage of the project.