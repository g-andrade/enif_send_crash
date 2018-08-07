REBAR3_URL=https://s3.amazonaws.com/rebar3/rebar3

ifeq ($(wildcard rebar3),rebar3)
	REBAR3 = $(CURDIR)/rebar3
endif

REBAR3 ?= $(shell test -e `which rebar3` 2>/dev/null && which rebar3 || echo "./rebar3")

ifeq ($(REBAR3),)
	REBAR3 = $(CURDIR)/rebar3
endif

.PHONY: all escript run

all: run

$(REBAR3):
	wget $(REBAR3_URL) || curl -Lo rebar3 $(REBAR3_URL)
	@chmod a+x rebar3

escript: $(REBAR3)
	@$(REBAR3) escriptize
	cp -p _build/default/lib/enif_send_crash/priv/* ./
	cp -p _build/default/bin/enif_send_crash enif_send_crash

run: escript
	./enif_send_crash
