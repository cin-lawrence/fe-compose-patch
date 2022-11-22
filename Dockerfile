# syntax=docker/dockerfile:experimental
FROM node:14.15.1-alpine as builder

RUN apk add --update --no-cache git openssh

RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh git clone git@github.com:Cinnamon/prj_flax_ffg_prod_fe ffg && \
  git clone git@github.com:Cinnamon/cinnamon-design-system cds
COPY .npmrc ffg/
COPY ./prj_flax_ffg_prod_fe/config.d/config.js /ffg/config.d/config.js
COPY .npmrc cds/

WORKDIR /ffg
RUN npm install

WORKDIR /cds
RUN npm install && \
  npm link && \
  npm link /ffg/node_modules/react && \
  npm run build:types && \
  npm run remove-modules

WORKDIR /ffg
RUN npm link @cinnamon/design-system

ENV NODE_OPTIONS=--max-old-space-size=4096

COPY build_link.sh /
COPY start.sh /
COPY entrypoint.sh /

