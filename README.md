# CKAN Container

Builds a CKAN 2.9.5 container image.

A quick way to spin up a development environment using docker-compose or use the build images for a production deployment.

Included extensions:

* ckanext-dcat
* ckanext-xloader

## Quick Start

Build and start CKAN:

```
docker-compose up --build --detach
```

This starts CKAN, a CKAN worker, PostgreSQL 13.x, Solr 8.x, and Redis 6.x. Once all services have started, browse to http://localhost:8000.

Stop CKAN:

```
docker-compose down
```

NOTE: All data will be erased when CKAN is stopped.

## Building

Build the CKAN image:

```
docker build -t ckan .
```
