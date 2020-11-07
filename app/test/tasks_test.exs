defmodule TasksTest do
    use ExUnit.Case

    alias Codebot.Adapter.TaskMock

    setup do
        TaskMock.wipe_tasks()
    end

    test "can create a task and list it" do
        TaskMock.store_task(%{"title" => "Go and buy a dog"})
        [%{"title" => title} | _] = TaskMock.list_tasks()

        assert title == "Go and buy a dog"
    end

    test "can save more then one task and list them" do
        1..100
        |> Enum.map(fn (index)-> TaskMock.store_task(%{"title" => "Task nr #{ Integer.to_string(index) }"}) end)
        tasks = TaskMock.list_tasks()

        assert length(tasks) == 100
        assert Map.fetch!(Enum.at(tasks, 99), "title") == "Task nr 100"
    end
end
