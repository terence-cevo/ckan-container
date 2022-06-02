#!/bin/sh

echo "Setting beaker.session.secret"
ckan config-tool $CKAN_INI "beaker.session.secret = $CKAN_BEAKER_SESSION_SECRET" > /dev/null

echo "Setting ckanext.xloader.jobs_db.uri"
ckan config-tool $CKAN_INI "ckanext.xloader.jobs_db.uri = $CKAN_SQLALCHEMY_URL" > /dev/null

echo "Setting ckanext.cloudstorage.driver"
ckan config-tool $CKAN_INI "ckanext.cloudstorage.driver = S3"

echo "Setting ckanext.cloudstorage.container_name"
ckan config-tool $CKAN_INI "ckanext.cloudstorage.container_name = abs-ckan-uploads-delete-me"

echo "Setting ckanext.cloudstorage.max_multipart_lifetime"
ckan config-tool $CKAN_INI "ckanext.cloudstorage.max_multipart_lifetime = 7"

echo "Setting ckanext.cloudstorage.use_secure_urls"
ckan config-tool $CKAN_INI "ckanext.cloudstorage.use_secure_urls = 1"

echo "Setting ckanext.cloudstorage.driver_options"
ckan config-tool $CKAN_INI "ckanext.cloudstorage.driver_options = {'region': 'ap-southeast-2', 'key':'$AWS_KEY', 'secret':'$AWS_SECRET'}"

echo "Initialising db"
ckan db init

echo "Creating admin account"
ckan user add admin password=password email=ckan@localhost
ckan sysadmin add admin

echo "Initialising db for cloudstorage"
ckan db upgrade -p cloudstorage


echo "Starting Gunicorn"
gunicorn -w 2 -b :8000 wsgi:application
