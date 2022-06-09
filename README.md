# CKAN Container

Builds a CKAN 2.9.5 container image.

A quick way to spin up a development environment using docker-compose or use the build images for a production deployment.

Included extensions:

* ckanext-dcat
* ckanext-xloader
* ckanext-s3filestore

## Settings for ckanext-s3sfilestore
With this extension ckan will store resources into an S3 bucket, instead of the local file-store.

Add s3filestore to the `ckan.plugins` setting in your CKAN config file 

### Config Settings

Required:

```
ckanext.s3filestore.aws_bucket_name = a-bucket-to-store-your-stuff
ckanext.s3filestore.region_name= region-name
ckanext.s3filestore.signature_version = s3v4
```
Conditional:
```
ckanext.s3filestore.aws_access_key_id = Your-Access-Key-ID
ckanext.s3filestore.aws_secret_access_key = Your-Secret-Access-Key

Or:

ckanext.s3filestore.aws_use_ami_role = true
```

Optional:

```
# An optional path to prepend to keys
ckanext.s3filestore.aws_storage_path = my-site-name

# An optional setting to fallback to filesystem for downloads
ckanext.s3filestore.filesystem_download_fallback = true
# The ckan storage path option must also be set correctly for the fallback to work
ckan.storage_path = path/to/storage/directory

# An optional setting to change the acl of the uploaded files. Default public-read.
ckanext.s3filestore.acl = private

# An optional setting to specify which addressing style to use. This controls whether the bucket name is in the hostname or is part of the URL. Default auto.
ckanext.s3filestore.addressing_style = path

# Set this parameter only if you want to use Minio as a filestore service instead of S3.
ckanext.s3filestore.host_name = http://minio-service.com

# To mask the S3 endpoint with your own domain/endpoint when serving URLs to end users.
# This endpoint should be capable of serving S3 objects as if it were an actual bucket.
# The real S3 endpoint will still be used for uploading files.
ckanext.s3filestore.download_proxy = https://example.com/my-bucket

# Defines how long a signed URL is valid (default 1 hour).
ckanext.s3filestore.signed_url_expiry = 3600

# Don't check for access on each startup
ckanext.s3filestore.check_access_on_startup = false
```

In particular if you do not pass `AWS Creds`, the script will automatically configure to use `AWS roles`

## Quick Start

Build and start CKAN:  

Resources will be stored inside a private S3 bucket which needs to be setup before starting containers

```
AWS_ACCESS_KEY_ID=<some-private-id> AWS_SECRET_ACCESS_KEY=<some-private-secret> docker-compose up --build --detach
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
