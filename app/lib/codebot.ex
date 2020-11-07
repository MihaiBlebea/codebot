defmodule Codebot do
    use Application

    @spec start(any, any) :: {:error, any} | {:ok, pid}
    def start(_type, _args) do
        port =
            Application.get_env(:codebot, :port)
            |> String.to_integer()

        IO.puts "Application starting on port #{ to_string(port) }..."

        children = [
            {Plug.Cowboy, scheme: :http, plug: Codebot.Web.Router, options: [port: port]},
            Codebot.Domain.Worker
        ]

        Supervisor.start_link(children, strategy: :one_for_one)
    end
end
