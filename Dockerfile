ARG RUBY_VERSION=2.7.5
FROM ruby:$RUBY_VERSION-alpine as spotlight

ENV RAILS_SERVE_STATIC_FILES="1"
ENV RAILS_LOG_TO_STDOUT="1"
ARG APP_ID_NUMBER=55000
ARG APP_ID_NAME=curiosity
ARG GROUP_ID_NUMBER=55000
ARG GROUP_ID_NAME=curiosity

RUN apk --no-cache upgrade && \
  apk add --no-cache \
  build-base \
  cmake \
  curl \
  git \
  imagemagick \
  less \
  libxml2-dev \
  libxslt-dev \
  nodejs-current \
  postgresql-dev \
  shared-mime-info \
  sqlite-dev \
  tzdata \
  yarn \
  zip && \
  addgroup -S ${GROUP_ID_NAME} -g ${GROUP_ID_NUMBER} && \
  adduser -h /home/${APP_ID_NAME} -s /bin/sh -u ${APP_ID_NUMBER} -S ${APP_ID_NAME} -G ${GROUP_ID_NAME} && \
  mkdir -p /app && \
  chown -R ${APP_ID_NAME}:${GROUP_ID_NAME} /app && \
  gem update bundler

USER ${APP_ID_NAME}:${GROUP_ID_NAME}
WORKDIR /app/spotlight

COPY --chown=${APP_ID_NAME}:${GROUP_ID_NAME} . /app/spotlight
RUN mkdir /app/bundle && \
  bundle config set force_ruby_platform true && \
  bundle config set path /app/bundle && \
  bundle install --jobs "$(nproc)"

# These 3 lines deal with a permissions bug in Docker found in some version
USER root
RUN chown ${APP_ID_NAME}:${GROUP_ID_NAME} /app/spotlight
USER ${APP_ID_NAME}:${GROUP_ID_NAME}
# the above lines can be removed with all Docker versions on ci runners are upgraded

RUN mkdir -p /app/spotlight/tmp/pids && \
  RAILS_ENV=production SECRET_KEY_BASE=`bin/rake secret` DB_ADAPTER=nulldb DATABASE_URL='postgresql://fake' bundle exec rake assets:precompile

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]
