#!/bin/sh

echo "Setting beaker.session.secret"
ckan config-tool $CKAN_INI "beaker.session.secret = $CKAN_BEAKER_SESSION_SECRET" > /dev/null

echo "Setting ckanext.xloader.jobs_db.uri"
ckan config-tool $CKAN_INI "ckanext.xloader.jobs_db.uri = $CKAN_SQLALCHEMY_URL" > /dev/null

echo "Setting ckanext.s3filestore.aws_bucket_name"
ckan config-tool $CKAN_INI "ckanext.s3filestore.aws_bucket_name = abs-ckan-uploads-delete-me"

echo "Setting ckanext.s3filestore.addressing_style"
ckan config-tool $CKAN_INI "ckanext.s3filestore.addressing_style = virtual"

echo "Setting ckanext.s3filestore.region_name"
ckan config-tool $CKAN_INI "ckanext.s3filestore.region_name = ap-southeast-2"

echo "Setting ckanext.s3filestore.signature_version"
ckan config-tool $CKAN_INI "ckanext.s3filestore.signature_version = s3v4"

echo "Setting ckanext.s3filestore.acl"
ckan config-tool $CKAN_INI "ckanext.s3filestore.acl = private"

echo "Setting ckanext.s3filestore.check_access_on_startup"
ckan config-tool $CKAN_INI "ckanext.s3filestore.check_access_on_startup = false"

if [ -z ${AWS_KEY} ] || [ -z ${AWS_SECRET} ]; then
  echo "Setting ckanext.s3filestore.aws_use_ami_role"
  ckan config-tool $CKAN_INI "ckanext.s3filestore.aws_use_ami_role =  true"
else
    echo 'ckanext.s3filestore.aws_access_key_id'
    ckan config-tool $CKAN_INI "ckanext.s3filestore.aws_access_key_id=$AWS_KEY"

    echo 'ckanext.s3filestore.aws_secret_access_key'
    ckan config-tool $CKAN_INI "ckanext.s3filestore.aws_secret_access_key=$AWS_SECRET"
fi

echo "Initialising db"
ckan db init

echo "Creating admin account"
ckan user add admin password=password email=ckan@localhost
ckan sysadmin add admin


echo "Starting Gunicorn"
gunicorn -w 2 -b :8000 wsgi:application
