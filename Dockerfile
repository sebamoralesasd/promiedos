# Start with the specified image
FROM ghcr.io/railwayapp/nixpacks:ubuntu-1693872184

# Set environment variables
ENV BUNDLE_GEMFILE="/app/Gemfile" \
    GEM_HOME="/usr/local/rvm/gems/3.2.1" \
    GEM_PATH="/usr/local/rvm/gems/3.2.1:/usr/local/rvm/gems/3.2.1@global" \
    MALLOC_ARENA_MAX="2" \
    NIXPACKS_METADATA="ruby" \
    RAILS_LOG_TO_STDOUT="enabled" \
    RAILS_SERVE_STATIC_FILES="1"

# Install required packages
RUN apt-get update && \
    apt-get install -y procps libpq-dev git curl autoconf bison build-essential \
    libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev \
    libffi-dev libgdbm6 libgdbm-dev libdb-dev

# Install Ruby
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash -s stable && \
    printf '\neval "$(~/.rbenv/bin/rbenv init -)"' >> /root/.profile && \
    . /root/.profile && \
    rbenv install 3.2.1 && \
    rbenv global 3.2.1 && \
    gem install bundler:2.3.22

# Ensure the paths are updated
ENV PATH="/root/.rbenv/bin:/usr/local/rvm/rubies/3.2.1/bin:/usr/local/rvm/gems/3.2.1/bin:/usr/local/rvm/gems/3.2.1@global/bin:$PATH"

# Copy app files
COPY . /app

WORKDIR /app

# Install dependencies
RUN bundle install

# Precompile assets
RUN bundle exec rake assets:precompile

# Run the application
CMD bundle exec bin/rails server -b 0.0.0.0 -p ${PORT:-3000} -e $RAILS_ENV
