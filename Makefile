.PHONY: lint format fix

# Targets to lint and format Python code using Ruff via uvx.
# Override PY_SRCS to narrow the scope (default: current directory).
PY_SRCS ?= .

lint:
	uvx ruff format $(PY_SRCS)
	uvx ruff check $(PY_SRCS)

format:
	uvx ruff format $(PY_SRCS)

fix:
	uvx ruff check $(PY_SRCS) --fix
	uvx ruff format $(PY_SRCS)

.PHONY: template-test
template-test:
	bash dev/test_copier.sh
