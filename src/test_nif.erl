-module(test_nif).
-on_load(init/0).

%%%%%
-export(
   [try_crashing/2
   ]).

%%%%%
init() ->
    PrivPath =
        case code:priv_dir(enif_send_crash) of
            {error, bad_name} -> "priv";
            ExistingPrivPath -> ExistingPrivPath
        end,
    {ok,  WorkingDir} = file:get_cwd(),

    lists:foldl(
      fun (Path, {error, _Reason}) ->
              NifPath = filename:join(Path, "test_nif"),
              erlang:load_nif(NifPath, 0);
          (_Path, ok) ->
              ok
      end,
      {error, no_attempt_made},
      [PrivPath, WorkingDir]).

try_crashing(_Iterations, _ToPid) ->
    erlang:nif_error(nif_library_not_loaded).
