# Reeder

Experimental app to read RSS subscriptions

## Requirements

- Ruby 2.0
- PostgreSQL
- Redis

## Install

Clone repository and install dependencies:

```
git clone git@github.com:sosedoff/reeder.git
cd reeder
bundle install
```

Create development database:

```
createdb -U postgres reeder_development
```

Migrate database:

```
rake db:migrate
```

## Usage

To start server locally (http://localhost:5000/) type:

```
foreman start
```

This will start web server, feed worker and periodic update worker.

## API Documentation

Check `API.md` file for API documentation and reference.

## Testing

Testing is done in two parts. To run the tests for the sinatra backend and API:

Prepare database:

```
createdb -U postgres reeder_test
rake db:migrate RACK_ENV=test
```

To execute test suite:

```
bundle exec rake test
```

To run the frontend javscript tests you will need to install Karma:

```
npm install
```

Then start the Karma server

```
./node_modules/.bin/karma start
```

and finally run the suite

```
./node_modules/.bin/karma run
```

## TODO

- OPML import with web interface
- Responsive / mobile layout
- Better feed processing based on update frequency

## License

The MIT License (MIT)

Copyright (c) 2013-2014 Dan Sosedoff <dan.sosedoff@gmail.com>
