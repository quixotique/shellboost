__run() {
   if [ "$1" = '!' ]; then
      shift
      if __run "$@"; then
         return 1
      else
         return 0
      fi
   fi
   "$@"
}

assert() {
   if ! __run "$@"; then
      printf '%s\n' "assertion failed: $*" >&2
      exit 3
   fi
}


