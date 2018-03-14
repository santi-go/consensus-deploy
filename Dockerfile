FROM node:8.9.4

RUN wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh
RUN apt-get -yq install git

ENV HOME /opt/deploy/
WORKDIR $HOME
COPY . $HOME
