#!/bin/bash
COMMIT=$1
if [ -z ${COMMIT+x} ]; then
  COMMIT='New deploy';
fi

echo "\e[93;1mCloning Heroku repository...\e[0m"
heroku git:clone -a consensus17

echo "\n\e[93;1mCloning Consensus-api repository...\e[0m"
git clone https://gitlab.com/devscola/consensus-api.git

echo "\n\e[93;1mCloning Consensus repository...\e[0m"
git clone https://gitlab.com/devscola/consensus.git

echo "\n\e[93;1mCopying 'password_mail' to consensus and consensus-api...\e[0m"
cp password_mail.env consensus-api/
cp password_mail.env consensus/

echo "\n\e[93;1mBuilding consensus app...\e[0m"
cd consensus
docker-compose up --build -d
docker-compose run --rm consensus npm run build-deploy
docker-compose down
cd ..

echo "\n\e[93;1mCopying consensus app to Heroku files...\e[0m"
cp -r consensus/public consensus17/

echo "\n\e[93;1mCopying files from consensus-api to Heroku files...\e[0m"
cp consensus-api/app.rb consensus17/
cp consensus-api/config.ru consensus17/
cp consensus-api/Gemfile consensus17/
cp consensus-api/Gemfile.lock consensus17/
cp -r consensus-api/images consensus17/
cp -r consensus-api/initializers consensus17/
cp -r consensus-api/system consensus17/
cp -r consensus-api/templates consensus17/

echo "\n\e[93;1mCommitting changes to Heroku repository...\e[0m"
cd consensus17
git add .
git commit -m "$COMMIT"
git status
printf "\n\e[93;1mPush the changes to repository? (y/n)\e[0m "; read INTRO
if [ $INTRO = 'y' ];
  then
  git push heroku master
fi
cd ..

printf "\n\e[93;1mClean deploy directory (remove 'consensus', 'consensus-api' and 'consensus17')? (y/n)\e[0m "; read INTRO
if [ $INTRO = 'y' ];
  then
  sudo rm -rf consensus consensus17 consensus-api
fi
