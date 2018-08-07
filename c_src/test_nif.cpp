#include <erl_nif.h>

static ERL_NIF_TERM try_crashing_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
    unsigned iterations = 0;
    ErlNifPid to_pid;
    if (!enif_get_uint(env, argv[0], &iterations)) {
        return enif_make_badarg(env);
    }
    if (!enif_get_local_pid(env, argv[1], &to_pid)) {
        return enif_make_badarg(env);
    };

    for (unsigned i = 0; i < iterations; ++i) {
        ERL_NIF_TERM msg = enif_make_uint64(env, 0xFFFFFFFFFFFFFFFFllu); // large enough for heap allocation
        enif_send(env, &to_pid, nullptr, msg);
    }
    return enif_make_atom(env, "ok");
}

static ErlNifFunc nif_funcs[] = {
    {"try_crashing", 2, try_crashing_nif, ERL_NIF_DIRTY_JOB_CPU_BOUND}
};

/****************************************************************/

static int load(ErlNifEnv* env, void** /*priv*/, ERL_NIF_TERM /*load_info*/) {
    return 0;
}

ERL_NIF_INIT(test_nif, nif_funcs, load, NULL, NULL, NULL)
