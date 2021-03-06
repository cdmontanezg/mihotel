# Base image:
FROM ruby:alpine

# Install dependencies
#RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs git tzdata
RUN apk update && apk add build-base postgresql-dev git tzdata nodejs

# Set an environment variable where the Rails app is installed to inside of Docker image:
ENV RAILS_ROOT /var/www/mihotel
RUN mkdir -p $RAILS_ROOT

# Set working directory, where the commands will be ran:
WORKDIR $RAILS_ROOT

# Gems:
COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs
# RUN npm install -g bower

COPY config/puma.rb config/puma.rb
 
# Copy the main application.
COPY . .
#RUN bower install --allow-root

EXPOSE 3000

LABEL maintainer="Anonymous"

ENV RAILS_ENV production
ENV RACK_ENV production

# The default command that gets ran will be to start the Puma server.
# CMD puma -C config/puma.rb
CMD bundle exec puma -C config/puma.rb
