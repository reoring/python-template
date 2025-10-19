## weather-agent-template

This repository is a Copier template for a minimal Python CLI app. It generates a small
"weather" sample with zero external API dependencies.

### Prerequisites
- Python 3.10+
- `uv` installed (if not installed: `curl -LsSf https://astral.sh/uv/install.sh | sh`)

### Use as a template (Copier)
```bash
# Generate into an output directory with your own values
uvx --from copier copier copy --force \
  -d project_name="My App" \
  -d project_slug="my-app" \
  -d package_name="my_app" \
  -d python_version="3.10" \
  /home/reoring/Sync/dev/weather-agent /tmp/my-app

cd /tmp/my-app
uv sync
uv run my-app
```

### Quick local smoke test
```bash
make template-test
```

### Template variables
- project_name: Human readable name (default: "My App")
- project_slug: CLI name (kebab-case)
- package_name: Top-level Python package (snake_case)
- python_version: Minimum Python version

Generated projects include their own README describing how to run the app.
