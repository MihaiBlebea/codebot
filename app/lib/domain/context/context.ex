defmodule Codebot.Domain.Context do
    @behaviour Codebot.Domain.Context.IKeepContext

    alias Codebot.Domain.Context

    defstruct id: nil, intent: nil, props: nil

    @spec start_link :: pid
    def start_link() do
        id = UUID.uuid1()
        case Agent.start_link(fn ()-> %Context{id: id} end) do
            {:error, _} -> raise "Could not start a new context"
            {:ok, pid} -> pid
        end
    end

    @spec get(atom | pid, binary | atom) :: any
    def get(pid, key) do
        Agent.get(pid, fn (state)-> Map.get(state, key) end)
    end

    @spec getId(atom | pid) :: binary
    def getId(pid) do
        get(pid, :id)
    end

    @spec put(atom | pid, binary | atom, any) :: :ok | :fail
    def put(pid, key, value) do
        cond do
            key == :intent -> Agent.update(pid, fn (state)-> Map.put(state, :intent, value) end)
            key == :props and is_map(value) -> Agent.update(pid, fn (state)-> Map.put(state, :props, value) end)
            true -> :fail
        end
    end

    @spec del(pid | atom, binary) :: :ok
    def del(pid, key) do
        Agent.update(pid, fn (state)-> Map.delete(state, key) end)
    end
end
