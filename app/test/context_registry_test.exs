defmodule ContextRegistryTest do
    use ExUnit.Case

    alias Codebot.Domain.Context.Registry

    alias Codebot.Domain.Context

    setup_all do
        pid = Registry.start_link
        {:ok, registry_pid: pid}
    end

    test "can create an empty context from registry" do
        {:ok, id} = Registry.spawn_context()

        assert is_binary(id)
    end

    test "can create a context from registry with intent and params" do
        {:ok, id} = Registry.spawn_context(:foo, %{"name" => "Mihai"})
        {:ok, c_pid} = Registry.lookup(id)
        intent = Context.get(c_pid, :intent)
        props = Context.get(c_pid, :props)

        assert is_binary(id) == true
        assert intent == :foo
        assert Map.fetch!(props, "name") == "Mihai"
    end
end
