# start httpGate
sudo /usr/bin/httpGate 8000 8080 /cert/server.key,/cert/server.crt
# run pil
pil server.l -start -wait
