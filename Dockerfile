FROM node:24.22.3 AS client

WORKDIR /var/scalargis

COPY scalargis-client/package.json scalargis-client/package-lock.json ./
RUN npm install

COPY scalargis-client/ ./
COPY configs/.env.viewer apps/viewer/.env
COPY configs/.env.backoffice apps/backoffice/.env

RUN npx nx run-many -t build

FROM server

COPY --from=client /var/scalargis/dist/apps/viewer /var/scalargis/scalargis/app/static/viewer
COPY --from=client /var/scalargis/dist/apps/backoffice /var/scalargis/scalargis/app/static/backoffice
