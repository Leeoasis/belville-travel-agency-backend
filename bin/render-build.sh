#!/usr/bin/env bash
# Exit on error
set -o errexit

# Install dependencies
bundle install

# Migrate the database
bundle exec rails db:migrate
