defmodule Codebot.Mock.Witai do

    def get_witai_token() do
        case Application.fetch_env(:codebot, :witai_token) do
            {:ok, token} -> token
            _ -> raise "Could not find key witai_token in config"
        end
    end

    def message("") do
        {:noreply, %{}}
    end

    @spec message(binary) :: {atom, %{}}
    def message(term) when is_binary(term) do
        case term do
            "hey" -> {:hello, %{}}
            "bye" -> {:bye, %{}}
        end
    end
end
