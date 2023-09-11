# Start with the official Ruby image
FROM ruby:3.2.1

# Set environment variables for Rails
ENV BUNDLE_GEMFILE="/app/Gemfile" \
    RAILS_LOG_TO_STDOUT="enabled" \
    RAILS_SERVE_STATIC_FILES="1"

# Install required packages
RUN apt-get update && apt-get install -y libpq-dev && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock first to leverage Docker cache
COPY Gemfile Gemfile.lock ./

# Install bundler and app's dependencies
RUN gem install bundler:2.3.22 && bundle install

# Copy remaining application files
COPY . .

# Precompile assets (assuming you're using Rails with Asset Pipeline)
RUN bundle exec rake assets:precompile

# Run the application
CMD bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}

