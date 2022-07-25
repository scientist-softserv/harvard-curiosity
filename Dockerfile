ARG RUBY_VERSION=2.7.5
FROM ruby:$RUBY_VERSION-alpine as spotlight

ENV RAILS_SERVE_STATIC_FILES="1"
ENV RAILS_LOG_TO_STDOUT="1"
ARG APP_ID_NUMBER=197
ARG APP_ID_NAME=curiosity
ARG GROUP_ID_NUMBER=1636
ARG GROUP_ID_NAME=curiosity

RUN apk --no-cache upgrade && \
  apk add --no-cache \
    automake \
    boost-dev \
    build-base \
    cmake \
    curl \
    curl-dev \
    git \
    imagemagick \
    less \
    libexecinfo-dev \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    m4 \
    nodejs-current \
    openssl \
    pcre-dev \
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
  gem update bundler && \
  gem install passenger && \
  export EXTRA_PRE_CFLAGS='-O' EXTRA_PRE_CXXFLAGS='-O' EXTRA_LDFLAGS='-lexecinfo' && \
  passenger-config compile-agent --auto --optimize && \
  passenger-config install-standalone-runtime --auto --url-root=fake --connect-timeout=1 && \
  passenger-config build-native-support && \
  # setup for openssl later on
  printf "[SAN]\nsubjectAltName=DNS:*.hul.harvard.edu,DNS:*.lts.harvard.edu" >> /etc/ssl1.1/openssl.cnf && \
  chown -R ${APP_ID_NAME}: /etc/ssl1.1

USER ${APP_ID_NAME}:${GROUP_ID_NAME}

WORKDIR /app/spotlight

COPY --chown=${APP_ID_NAME}:${GROUP_ID_NAME} Gemfile* /app/spotlight/

# Uncomment if developing the spotlight-oaipmh-resources gem within this application
# COPY --chown=${APP_ID_NAME}:${GROUP_ID_NAME} ./vendor/spotlight-oaipmh-resources /app/spotlight/vendor/spotlight-oaipmh-resources

RUN mkdir /app/bundle && \
  bundle config set force_ruby_platform true && \
  bundle config set path /app/bundle && \
  bundle install --jobs "$(nproc)"

COPY --chown=${APP_ID_NAME}:${GROUP_ID_NAME} . /app/spotlight

# These 3 lines deal with a permissions bug in Docker found in some version
USER root
RUN chown ${APP_ID_NAME}:${GROUP_ID_NAME} /app/spotlight
USER ${APP_ID_NAME}:${GROUP_ID_NAME}
# the above lines can be removed with all Docker versions on ci runners are upgraded

RUN mkdir -p /app/spotlight/tmp/cache/downloads && \
  chmod g+s /app/spotlight/tmp/cache && \
  chmod 755 /app/spotlight/tmp/cache/downloads && \
  mkdir -p /app/spotlight/tmp/pids && \
  RAILS_ENV=production SECRET_KEY_BASE=`bin/rake secret` DB_ADAPTER=nulldb DATABASE_URL='postgresql://fake' bundle exec rake assets:precompile && \
  mkdir /app/certs && \
  openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj "/C=US/ST=Massachusetts/L=Cambridge/O=Library Technology Services/CN=*.lib.harvard.edu" -extensions SAN -reqexts SAN -config /etc/ssl1.1/openssl.cnf -keyout /app/certs/server.key -nodes -out /app/certs/server.pem

CMD ["passenger", "start", "--port", "4000", "--log-file", "/dev/stdout", "--no-install-runtime", "--no-compile-runtime","--ssl","--ssl-certificate","/app/certs/server.pem","--ssl-certificate-key","/app/certs/server.key"]
