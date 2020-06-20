FROM ruby:2.7.1

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -qq -y build-essential libpq-dev nodejs yarn

RUN gem install bundler



RUN mkdir /build && mkdir /application
WORKDIR /build


ADD ./package.json /build/
RUN yarn install

COPY . /application

WORKDIR /application
RUN bundle install
RUN yarn install --check-files

COPY entrypoint.sh /usr/bin/
ENTRYPOINT ["./entrypoint.sh"]


# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
