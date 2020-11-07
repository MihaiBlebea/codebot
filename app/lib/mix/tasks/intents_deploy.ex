defmodule Mix.Tasks.IntentsDeploy do
    use Mix.Task

    @shortdoc "Deploy the intents to Witai using the API"
    @spec run(any) :: none
    def run(args) do
        Mix.Task.run("app.start")

        args
        |> fetch_path_from_args
        |> read_file
        |> decode
        |> IO.inspect
        |> deploy(:intent)
        |> deploy(:entity)
        |> deploy(:utterance)
    end

    defp read_file(path) do
        File.read!(path)
    end

    defp decode(content) do
        JSON.decode!(content)
    end

    defp deploy(template, :intent) do
        template
        |> Map.fetch!("intent")
        |> deploy_intents

        template
    end

    defp deploy(template, :entity) do
        template
        |> Map.fetch!("entities")
        |> Enum.map(fn (entity)-> Witai.create_entity(entity) end)
        |> IO.inspect

        template
    end

    defp deploy(template, :utterance) do
        template
        |> Map.fetch!("utterances")
        |> Witai.create_utterances
        |> IO.inspect

        template
    end

    defp deploy_intents(list) when is_list(list) do
        list |> Enum.map(fn (intent_name)-> Witai.create_intent(intent_name) end)
    end

    defp deploy_intents(intent) when is_binary(intent) do
        Witai.create_intent(intent)
    end

    defp fetch_path_from_args(args) do
        case length(args) do
            0 -> raise "Please provide a valid path to a json file"
            _ -> Enum.at(args, 0)
        end
    end
end
