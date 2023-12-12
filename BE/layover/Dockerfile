# Base Image
FROM node:21

# Install tzdata package
RUN apt-get update && apt-get install -y tzdata

# Set timezone to KST
ENV TZ=Asia/Seoul

# Create app directory
WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

RUN npm test

CMD [ "node", "dist/main.js" ]

