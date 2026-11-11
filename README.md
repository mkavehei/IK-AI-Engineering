# AI Engineering — Assignments

Assignments completed for the **Applied Agentic AI: Agentic AI Foundations & Reflex Agents** AI Engineering program.

**Author:** Mojgan Kavehei · [LinkedIn](https://www.linkedin.com/in/mojgankavehei/)

Each assignment has its own folder with a README that explains the task, how to run it, the results, and what I learned. You can read every README and notebook directly on GitHub — nothing needs to be run.

## Assignments

| #   | Assignment | Topic | Status |
| --- | ---------- | ----- | ------ |
| 01 | [The Autonomous IT Support Agent](assignments/01-the-autonomous-it-support-agent/) | Agentic AI Foundations & Reflex Agents | Done |
<!-- ASSIGNMENTS-TABLE (new rows are added above this line by tools/new_assignment.sh) -->

## How this repository is organized

```
assignments/
  01-short-name/
    README.md          task, how to run, results, what I learned
    notebook.ipynb     the work (and/or .py files)
    requirements.txt   Python packages this assignment needs
    data/              small sample data only
    results/           charts and screenshots of the output
```

## Running an assignment (optional)

```bash
cd assignments/01-short-name
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp ../../.env.example .env      # then put your own API keys in .env
jupyter notebook                # or: python main.py
```

API keys are never stored in this repository. Each assignment reads them from a local `.env` file, which is excluded by `.gitignore`.
