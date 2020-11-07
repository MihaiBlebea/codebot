defmodule Codebot.Mock.WitaiRequestClient do

    @success_code 200

    @fail_code 500

    @spec get!(binary, any) :: %{body: map, status_code: 200}
    def get!(url, _headers) do
        action = url |> get_endpoint_from_url

        case action do
            "message" -> witai_message_resp_body() |> JSON.encode! |> build_response(@success_code)
        end
    end

    @spec post!(binary, any, any) :: %{body: map, status_code: 200}
    def post!(url, _body, _headers) do
        action = url |> get_endpoint_from_url

        case action do
            "intents" -> post_intent_res_body() |> JSON.encode! |> build_response(@success_code)
            "entities" -> post_entity_res_body() |> JSON.encode! |> build_response(@success_code)
            "utterances" -> post_utterance_resp_body() |> JSON.encode! |> build_response(@success_code)
        end
    end

    # def put!(url, body, headers, options) do
    #     %{body: _body, status_code: code}
    # end

    @spec delete!(any, any, any) :: %{body: map, status_code: 200}
    def delete!(_url, _headers, _options) do
        build_response(%{}, @success_code)
    end

    @spec request!(:delete, any, any, any, any) :: %{body: map, status_code: 200}
    def request!(:delete, _url, _body, _headers, _options) do
        build_response(%{}, @success_code)
    end

    @spec witai_message_resp_body :: map
    def witai_message_resp_body() do
        %{
            "text" => "Hey mate!",
            "intents" => [
                %{
                    "id" => "1701608719981716",
                    "name" => "hello",
                    "confidence" => 0.8849
                }
            ],
            "entities" => %{
                "metric:metric" => [
                    %{
                        "id" => "3701487719281796",
                        "name" => "metric",
                        "role" => "metric",
                        "start" => 9,
                        "end" => 15,
                        "body" => "people",
                        "value" => "metric_visitor",
                        "confidence" => 0.9231,
                        "entities" => []
                    }
                ],
            },
            "traits" => []
        }
    end

    @spec post_intent_res_body :: map
    def post_intent_res_body() do
        %{
            "id" => "13989798788",
            "name" => "buy_flowers"
        }
    end

    @spec post_entity_res_body :: map
    def post_entity_res_body() do
        %{
            "id" => "5418abc7-cc68-4073-ae9e-3a5c3c81d965",
            "name" => "flower_color",
            "roles" => ["flower_color"],
            "lookups" => ["free-text", "keywords"],
            "keywords" => []
        }
    end

    @spec post_utterance_resp_body :: map
    def post_utterance_resp_body() do
        [
            %{
                "text" => "I want to fly to sfo",
                "intent" => "flight_request",
                "entities" => [
                    %{
                        "entity" => "wit$location:to",
                        "start" => 17,
                        "end" => 20,
                        "body" => "sfo",
                        "entities" => []
                    }
                ],
                "traits" => []
            }
        ]
    end

    defp build_response(body, code) do
        %{body: body, status_code: code}
    end

    defp get_endpoint_from_url(url) do
        url
        |> String.replace_leading("https://api.wit.ai/", "")
        |> String.split("/")
        |> Enum.at(0)
        |> String.split("?")
        |> Enum.at(0)
    end
end
