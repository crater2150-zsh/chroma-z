# chroma-z - multiline prompt theme for zsh

A multiline prompt theme for zsh, that can display various info without changing
where the cursor starts.

![default prompt](screenshots/default.png)

Can display Virtualenv/Conda environment and exit code of last command:
![show exit code](screenshots/venv_exit_code.png)

Changes color when in an SSH session or when the user is root:
![ssh colors](screenshots/ssh.png)

In directories with a versioning system, info about the state is shown in an
extra line:
![git info](screenshots/git.png)

When using an older terminal, you can set `PROMPT_UNICODE=no` to change to a
ascii-only variant:
![ascii prompt](screenshots/ascii.png)
