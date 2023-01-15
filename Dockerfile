# syntax=docker/dockerfile:experimental
FROM node:14.15.1-alpine

ARG DEPENDENCY_OWNER=Cinnamon
ARG DEPENDENCY_GIT=cinnamon-design-system
ARG PROJECT_OWNER=Cinnamon
ARG PROJECT_GIT=flaxscannerhub-fe

ENV DEPENDENCY_DIR=${DEPENDENCY_GIT}
ENV PROJECT_DIR=${PROJECT_GIT}

RUN apk add --update --no-cache git openssh

RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh git clone git@github.com:$DEPENDENCY_OWNER/$DEPENDENCY_GIT $DEPENDENCY_DIR && \
  git clone git@github.com:$PROJECT_OWNER/$PROJECT_GIT $PROJECT_DIR

COPY .npmrc $DEPENDENCY_DIR
COPY .npmrc $PROJECT_DIR

WORKDIR /$PROJECT_DIR
RUN npm install

WORKDIR /$DEPENDENCY_DIR
RUN npm install && \
  npm link && \
  npm link /$PROJECT_DIR/node_modules/react && \
  npm run build:types && \
  npm run remove-modules && \
  npm i @emotion/cache

WORKDIR /$PROJECT_DIR
RUN export PACKAGE=$(cat /$DEPENDENCY_DIR/package.json | grep \"name\"\: | awk -F '"' '{print $4}') && \
  echo $PACKAGE && \
  npm link $PACKAGE

ENV NODE_OPTIONS=--max-old-space-size=4096

COPY build_link.sh /
COPY start.sh /
COPY entrypoint.sh /
