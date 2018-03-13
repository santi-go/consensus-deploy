FROM node:8.9.4

RUN wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh
RUN apt-get -yq install git

ENV HOME /opt/consensus_applicative/
WORKDIR $HOME
COPY . $HOME

RUN sh deploy_in_heroku.sh
