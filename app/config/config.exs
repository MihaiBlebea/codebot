use Mix.Config

alias Codebot.Domain.Worker

config :mongodb_driver,
    host: "localhost"

config :codebot,
    # port: System.get_env("HTTP_PORT"),
    port: "8080",
    slack_token: System.get_env("SLACK_TOKEN"),
    mongo_url: "mongodb://localhost:27015/",
    mongo_db: "codebot-v1",
    nlp_module: Witai

config :witai, token: System.get_env("WITAI_TOKEN")

config :codebot, Worker,
    jobs: [
        {"*/5 * * * *", &Worker.tell_joke/0 }
    ]

import_config "config.#{ Mix.env() }.exs"
