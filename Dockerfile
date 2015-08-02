FROM adamstegman/ruby

RUN apt-get -y update

# Install nginx
RUN apt-get -y install nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
ADD deploy/nginx-site.conf /etc/nginx/sites-enabled/default

# App dependencies
RUN apt-get -y install libmysqlclient-dev nodejs

# Configure log aggregation
RUN curl -o /tmp/remote_syslog.tar.gz -L https://github.com/papertrail/remote_syslog2/releases/download/v0.14/remote_syslog_linux_amd64.tar.gz && \
      tar xf /tmp/remote_syslog.tar.gz -C /tmp && \
      cp /tmp/remote_syslog/remote_syslog /usr/local/bin/
ADD deploy/log_files.yml /etc/log_files.yml

# Install Rails app
WORKDIR /opt/test_app
ADD . /opt/test_app
RUN bundle install --without development test

# Configure Rails app
ADD deploy/unicorn.rb /etc/unicorn.rb
ENV RAILS_ENV production
ENV UNICORN_CONCURRENCY 1
ENV UNICORN_TIMEOUT 15

RUN bundle exec rake assets:precompile

# Clean up the image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start Rails app
EXPOSE 80
CMD bundle exec foreman start -f Procfile.docker
