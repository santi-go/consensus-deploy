#!/bin/bash
COMMIT='New deploy'

git config --global user.email 'devscolavlc@gmail.com'
git config --global user.name 'Devscola Run2017-2018'

mv netrc .netrc

echo "\nCloning Consensus repository..."
git clone https://gitlab.com/devscola/consensus.git

echo "\nBuilding Consensus project..."
cd consensus
npm install
npm run build-deploy
cd ..

echo "\nCloning Consensus-api repository..."
git clone https://gitlab.com/devscola/consensus-api.git

echo "Cloning Heroku repository..."
heroku git:clone -a consensus17

echo "\nCopying consensus app to Heroku files..."
cp -r consensus/public consensus17/

echo "\nCopying files from consensus-api to Heroku files..."
cp consensus-api/app.rb consensus17/
cp consensus-api/config.ru consensus17/
cp consensus-api/Gemfile consensus17/
cp consensus-api/Gemfile.lock consensus17/
cp -r consensus-api/images consensus17/
cp -r consensus-api/initializers consensus17/
cp -r consensus-api/system consensus17/
cp -r consensus-api/templates consensus17/

echo "\nCommitting changes to Heroku repository..."
cd consensus17
git add .
git commit -m "$COMMIT"
git push heroku master
cd ..

rm -rf consensus consensus17 consensus-api
