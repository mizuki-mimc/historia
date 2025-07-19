FROM ruby:3.3.8-slim-bullseye AS base

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        git \
        build-essential \
        libpq-dev \
        libyaml-dev \
        ca-certificates \
        curl \
        gnupg \
        chromium \
        chromium-driver \
        libvips-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

FROM ruby:3.3.8-slim-bullseye AS production

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        git \
        build-essential \
        libpq-dev \
        libyaml-dev \
        ca-certificates \
        curl \
        gnupg \
        libvips-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=base /usr/local/bundle/ /usr/local/bundle/

COPY . .

RUN RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 RAILS_MASTER_KEY_BASE_DUMMY=1 bundle exec bin/rails assets:precompile
RUN bundle exec rails tmp:clear

COPY bin/render-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/render-entrypoint.sh
ENTRYPOINT ["render-entrypoint.sh"]

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]