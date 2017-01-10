FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN gem install bundler
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp
RUN bundle install --path vendor/
ADD . /myapp
