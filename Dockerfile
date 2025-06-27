FROM node:lts-alpine as build

WORKDIR /app

COPY package*.json ./

RUN rm -rf node_modules
RUN rm -rf build

COPY . .

RUN npm ci
RUN npm run build

FROM node:lts-alpine as run

WORKDIR /app

COPY --from=build /app/package.json ./package.json
COPY --from=build /app/build ./build

RUN npm install --production

EXPOSE 2000

ENTRYPOINT [ "npm", "run", "start" ]
