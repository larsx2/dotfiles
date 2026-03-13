######################
####### DOCKER #######
######################
alias dc="docker compose"
alias dupd="docker compose up -d"
alias ddown="docker compose down"
alias dstop="docker compose stop"
alias dstart="docker compose start"
alias dreload="docker compose restart"
alias dkill="docker compose kill"
alias dps="docker compose ps"
alias dls="docker compose ls"
alias dlogs="docker compose logs"
alias dlogsf="docker compose logs -f --tail=100"
alias dtail="docker compose logs --tail=100"
alias dtailn="docker compose logs --tail="
alias dbuild="docker compose build"
alias drm="docker compose rm"
alias drun="docker compose run"
alias dexec="docker compose exec"
alias dpull="docker compose pull"
alias dpush="docker compose push"
alias dversion="docker compose version"

dnuke() {
  if [[ -z $(docker ps -aq) ]]; then
    echo "✨ No containers to nuke"
    return 0
  fi
  
  local count=$(docker ps -aq | wc -l)
  echo "⚠️  About to nuke $count container(s)"
  if gum confirm "Nuke $count container(s)?"; then
    docker ps -aq | xargs docker rm -f
    echo "✅ All containers nuked!"
  else
    echo "❌ Aborted"
  fi
}
