.PHONY: all clean gen_thrift deps example run

all: clean compile release

clean:
	@echo "Cleaning..."
	@rm -rf _build

deps:
	@echo "Dependencies..."
	@mix deps.get
	@mix deps.compile

compile:
	@echo "Compiling..."
	@mix compile

release: compile
	@echo "Bulding release..."
	@mix release --name=example --env=dev --no-tar

run:
	_build/dev/rel/example/bin/example console

# gen_thrift_erlang:
# 	@rm -rf apps/example/src/gen
# 	@mkdir apps/example/src/gen
# 	@thrift -r -v -out apps/example/src/gen --gen erl apps/example/thrift/example.thrift
# 	@rm -rf apps/example/include/gen/*
# 	@cp apps/example/src/gen/*.hrl apps/example/include/gen