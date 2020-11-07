defmodule Codebot.Repository do
    # https://github.com/zookzook/elixir-mongodb-driver

    @spec connect :: pid
    def connect() do
        url = Application.fetch_env!(:codebot, :mongo_url)
        db_name = Application.fetch_env!(:codebot, :mongo_url)
        case Mongo.start_link(url: "#{ url }/#{ db_name }") do
            {:ok, pid} -> pid
            {:error, _} -> raise "Could not connect to mongo db"
        end
    end

    @spec drop(atom | pid, binary) :: :ok | {:error, Mongo.Error.t()}
    def drop(pid, collection) do
        Mongo.drop_collection(pid, collection)
    end

    @spec insert_one(pid | atom, binary, map) :: {:error, any} | {:ok, any}
    def insert_one(pid, collection, doc) when is_atom(collection)and is_map(doc)  do
        Mongo.insert_one(pid, collection, doc)
    end

    @spec find_one(pid | atom, atom, map) :: map
    def find_one(pid, collection, query) when is_atom(collection) and is_map(query) do
        Mongo.find_one(pid, collection, query)
    end

    @spec find_many(pid | atom, atom, map) :: list
    def find_many(pid, collection, query) when is_atom(collection) and is_map(query) do
        Mongo.find(pid, collection, query)
        |> Enum.to_list
    end

    def update_one(pid, collection, find_query, update_query)
        when is_atom(collection)
        and is_map(find_query)
        and is_map(update_query) do

        Mongo.update_one(pid, collection, find_query, update_query)
    end
end
