# How to add an assignment

In VS Code's Terminal, inside this folder:

**1. Make the folder** (number, title, topic):
```bash
bash tools/new_assignment.sh 02 "Assignment title" "Topic"
```

**2. Put your notebook into the new folder** (drag it from Finder onto the folder in VS Code).
Name it simply, for example `assignment-02.ipynb` — lowercase, no spaces.

**3. Safety check** — must say OK:
```bash
bash tools/check_before_commit.sh
```

**4. Source Control → message → Commit → Sync.**
