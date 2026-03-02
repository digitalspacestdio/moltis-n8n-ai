## ADDED Requirements

### Requirement: zeroclaw runs as Docker service

The stack SHALL run zeroclaw as a Docker service using ghcr.io/zeroclaw-labs/zeroclaw image, on the same network as n8n.

#### Scenario: zeroclaw starts successfully
- **WHEN** user runs `docker-compose up -d`
- **THEN** zeroclaw container starts and gateway listens on port 3456

#### Scenario: zeroclaw can reach n8n
- **WHEN** zeroclaw runs and n8n is on the same Docker network
- **THEN** zeroclaw can reach n8n at http://n8n:5678/webhook for workflow invocations

### Requirement: Gateway port 3456

zeroclaw gateway SHALL listen on port 3456 to preserve compatibility with existing docs and external references.

#### Scenario: Port mapping
- **WHEN** stack is running
- **THEN** host port 3456 maps to zeroclaw gateway port 3456

### Requirement: Workspace and config persistence

zeroclaw data volume SHALL persist workspace and config; workspace directory SHALL be mountable from host.

#### Scenario: Data persists across restarts
- **WHEN** user stops and restarts the stack
- **THEN** zeroclaw workspace and config are preserved
