# Use an official Ruby image
FROM ruby:3.2.1

# Set environment variables to improve caching
ENV BUNDLE_GEMFILE=/app/Gemfile \
    GEM_HOME=/usr/local/bundle \
    GEM_PATH=/usr/local/bundle \
    MALLOC_ARENA_MAX=2 \
    NIXPACKS_METADATA=ruby \
    RAILS_LOG_TO_STDOUT=enabled \
    RAILS_SERVE_STATIC_FILES=1

# Install system dependencies (less likely to change between app builds)
RUN apt-get update -qq && apt-get install -y \
    procps libpq-dev git curl autoconf bison build-essential \
    libssl-dev libyaml-dev libreadline6-dev zlib1g-dev \
    libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev && \
    rm -rf /var/lib/apt/lists/*

# Create a directory for the app inside the container and set it as the working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock first to leverage Docker caching
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN bundle install

# Copy the rest of the application
COPY . ./

# Assets precompilation
RUN bundle exec rake assets:precompile

# Start the application
CMD bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}
