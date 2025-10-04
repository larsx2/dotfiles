######################
####### DOCKER #######
######################
alias dc="docker compose"
alias dupd="docker compose up -d"
alias ddown="docker compose down"
alias dstop="docker compose stop"
alias dps="docker compose ps"
alias dls="docker compose ls"
alias dlogs="docker compose logs"
alias dlogsf="docker compose logs -f --tail=100"
alias dtail="docker compose logs --tail=100"
alias dtailn="docker compose logs --tail="
alias dtailf="docker compose logs -f --tail=100"
alias dbuild="docker compose build"
alias drm="docker compose rm"
alias drun="docker compose run"
alias dexec="docker compose exec"
alias dpull="docker compose pull"
alias dpush="docker compose push"
alias dversion="docker compose version"
alias dreload="docker compose restart"
alias dkill="docker compose kill"
alias dstart="docker compose start"
alias dstop="docker compose stop"

dnuke() {
  if [[ -z $(docker ps -aq) ]]; then
    echo "✨ No containers to nuke"
    return 0
  fi
  
  local count=$(docker ps -aq | wc -l)
  echo "⚠️  About to nuke $count container(s)"
  echo -n "Are you sure? (y/N): "
  read -r confirm
  
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    # This ensures all IDs are passed correctly
    docker ps -aq | xargs docker rm -f
    echo "✅ All containers nuked!"
  else
    echo "❌ Aborted"
  fi
}
