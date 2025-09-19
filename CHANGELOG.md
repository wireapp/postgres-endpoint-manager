# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-09-19

### Added
- Initial release of PostgreSQL Endpoint Manager
- Kubernetes-native PostgreSQL cluster endpoint management
- Automatic discovery and management of PostgreSQL read-write and read-only endpoints
- Comprehensive configuration via environment variables
- Multi-platform Docker builds (AMD64/ARM64)
- Extensive test suite with multiple scenarios
- Detailed documentation and architecture guides
- CI/CD pipeline with automated releases

### Changed
- Switched from distroless to Debian 11 slim base image for proper C library support
- Updated Python version requirement from 3.12+ to 3.9+ for compatibility
- Improved Docker registry configuration and build process
- Enhanced Makefile with comprehensive build, test, and deployment targets

### Fixed
- Resolved psycopg runtime import errors in Kubernetes deployments
- Fixed PostgreSQL client library dependencies in container images
- Corrected package structure and module imports
- Updated documentation to reflect actual implementation

### Technical Details
- **Base Image**: Debian 11 slim with Python 3.9
- **Dependencies**: psycopg>=3.2.0, structlog>=24.0.0, kubernetes>=30.0.0
- **Architecture**: Multi-component system with orchestrator, topology verifier, and endpoint updater
- **Testing**: Comprehensive test harness with mocked dependencies and real cluster scenarios

### Documentation
- Complete README with setup, configuration, and usage instructions
- Container entrypoint documentation
- Communication flow diagrams
- CI/CD pipeline documentation
- Architecture component descriptions

---

### Release Process
This project uses semantic versioning. To release a new version:

1. Update version in relevant files
2. Update this changelog
3. Create and push git tag: `git tag v1.2.3 && git push origin v1.2.3`
4. CI/CD pipeline will automatically build and publish Docker images

### Types of Changes
- **Added** for new features
- **Changed** for changes in existing functionality
- **Deprecated** for soon-to-be removed features
- **Removed** for now removed features
- **Fixed** for any bug fixes
- **Security** in case of vulnerabilities