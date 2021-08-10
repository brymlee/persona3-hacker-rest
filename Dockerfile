FROM archlinux:latest
RUN pacman -Syu --noconfirm nodejs npm curl stack make gcc
RUN stack update
RUN stack setup
RUN mkdir rest
WORKDIR rest
COPY persona3-hacker/persona3-hacker.cabal persona3-hacker.cabal 
RUN stack init
COPY persona3-hacker/src src
RUN stack build
COPY package.json package.json
RUN npm i
COPY index.js index.js
EXPOSE 80
CMD ["node", "index.js"]
