defmodule Codebot.MixProject do
    use Mix.Project

    def project do
        [
            app: :codebot,
            version: "0.1.0",
            elixir: "~> 1.10",
            elixirc_paths: elixirc_paths(Mix.env),
            start_permanent: Mix.env() == :prod,
            deps: deps()
        ]
    end

    # Run "mix help compile.app" to learn about applications.
    def application do
        [
            extra_applications: [:logger, :mongodb_driver, :witai],
            mod: {Codebot, []}
        ]
    end

    defp elixirc_paths(:test), do: ["lib", "web", "test/mocks"]
    defp elixirc_paths(_), do: ["lib", "web"]

    # Run "mix help deps" to learn about dependencies.
    defp deps do
        [
            {:plug_cowboy, "~> 2.0"},
            {:cowboy, "~> 2.4"},
            {:plug, "~> 1.7"},
            {:cors_plug, "~> 1.2"},
            {:httpoison, "~> 1.6", override: true},
            # {:floki, "~> 0.29.0"},
            {:json, "~> 1.2"},
            {:ex_doc, "~> 0.22", only: :dev, runtime: false},
            {:mongodb_driver, "~> 0.5"},
            {:uuid, "~> 1.1"},
            {:witai, "~> 0.1.1"},
            {:quantum, "~> 3.0"}
        ]
    end
end
