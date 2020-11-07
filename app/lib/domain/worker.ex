defmodule Codebot.Domain.Worker do
    use Quantum, otp_app: :codebot

    alias Codebot.Adapter.TaskMock

    alias Codebot.Adapter.Slack

    @spec fetch_task_list :: :ok
    def fetch_task_list() do
        TaskMock.list_tasks()
        |> Enum.map(fn (task)-> Map.fetch!(task, "name") end)
        |> Enum.join("\n")
        |> IO.inspect
        |> Slack.send_msg
        # |> Enum.map(fn (task)-> Slack.send_msg(task) end)
    end

    def tell_joke() do
        {:ok, %{body: body}} = HTTPoison.get("https://sv443.net/jokeapi/v2/joke/Any")

        content = JSON.decode!(body)
        cond do
            Map.fetch!(content, "type") == "twopart" ->
                Slack.send_msg Map.fetch!(content, "setup")
                :timer.sleep 5000
                Slack.send_msg Map.fetch!(content, "delivery")
            Map.fetch!(content, "type") == "single" ->
                Slack.send_msg Map.fetch!(content, "joke")
            true -> nil
        end
    end
end
