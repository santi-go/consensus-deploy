# Deploy

## Build application

You need docker-compose


## Deploy in Heroku

Install Heroku CLI from heroku:

~~~
wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh
~~~

Log-in into heroku space:

~~~
heroku login
~~~


## Deploy

Copy 'password_mail.env' into folder.

Run script deploy:

~~~
sh deploy_in_heroku.sh 'Commit name'
~~~
