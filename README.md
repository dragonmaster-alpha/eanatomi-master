## README 

# System dependencies

The system depends on the following:

* ruby
* postgresql
* redis
* elastic search
* yarn

Install ruby with your favorite ruby version manager, rbenv, asdf, rvm, etc.

To install them in macOS use homebrew and run the following commands:

`brew install postgresql`

`brew install redis`

`brew install elasticsearch`

`brew install yarn`

Elastic search depends on java8 so you might need to install that as well

`brew cask install homebrew/cask-versions/java8`

Now the ruby and js dependencies can be installed:

`yarn`

`bundle`

# Heroku setup

The system runs on heroku. So you first need to install the [heroku cli](https://devcenter.heroku.com/articles/heroku-cli)

After setting up heroku you can link with heroku:

`heroku config --app eanatomi`

Now you need to import some of the environment variables from heroku to your local .env file.

`heroku config:get BUCKETEER_BUCKET_NAME -s  >> .env`

`heroku config:get IMGIX_API_KEY -s  >> .env`

`heroku config:get IMGIX_HOST -s  >> .env`

`heroku config:get RECAPTCHA_SITE_KEY -s  >> .env`

`heroku config:get RECAPTCHA_SECRET_KEY -s  >> .env`

`heroku config:get BUCKETEER_AWS_ACCESS_KEY_ID -s  >> .env`

`heroku config:get BUCKETEER_AWS_SECRET_ACCESS_KEY -s  >> .env`

To pull the db from heroku to use locally run:

`heroku pg:pull YELLOW eanatomi_development`

After pulling the db you might would like to reindex the eleastic search index:

`heroku local:run bundle exec rake searchkick:reindex:all`

# Running the app locally

Run `heroku local -f Procfile.local`

If you want to run another command rails, rake etc. use the following

`heroku local:run YOUR_COMMAND`

So to start the rails consolse you would type:

`heroku local:run bundle exec rails c`
