# Usage: $ . scripts/aliases.sh

Y="\033[33m" # YELLOW
R="\033[0m"  # RESET

printf "🎉 Create ${Y}php${R}, ${Y}composer${R} & ${Y}symfony${R} aliases 🎉‍\n"

function php() { make php p="$*"; }
function composer() { make composer p="$*"; }
function symfony() { make symfony p="$*"; }
