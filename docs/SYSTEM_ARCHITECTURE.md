MULTI-AGENT AUTOMATION SYSTEM – FINAL ARCHITECTURE
Version: 2.0 | Updated: April 2026 | Target Hardware: ASUS X555LI (i5-5200U, 12GB RAM, Xubuntu)
Core Philosophy: Cloud Free Tier = Heavy Compute (Gen/Debate/Code) → Local Machine = Orchestration, Memory, Review, Learning/Fine-Tuning

📋 TABLE OF CONTENTS
    1. Objectives & Purpose
    2. System Architecture
    3. Core Flows
    4. Free Tier Multi-Provider Router Strategy
    5. Tech Stack
    6. Memory & Learning Pipeline
    7. Setup Checklist (Phased)
    8. Key Metrics & Monitoring
    9. Execution Guidelines

1. OBJECTIVES & PURPOSE
🎯 Primary Objective
Xây dựng hệ thống multi-agent tự động hóa nội dung, code, phân tích kinh doanh và đăng social media. Tận dụng tối đa Cloud Free Tier cho các tác vụ nặng, Local Machine đóng vai trò trung tâm điều phối, lưu trữ memory, review, và tự học qua fine-tuning để dần giảm phụ thuộc cloud.
👤 User Profile & Needs
    • Solo Developer / Coder cơ bản: Tập trung vào strategy, content direction, phê duyệt.
    • Không muốn: Quản lý phức tạp, chi phí API, vendor lock-in, phụ thuộc cloud 100%.
    • Cần: Hệ thống hoạt động ổn định trên laptop yếu, tự học theo thời gian, quality cải thiện month-by-month.
📅 Realistic Timeline
Phase
Duration
Deliverable
MVP (Cloud Gen + Local UI + Memory)
2-3 weeks
Router, FastAPI, Streamlit, SQLite, Basic Agent
Debate + Multi-Platform Posting
4-6 weeks
AG2 Cloud Debate, Playwright, APScheduler
Fine-Tuning Pipeline Ready
Week 7-8
Colab integration, Dataset export, A/B testing
Continuous Learning & Optimization
Month 2+
Monthly fine-tune, local model gradually takes over

2. SYSTEM ARCHITECTURE
┌─────────────────────────────────────────────────────┐
│                 WEB UI (Streamlit)                  │
│  • Dashboard: agent status, pending approvals       │
│  • Content Review: approve/reject per platform      │
│  • Memory Browser: search Qdrant vectors            │
│  • Model Manager: track fine-tune versions          │
│  • Settings: router rules, agent config             │
└─────────────────────────────────────────────────────┘
                          │ HTTP/WebSocket
                          ▼
┌─────────────────────────────────────────────────────┐
│           FASTAPI BACKEND (Local Orchestrator)      │
│                                                     │
│  ┌─ Free Tier Router ─────────────────────────┐    │
│  │ • Manages pool of 9+ free models/providers │    │
│  │ • Auto-switches on rate-limit/timeout      │    │
│  │ • Caches successful responses locally      │    │
│  └──────────────────┬─────────────────────────┘    │
│                     │ HTTPS (Cloud Offload)        │
│  ┌─ Agent Logic ────▼─────────────────────────┐    │
│  │ • Cloud: Gen, Debate (Critic/Validator)    │    │
│  │ • Cloud: Code generation, business analysis│    │
│  │ • Local: Quick safety check, formatting    │    │
│  └──────────────────┬─────────────────────────┘    │
│                     │                              │
│  ┌─ Memory Manager ─▼─────────────────────────┐    │
│  │ • HOT: SQLite (session, approvals, tasks)  │    │
│  │ • WARM: Qdrant (semantic vectors + meta)   │    │
│  │ • COLD: JSON.gz archives (indefinite)      │    │
│  │ • Retention: 7d / 30d / forever            │    │
│  └──────────────────┬─────────────────────────┘    │
│                     │                              │
│  ┌─ Scheduler ──────▼─────────────────────────┐    │
│  │ • APScheduler: cron jobs for posting       │    │
│  │ • Playwright: human-like browser automation│    │
│  │ • Checkpoint: crash resume from state DB   │    │
│  └────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────┘
          │              │              │
          ▼              ▼              ▼
    ┌─────────┐    ┌─────────┐    ┌──────────┐
    │ SQLite  │    │ Qdrant  │    │ Encrypted│
    │ (State) │    │ (Search)│    │  Config  │
    └─────────┘    └─────────┘    └──────────┘
          │
          ▼ (Monthly Export)
    ┌─────────────────────────────────────┐
    │        FINE-TUNING PIPELINE         │
    │  • Google Colab (Free GPU)          │
    │  • Unsloth → GGUF-Q4 export         │
    │  • A/B Test vs Base Model           │
    │  • Deploy → Local LLM improves      │
    └─────────────────────────────────────┘

3. CORE FLOWS
🔹 Flow A: Generate → Debate → Approve → Learn (Cloud-First)
1. USER: Request via Web UI ("Generate X for Instagram")
   │
2. FASTAPI: Routes to Free Tier Router
   ├─ Router selects best available free model
   └─ Sends prompt + agent instructions to Cloud
   │
3. CLOUD EXECUTION (Heavy Compute Offloaded)
   ├─ Generator Agent: Drafts core content
   ├─ Critic/Validator Agents (AG2): 2-round debate & refinement
   ├─ Code/Business Agents: Add examples/strategy (if requested)
   └─ Output: Final polished draft(s) + metadata
   │
4. LOCAL RECEIPT: FastAPI receives cloud output
   ├─ Stores in SQLite (pending approval)
   ├─ Embeds vector → Qdrant (WARM memory)
   └─ Notifies Telegram + Web UI
   │
5. USER REVIEW: Approve/Reject/Edit in UI
   ├─ If approved: Schedule via APScheduler
   └─ If rejected: Store feedback → Qdrant (for future training)
   │
6. POSTING: At scheduled time
   ├─ Playwright wakes (browser profile + encrypted creds)
   ├─ Human-like timing → Posts to platform
   └─ Stores post URL + success status
   │
7. LOCAL LEARNING LOOP (Continuous)
   ├─ Track engagement (likes, shares, comments)
   ├─ Update quality score in SQLite/Qdrant
   └─ Monthly: Export high-quality approved pairs → Fine-tune Local LLM
🔹 Flow B: Monthly Fine-Tuning & Local Model Upgrade
1. TRIGGER: 1st of month (APScheduler)
   │
2. DATA PREP: Query SQLite/Qdrant
   ├─ Filter: approved=true, engagement>=median, quality>=4/5
   ├─ Format: {prompt, cloud_output, platform, feedback, timestamp}
   └─ Target: 1000+ clean examples
   │
3. CLOUD TRAINING: Upload to Google Colab
   ├─ Load base model (Qwen3.5-4B / target local model)
   ├─ Fine-tune via Unsloth (LoRA/QLoRA)
   ├─ Export as GGUF-Q4_K_M
   └─ Download to ~/ai_agents/models/
   │
4. LOCAL VALIDATION: A/B Testing
   ├─ Run 50 test prompts on old vs new model
   ├─ Auto-score + manual sample check
   ├─ If new wins >60%: set as active
   └─ Archive old version
   │
5. RESULT: Local LLM gradually handles more tasks offline
   └─ Cloud dependency decreases over time
🔹 Flow C: Crash Recovery & State Resume
1. SYSTEM RESTARTS after crash/power loss
   │
2. CHECKPOINT LOADER scans SQLite for incomplete tasks
   ├─ Identifies stage: routing/cloud_gen/review/posting
   └─ Loads serialized context (prompt, partial output, agent state)
   │
3. RESUME LOGIC:
   ├─ If cloud_gen failed → Retry via Router
   ├─ If review pending → Notify user
   └─ If posting failed → Retry with exponential backoff
   │
4. TELEGRAM ALERT sent if manual intervention required

4. FREE TIER MULTI-PROVIDER ROUTER STRATEGY
🔄 Router Logic (Priority & Failover)
ROUTER_CONFIG:
  strategy: "round_robin_with_health_check"
  timeout_per_request: 300s
  max_retries: 3
  rate_limit_handling: "auto_switch_on_429_or_503"

FREE_TIER_POOL:
  - provider: "OpenRouter"
    models: ["qwen/qwen3-80b:free", "meta-llama/llama-3.3-70b:free", "google/gemma-3-4b:free"]
  - provider: "Groq"
    models: ["llama-3.3-70b-versatile", "mixtral-8x7b-32768"]
  - provider: "Together AI"
    models: ["meta-llama/Llama-3-8b-chat-hf", "Qwen/Qwen2.5-7B-Instruct-Turbo"]
  - provider: "HuggingFace Inference API"
    models: ["mistralai/Mistral-7B-Instruct-v0.3"]
  - provider: "Local Fallback" (only for light tasks)
    model: "Qwen3.5-4B-Q4_K_M"

FAILOVER_MECHANISM:
  1. Try primary provider/model
  2. If 429/503/timeout → mark as "throttled" for 5 min
  3. Auto-switch to next available in pool
  4. Log usage per provider to stay under daily limits
  5. Cache successful responses locally for identical future prompts
✅ Result: Gần như không bao giờ bị block hoàn toàn. Tận dụng tối đa quota free từ nhiều nhà cung cấp, nghiên cứu áp dụng 9router

5. TECH STACK
Category
Tool/Service
Purpose
Cloud Router
OpenRouter API + Custom Failover Logic
Route to 9+ free models, auto-switch on limits
Local Backend
FastAPI (Python 3.10+)
Core orchestration, memory, API hub
Local LLM
Ollama + Qwen3.5-4B-Q4_K_M
Lightweight review, local fallback, fine-tuning target
Agent Framework
CrewAI (task routing), AG2 (cloud debate)
Multi-agent orchestration, critique loops
Memory
SQLite (HOT), Qdrant Local (WARM), JSON.gz (COLD)
Session state, semantic search, long-term archives
UI
Streamlit + FastAPI
Python-native, zero-build frontend for MVP
Automation
APScheduler + Playwright
Cron scheduling, human-like browser posting
Fine-Tuning
Google Colab (Free GPU) + Unsloth
Monthly local model training → GGUF export
Security
Encrypted config files (age/ansible-vault)
Store tokens, browser profiles, credentials safely
Notifications
Telegram Bot (Minimal)
Alerts for review needed, post success, system errors

6. MEMORY & LEARNING PIPELINE
🗃️ 3-Layer Retention Policy
Layer
Storage
Retention
Cleanup
HOT
SQLite
7 days
Auto-archive or delete after approval/post
WARM
Qdrant (Local)
30 days
Delete vectors >30d after monthly archive
COLD
monthly_YYYY_MM.json.gz
Indefinite
Encrypted, versioned, backup to external drive
📈 Learning Loop Design
Cloud Output → User Approve → Engagement Tracked → Quality Score Assigned
       ↓
Stored in Qdrant + SQLite (labeled dataset)
       ↓
Monthly Export (filter: score≥4, engagement≥median)
       ↓
Fine-tune Local Model (Unsloth/Colab)
       ↓
Local Model Gradually Replaces Cloud for Similar Tasks

7. SETUP CHECKLIST (PHASED)
🟢 PHASE 0: PREP (Week -1)
    • Backup laptop, verify Xubuntu, free 40GB SSD
    • Create test social accounts (IG, Pinterest, FB, Threads)
    • Register OpenRouter, Groq, Together AI, HuggingFace (collect free API keys)
    • Setup Google Colab, Telegram BotFather (2 tokens)
    • Document hardware baseline (RAM, CPU temp, disk speed)
🔵 PHASE 1: CORE INFRA (Week 1)
    • Install Ollama, pull qwen3.5:4b (for local fallback/future fine-tune)
    • Setup Python 3.10+ venv (~/ai_agents)
    • Install core deps: fastapi, uvicorn, crewai, qdrant-client, python-telegram-bot, playwright
    • Initialize directory structure (agents/, memory/, models/, archives/, config/)
    • Setup encrypted config storage for API keys & browser profiles
🟡 PHASE 2: ROUTER & AGENTS (Week 2)
    • Build Free Tier Router logic (pool, health check, auto-switch, caching)
    • Define CrewAI agents (Manager, Content, Code, Business)
    • Setup Cloud Debate flow via AG2 (2-round max)
    • Connect Router → Cloud Agents → FastAPI endpoints
🟠 PHASE 3: MEMORY & UI (Week 2-3)
    • Initialize SQLite tables (tasks, approvals, checkpoints, engagement)
    • Setup Qdrant local collection, test vector store/retrieve
    • Build Streamlit UI: Dashboard, Review, Memory Browser, Settings
    • Connect WebSocket for real-time cloud agent streaming
🔴 PHASE 4: AUTOMATION (Week 3-4)
    • Setup APScheduler (daily/weekly/monthly jobs)
    • Implement Playwright scripts (start with Instagram, human-like timing)
    • Connect approval UI → scheduler → Playwright → post verification
    • Test checkpoint resume (simulate crash mid-flow)
🟣 PHASE 5: FINE-TUNING PIPELINE (Week 5-6)
    • Build dataset exporter (SQL → JSON, filter by quality/engagement)
    • Create Colab notebook template (Unsloth + GGUF export)
    • Setup model versioning (~/ai_agents/models/v1/, v2/...)
    • Implement A/B testing logic & deployment switch
⚫ PHASE 6: TESTING & OPS (Week 6-8)
    • End-to-end test: Request → Cloud Debate → Review → Schedule → Post
    • Stress test: 3 concurrent tasks, monitor RAM/CPU, verify router failover
    • Document troubleshooting, add error handling (retries, alerts, fallbacks)
    • Go live with 1 platform, expand gradually

8. KEY METRICS & MONITORING
📊 System Health
ROUTER:
  cloud_success_rate: ">85%"
  auto_switch_count: "<5 per day"
  local_fallback_usage: "<10%"
RESOURCE:
  ram_peak: "<10GB"
  cpu_temp: "<80°C"
  qdrant_memory: "<500MB"
RELIABILITY:
  checkpoint_recovery: "100%"
  posting_success: ">95%"
  error_rate: "<0.5%"
📈 Quality & Learning
CONTENT:
  approval_rate: ">70%"
  post_debate_improvement: "+1-2 quality points"
  engagement_trend: "positive month-over-month"
FINE-TUNE:
  monthly_dataset_size: "1000+ labeled examples"
  model_improvement_delta: "+3-5% per cycle"
  cloud_dependency_reduction: "5-10% tasks moved local/month"

9. EXECUTION GUIDELINES
    1. Start Small: Week 1-2 only build Router + 1 Agent + SQLite + Streamlit UI. Verify cloud-to-local flow works before adding debate or posting.
    2. Track Everything: Log every router switch, cloud model used, response time, and user approval. This data fuels your fine-tuning pipeline.
    3. Secure Credentials: Never hardcode API keys. Use encrypted config files and environment variables. Rotate tokens if any platform suspends test accounts.
    4. Browser Automation Caution: Start with 1 platform (Instagram). Use mobile viewport, random delays (30-120s), and avoid spammy patterns. Monitor account health daily.
    5. Fine-Tuning Discipline: Only train on approved + engaged content. Garbage in = garbage out. Quality filtering is more important than dataset size.
    6. Living Document: Update this architecture as you learn. Add failed router endpoints, new free providers, or agent behavior tweaks. Version control your config.


MASTER CHECKLIST: MULTI-AGENT SYSTEM (Cloud-First, Local-Learn)
Print-friendly • Check off as you go • Estimated total: 6-8 weeks

🟢 PHASE 0: PREPARATION (Week -1 | ~4-6 hours)
🔧 Environment Setup
    • Backup toàn bộ dữ liệu laptop (external drive or cloud)
    • Kiểm tra Xubuntu version: lsb_release -a → cần ≥ 22.04 LTS
    • Free up SSD: Delete/uninstall apps không cần → target 40GB free
    • Tạo user riêng cho project (optional nhưng recommended):
bash
    • sudo adduser aiagent
    • sudo usermod -aG sudo aiagent  # nếu cần quyền admin

Ghi lại hardware baseline:
        ◦ RAM total: free -h
        ◦ CPU model: lscpu | grep "Model name"
        ◦ Disk speed (optional): hdparm -t /dev/sda
🔐 Accounts & Credentials
    • Telegram: Tạo 2 bots via @BotFather
        ◦ Bot 1 (notifications): Lưu token 123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11
        ◦ Bot 2 (assistant, optional): Lưu token riêng
    • Social test accounts (dùng email riêng để dễ quản lý):
        ◦ Instagram (business account recommended)
        ◦ Pinterest (business account)
        ◦ Facebook (page or personal for testing)
        ◦ Threads (linked to IG test account)
        ◦ Blog platform (Ghost/WordPress local or static site)
    • Cloud AI Providers (Free Tier):
        ◦ OpenRouter.ai: Register → API key → note free models available
        ◦ Groq.com: Register → API key → check rate limits
        ◦ Together.ai: Register → API key → note free tier quota
        ◦ HuggingFace: Register → Access Token → Inference API access
        ◦ Google Colab: Verify account active, GPU available
    • Git Hosting:
        ◦ GitHub/GitLab account
        ◦ Generate SSH key: ssh-keygen -t ed25519 -C "aiagent@laptop"
        ◦ Add public key to hosting platform
📁 Project Initialization
    • Tạo folder structure:
mkdir -p ~/ai_agents/{agents,memory/models,archives,scheduled_posts,config,logs,docs}
    • Khởi tạo Git repo:
cd ~/ai_agents
git init
git remote add origin git@github.com:yourusername/ai_agents.git

    • Tạo .gitignore (copy template below):
gitignore
# Secrets
config/*.enc
.env

# Large files
models/*.gguf
archives/*.json.gz
memory/qdrant_data/

# System
__pycache__/
*.pyc
.venv/
logs/*.log
    • Commit initial structure:
bash
git add .gitignore README.md docs/SYSTEM_ARCHITECTURE.md
git commit -m "chore: init repo + architecture doc"
git push -u origin main
📄 Documentation Setup
    • Copy SYSTEM_ARCHITECTURE.md vào ~/ai_agents/docs/
    • Tạo DECISION_LOG.md template:
markdown
## [YYYY-MM-DD] Decision Title
- Context: ...
- Options considered: ...
- Decision: ...
- Reason: ...
- Impact: ...

    • Tạo QUICK_START.md cho future-you hoặc collaborator
✅ Phase 0 Done When: Repo initialized, accounts ready, folder structure in place, architecture doc committed.

🔵 PHASE 1: CORE INFRASTRUCTURE (Week 1 | ~10-15 hours)
🤖 Local LLM Setup (Fallback Only)
    • Install Ollama:
bash
curl -fsSL https://ollama.ai/install.sh | sh
ollama --version  # verify

    • Pull fallback model (chỉ dùng cho light tasks/local review):
bash
ollama pull qwen3.5:4b
ollama list  # verify
    • Test inference speed (CRITICAL METRIC):
bash
time ollama run qwen3.5:4b "Viết 3 câu ngắn về AI agents"
        ◦ Ghi lại: tokens/sec, RAM usage (htop), CPU temp (sensors)
        ◦ Nếu <0.5 tokens/sec → consider using 2B model instead
🐍 Python Environment
    • Verify Python 3.10+:
bash
python3 --version  # need >=3.10
    • Create virtual environment:
bash
python3 -m venv ~/ai_agents/.venv
source ~/ai_agents/.venv/bin/activate
    • Create requirements.txt (starter):
Txt
# Core
fastapi>=0.110.0
uvicorn[standard]>=0.29.0
httpx>=0.27.0

# Agents
crewai>=0.30.0
ag2>=0.1.0  # verify package name

# Memory
qdrant-client[local]>=1.8.0
sqlalchemy>=2.0.0

# Automation
apscheduler>=3.10.0
playwright>=1.42.0

# UI
streamlit>=1.32.0

# Utilities
python-telegram-bot>=20.0
pydantic>=2.6.0
python-dotenv>=1.0.0

    • Install dependencies:
bash
pip install -r requirements.txt
python -c "import fastapi, crewai, qdrant_client; print('OK')"
🔐 Security & Config
    • Install encryption tool:
bash
sudo apt install age  # or ansible-vault
    • Create encrypted config template:
bash
mkdir -p ~/ai_agents/config
cat > ~/ai_agents/config/secrets_template.txt <<EOF
OPENROUTER_API_KEY=sk-or-...
GROQ_API_KEY=gsk_...
TELEGRAM_BOT1_TOKEN=...
TELEGRAM_BOT2_TOKEN=...
INSTAGRAM_USER=...
INSTAGRAM_PASS=...
EOF
# Encrypt (example with age):
age -o config/secrets.enc -R ~/.ssh/id_ed25519.pub config/secrets_template.txt
rm config/secrets_template.txt
    • Create .env.example (never commit real values):
bash
cat > ~/ai_agents/.env.example <<EOF
# Cloud Providers
OPENROUTER_API_KEY=your_key_here
GROQ_API_KEY=your_key_here

# Local Paths
AGENTS_DIR=./agents
MEMORY_DIR=./memory
MODELS_DIR=./models

# Router Settings
ROUTER_TIMEOUT=300
ROUTER_MAX_RETRIES=3
EOF
🗄️ Database Initialization
    • SQLite (HOT memory):
        ◦ Create memory/init_sqlite.py script (no code yet, just plan tables):
sql
-- conversations: id, timestamp, prompt, cloud_model_used, status
-- approvals: id, content_id, approved_by, scheduled_time, platform
-- checkpoints: task_id, stage, serialized_state, last_updated
-- engagement: post_id, platform, likes, comments, shares, timestamp
-- fine_tune_versions: version_id, base_model, dataset_size, quality_score, deployed_at
        ◦ Test: sqlite3 memory/hot.db ".tables" → verify creation
    • Qdrant Local (WARM memory):
        ◦ Install with local persistence: pip install "qdrant-client[local]"
        ◦ Create memory/init_qdrant.py to setup collection:
python
# Pseudocode: create collection "agent_memory" with:
# - vector_size: 4096 (for Qwen3.5 embeddings)
# - distance: Cosine
# - payload schema: {platform, content_type, quality_score, engagement}
        ◦ Test: store + retrieve one dummy vector
✅ Phase 1 Done When: Ollama running, Python env ready, encrypted config setup, SQLite + Qdrant initialized, first commit pushed.

🟡 PHASE 2: ROUTER + AGENT CORE (Week 2 | ~12-18 hours)
🔄 Free Tier Router Implementation
    • Design router config file (config/router.yaml):
yaml
strategy: round_robin_with_health
timeout: 300
max_retries: 3
providers:
  - name: openrouter
    base_url: https://openrouter.ai/api/v1
    models:
      - qwen/qwen3-80b:free
      - meta-llama/llama-3.3-70b:free
    rate_limit: {requests: 20, period: 60}  # per minute
  - name: groq
    base_url: https://api.groq.com/openai/v1
    models:
      - llama-3.3-70b-versatile
    rate_limit: {requests: 30, period: 60}
  # ... add other providers
    • Build router skeleton (agents/router.py):
        ◦ Function: select_next_provider() → health check + rate limit aware
        ◦ Function: send_request(prompt, model_hint) → auto-retry + fallback
        ◦ Function: cache_response(prompt_hash, response) → local cache for identical prompts
        ◦ Logging: track which provider used, response time, errors
    • Test router manually:
# In Python shell:
from agents.router import send_request
result = send_request("Viết 2 câu về AI", model_hint="creative")
print(result)  # Should return cloud response or local fallback
🤖 Agent Definitions (CrewAI + Cloud)
    • Define Manager Agent (agents/manager.py):
        ◦ Role: "Orchestrator"
        ◦ Goal: "Route tasks to best agent, resolve conflicts, ensure output quality"
        ◦ Tools: router, memory search, approval checker
    • Define Sub-Agents (cloud-executed):
        ◦ ContentAgent: Draft marketing/technical/business content
        ◦ CodeAgent: Generate Python/VBA/scripts with explanations
        ◦ BusinessAgent: Add strategy, planning, ROI angles
        ◦ PlatformAdapter: Transform base content → IG/Pinterest/FB/Threads/Blog formats
    • Define Debate Agents (AG2, cloud):
        ◦ CriticAgent: Find weaknesses, suggest improvements
        ◦ ValidatorAgent: Fact-check, citation verification
        ◦ AuthorAgent: Synthesize feedback into revised draft
    • Test single agent flow:
python
# Pseudocode test:
result = ManagerAgent.route(
    task="Generate Instagram post about AI automation",
    agents=["ContentAgent", "PlatformAdapter"]
)
assert "caption" in result
assert "hashtags" in result
🧠 Memory Integration
    • Connect agents → SQLite:
        ◦ After each cloud response: save to conversations table
        ◦ On user approval: update approvals table
        ◦ On post success: log to engagement table
    • Connect agents → Qdrant:
        ◦ Embed approved content → store vector + metadata
        ◦ Test semantic search: "Find posts about automation with high engagement"
    • Implement checkpoint saver:
        ◦ Serialize task state at key stages: routing_done, cloud_response_received, user_approved
        ◦ Store in checkpoints table with task_id
✅ Phase 2 Done When: Router can switch providers, agents defined and testable, memory writes working, checkpoint system saves state.

🟠 PHASE 3: UI + NOTIFICATIONS (Week 2-3 | ~10-14 hours)
🌐 FastAPI Backend Routes
    • Create main.py skeleton:
python
from fastapi import FastAPI
app = FastAPI(title="AI Agent Orchestrator")

@app.post("/agent/generate")
async def generate_content(request: GenerateRequest): ...

@app.post("/content/approve")
async def approve_content(approval: ApprovalRequest): ...

@app.get("/memory/search")
async def search_memory(query: str): ...

@app.get("/status")
async def system_status(): ...
    • Add WebSocket for streaming (optional but nice):
        ◦ Endpoint: /ws/agent/{task_id} → stream cloud agent output in real-time
    • Test endpoints with curl/Postman:
bash
curl -X POST http://localhost:8000/agent/generate \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Test post", "platform": "instagram"}'
💬 Telegram Bot 1 (Notifications)
    • Setup minimal bot (notifications/telegram_bot1.py):
        ◦ Commands: /start, /status, /help
        ◦ Events to notify:
            ▪ task_completed: "✅ Content ready for review: [link]"
            ▪ review_needed: "⏳ 3 posts pending approval"
            ▪ post_published: "🚀 Posted to Instagram: [URL]"
            ▪ system_error: "❌ Router failed: [error]"
        ◦ Include deep link to Web UI for quick review
    • Test manually:
python
from notifications.telegram_bot1 import send_alert
send_alert("review_needed", {"count": 2, "ui_link": "http://localhost:8501/review"})
🎨 Streamlit Web UI (MVP)
    • Create ui/app.py:
        ◦ Page 1: Dashboard (agent status, recent tasks, system health)
        ◦ Page 2: Content Review (list pending, approve/reject/edit, schedule)
        ◦ Page 3: Memory Browser (search Qdrant, view vectors)
        ◦ Page 4: Settings (router config, agent prompts, platform adapters)
    • Connect to FastAPI:
        ◦ Use requests or httpx to call backend endpoints
        ◦ Handle loading states, errors gracefully
    • Test UI flow:
        ◦ Submit prompt → see cloud response in review queue
        ◦ Approve → see status change to "scheduled"
        ◦ Search memory → see relevant past posts
✅ Phase 3 Done When: Can generate content via UI, review/approve, get Telegram notifications, search memory.

🔴 PHASE 4: AUTOMATION + POSTING (Week 3-4 | ~15-20 hours)
⏰ APScheduler Setup
    • Create scheduler/jobs.py:
        ◦ Daily job: check_and_post_pending() → 9:00 AM local time
        ◦ Weekly job: cleanup_old_vectors() → Sunday 2:00 AM
        ◦ Monthly job: export_fine_tune_data() → 1st of month, 3:00 AM
    • Add retry logic:
python
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=2, max=10))
def post_with_retry(platform, content): ...
    • Test scheduler manually:
Python
from scheduler.jobs import check_and_post_pending
check_and_post_pending()  # Should find approved posts, trigger Playwright
🌐 Playwright Browser Automation (START WITH 1 PLATFORM)
    • Install Playwright + browsers:
bash
pip install playwright
playwright install chromium  # or firefox
    • Create Instagram poster (automation/instagram.py):
        ◦ Use mobile viewport: set_viewport_size({"width": 390, "height": 844})
        ◦ Human-like timing: await page.wait_for_timeout(random.randint(30000, 120000))
        ◦ Login flow: use encrypted credentials + browser profile persistence
        ◦ Post flow: type caption → add hashtags → click post → verify success
    • Security:
        ◦ Never hardcode credentials → read from decrypted config at runtime
        ◦ Store browser profile in ~/.config/ai_agents/profiles/instagram/
    • Test manually first:
bash
python automation/instagram.py --test --content "Test post from AI agent"
# Should open browser, login, post to test account, close
🔗 Content Adapter Pattern
    • Create agents/platform_adapter.py:
python
class PlatformAdapter:
    def transform(self, base_content: dict, platform: str) -> dict:
        if platform == "instagram":
            return {
                "caption": shorten(base_content["text"], 2200),
                "hashtags": extract_tags(base_content, max=10),
                "image_prompt": generate_image_prompt(base_content)
            }
        elif platform == "pinterest":
            return {
                "title": generate_seo_title(base_content),
                "description": summarize(base_content["text"], 500),
                "link": base_content.get("source_url")
            }
        # ... other platforms
    • Test adapter:
python
adapter = PlatformAdapter()
base = {"text": "AI agents automate content creation...", "topics": ["AI", "automation"]}
ig = adapter.transform(base, "instagram")
pin = adapter.transform(base, "pinterest")
assert ig["caption"] != pin["description"]  # Platform-specific
🔁 Approval → Schedule → Post Flow
    • Connect UI approval → SQLite scheduled_posts:
        ◦ On approve: insert with platform, scheduled_time, content_variant
    • Connect scheduler → Playwright:
        ◦ Job queries scheduled_posts where scheduled_time <= now AND status = pending
        ◦ Calls appropriate platform poster script
    • End-to-end test (manual trigger):
        ◦ Generate content → approve for Instagram → schedule for "now + 1 minute"
        ◦ Wait → verify post appears on test Instagram account
        ◦ Check Telegram notification received
✅ Phase 4 Done When: Can approve content in UI → system auto-posts to Instagram at scheduled time with human-like behavior.

🟣 PHASE 5: FINE-TUNING PIPELINE (Week 5-6 | ~10-15 hours)
📊 Data Collection & Filtering
    • Create exporter script (learning/export_dataset.py):
        ◦ Query SQLite: approved=true AND engagement_score >= median
        ◦ Enrich with Qdrant: add semantic tags, quality_score
        ◦ Format for training:
json
{
  "prompt": "Generate Instagram post about X",
  "output": "Cloud-generated approved content",
  "platform": "instagram",
  "engagement": {"likes": 42, "comments": 5},
  "quality_score": 4.5,
  "timestamp": "2026-04-15T10:30:00Z"
}
    • Add auto-filtering:
        ◦ Remove posts with <100 characters (too short)
        ◦ Remove posts with negative sentiment in comments (if tracked)
        ◦ Deduplicate near-identical prompts
☁️ Google Colab Integration
    • Create notebook template (learning/colab_finetune.ipynb):
        ◦ Section 1: Install Unsloth, load base model (Qwen3.5-4B)
        ◦ Section 2: Load dataset from JSON (upload or GDrive)
        ◦ Section 3: Configure LoRA/QLoRA training params
        ◦ Section 4: Train + export as GGUF-Q4_K_M
        ◦ Section 5: Download to local via wget or gdown
    • Test with dummy data:
        ◦ Create 10 fake examples → run notebook → verify GGUF output downloads
🔄 Model Versioning & A/B Testing
    • Setup model directory structure:
~/ai_agents/models/
├── base/
│   └── qwen3.5-4b-q4_k_m.gguf  # original
├── v1_202604/
│   ├── model.gguf
│   ├── metadata.json  # {dataset_size, training_steps, quality_score}
│   └── test_results.json
└── active -> v1_202604/  # symlink to current model
    • Create A/B test script (learning/ab_test.py):
        ◦ Run 50 test prompts on both old and new model
        ◦ Auto-score: length, relevance, keyword match
        ◦ Manual sample: you rate 10 outputs from each (1-5)
        ◦ Deploy new if: auto_score +5% AND manual_score >=4.0
    • Implement model switcher:
        ◦ FastAPI reads models/active symlink to load model
        ◦ Web UI shows current version + option to rollback
✅ Phase 5 Done When: Can export approved data → fine-tune in Colab → download new model → A/B test → deploy if better.

⚫ PHASE 6: TESTING, DOCS, GO-LIVE (Week 6-8 | ~8-12 hours)
🧪 End-to-End Testing
    • Manual E2E test (Instagram only):
        ◦ Request: "Generate post about AI automation"
        ◦ Verify: Cloud debate → UI review → approve → schedule → post → notification
        ◦ Check: Memory stored, engagement tracked
    • Stress test:
        ◦ Submit 3 generation requests in parallel
        ◦ Monitor: RAM <10GB, no crashes, router handles rate limits
    • Failure scenarios:
        ◦ Simulate Ollama crash → verify local fallback or graceful error
        ◦ Simulate Instagram login fail → verify retry + alert
        ◦ Simulate Qdrant full → verify auto-archive + cleanup
📚 Documentation
    • Update QUICK_START.md with actual commands that worked
    • Create TROUBLESHOOTING.md:
markdown
## Router keeps failing
- Check: `tail -f logs/router.log`
- Fix: Rotate API keys, reduce request rate

## Playwright login fails
- Check: Instagram 2FA enabled?
- Fix: Use app password, update browser profile
    • Add HOW_TO_ADD_AGENT.md:
        ◦ Step 1: Define agent in agents/new_agent.py
        ◦ Step 2: Register with ManagerAgent
        ◦ Step 3: Add to router config if cloud-executed
        ◦ Step 4: Test with sample prompt
🚀 Go-Live Checklist
    • Final security audit:
        ◦ No plaintext credentials in code/config
        ◦ Encrypted files have strong passphrase
        ◦ Test accounts have limited permissions
    • Backup strategy verified:
        ◦ SQLite dump script tested
        ◦ Archives copied to external drive
        ◦ Git repo pushed to remote
    • Monitoring in place:
        ◦ logs/system.log rotating daily
        ◦ Telegram alerts for critical errors
        ◦ Simple health endpoint: GET /status → {"ollama":"up","router":"healthy"}
    • Start small:
        ◦ Enable only Instagram + Blog initially
        ◦ Limit to 2 posts/day for first week
        ◦ Review all outputs manually for first 20 posts
✅ Phase 6 Done When: System runs end-to-end for 1 platform, documented, backed up, and you're comfortable with daily operations.

🗓️ WEEKLY OPERATIONS CHECKLIST (Post-Launch)
Daily (~5 min)
    • Check Web UI dashboard for pending approvals
    • Review Telegram notifications for errors
    • Verify yesterday's posts published successfully
Weekly (~30 min)
    • Review engagement metrics (likes, comments) in UI
    • Adjust agent prompts if quality drifts
    • Check router logs for provider throttling
    • Backup SQLite: sqlite3 memory/hot.db ".dump" > backups/weekly_$(date +%F).sql
Monthly (~2 hours)
    • Run fine-tuning export → Colab → deploy if better
    • Archive old Qdrant vectors (>30 days) to JSON.gz
    • Review and update DECISION_LOG.md with lessons learned
    • Rotate API keys if any provider shows suspicious usage

🎯 SUCCESS METRICS (Track Monthly)
Metric
Target
How to Measure
Cloud dependency
↓ 5-10%/month
% tasks handled by local vs cloud
Content approval rate
>70%
Approved / Generated in SQLite
Posting success rate
>95%
Successful posts / Scheduled
Fine-tune improvement
+3-5% quality/cycle
A/B test scores
System uptime
>99%
Logs + Telegram alert frequency
