# Ref https://akoutmos.com/post/multipart-docker-and-elixir-1.9-releases/
FROM elixir:latest AS app_builder

ENV MIX_ENV=prod \
    TEST=1 \
    LANG=C.UTF-8

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Create the application build directory
RUN mkdir /app
WORKDIR /app

# Copy over all the necessary application files and directories
COPY config ./config
COPY lib ./lib
COPY web ./web
COPY mix.exs .
COPY mix.lock .

# Fetch the application dependencies and build the application
RUN mix deps.get
RUN mix deps.compile
RUN mix release


# ---- Application Stage ----
FROM ubuntu AS app

ENV LANG=C.UTF-8
ENV SLACK_TOKEN=${SLACK_TOKEN}
ENV WITAI_TOKEN=${WITAI_TOKEN}
ENV HTTP_PORT=${HTTP_PORT}

# Install openssl
RUN apt-get update && apt-get install -y openssl

# Copy over the build artifact from the previous step and create a non root user
RUN useradd --create-home app
WORKDIR /home/app
COPY --from=app_builder /app/_build .
RUN chown -R app: ./prod
USER app

RUN cd ./prod/rel && ls

EXPOSE ${HTTP_PORT}

# Run the Phoenix app
CMD ["./prod/rel/codebot/bin/codebot", "start"]