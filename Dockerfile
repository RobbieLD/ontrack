FROM alpine:latest

RUN apk update 

RUN apk upgrade 

ENV BUILD_PACKAGES curl-dev ruby-dev build-base

RUN apk add curl wget bash $BUILD_PACKAGES

RUN apk add file git gzip libc6-compat ncurses ruby ruby-io-console ruby-bundler ruby-dbm ruby-etc ruby-irb ruby-json sudo

RUN apk add --update nodejs npm

RUN npm install -g yarn

# Create homebrew user
RUN adduser -D -s /bin/bash linuxbrew

RUN echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

RUN su -l linuxbrew

# Install Hombrew
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

RUN PATH=$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH

# Update Brew
RUN brew update
RUN brew doctor

# Clean APK cache
RUN rm -rf /var/cache/apk/*

RUN mkdir /usr/app 

WORKDIR /usr/app

COPY . /user/app/

# Run the install script
RUN sh scripts.sh install_with_brew

# Start the app
CMD ["sh", "scripts.sh", "start"]