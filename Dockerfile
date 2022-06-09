FROM ubuntu:20.04

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

ENV CKAN_HOME /opt/ckan
ENV CKAN_INI $CKAN_HOME/ckan.ini
ENV LANG C.UTF-8
ENV TZ UTC
ENV AWS_KEY=$AWS_ACCESS_KEY_ID
ENV AWS_SECRET=$AWS_SECRET_ACCESS_KEY

RUN set -ex; \
    apt-get update; \
    apt-get install -y curl git libpq-dev make python3-magic python3-pip sudo; \
    mkdir -p $CKAN_HOME/src; \
    addgroup --system --gid 92 ckan; \
    adduser --system --home $CKAN_HOME --no-create-home --disabled-password --uid 92 --gid 92 ckan

WORKDIR $CKAN_HOME

RUN set -ex; \
    pip install setuptools==44.1.0; \
    pip install -e git+https://github.com/ckan/ckan.git@ckan-2.9.5#egg=ckan; \
    pip install -r src/ckan/requirements.txt; \
    pip install gunicorn;

RUN set -ex; \
    pip install -e "git+https://github.com/datagovau/ckanext-s3filestore#egg=ckanext-s3filestore[requirements]"; \
    pip install -e "git+https://github.com/datagovau/ckanext-s3filestore#egg=ckanext-s3filestore"

RUN set -ex; \
    # ckanext-xloader
    pip install -e git+https://github.com/ckan/ckanext-xloader.git#egg=ckanext-xloader; \
    pip install -r src/ckanext-xloader/requirements.txt; \
    # ckanext-dcat
    pip install -e git+https://github.com/ckan/ckanext-dcat.git#egg=ckanext-dcat; \
    pip install -r src/ckanext-dcat/requirements.txt

COPY ckan.ini .
COPY web.sh .
COPY worker.sh .

RUN set -ex; \
    ckan generate config default.ini; \
    ln -s src/ckan/who.ini who.ini; \
    ln -s src/ckan/wsgi.py wsgi.py; \
    chmod +x web.sh worker.sh; \
    chown -R ckan:ckan $CKAN_HOME

USER ckan

EXPOSE 8000

CMD ["/opt/ckan/web.sh"]
