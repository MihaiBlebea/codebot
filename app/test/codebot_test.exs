defmodule CodebotTest do
    use ExUnit.Case
    doctest Codebot

    @tag :skip
    test "greets the world" do
        assert Codebot.hello() == :world
    end
end
