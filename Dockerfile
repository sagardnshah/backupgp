FROM python:3.9
ARG NAME

RUN apt-get update && apt-get install -y tmux
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir \
    google-auth \
    google-auth-oauthlib \
    google-auth-httplib2 \
    google-api-python-client

WORKDIR /$NAME
CMD [ "python", "backupgp.py" ]

# for OAuth authenticaltion flow to forward the response back to the container 
# disabled for now as using host network instead of bridge
# EXPOSE 8080