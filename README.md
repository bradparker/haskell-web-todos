# A toy app for leaning about web dev in Haskell

## Setup

### System requirements

* `direnv`
* Docker (`docker`, `docker-compose`)
* Haskell Stack (`stack`)
* Postgres client (`psql`)

### Boostraping

```
$ cp .envrc.example .envrc
$ scripts/db/create
$ docker-compose --rm sqitch deploy db:$DATABASE_URL
$ cd api
$ stack build
```

## Running

```
# in ./api
$ stack exec api-exe
```

There are currently two example actions:

```
$ curl -GET http://localhost:3000/todos
$ curl -X POST -d '{ "description": "A thing I must do" }' http://localhost:3000/todos
```
