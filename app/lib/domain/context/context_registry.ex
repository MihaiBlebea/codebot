defmodule Codebot.Domain.Context.Registry do

    alias Codebot.Domain.Context

    @spec start_link :: pid
    def start_link() do
        case Registry.start_link(keys: :unique, name: __MODULE__) do
            {:error, _err} -> raise "Could not start the context registry"
            {:ok, pid} -> pid
        end
    end

    def register(pid, context_id, context_pid) when is_binary(context_id) do
        case Registry.register(pid, context_id, context_pid) do
            {:error, _} -> raise "Could not register context in registry"
            {:ok, _} -> :ok
        end
    end

    @spec spawn_context() :: {:ok, binary} | {:fail, binary}
    def spawn_context() do
        spawn_context(nil, %{})
    end

    @spec spawn_context(atom, map) :: {:ok, binary} | {:fail, binary}
    def spawn_context(intent, props) when is_map(props) do
        context_pid = Context.start_link
        id = Context.getId(context_pid)
        Context.put(context_pid, :intent, intent)
        Context.put(context_pid, :props, props)

        case Registry.register(__MODULE__, id, context_pid) do
            {:error, _} -> {:fail, "Could not register context in the registry"}
            {:ok, _} -> {:ok, id}
        end
    end

    @spec lookup(binary) :: {:fail, binary} | {:ok, pid}
    def lookup(context_id) when is_binary(context_id) do
        case Registry.lookup(__MODULE__, context_id) do
            [{_pid, value} | _] -> {:ok, value}
            _ -> {:fail, "Could not find context in registry"}
        end
    end
end
