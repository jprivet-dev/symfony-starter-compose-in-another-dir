# Usage:
#   . scripts/aliases.sh [options]

Y="\033[33m" # YELLOW
G="\033[32m" # GREEN
R="\033[0m"  # RESET

function aliases_create() {
  local name="${1}"
  printf "✅ Create ${G}${name}${R} alias for the ${G}make ${name}${R} command\n"
  alias ${name}="aliases_make ${name}"
}

function aliases_delete() {
  local name="${1}"
  printf "❌ Delete ${G}${name}${R} alias for the ${G}make ${name}${R} command\n"
  unalias ${name}
}

function aliases_make() {
  local name="${1}"
  shift
  make ${name} p="${*}"
}

function aliases_help() {
  printf "\n"
  printf "${Y}Description:${R}\n"
  printf "  Create or delete aliases for make commands\n"
  printf "\n"
  printf "${Y}Usage:${R}\n"
  printf "  . aliases [options]\n"
  printf "\n"
  printf "${Y}Options:${R}\n"
  printf "  ${G}--help, -h    ${R}Show help\n"
  printf "  ${G}--delete, -d  ${R}Delete all aliases\n"
  printf "\n"
  printf "${Y}Help:${R}\n"
  printf "  Create all aliases:\n"
  printf "\n"
  printf "    ${G}. aliases${R}\n"
  printf "\n"
  printf "  Delete all aliases:\n"
  printf "\n"
  printf "    ${G}. aliases --delete${R}\n"
  printf "\n"
}

function aliases_delete_all() {
  aliases_delete symfony
  aliases_delete composer
  aliases_delete php
}

function aliases_create_all() {
  aliases_create symfony
  aliases_create composer
  aliases_create php
  printf "\n"
  printf "Delete all aliases with ${G}. aliases --delete${R} command\n"
  printf "Show help with ${G}. aliases --help${R} command\n"
}

case ${1} in
-h | --help)
  aliases_help
  ;;
-d | --delete)
  aliases_delete_all
  ;;
*)
  aliases_create_all
  ;;
esac
