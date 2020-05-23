FROM node:10
RUN mkdir -p /usr/src/graphqlApp
WORKDIR /usr/src/graphqlApp
COPY package.json /usr/src/graphqlApp/
RUN npm install
COPY . /usr/src/graphqlApp
EXPOSE 4053
CMD npm start
