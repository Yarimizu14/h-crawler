FROM ruby:2.4.0

RUN mkdir /app
WORKDIR /app

RUN apt-get update
RUN apt-get install -y build-essential chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev
ENV PHANTOMJS phantomjs-2.1.1-linux-x86_64
RUN cd /tmp && wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOMJS.tar.bz2 && bzip2 -dc $PHANTOMJS.tar.bz2 | tar xvf - && mv $PHANTOMJS/bin/phantomjs /usr/local/bin/

COPY Gemfile* ./
RUN mkdir ./vendor
RUN gem install bundler && bundle install --path ./vendor

RUN mkdir ./result
COPY model/ ./model
COPY azure.rb ./
CMD bundle exec ruby azure.rb
