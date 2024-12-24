FROM node:18-alpine
RUN apk update && apk add --no-cache bash

ENV NODE_ENV=production

EXPOSE 6673:6673

RUN addgroup -S spacex && adduser -S -G spacex spacex
RUN mkdir -p /app && chown -R spacex:spacex /app

USER spacex

WORKDIR /app

COPY ./start.sh /app/

ENTRYPOINT [ "/app/start.sh" ]

COPY --chown=spacex:spacex package.json package-lock.json /app/

RUN npm install --production

COPY --chown=spacex:spacex . .