# Docker image containing the celocli, built from NPM.
#
# Example build command:
#
#   VERSION=x.y.z; docker build . --build-arg VERSION=$VERSION -t gcr.io/celo-testnet/celocli-standalone:$VERSION
FROM node:12-alpine

# Install cli install dependencies.
RUN apk add --no-cache python3 git make gcc g++ bash libusb-dev linux-headers eudev-dev

# Add an set as default a non-privileged user named celo.
RUN adduser -D -S celo
USER celo

# Make folders for npm packages.
RUN mkdir /home/celo/.npm-global
ENV PATH=/home/celo/.npm-global/bin:$PATH
ENV NPM_CONFIG_PREFIX=/home/celo/.npm-global
ENV RPC_URL=https://rpc.ankr.com/celo

WORKDIR /home/celo/

# Install @celo/celocli from NPM.
RUN npm i -g @celo/celocli && rm -rf .npm
RUN celocli config:set --node $RPC_URL

CMD /bin/bash
