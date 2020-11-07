defmodule ContextTest do
    use ExUnit.Case

    alias Codebot.Domain.Context

    setup do
        pid = Context.start_link()
        {:ok, context_pid: pid}
    end

    test "can start a new context with random id", %{context_pid: pid} do
        id = Context.getId(pid)
        assert is_binary(id) == true
        refute id == ""
    end

    test "can start context with unique id" do
        table =
            1..1000
            |> Enum.map(fn (_index) ->
                Task.async(fn ->
                    pid = Context.start_link()
                    Context.getId(pid)
                end)
            end)
            |> Enum.map(fn (t)->
                Task.await(t)
            end)
            |> Enum.uniq

        assert length(table) == 1000
    end

    test "can set and retrieve a context intent", %{context_pid: pid} do
        Context.put(pid, :intent, :hello)

        assert Context.get(pid, :intent) == :hello
    end

    test "can not set other keys in context", %{context_pid: pid} do
        Context.put(pid, :foo, :bar)

        refute Context.get(pid, :foo) == :bar
        assert Context.put(pid, :foo, :bar) == :fail
    end

    test "can add props to the context as map", %{context_pid: pid} do
        Context.put(pid, :props, %{"name" => "Mihai", "job" => "developer"})
        props = Context.get(pid, :props)

        assert Map.fetch!(props, "name") == "Mihai"
        assert Map.fetch!(props, "job") == "developer"
    end

    test "can not set props as anything other then map", %{context_pid: pid} do
        res = Context.put(pid, :props, "Mihai")
        props = Context.get(pid, :props)

        refute props == "Mihai"
        assert props == nil
        assert res == :fail
    end

    test "can update intent", %{context_pid: pid} do
        Context.put(pid, :intent, :foo)
        Context.put(pid, :intent, :bar)
        intent = Context.get(pid, :intent)

        assert intent == :bar
    end

    test "can update props", %{context_pid: pid} do
        Context.put(pid, :props, %{"name" => "Mihai"})
        Context.put(pid, :props, %{"name" => "Serban"})
        props = Context.get(pid, :props)

        assert Map.fetch!(props, "name") == "Serban"
    end

    test "can delete an intent", %{context_pid: pid} do
        Context.put(pid, :intent, :foo)
        Context.del(pid, :intent)

        assert Context.get(pid, :intent) == nil
    end

    test "can delete a all props", %{context_pid: pid} do
        Context.put(pid, :props, %{"name" => "Mihai"})
        Context.del(pid, :props)

        assert Context.get(pid, :props) == nil
    end
end
