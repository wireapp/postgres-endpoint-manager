# PostgreSQL Endpoint Manager

A Kubernetes-native PostgreSQL endpoint management tool for Wire that automatically discovers and manages PostgreSQL cluster topology, updating Kubernetes services to point to the correct read-write and read-only endpoints.

## Requirements

- **Kubernetes**: v1.29+ (requires kubernetes client v30.0.0+)
- **Python**: 3.9+
- **PostgreSQL**: Compatible with psycopg 3.2+

## Dependencies

- `psycopg>=3.2.0` - PostgreSQL database adapter
- `structlog>=24.0.0` - Structured logging
- `kubernetes>=30.0.0` - Kubernetes Python client

## Quick Start

### Using Docker

```bash
# Pull the latest image
docker pull sukisuk/postgres-endpoint-manager:latest

# Run the container
docker run --rm sukisuk/postgres-endpoint-manager:latest --help
```

### Local Development

```bash
# Clone the repository
git clone https://github.com/wireapp/postgres-endpoint-manager.git
cd postgres-endpoint-manager

# Install dependencies
pip install -r requirements.txt

# Run tests
python -m pytest tests/
```

### Staying Updated

For the latest changes and release notes, see the [Changelog](CHANGELOG.md).

## Configuration

The application requires the following environment variables:

### Required
- `PG_NODES`: Comma-separated list of PostgreSQL node IP addresses/hostnames
- `NAMESPACE`: Kubernetes namespace (default: `default`)

### Optional
- `RW_SERVICE`: Read-write service name (default: `{CHART_NAME}-rw`)
- `RO_SERVICE`: Read-only service name (default: `{CHART_NAME}-ro`)
- `PGUSER`: PostgreSQL username (default: `repmgr`)
- `PGPASSWORD`: PostgreSQL password (default: `securepassword`)
- `PGDATABASE`: PostgreSQL database name (default: `repmgr`)
- `PGCONNECT_TIMEOUT`: Connection timeout in seconds (default: `5`)
- `PGPORT`: PostgreSQL port (default: `5432`)
- `PGSSLMODE`: SSL mode for connections (default: empty)
- `TCP_CONNECT_TIMEOUT`: TCP connection timeout (default: `1.0`)
- `MAX_WORKERS`: Maximum worker threads (default: `3`)
- `CHART_NAME`: Helm release name for service naming (default: `postgres-external`)

## Development

### Building

```bash
# Build Docker image
make build-pg-manager

# Build for multiple platforms
make build-pg-manager-multi

# Run tests
make test-pg-manager

# Push to registry
make push-pg-manager
```

### Testing

The project includes comprehensive test scenarios:

```bash
# Run all tests
make test-pg-manager

# Test with custom configuration
make test-pg-manager-custom

# Interactive testing
make test-pg-manager-interactive
```

### Releasing

Create a semantic version tag to trigger automated release:

```bash
git tag v1.0.0
git push origin v1.0.0
```

This will build and push images with tags: `1.0.0`, `1.0`, `1`, `latest`

## Architecture

The PostgreSQL Endpoint Manager consists of several key components:

- **Orchestrator**: Main coordination logic
- **KubeClient**: Kubernetes API interactions
- **PostgresChecker**: Database connectivity and health checks
- **TopologyVerifier**: Cluster topology validation
- **EndpointUpdater**: Kubernetes service endpoint management

For a detailed visual representation of the application flow, see the [Communication Flow Diagram](docs/communicationflow.mmd).

## Documentation

- **[Container Entrypoint](docs/entrypoint.md)** - Detailed information about the container structure, entrypoint flow, and package organization
- **[Communication Flow](docs/communicationflow.mmd)** - Mermaid diagram showing the complete application flow from startup to endpoint updates
- **[CI/CD Pipeline](docs/PG_MANAGER_CI.md)** - Comprehensive guide to the CI pipeline, runtime vs test images, and debugging workflows
- **[Changelog](CHANGELOG.md)** - Complete history of changes and releases

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.
