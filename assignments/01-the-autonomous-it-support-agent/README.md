# 01 — The Autonomous IT Support Agent

**Topic:** Agentic AI Foundations & Reflex Agents  
**Notebook:** [`it-support-agent.ipynb`](it-support-agent.ipynb)

## The task

Build an AI agent that acts as a **Level 1 IT incident responder** for servers. When a user reports a problem, the agent must:

1. **Investigate** — check the server's health (CPU, memory) and its recent logs.
2. **Act** — restart the service when CPU or memory is critical (over 90%).
3. **Escalate** — hand the issue to a human engineer when the logs show a problem a restart can't fix, such as a failed connection to another service.

## My approach

- **Model access:** the OpenAI Python SDK pointed at **OpenRouter** (`base_url="https://openrouter.ai/api/v1"`), with the API key read from a notebook secret — never written in the code.
- **Four tools** the agent can call:

  | Tool                   | What it does                                                                 |
  | ---------------------- | ---------------------------------------------------------------------------- |
  | `get_server_health`    | Returns CPU, memory and status for a server (provided)                       |
  | `fetch_recent_logs`    | Returns the latest log lines for a server (provided)                         |
  | `restart_service`      | Restarts the service and returns a JSON confirmation (**implemented by me**) |
  | `escalate_to_engineer` | Opens a ticket for a human engineer with a summary (**implemented by me**)   |

- **Tool schema:** each tool is described to the model in JSON (name, purpose, parameters), so the model can decide which one to call.
- **Agent loop** (`run_it_agent`): the system prompt sets the rules (restart above 90%, escalate on dependency errors). The loop sends the conversation to the model, runs any tool the model asks for, returns the result to the model, and repeats until the model gives a final answer.

## Results

All five test scenarios were run; the outputs are saved in the notebook.

| Scenario                 | Server              | What the agent found                                                | Action taken                                                      |
| ------------------------ | ------------------- | ------------------------------------------------------------------- | ----------------------------------------------------------------- |
| A — Slow, timing out     | `payment-server-01` | CPU 98%, thread-pool exhaustion, hung process                       | **Restarted** the service                                         |
| B — "Something is wrong" | `db-node-02`        | CPU 12%, memory 60%, logs normal                                    | **No action** — reported healthy, asked for more details          |
| C — Login failures       | `auth-service-03`   | Memory 95%, Java heap / memory-leak errors                          | **Restarted**, and warned the restart may only be a temporary fix |
| D — Search not working   | `search-index-09`   | CPU and memory normal, can't connect to `elastic-cluster-main:9200` | **Escalated** to an engineer                                      |
| E — Routine check        | `frontend-node-04`  | CPU 25%, memory 30%, healthy logs                                   | **No action**                                                     |

In every case the agent checked health **and** logs before deciding, and it chose the action that matched the rules. In scenario B the notebook's comment expected an escalation, but the server's data was fully healthy, so the agent reported it as healthy and asked for symptoms — a reasonable decision given the evidence.

## What I learned

- How **function calling** works: the model doesn't run code itself; it asks for a tool, the program runs it, and the result goes back to the model.
- Clear **tool descriptions and a precise system prompt** decide whether the agent picks the right action.
- An agent needs a **loop** that keeps going until the model stops asking for tools.
- **Evidence beats assumptions**: the agent should act on what the health data and logs show, not on how the user describes the problem.
- API keys belong in **secrets**, never in the notebook.

## How to run

The notebook is written for **Google Colab**:

1. Open the notebook in Colab.
2. In the 🔑 **Secrets** panel, add `OPENROUTER_APIKEY` with your OpenRouter key and turn on notebook access.
3. Run all cells (**Runtime → Run all**).

To run it locally instead, install the packages in `requirements.txt` and replace `userdata.get('OPENROUTER_APIKEY')` with `os.environ["OPENROUTER_APIKEY"]`.

## Files

- `it-support-agent.ipynb` — the full assignment with saved outputs
- `requirements.txt` — Python packages (for running outside Colab)
