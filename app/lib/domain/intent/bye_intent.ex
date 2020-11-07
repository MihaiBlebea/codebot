defmodule Codebot.Domain.Intent.ByeIntent do
    @behaviour Codebot.Domain.Intent.IExecuteIntent

    @spec execute(map) :: binary
    def execute(_params) do
        get_messages()
        |> pick_message
    end

    defp get_messages() do
        [
            "See you soon",
            "Take care",
            "Glad I could help",
            "Have a good day"
        ]
    end

    defp pick_message(messages) do
        messages
        |> Enum.take_random(1)
        |> Enum.at(0)
    end
end
