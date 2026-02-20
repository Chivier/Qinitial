#PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}*%{$fg[blue]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

PROMPT='%{$fg_bold[white]%}%n%{$fg[magenta]%}@%{$fg_bold[yellow]%}%m %{$fg_bold[green]%}%~ %{$reset_color%}$(git_prompt_info) %{$fg[cyan]%}%D{[%I:%M:%S]}
%{$fg_bold[yellow]%}> %{$reset_color%}'
