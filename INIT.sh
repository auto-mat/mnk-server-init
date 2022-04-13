ssh -fN -R 10022:localhost:22 reverse@hobbs.cz
sleep 1000
git pull
exec sh INIT.sh
