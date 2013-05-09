function virtualenv_prompt_info(){
  if [[ -n $VIRTUAL_ENV ]]; then
    printf "%s" `basename $VIRTUAL_ENV`
  fi
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
