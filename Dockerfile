FROM ruby:2.7.0-alpine3.11

RUN apk --update add build-base nodejs tzdata postgresql-dev postgresql-client libxslt-dev libxml2-dev imagemagick
RUN apk add bash build-base curl file coreutils git gzip libc6-compat ncurses ruby ruby-dbm ruby-etc ruby-irb ruby-json sudo

RUN adduser -D -s /bin/bash linuxbrew
RUN echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
#RUN su -l linuxbrew

RUN su -l linuxbrew -c "sh $(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

#RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
#RUN PATH=$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH

#RUN brew update
#RUN brew doctor

ENV INSTALL_PATH /ontrack
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./

ARG RAILS_ENV

ENV RACK_ENV=$RAILS_ENV

RUN bundle update

RUN gem install bundler

RUN bundle install;

COPY * /ontrack/

# Run the install script
#RUN sh scripts.sh install_with_brew

# Start the app
##CMD ["sh", "scripts.sh", "start"]