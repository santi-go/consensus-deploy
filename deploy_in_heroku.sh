#!/bin/bash
echo "\nConfigure git user..."
git config --global user.email 'devscolavlc@gmail.com'
git config --global user.name 'Devscola Run2017-2018'

echo "\nPrepare heroku login..."
mv netrc .netrc

echo "\nCloning Heroku repository..."
heroku git:clone -a consensus17

echo "\nCloning Consensus repository..."
git clone https://gitlab.com/devscola/consensus.git
cd consensus
APP=$( git log --format='%s from %cn' -1 )
cd ..
echo "cloned $APP"

echo "\nBuilding Consensus project..."
cd consensus
npm install
npm run build-deploy
cd ..

echo "\nCopying consensus app to Heroku files..."
cp -r consensus/public consensus17/

echo "\nCloning Consensus-api repository..."
git clone https://gitlab.com/devscola/consensus-api.git
cd consensus-api
API=$( git log --format='%s from %cn;' -1 )
cd ..
echo "cloned $API"

echo "\nCopying files from consensus-api to Heroku files..."
cp consensus-api/app.rb consensus17/
cp consensus-api/config.ru consensus17/
cp consensus-api/Gemfile consensus17/
cp consensus-api/Gemfile.lock consensus17/
cp -r consensus-api/images consensus17/
cp -r consensus-api/initializers consensus17/
cp -r consensus-api/system consensus17/
cp -r consensus-api/templates consensus17/

echo "\nCommitting to Heroku repository from Api: $API and App: $APP"
cd consensus17
git add .
git commit -m "Deploy from Api: $API and App: $APP"
git push heroku master
cd ..

rm -rf consensus consensus17 consensus-api
