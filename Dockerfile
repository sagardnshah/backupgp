FROM python:3.9

ARG NAME
ARG CLINET_CONFIG_DIR

RUN mkdir -p $CLINET_CONFIG_DIR
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir google-auth

WORKDIR /$NAME
CMD [ "python", "backupgp.py" ]