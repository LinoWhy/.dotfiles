uv_venv() {
  local venv="$PWD/.venv"
  local python_version=""

  if ! has uv; then
    log_error "uv is required but not found in PATH."
    return 1
  fi

  if [[ -f .python-version ]]; then
    python_version="$(<.python-version)"
    watch_file .python-version
  fi

  if [[ ! -d "$venv" ]]; then
    if [[ -n "$python_version" ]]; then
      uv venv --python "$python_version" "$venv" || return 1
    else
      return 0
    fi
  fi

  export VIRTUAL_ENV="$venv"
  PATH_add "$venv/bin"

  if [[ -f pyproject.toml ]]; then
    watch_file pyproject.toml
    uv sync || return 1
  elif [[ -f requirements.txt ]]; then
    watch_file requirements.txt
    uv pip sync requirements.txt || return 1
  fi
}
