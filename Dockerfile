FROM elixir:1.12.1-alpine AS build

RUN apk add --no-cache build-base npm git python3

ENV APP_DIR=/opt/app/nfl_rushing

WORKDIR $APP_DIR

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY rel rel
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

COPY lib lib
RUN mix do compile, release

FROM alpine:3.9 AS application

RUN apk add --no-cache libgcc libstdc++ ncurses-libs openssl

ENV APP_DIR=/opt/app/nfl_rushing

WORKDIR $APP_DIR

RUN chown nobody:nobody $APP_DIR

USER nobody:nobody

COPY --from=build --chown=nobody:nobody $APP_DIR/_build/prod/rel/nfl_rushing ./

ENV HOME=$APP_DIR

CMD ["bin/nfl_rushing", "start"]
