ARG RUBY_VERSION=3.1.2
FROM ruby:$RUBY_VERSION
ARG YARN_VERSION 1.16.0

RUN apt-get update -qq \
    && apt-get install -y build-essential libvips bash bash-completion libffi-dev tzdata postgresql nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/man
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y yarn

WORKDIR /rails

ENV RAILS_LOG_TO_STDOUT="1" \
RAILS_SERVE_STATIC_FILES="TRUE" \
RAILS_ENV="production" \
BUNDLE_WITHOUT="development"

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN rails webpacker:install
RUN bundle exec bootsnap precompile --gemfile app/ lib/

RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails webpacker:compile

EXPOSE 3000
CMD ["./BIN/RAILS", "SERVER"]
