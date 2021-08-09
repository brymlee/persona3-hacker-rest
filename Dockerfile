FROM archlinux:latest
RUN pacman -Syu --noconfirm nodejs npm curl stack
RUN mkdir rest
WORKDIR rest
COPY package.json package.json
RUN npm i
COPY index.js index.js
EXPOSE 80
CMD ["node", "index.js"]
