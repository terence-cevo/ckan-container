#!/bin/sh

echo "Setting ckanext.xloader.jobs_db.uri"
ckan config-tool $CKAN_INI "ckanext.xloader.jobs_db.uri = $CKAN_SQLALCHEMY_URL" > /dev/null

echo "Starting CKAN worker"
ckan jobs worker