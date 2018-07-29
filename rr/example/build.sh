#!/bin/sh
chmod +x quickstart.sh
gcloud builds submit --tag gcr.io/roza-base/quickstart-image .