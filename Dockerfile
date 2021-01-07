FROM elixir:1.9-slim

RUN /usr/local/bin/mix local.hex --force && \
  /usr/local/bin/mix local.rebar --force

ENV APP_HOME /padelslots_app

RUN mkdir $APP_HOME

ARG PG_HOST
ARG PG_PASS

# copy mix.exs only
COPY mix.* $APP_HOME/
COPY apps/data/mix.* $APP_HOME/apps/data/
COPY apps/scraper/mix.* $APP_HOME/apps/scraper/
COPY apps/webslots/mix.* $APP_HOME/apps/webslots/

WORKDIR $APP_HOME
ARG MIX_ENV=test

RUN mix deps.get && mix compile

COPY config $APP_HOME/config
COPY apps $APP_HOME/apps

RUN mix compile
