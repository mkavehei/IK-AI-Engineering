# Assignment 02: Chat with CSV (Week 0 Mini Project)

In this assignment I ran my first AI agent: a small web app where I upload CSV files and ask questions in plain English, and the AI answers using the real data in the tables. The app comes from the course code ([ANI-IN/Hello-Agent](https://github.com/ANI-IN/Hello-Agent)). It is built with **Streamlit** (the web page), **pandas** (reading the tables) and **LangChain** (connecting the AI model to the data).

---

## Files in this folder

| File | What it is |
|---|---|
| `1_How_to_install_Streamlit.txt` | My step-by-step commands to set up and run the app on my Mac, plus fixes for the problems I hit. |
| `2_Streamlit_key_points.txt` | Two paragraphs on how Streamlit works and what it is used for. |
| `app_v2.py` | My practice app to learn the structure of a Streamlit app. It shows a CSV or text file. No AI, no key. |

---

## What I changed in the course app

The course app was set up for OpenAI. I use an **OpenRouter** key, so I changed one block in `app.py` to send the questions to OpenRouter and to use the **GPT-6 Luna** model:

```python
llm = ChatOpenAI(
    temperature=0.0,
    model="openai/gpt-6-luna",
    api_key=openai_api_key,
    base_url="https://openrouter.ai/api/v1"
)
```

My API key is never saved in any file. I paste it only into the app's page in the browser, and it is gone when the app stops.

---

## How the AI agent works

This is not a normal chatbot that answers from memory. When I ask a question:

1. The app loads my CSV files as tables.
2. The AI **plans** how to find the answer.
3. It **writes a small piece of Python code** to search the tables.
4. It **runs** that code and reads the result.
5. It writes the **final answer** in plain English, quoting the real data.

Steps 2 to 4 are what make it an **agent**: it takes actions (writing and running code), not just text. I could see the code it wrote in the Terminal while it was working.

---

## What I learned about Streamlit

- Streamlit turns **one Python file into a web page**. Each `st.something()` line adds one piece to the page, in order.
- The whole file **runs again from top to bottom** every time I type, click or upload something.
- A typical app has six parts: **imports, page setup, sidebar, inputs, the work, showing the result.** I practiced this in `app_v2.py`.
- Streamlit is **not only for CSV**. It only builds the page; other add-ons read the data (text, PDF, images, audio).
- It is great for **demos, learning projects and small tools**, and not the best choice for big public websites.

---

## Problems I hit and how I fixed them

| Problem | What I saw | Cause | Fix |
|---|---|---|---|
| Wrong Streamlit ran | `No module named 'streamlit.cli'`, with a path in `/opt/anaconda3/` | Anaconda was active, so its broken Streamlit ran instead of the project's | `conda deactivate`, then switch on the project's `.venv` |
| The `.venv` did not exist | `mv: .venv: No such file or directory` | The project's add-ons were never installed in this folder | Created a new `.venv` and ran `pip install -r requirements.txt` |
| Two copies of the project | My edit in `app.py` had no effect | I edited the copy inside `MyAIEngineering`, but the Terminal ran another copy | Deleted the extra copy, kept everything under `MyAIEngineering`, and told git to ignore the course code (`.gitignore`) |
| Key rejected | `Error code: 401 - Incorrect API key`, pointing to `platform.openai.com` | The key was sent to OpenAI instead of OpenRouter, because the running copy did not have my change | After fixing the two copies, the key went to OpenRouter and worked |
| Page would not open | `localhost refused to connect` | The app had not started yet; Streamlit was waiting for its first-time email question in the Terminal | Pressed Enter in the Terminal |

**Lessons from the problems:**
- Always check that the Terminal line starts with **`(.venv)`** before running the app.
- `which streamlit` tells me **which copy** of Streamlit will run.
- Error messages tell me **where the request went**: the `platform.openai.com` link showed the key went to the wrong service.
- Make sure the file I edit is the **same file** the Terminal runs.

---

## My test results

I checked each answer against the CSV file myself.

| Question | File | AI's answer | Correct? | Notes |
|---|---|---|---|---|
| what is the foreign transaction fee | credit_card_terms.csv | 3% of each transaction in U.S. dollars for purchases made outside the United States | ✅ Yes, partly complete | Matches row CC-904. It left out that the fee also applies to online purchases from foreign merchants. |
| how long does standard shipping take | ecommerce_faqs.csv | First try: error 401 (key went to OpenAI) | _add result after the fix_ | |
| what is the return policy for electronics | ecommerce_faqs.csv | _add result_ | | |
| are children allowed in the ICU | hospital_policy.csv | _add result_ | | |
| what are the rate limits for the free plan | saas_docs.csv | _add result_ | | |
| which user roles can edit projects | saas_docs.csv | _add result_ | | |
| list every fee in the credit card terms over $40 | credit_card_terms.csv | _add result_ | | The correct answer is only the $495 annual fee (CC-902). The $40 late fee is not *over* $40. |
| what is the hospital's parking fee | hospital_policy.csv | _add result_ | | Not in the data. Does the AI admit it, or make something up? |

---

## What I learned

- An **AI agent** is an AI that takes actions, like writing and running code, to find an answer from real data.
- I can switch the AI model and provider by changing **just a few lines** (`model`, `api_key`, `base_url`).
- A **`.venv`** is a private box of add-ons for one project. Most of my setup problems came from the wrong Python or Streamlit being used.
- **Always check the AI's answers** against the source data: an answer can be correct but incomplete.
- **Keep secrets out of files:** the API key only goes into the app's page, never into code or the repo.

---

## How to run it again

```
cd ~/Documents/MyActivitiesGithub/MyAIEngineering/Hello-Agent
conda deactivate
source .venv/bin/activate
streamlit run app.py
```

Full setup steps are in `1_How_to_install_Streamlit.txt`.
