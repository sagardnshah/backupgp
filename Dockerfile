FROM python:3.9
ARG NAME

WORKDIR /$NAME
CMD [ "python", "backupgp.py" ]