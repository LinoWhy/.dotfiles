alias x=extract

# ─── private helpers ─────────────────────────────────────────────────────────

# Detect archive format using magic bytes (file --mime-type).
# For single-file compression formats, `tar -tf` probes whether the content
# is a tar archive (no need to trust the extension for the inner layer).
# Outputs a canonical format key; exits 0 on success, 1 if unrecognised.
function _extract_fmt_by_magic() {
  local file="$1"
  (( $+commands[file] )) || return 1

  local mime
  mime=$(file --mime-type -b -- "$file" 2>/dev/null) || return 1
  [[ -z "$mime" ]] && return 1

  case "$mime" in
    application/gzip|application/x-gzip)
      tar -tf "$file" &>/dev/null && echo "tar.gz"   || echo "gz" ;;
    application/x-bzip2)
      tar -tf "$file" &>/dev/null && echo "tar.bz2"  || echo "bz2" ;;
    application/x-xz)
      tar -tf "$file" &>/dev/null && echo "tar.xz"   || echo "xz" ;;
    application/zstd|application/x-zstd)
      tar -tf "$file" &>/dev/null && echo "tar.zst"  || echo "zst" ;;
    application/x-lzma)
      tar -tf "$file" &>/dev/null && echo "tar.lzma" || echo "lzma" ;;
    application/x-compress)
      tar -tf "$file" &>/dev/null && echo "tar"      || echo "z" ;;
    application/x-lzip)
      tar -tf "$file" &>/dev/null && echo "tar.lz"   || echo "lz" ;;
    application/x-lz4)
      tar -tf "$file" &>/dev/null && echo "tar.lz4"  || echo "lz4" ;;
    application/x-tar|application/x-ustar)
      echo "tar" ;;
    application/zip)
      echo "zip" ;;
    application/x-rar|application/vnd.rar)
      echo "rar" ;;
    application/x-7z-compressed)
      echo "7z" ;;
    application/x-rpm)
      echo "rpm" ;;
    application/x-debian-package|application/vnd.debian.binary-package)
      echo "deb" ;;
    application/x-cpio)
      echo "cpio" ;;
    application/vnd.ms-cab-compressed)
      echo "cab" ;;
    *)
      return 1 ;;
  esac
}

# Detect archive format from the file extension (lowercased).
# Outputs a canonical format key; exits 0 on success, 1 if unrecognised.
function _extract_fmt_by_ext() {
  case "${1:l}" in
    *.tar.gz|*.tgz)          echo "tar.gz" ;;
    *.tar.bz2|*.tbz|*.tbz2)  echo "tar.bz2" ;;
    *.tar.xz|*.txz)          echo "tar.xz" ;;
    *.tar.zma|*.tlz)         echo "tar.lzma" ;;
    *.tar.zst|*.tzst)        echo "tar.zst" ;;
    *.tar)                   echo "tar" ;;
    *.tar.lz)                echo "tar.lz" ;;
    *.tar.lz4)               echo "tar.lz4" ;;
    *.tar.lrz)               echo "tar.lrz" ;;
    *.gz)                    echo "gz" ;;
    *.bz2)                   echo "bz2" ;;
    *.xz)                    echo "xz" ;;
    *.lrz)                   echo "lrz" ;;
    *.lz4)                   echo "lz4" ;;
    *.lzma)                  echo "lzma" ;;
    *.z)                     echo "z" ;;
    *.zip|*.war|*.jar|*.ear|*.sublime-package|*.ipa|*.ipsw|*.xpi|*.apk|*.aar|*.whl)
                             echo "zip" ;;
    *.rar)                   echo "rar" ;;
    *.rpm)                   echo "rpm" ;;
    *.7z)                    echo "7z" ;;
    *.deb)                   echo "deb" ;;
    *.zst)                   echo "zst" ;;
    *.cab|*.exe)             echo "cab" ;;
    *.cpio|*.obscpio)        echo "cpio" ;;
    *.zpaq)                  echo "zpaq" ;;
    *.zlib)                  echo "zlib" ;;
    *)                       return 1 ;;
  esac
}

# Perform the actual extraction given a canonical format key.
# Must be called from inside the target extraction directory.
# $1: format key   $2: absolute path to archive   $3: original filename
function _do_extract() {
  local fmt="$1" full_path="$2" file="$3"

  case "$fmt" in
    tar.gz)
      (( $+commands[pigz] )) && tar -I pigz -xvf "$full_path" || tar zxvf "$full_path" ;;
    tar.bz2)
      (( $+commands[pbzip2] )) && tar -I pbzip2 -xvf "$full_path" || tar xvjf "$full_path" ;;
    tar.xz)
      (( $+commands[pixz] )) && tar -I pixz -xvf "$full_path" || {
        tar --xz --help &>/dev/null \
        && tar --xz -xvf "$full_path" \
        || xzcat "$full_path" | tar xvf -
      } ;;
    tar.lzma)
      tar --lzma --help &>/dev/null \
      && tar --lzma -xvf "$full_path" \
      || lzcat "$full_path" | tar xvf - ;;
    tar.zst)
      tar --zstd --help &>/dev/null \
      && tar --zstd -xvf "$full_path" \
      || zstdcat "$full_path" | tar xvf - ;;
    tar)     tar xvf "$full_path" ;;
    tar.lz)  tar xvf "$full_path" ;;  # bsdtar/libarchive handles lzip natively
    tar.lz4) lz4 -c -d "$full_path" | tar xvf - ;;
    tar.lrz) (( $+commands[lrzuntar] )) && lrzuntar "$full_path" \
               || { echo "extract: lrzuntar not found" >&2; return 1 } ;;
    gz)
      (( $+commands[pigz] )) \
      && pigz -cdk "$full_path" > "${file:t:r}" \
      || gunzip -ck "$full_path" > "${file:t:r}" ;;
    bz2)
      (( $+commands[pbzip2] )) && pbzip2 -d "$full_path" || bunzip2 "$full_path" ;;
    xz)    unxz "$full_path" ;;
    lrz)   (( $+commands[lrunzip] )) && lrunzip "$full_path" \
               || { echo "extract: lrunzip not found" >&2; return 1 } ;;
    lz4)   lz4 -d "$full_path" ;;
    lzma)  unlzma "$full_path" ;;
    z)     uncompress "$full_path" ;;
    zip)   unzip "$full_path" ;;
    rar)   unrar x -ad "$full_path" ;;
    rpm)   rpm2cpio "$full_path" | cpio --quiet -id ;;
    7z)
      # bsdtar (macOS built-in, via libarchive) natively handles 7z;
      # fall back to standalone 7z tools if available.
      if tar xvf "$full_path" 2>/dev/null; then
        :
      elif (( $+commands[7zz] )); then
        7zz x "$full_path"
      elif (( $+commands[7za] )); then
        7za x "$full_path"
      elif (( $+commands[7z] )); then
        7z x "$full_path"
      else
        echo "extract: no 7z extractor found" >&2
        return 1
      fi ;;
    deb)
      command mkdir -p "control" "data"
      ar vx "$full_path" > /dev/null
      builtin cd -q control; extract ../control.tar.*
      builtin cd -q ../data; extract ../data.tar.*
      builtin cd -q ..; command rm *.tar.* debian-binary ;;
    zst)   unzstd --stdout "$full_path" > "${file:t:r}" ;;
    cab)   cabextract "$full_path" ;;
    cpio)  cpio -idmvF "$full_path" ;;
    zpaq)  zpaq x "$full_path" ;;
    zlib)  zlib-flate -uncompress < "$full_path" > "${file:r}" ;;
    *)
      echo "extract: '$file' cannot be extracted" >&2
      return 1 ;;
  esac
}

# ─── public function ──────────────────────────────────────────────────────────

function extract() {
  setopt localoptions noautopushd

  if (( $# == 0 )); then
    cat >&2 <<'EOF'
Usage: extract [-option] [file ...]

Options:
    -r, --remove    Remove archive after unpacking.
EOF
  fi

  local remove_archive=1
  if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
    remove_archive=0
    shift
  fi

  local pwd="$PWD"
  while (( $# > 0 )); do
    if [[ ! -f "$1" ]]; then
      echo "extract: '$1' is not a valid file" >&2
      shift
      continue
    fi

    local success=0
    local file="$1" full_path="${1:A}"
    local extract_dir="${1:t:r}"

    # Remove the .tar extension if the file name is .tar.*
    if [[ $extract_dir =~ '\.tar$' ]]; then
      extract_dir="${extract_dir:r}"
    fi

    # If there's a file or directory with the same name as the archive,
    # add a random string to the end of the extraction directory.
    if [[ -e "$extract_dir" ]]; then
      local rnd="${(L)"${$(( [##36]$RANDOM*$RANDOM ))}":1:5}"
      extract_dir="${extract_dir}-${rnd}"
    fi

    # Detect format: magic bytes first, file extension as fallback.
    local fmt
    fmt=$(_extract_fmt_by_magic "$full_path") \
    || fmt=$(_extract_fmt_by_ext "$file") \
    || {
      echo "extract: '$file' cannot be extracted" >&2
      shift
      continue
    }

    # Create an extraction directory based on the file name.
    command mkdir -p "$extract_dir"
    builtin cd -q "$extract_dir"
    echo "extract: extracting to $extract_dir" >&2

    _do_extract "$fmt" "$full_path" "$file"
    success=$?

    (( success == 0 && remove_archive == 0 )) && command rm "$full_path"
    shift

    # Return to original working directory.
    builtin cd -q "$pwd"

    # If content of extract dir is a single item, move its contents up.
    # Glob flags: D=include dotfiles, N=no error if empty, Y2=at most 2 entries.
    local -a content
    content=("${extract_dir}"/*(DNY2))
    if [[ ${#content} -eq 1 && -e "${content[1]}" ]]; then
      # The extracted item may share the name of $extract_dir — handle
      # via a temporary rename to avoid conflicts (3-step move).
      if [[ "${content[1]:t}" == "$extract_dir" ]]; then
        local tmp_name==(:); tmp_name="${tmp_name:t}"
        command mv "${content[1]}" "$tmp_name" \
        && command rmdir "$extract_dir" \
        && command mv "$tmp_name" "$extract_dir"
      elif [[ ! -e "${content[1]:t}" ]]; then
        command mv "${content[1]}" . \
        && command rmdir "$extract_dir"
      fi
    elif [[ ${#content} -eq 0 ]]; then
      command rmdir "$extract_dir"
    fi
  done
}
