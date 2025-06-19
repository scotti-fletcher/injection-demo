# syntax=docker/dockerfile:1

# Dockerfile Base Image
# Description: Ubuntu 24.10 base with Ruby environment
# Security: Runs as root (explicit choice)
# Package Management:
#   - Removes Python3 and unused dependencies
#   - Installs Ruby dev tools and MongoDB libraries
# Note: DEBIAN_FRONTEND set for non-interactive installs

FROM ubuntu:24.10
LABEL maintainer="Scott Fletcher <scotti.fletcher.1@gmail.com>"
ENV DEBIAN_FRONTEND=noninteractive

# System setup (run as root)
RUN apt update -y && apt upgrade -y && \
    apt remove -y python3 && \
    apt autoremove -y && \
    apt install -y ruby-dev bundler libssl-dev pkg-config libmongoc-dev libbson-dev

WORKDIR /flappy
COPY Gemfile Gemfile.lock ./

# Description: Handles Ruby gem dependencies
# Security Actions:
#   - Forces removal of vulnerable default gems (rexml, webrick)
#   - Installs patched version of rexml (3.3.9)
#   - Cleans up residual gem files
# Process: Uses bundle for dependency management
RUN rm -f /usr/lib/ruby/gems/*/specifications/rexml-*.gemspec && \
    gem uninstall -i /usr/lib/ruby/gems/* rexml webrick net-imap cgi --force --all && \
    gem install rexml -v 3.3.9 --no-document && \
    # Also remove any default gem specifications
    rm -f /usr/local/lib/ruby/gems/*/specifications/default/rexml-*.gemspec

RUN find / -path '*gems/webrick-*' -delete 2>/dev/null || true && \
    find / -path '*specifications/webrick*' -delete 2>/dev/null || true && \
    find / -path '*cache/webrick*' -delete 2>/dev/null || true && \
    # Rebuild gem cache
    gem cleanup

RUN bundle install

COPY . .
# Application Deployment
# Description: Copies and runs the Ruby web application
# Security Note: Container runs as root (consider USER directive)
# Networking: Binds to 0.0.0.0 (all interfaces)
# Port: Default Ruby WEBrick port (likely 4567)
# Warning: WEBrick not recommended for production
CMD ["ruby", "/flappy/webserver.rb", "-o", "0.0.0.0"]