FROM docker.io/archlinux:latest
RUN pacman -Syu nodejs npm git --noconfirm
RUN npm i -g purescript spago
RUN mkdir persona3-hacker-rest
WORKDIR persona3-hacker-rest
COPY package.json package.json
RUN npm i
COPY packages.dhall packages.dhall
COPY spago.dhall spago.dhall
RUN spago install
COPY persona3-hacker persona3-hacker
RUN rm persona3-hacker/src/Main.purs
COPY src src
COPY test test
RUN spago build
RUN spago test
RUN spago bundle-app
EXPOSE 80
CMD ["node", "index.js"]
