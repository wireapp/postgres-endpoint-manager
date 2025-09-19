# PostgreSQL Endpoint Manager

A Kubernetes-native PostgreSQL endpoint management tool for Wire.

## Requirements

- **Kubernetes**: v1.29.x (requires kubernetes client v30.0.0+)
- **Python**: 3.12+
- **PostgreSQL**: Compatible with psycopg 3.2+

## Quick Start

### Using Docker

```bash
# Pull the latest image
docker pull quay.io/wire/postgres-endpoint-manager:latest

# Run the container
docker run --rm quay.io/wire/postgres-endpoint-manager:latest --help
```

### Local Development

```bash
# Clone the repository
git clone <repository-url>
cd postgres-endpoint-manager

# Install dependencies
pip install -r requirements.txt

# Run tests
python -m pytest tests/
```

## Configuration

The application requires the following environment variables:

- `KUBECONFIG`: Path to Kubernetes configuration file
- `POSTGRES_HOST`: PostgreSQL server hostname
- `POSTGRES_PORT`: PostgreSQL server port (default: 5432)
- `POSTGRES_USER`: PostgreSQL username
- `POSTGRES_PASSWORD`: PostgreSQL password

## Development

### Building

```bash
# Build Docker image
docker build -t postgres-endpoint-manager .

# Run tests
docker run --rm postgres-endpoint-manager python -m pytest tests/
```

### Releasing

Create a semantic version tag to trigger automated release:

```bash
git tag v1.0.0
git push origin v1.0.0
```

This will build and push images with tags: `1.0.0`, `1.0`, `1`, `latest`

## License

[Add license information here]
