defmodule BotTest do
    use ExUnit.Case

    @noreply [
        "Sorry! Could not get that. Can you say that again?",
        "Sorry. Again?",
        "What was that?",
        "I beg your pardon"
    ]

    @hello [
        "Hey! How are you buddy?",
        "What's new?",
        "How are you today?",
        "All good?"
    ]

    @bye [
        "See you soon",
        "Take care",
        "Glad I could help",
        "Have a good day"
    ]

    test "can pass an empty string msg and still get a response" do
        resp = Codebot.Bot.query ""

        assert resp in @noreply
    end

    test "can pass a hey message and get response" do
        resp = Codebot.Bot.query "hey"

        assert resp in @hello
    end

    test "can pass a bye message and get response" do
        resp = Codebot.Bot.query "bye"

        assert resp in @bye
    end
end
