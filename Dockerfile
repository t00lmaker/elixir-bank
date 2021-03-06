FROM elixir:1.9.0-alpine AS build

# install build dependencies
RUN apk add --update build-base npm git

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
COPY rel rel
RUN mix deps.get
RUN mix deps.compile

# build assets
COPY priv priv

# build project
COPY lib lib
RUN mix compile

# build release (uncomment COPY if rel/ exists)
# COPY rel rel
RUN mix distillery.release 

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --update bash openssl

# path to app
RUN mkdir /app
WORKDIR /app

# copy release to path app
COPY --from=build /app/_build/prod/rel/bankapi ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app 

# start app
CMD ["bin/bankapi", "foreground"]
