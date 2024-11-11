import os
import json
import requests

from google_auth_oauthlib.flow import InstalledAppFlow
from google.oauth2.credentials import Credentials
from google.auth.transport.requests import Request

# credentials and token paths
CREDENTIALS_FILE_PATH = '/config/google-client-credentials.json'
TOKEN_FILE_PATH = '/config/token.json'

# set read-only scope for Photos Library API
SCOPES = ['https://www.googleapis.com/auth/photoslibrary.readonly']

def google_oauth():
    creds = None
    
    # if token.json exists, then load 'creds' 
    if os.path.exists(TOKEN_FILE_PATH):
        try:
            creds = Credentials.from_authorized_user_file(TOKEN_FILE_PATH, SCOPES)
        except ValueError:
            creds = None

    # if access token invalid then try to refresh first, else trigger a new request from scratch via user approval in browser
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(CREDENTIALS_FILE_PATH, SCOPES)
            creds = flow.run_local_server(port=8080, open_browser=False, success_message="Success: Authentication")
        
        # Save credentials for the next run
        with open(TOKEN_FILE_PATH, 'w') as token:
            token.write(creds.to_json())
            os.chown(TOKEN_FILE_PATH, 1000, 1000) # container runs as root, change token.json owner to correct UID, GID
    
    return creds

def get_photos_library(creds):
    # extract access token
    access_token = creds.token
    
    # create session with credential
    session = requests.Session()
    session.headers.update({'Authorization': f'Bearer {access_token}'})

    # send request to Photos Library API to list media items
    url = 'https://photoslibrary.googleapis.com/v1/mediaItems'
    response = session.get(url)

    # handle the response
    if response.status_code == 200:
        items = response.json().get('mediaItems', [])
        for item in items:
            print(f"Media Item: {item['filename']}, URL: {item['productUrl']}")
    else:
        print(f"Error: {response.status_code}, {response.text}")

if __name__ == '__main__':
    credentials = google_oauth()
    get_photos_library(credentials)
