use Mix.Config

config :mongodb_driver,
    host: "localhost"

config :codebot,
    port: 8080,
    mongo_url: "mongodb://localhost:27015/",
    mongo_db: "codebot-v1",
    nlp_module: Codebot.Mock.Witai

config :witai, token: ""
