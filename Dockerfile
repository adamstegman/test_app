FROM adamstegman/ruby

RUN apt-get -y update

# Install nginx
RUN apt-get -y install nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
ADD deploy/nginx-site.conf /etc/nginx/sites-enabled/default

# App dependencies
RUN apt-get -y install libmysqlclient-dev nodejs

# Install supervisord
RUN apt-get -y install wget python
RUN wget -P /tmp https://bootstrap.pypa.io/ez_setup.py && \
    python /tmp/ez_setup.py
RUN easy_install supervisor
ADD deploy/supervisord.conf /etc/supervisord.conf
ADD deploy/universal_fatal.supervisor.conf /etc/supervisord/universal_fatal
ADD deploy/universal_fatal.py /usr/bin/universal_fatal.py
RUN chmod 775 /usr/bin/universal_fatal.py

# Configure log aggregation
RUN wget -P /tmp https://github.com/papertrail/remote_syslog2/releases/download/v0.14/remote_syslog_linux_amd64.tar.gz && \
    tar xf /tmp/remote_syslog_linux_amd64.tar.gz -C /tmp && \
    cp /tmp/remote_syslog/remote_syslog /usr/local/bin/
ADD deploy/log_files.yml /etc/log_files.yml
ADD deploy/remote_syslog.supervisor.conf /etc/supervisord/remote_syslog

# Install Rails app
WORKDIR /opt/test_app
ADD . /opt/test_app

ENV RAILS_ENV production
ENV UNICORN_CONCURRENCY 1
ENV UNICORN_TIMEOUT 15

RUN bundle install --without development test
RUN bundle exec rake assets:precompile

ADD deploy/unicorn.rb /etc/unicorn.rb
ADD deploy/nginx.supervisor.conf /etc/supervisord/nginx
ADD deploy/unicorn.supervisor.conf /etc/supervisord/unicorn

# Clean up the image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start Rails app
EXPOSE 80
CMD supervisord -n
