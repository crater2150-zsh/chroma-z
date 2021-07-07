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

## Custom Prompt Elements

You can add custom prompt elements, which will be styled similar to the
virtualenv display (see above). For each custom element, add a function to
`__chromaz_extra_left`. It will be called and if its output isn't empty, a
prompt element with the output will be added.

Example: show number of open todos (assuming `todo` outputs a list of todos):

```
_prompt_todos() { local todos=$(todo | wc -l); [[ $todos -gt 0 ]] && echo "Todos: $todos" }
__chromaz_extra_left+=_prompt_todos
```
