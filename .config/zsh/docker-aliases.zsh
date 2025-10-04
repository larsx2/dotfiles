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
