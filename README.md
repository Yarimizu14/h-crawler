# h-crawler

```bash
$ docker build -t h-crawler .
$ docker run -e EMAIL=<email> -e PASSWORD=<password> -e AWS_ACCESS_KEY_ID=<key-id> -e AWS_SECRET_ACCESS_KEY=<secret-key> h-crawler
```

## Setup

## Create Database

```
$ docker run --name some-postgres -p 5432:5432 -e POSTGRES_PASSWORD=password -d postgres
$ psql -U postgres -h localhost
# CREATE DATABASE my_db;
$ bundle exec ruby migrate.rb
```
