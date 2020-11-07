defmodule Codebot.Domain.Intent do

    alias Codebot.Domain.Intent.HelloIntent

    alias Codebot.Domain.Intent.ByeIntent

    alias Codebot.Domain.Intent.NoreplyIntent

    @spec pick({:hello, any}) :: binary
    def pick({:noreply, _params }) do
        NoreplyIntent.execute(%{})
    end

    def pick({:hello, _params }) do
        HelloIntent.execute(%{})
    end

    def pick({:bye, _params }) do
        ByeIntent.execute(%{})
    end
end
