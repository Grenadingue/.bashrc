prompt_color="\[${style[reset]}${style[bold]}\]"
session_color="\[${style[reset]}${colors[light-gray]}\]"
user_color="\[${style[bold]}${colors[dark-gray]}\]"
host_color="\[${style[bold]}${colors[dark-gray]}\]"
path_color="\[${style[reset]}${colors[blue]}\]"
end_of_prompt="\[${style[reset]}\]"

if [ "$SESSION_TYPE" == "remote/ssh" ]; then
    host_color="\[${colors[green]}\]"
fi
if [ "$USER" == "root" ]; then
    user_color="\[${colors[red]}\]"
fi

if [ "$color_support" = yes ]; then
    PS1="${session_color}[${user_color}\u${session_color}@${host_color}\h${session_color}]:${path_color}\w${prompt_color} \$ ${end_of_prompt}"
else
    PS1='[\u@\h]:\w \$ '
fi
