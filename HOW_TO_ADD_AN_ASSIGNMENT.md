# How to add an assignment

All commands run in VS Code's Terminal, inside the `IK-AI-Engineering` folder.

## 1. Create the folder
```bash
bash tools/new_assignment.sh 01 "Prompt engineering basics" "Prompt engineering"
```
This makes `assignments/01-prompt-engineering-basics/` from the template and adds a row
to the table on the front page.

## 2. Put your work in it
- Your notebook (rename it `notebook.ipynb`, or keep your own name and update the README) and/or `.py` files
- Small data files into `data/`
- Screenshots and charts into `results/`
- Missing packages into `requirements.txt`

## 3. Fill in the assignment's README.md
The task, your approach, results (add images from `results/`), what you learned.

## 4. Before you commit
- Run the notebook from top to bottom (Kernel → Restart & Run All) so all outputs show.
- API keys only in `.env`, never in the notebook. In code, read them like this:
  ```python
  from dotenv import load_dotenv; import os
  load_dotenv()
  key = os.environ["OPENAI_API_KEY"]
  ```
- Run the safety check:
  ```bash
  bash tools/check_before_commit.sh
  ```
  Commit only when it says **OK**.

## 5. Mark it done
In the front-page `README.md`, change the status of that row from *In progress* to **Done**.

## 6. Commit and Sync
Source Control → message like `Assignment 01: Prompt engineering basics` → Commit → Sync.
