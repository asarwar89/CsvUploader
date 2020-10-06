# README

* Ruby version: 2.7.1

## Getting started

To get started with the app, first clone the repo and `cd` into the directory:

```
$ git clone https://github.com/asarwar89/CsvUploader.git
$ cd CsvUploader
```

Then install the needed gems (while skipping any gems needed only in production):

```
$ bundle install
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rspec
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

