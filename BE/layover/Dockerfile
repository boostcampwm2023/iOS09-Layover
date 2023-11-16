# Base Image
FROM node:21

# Create app directory
WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

RUN npm test

CMD [ "node", "dist/main.js" ]

