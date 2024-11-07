# Usage:
#   . scripts/aliases.sh [options]

Y="\033[33m" # YELLOW
G="\033[32m" # GREEN
S="\033[0m"  # RESET

function alias_create() {
  local name="${1}"
  printf "✅ Create ${G}${name}${S} alias for ${G}make ${name}${S}\n"
  alias ${name}="aliases_make ${name}"
}

function alias_delete() {
  local name="${1}"
  printf "❌ Delete ${G}${name}${S} alias for ${G}make ${name}${S}\n"
  unalias ${name}
}

function aliases_make() {
  local name="${1}"
  shift
  make ${name} p="${*}"
}

function aliases_help() {
  printf "\n"
  printf "${Y}Description:${S}\n"
  printf "  Create or delete aliases for make commands\n"
  printf "\n"
  printf "${Y}Usage:${S}\n"
  printf "  . aliases [options]\n"
  printf "\n"
  printf "${Y}Options:${S}\n"
  printf "  ${G}--help, -h    ${S}Show help\n"
  printf "  ${G}--delete, -d  ${S}Delete all aliases\n"
  printf "\n"
  printf "${Y}Help:${S}\n"
  printf "  Create all aliases:\n"
  printf "\n"
  printf "    ${G}. aliases${S}\n"
  printf "\n"
  printf "  Delete all aliases:\n"
  printf "\n"
  printf "    ${G}. aliases --delete${S}\n"
  printf "\n"
}

function aliases_create_all() {
  alias_create symfony
  alias_create sf
  alias_create composer
  alias_create php
  printf "\n"
  printf "Delete all aliases with ${G}. aliases --delete${S} command\n"
  printf "Show help with ${G}. aliases --help${S} command\n"
}

function aliases_delete_all() {
  alias_delete symfony
  alias_delete sf
  alias_delete composer
  alias_delete php
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
