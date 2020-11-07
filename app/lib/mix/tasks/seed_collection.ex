defmodule Mix.Tasks.SeedCollection do
    use Mix.Task

    alias Codebot.Repository, as: Repo

    @shortdoc "Scrape the docs site and saves results in database"
    def run(_) do
        Mix.Task.run("app.start")

        journal = Codebot.Model.Journal.new(
            "Buy food",
            "Go to the shop and buy food tomorrow",
            "2020-02-01"
        )
        Repo.connect()
        |> Repo.insert_one(:journals, journal)
    end
end
