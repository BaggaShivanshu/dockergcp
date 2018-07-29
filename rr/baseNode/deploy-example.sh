#!/bin/bash
# Checks Google Cloud Container Registry to see if builds finish deploying from recent updates
# to the source repository.
#
# By default, retries 9 times, waiting 45 seconds between attempts.
#
# Configure the variables at the top of the file for your environment

NAME="Route API"

# http://patorjk.com/software/taag
LOGO="
 ________  ________  ___  ___  _________  _______      
|\   __  \|\   __  \|\  \|\  \|\___   ___\\  ___ \     
\ \  \|\  \ \  \|\  \ \  \\\  \|___ \  \_\ \   __/|    
 \ \   _  _\ \  \\\  \ \  \\\  \   \ \  \ \ \  \_|/__  
  \ \  \\  \\ \  \\\  \ \  \\\  \   \ \  \ \ \  \_|\ \ 
   \ \__\\ _\\ \_______\ \_______\   \ \__\ \ \_______\
    \|__|\|__|\|_______|\|_______|    \|__|  \|_______|
                                                                                                                            
"

# URL is used to provide a helpful link in the console once the deployment is complete.
# The link would be clickable if your CLI supports it (iTerm2 etc).
URL="https://api.rozaroute.com/etc/"

# DEPLOYMENT is the deployment/service name in Kubernetes. Run `kubectl get services`
# to verify the name.
DEPLOYMENT="route-api"

# PROJECT_ID is the GCP Project ID used for deployment and source code. The default
# will look for the currently configured project using the gcloud cli. You can provide a
# static id here if desired.
PROJECT_ID="$(gcloud config get-value project)"

# IMAGE_NAME will generate a full docker/image name based on the current project id and
# current git HEAD SHA for the folder. The default is to generate the basename from the name of the repo
# configured in the remote.origin for the current folder's git information.
#
# The name must be the same in GCP Source Repositories for this to match up. It does not need to match
# the deployment/service name in kubernetes.
#
# For this to work, the name generation on the source repository build triggers must match this output:
# gcr.io/$PROJECT_ID/$REPO_NAME:$COMMIT_SHA
IMAGE_NAME="gcr.io/$(gcloud config get-value project)/$(basename -s .git `git config --get remote.origin.url`):$(git rev-parse HEAD)"

function fail {
  echo $1 >&2
  exit 1
}

trap 'fail "The deployment was aborted. Message -- "' ERR

function configure {
  echo "Validating configuration..."
  [ ! -z "$DEPLOYMENT" ] || fail "Configuration option is not set: DEPLOYMENT"
  [ ! -z "$PROJECT_ID" ] || fail "Configuration option is not set: PROJECT_ID"
  [ ! -z "$IMAGE_NAME" ] || fail "Configuration option is not set: IMAGE_NAME"
}

function attempt_build {
  echo "Checking build status for $IMAGE_NAME"
  local n=1
  local max=9
  local delay=45
  while true; do
    gcloud container builds list | grep $IMAGE_NAME | grep -q SUCCESS && break || {
      if [[ $n -lt $max ]]; then
        ((n++))
        echo "Build not completed. Attempt $n/$max:"
        sleep $delay;
      else
        fail "The command has failed after $n attempts."
      fi
    }
  done
}

function set_image {
  echo Container build completed, updating $DEPLOYMENT ...
  kubectl set image deployment/$DEPLOYMENT $DEPLOYMENT=$IMAGE_NAME
}

echo $LOGO

echo $NAME

configure
attempt_build
set_image
echo "Deployment complete"
echo "visit: $URL"