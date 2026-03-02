## ADDED Requirements

### Requirement: zeroclaw config example provided

The project SHALL provide an example zeroclaw config (config.toml format) at config/zeroclaw.example.toml with gateway and n8n webhook base.

#### Scenario: Example config exists
- **WHEN** user clones the repo
- **THEN** config/zeroclaw.example.toml exists with documented gateway.port, gateway.host, and n8n webhook URL

### Requirement: Config mounted into zeroclaw container

Custom config SHALL be mountable into the zeroclaw container so users can override defaults without rebuilding.

#### Scenario: User provides custom config
- **WHEN** user creates config/zeroclaw.toml from the example and runs docker-compose
- **THEN** zeroclaw uses the mounted config
