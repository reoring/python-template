## weather-agent

OpenAI Responses クライアント（`agent_framework.openai.OpenAIResponsesClient`）を使った最小サンプルです。これは Microsoft Agent Framework で作成したデモ用の Agent アプリケーションです。`uv` で実行できます。

### 前提
- Python 3.10+
- `uv` がインストール済み（未インストールの場合: `curl -LsSf https://astral.sh/uv/install.sh | sh`）

### セットアップ
```bash
uv sync
cp .env.example .env
# .env を開いて OPENAI_API_KEY と OPENAI_RESPONSES_MODEL_ID を設定
```

`.env` の例:
```env
OPENAI_API_KEY=sk-...
OPENAI_RESPONSES_MODEL_ID=gpt-5-nano
# 任意
# OPENAI_ORG_ID=...
# OPENAI_BASE_URL=...
```

### 実行
```bash
# エントリポイント（console_script）
uv run weather-agent

# もしくはモジュール実行
uv run python -m weather_agent.main
```
