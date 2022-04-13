# mnk-server-init

This is the configuration for the server for rendering the Městem na Kole map tiles. It is configured to start up, pull this repository and run INIT.sh

You can get access to the server by adding the contents of `~/.ssh/id_rsa.pub` to [INIT.sh](https://github.com/auto-mat/mnk-server-init/blob/main/INIT.sh#L2) and restarting the server.

Once your public key is added, you can log in with:

````
ssh -p 10022 root@hobbs.cz
````

There will be no password.
