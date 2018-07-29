# Set the base image
FROM node:alpine
# Author
LABEL AUTHOR: JG
# Define working directory
WORKDIR /home/api
# these should be installed
# https://github.com/nodejs/docker-node/blob/master/10/alpine/Dockerfile 
# RUN apt-get update && apt-get install curl
# RUN apt-get update && apt-get install -y apt-transport-https
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# RUN apt-get update && apt-get install yarn

# Install global modules with yarn
RUN yarn add pm2 nodemon --global

# Install node_modules with yarn using a temp directory
ADD package.json package-lock.json yarn.lock /tmp/
RUN cd /tmp && yarn
RUN mkdir -p /home/api && cd /home/api && ln -s /tmp/node_modules

# Copy API to WORKDIR
COPY . /home/api
# Create .env file from .env.example
RUN cd ~/home/api && cp .env.example .env
# Expose ports
EXPOSE 443 8080
# Run API
CMD ["yarn", "prod"]