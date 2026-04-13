#!/bin/bash
# Load environment vars for AI Agent project

cd ~/ai_agents

# Try decrypt age secrets (if available)
if [ -f config/secrets.enc ] && [ -f ~/.config/ai_agents/age-key.txt ]; then
    export $(age -d -i ~/.config/ai_agents/age-key.txt config/secrets.enc 2>/dev/null | grep -v '^#' | xargs)
    echo "✅ Loaded encrypted secrets"
fi

# Load .env.example defaults (if var not set)
if [ -f .env.example ]; then
    set -a
    source .env.example
    set +a
fi

echo "✅ Env loaded: 9Router=$NINE_ROUTER_BASE"
