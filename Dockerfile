FROM ruby:2.5.3-alpine3.7

ENV YARN_VERSION=1.7.0

RUN apk update && apk upgrade; \
  apk add --update --no-cache \
  nodejs \
  build-base \
  tzdata \
  libxml2-dev \
  libxslt-dev \
  sqlite-dev

ADD https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz /tmp/yarn.tar.gz

RUN tar -xzf /tmp/yarn.tar.gz -C "/usr/src"; \
    ln -s "/usr/src/yarn-v${YARN_VERSION}/bin/yarn" /usr/local/bin/; \
    rm /tmp/yarn.tar.gz

ENV LANG=zh_TW.UTF-8 \
    TZ=Asia/Taipei \
    RAILS_SERVE_STATIC_FILES=true \
    APP_PATH=/usr/src/app

WORKDIR $APP_PATH

COPY package.json yarn.lock ./

RUN yarn install

COPY Gemfile Gemfile.lock ./

RUN gem install bundler

RUN bundle install

COPY . .

CMD ["/bin/sh"]
