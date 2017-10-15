# Base image:
FROM ruby:2.4.2-alpine

# Install dependencies
#RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs git tzdata
RUN apk update && apk add build-base nodejs postgresql-dev git tzdata

# Set an environment variable where the Rails app is installed to inside of Docker image:
ENV RAILS_ROOT /var/www/mihotel
RUN mkdir -p $RAILS_ROOT

# Set working directory, where the commands will be ran:
WORKDIR $RAILS_ROOT

# Gems:
COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs
RUN npm install -g bower

COPY config/puma.rb config/puma.rb
 
# Copy the main application.
COPY . .

EXPOSE 3000

LABEL maintainer="Anonymous"

# The default command that gets ran will be to start the Puma server.
# CMD puma -C config/puma.rb
CMD bundle exec puma -C config/puma.rb