# PostgreSQL Endpoint Manager - Container Entrypoint

## Overview

The PostgreSQL Endpoint Manager runs as a containerized application with a clean Python package structure using the `src/` layout.

## Entrypoint Flow

```
Container Start
    ↓
python -m src.cli
    ↓
Load environment variables (PG_NODES, RW_SERVICE, RO_SERVICE)
    ↓
Initialize Kubernetes client
    ↓
Discover PostgreSQL topology
    ↓
Update Kubernetes endpoints
    ↓
Exit
```

## Container Structure

- **Base**: Debian 11 slim with Python 3.9 (provides C library support for psycopg)
- **Package**: `/app/src/`
- **Entrypoint**: `python -m src.cli`
- **User**: Non-root (app user)

## Running the Container

```bash
# Production run
docker run --rm sukisuk/postgres-endpoint-manager:latest

# Development with custom environment
docker run --rm \
  -e PG_NODES="10.0.0.1,10.0.0.2,10.0.0.3" \
  -e RW_SERVICE="postgres-rw" \
  -e RO_SERVICE="postgres-ro" \
  sukisuk/postgres-endpoint-manager:latest
```

## Testing

```bash
# Run comprehensive test suite
make test-pg-manager

# Manual test with mounted tests
docker run --rm \
  -v $(pwd)/tests:/app/tests \
  --entrypoint python3 \
  sukisuk/postgres-endpoint-manager-test:latest \
  /app/tests/test_postgres_endpoint_manager.py --comprehensive
```

## Package Structure

```
src/
├── __init__.py      # Package initialization
├── cli.py           # Main entrypoint
├── config.py        # Configuration management
├── db.py            # Database connectivity
├── exceptions.py    # Custom exceptions
├── kube.py          # Kubernetes client
├── logging_.py      # Logging configuration
├── orchestrator.py  # Main orchestration logic
├── topology.py      # Node discovery and topology
├── updater.py       # Endpoint updates
└── utils.py         # Utility functions
```

The package follows Python packaging standards with clean module separation and comprehensive logging.
