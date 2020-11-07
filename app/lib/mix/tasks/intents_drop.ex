defmodule Mix.Tasks.IntentsDrop do
    use Mix.Task

    @shortdoc "Drop the intents to Witai using the API"
    @spec run(any) :: none
    def run(args) do
        Mix.Task.run("app.start")

        args
        |> fetch_path_from_args
        |> read_file
        |> decode
        |> drop(:intent)
        |> drop(:entity)
        |> drop(:utterance)
    end

    defp read_file(path) do
        File.read!(path)
    end

    defp decode(content) do
        JSON.decode!(content)
    end

    defp drop(template, :intent) do
        template
        |> Map.fetch!("intent")
        |> drop_intents

        template
    end

    defp drop(template, :entity) do
        template
        |> Map.fetch!("entities")
        |> Enum.map(fn (entity)-> Map.fetch!(entity, "name") |> Witai.delete_entity end)
        |> IO.inspect

        template
    end

    defp drop(template, :utterance) do
        template
        |> Map.fetch!("utterances")
        |> Enum.map(fn (utterance)-> Map.fetch!(utterance, "text") end)
        |> Witai.delete_utterances
        |> IO.inspect

        template
    end

    defp drop_intents(list) when is_list(list) do
        list |> Enum.map(fn (intent_name)-> Witai.delete_intent(intent_name) end)
    end

    defp drop_intents(intent) when is_binary(intent) do
        Witai.delete_intent(intent)
    end

    defp fetch_path_from_args(args) do
        case length(args) do
            0 -> raise "Please provide a valid path to a json file"
            _ -> Enum.at(args, 0)
        end
    end
end
