#!/bin/sh

echo "Setting beaker.session.secret"
ckan config-tool $CKAN_INI "beaker.session.secret = $CKAN_BEAKER_SESSION_SECRET" > /dev/null

echo "Setting ckanext.xloader.jobs_db.uri"
ckan config-tool $CKAN_INI "ckanext.xloader.jobs_db.uri = $CKAN_SQLALCHEMY_URL" > /dev/null

echo "Initialising DB"
ckan db init

echo "Creating admin account"
ckan user add admin password=password email=ckan@localhost
ckan sysadmin add admin

echo "Starting Gunicorn"
gunicorn -w 2 -b :8000 wsgi:application