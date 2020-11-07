defmodule Codebot.Domain.Intent.IExecuteIntent do
    @callback execute(map) :: binary
end
