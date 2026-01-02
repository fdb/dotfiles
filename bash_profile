if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

. "$HOME/.cargo/env"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/fdb/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/fdb/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/fdb/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/fdb/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/fdb/.lmstudio/bin"
# End of LM Studio CLI section

