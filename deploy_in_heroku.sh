#!/bin/bash
COMMIT=$1
if [ -z ${COMMIT+x} ]; then
  COMMIT='New deploy';
fi

heroku git:clone -a consensus17
git clone https://gitlab.com/devscola/consensus-api.git
git clone https://gitlab.com/devscola/consensus.git

cp password_mail.env consensus-api/
cp password_mail.env consensus/

cd consensus-api
docker-compose up --build -d
docker-compose exec api bundle install
docker-compose down
cd ..

cp consensus-api/app.rb consensus17/
cp consensus-api/config.ru consensus17/
cp consensus-api/Gemfile consensus17/
cp consensus-api/Gemfile.lock consensus17/
cp -r consensus-api/images consensus17/
cp -r consensus-api/initializers consensus17/
cp -r consensus-api/system consensus17/
cp -r consensus-api/templates consensus17/

cd consensus
docker-compose up --build -d
docker-compose run --rm consensus npm run build-deploy
docker-compose down
cd ..

cp -r consensus/public consensus17/

echo "\n"

cd consensus17
git add .
git commit -m "$COMMIT"
git status
printf "\nPush the changes to repository? (y/n) "; read INTRO
if [ $INTRO = 'y' ]
  then
  git push heroku master
fi
cd ..

printf "\nClean deploy directory (remove 'consensus', 'consensus-api' and 'consensus17')? (y/n) "; read INTRO
if [ $INTRO = 'y' ]
  then
  sudo rm -rf consensus-api consensus consensus17
fi
