defmodule Codebot.Bot do

    alias Codebot.Domain.Intent

    @spec query(binary) :: binary
    def query(term) do
        term
        |> get_nlp_module().message
        |> Intent.pick
    end

    defp get_nlp_module() do
        Application.fetch_env!(:codebot, :nlp_module)
    end
end
