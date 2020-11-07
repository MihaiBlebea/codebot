defmodule Codebot.Domain.Context.IKeepContext do
    @callback get(atom | pid, binary | atom) :: any

    @callback getId(atom | pid) :: binary

    @callback put(atom | pid, binary | atom, any) :: :ok | :fail

    @callback del(pid | atom, binary) :: :ok
end
