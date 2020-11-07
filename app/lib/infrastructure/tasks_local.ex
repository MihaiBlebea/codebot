defmodule Codebot.Adapter.TaskMock do

    @path "./store/tasks.#{ Mix.env() }.json"

    @spec store_task(map) :: :ok
    def store_task(task) when is_map(task) do
        read()
        |> decode
        |> append(task)
        |> encode
        |> write
    end

    @spec list_tasks :: list
    def list_tasks() do
        read()
        |> decode
    end

    @spec wipe_tasks :: :ok | :fail
    def wipe_tasks() do
        case File.rm(@path) do
            :ok -> :ok
            {:error, :enoent} -> :ok
            _ -> :fail
        end
    end

    defp append(tasks, task) when is_map(task) do
        Enum.concat(tasks, [task])
    end

    defp write(tasks) when is_binary(tasks) do
        File.write!(@path, tasks)
    end

    defp read() do
        case File.read(@path) do
            {:ok, content} -> content
            {:error, :enoent} -> []
            _ -> []
        end
    end

    defp encode(tasks) do
        JSON.encode!(tasks)
    end

    defp decode([]), do: []

    defp decode(tasks), do: JSON.decode!(tasks)
end
