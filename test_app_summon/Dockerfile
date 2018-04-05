FROM ruby:2.3

RUN gem install -N activesupport --version 4.2.7.1
RUN gem install -N conjur-api:"< 5.0" conjur-cli:"< 6.0" sinatra

COPY summon usr/local/bin/summon

RUN mkdir /usr/local/lib/summon
COPY summon-conjur usr/local/lib/summon

WORKDIR /usr/src

COPY test_app.rb test_app.rb
COPY secrets.yml secrets.yml

env PORT 80

CMD [ "summon", "--provider", "summon-conjur", "ruby", "test_app.rb" ]
#CMD [ "sleep", "infinity" ]