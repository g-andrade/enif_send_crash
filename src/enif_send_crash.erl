-module(enif_send_crash).

-export([main/1]).

main(_Args) ->
    ToPid = spawn_link(fun recv_loop/0),
    try_crashing_loop(1, ToPid).

recv_loop() ->
    receive
        _Msg -> recv_loop()
    end.

try_crashing_loop(Iterations, ToPid) ->
    io:format("Trying to crash (~p iterations)...~n", [Iterations]),
    test_nif:try_crashing(Iterations, ToPid),
    try_crashing_loop(Iterations * 2, ToPid).
