defmodule Mix.Tasks.DropCollection do
    use Mix.Task

    alias Codebot.Repository, as: Repo

    @shortdoc "Drop the mongo db collection"
    @spec run(any) :: none
    def run(_) do
        Mix.Task.run("app.start")

        Repo.connect()
        |> Repo.drop(:journals)
    end
end
