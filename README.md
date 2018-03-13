# Deploy

## Prepare project

Copy '~/.netrc' in project folder as 'netrc'.


## Build application

~~~
docker build --rm --no-cache -t deploy_heroku .
~~~


## Delete build

~~~
docker rmi deploy_heroku
~~~
