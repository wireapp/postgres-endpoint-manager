## Builder stage: install build deps and Python packages
FROM python:3.9-slim as builder

# Install build-time tools and the test-only client (postgresql-client) here so the
# final runtime image can be minimal. We'll trim installed site-packages in the
# builder after pip install to remove tests and caches.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    postgresql-client \
    curl \
    jq \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
COPY requirements.txt .
RUN python -m pip install --upgrade pip setuptools wheel
# Install into a private prefix so we can copy only the site-packages into the
# final image and avoid overwriting the distroless Python runtime binary.
RUN python -m pip install --prefix=/install --upgrade -r requirements.txt

# Ensure the builder image knows to load site-packages we installed into /install
# This is important because we run the builder stage image (tagged as -test) to
# execute the test harness; without PYTHONPATH the /install prefix isn't on
# sys.path and imports (structlog, psycopg, etc.) fail at runtime.
ENV PYTHONPATH=/install/lib/python3.9/site-packages:/usr/local/lib/python3.9/site-packages:/app:/app/src:$PYTHONPATH

# Test that psycopg can be imported (fail fast if dependencies are missing)
RUN python -c "import psycopg; print(f'psycopg {psycopg.__version__} imported successfully')"

# Verify that runtime libraries were collected
RUN ls -la /install/_runtime_libs/ | head -10

# Trim common unnecessary files from the installed packages to reduce final size
RUN find /install -type d -name 'tests' -exec rm -rf {} + || true
RUN find /install -type d -name '__pycache__' -exec rm -rf {} + || true
RUN find /install -name '*.pyc' -delete || true
RUN rm -rf /install/pip* /install/*.dist-info/*-info || true

# Collect runtime libs (libpq, libssl, libcrypto) into a known location so we
# can copy them reliably into the final distroless image. Use ldconfig to find
# the actual installed filenames.
RUN mkdir -p /install/_runtime_libs && \
        for lib in libpq libssl libcrypto; do \
            for f in $(ldconfig -p | awk '/"$lib"/ {print $NF}' | sort -u 2>/dev/null); do \
                cp -L "$f" /install/_runtime_libs/ || true; \
            done || true; \
        done || true

# Copy source code for testing in the builder stage
COPY src /app/src
COPY tests /app/tests

## Final stage: minimal runtime using Debian slim with proper library support
FROM debian:11-slim

# Install Python and only the runtime dependencies we need
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    libpq5 \
    libssl1.1 \
    openssl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create a symlink for python if needed
RUN ln -sf /usr/bin/python3 /usr/bin/python || true

# Copy installed Python site-packages from the builder
COPY --from=builder /install/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/

# Copy source code
COPY src /app/src

# Ensure Python will search the installed site-packages at runtime
ENV PYTHONPATH=/usr/local/lib/python3.9/site-packages:/app:/app/src

# Create a non-root user for security
RUN useradd --create-home --shell /bin/bash app \
    && chown -R app:app /app
USER app

# Entrypoint: run the package CLI module directly
ENTRYPOINT ["python", "-m", "src.cli"]