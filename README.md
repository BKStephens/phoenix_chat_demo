# ChatDemo

## Start demo

[Install docker](https://docs.docker.com/get-docker/)

```
docker-compose build
docker-compose up
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Run tests

Make sure the docker containers are already running and run:

```
docker-compose exec web mix test
```
