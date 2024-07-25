# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

# update lab environment
sudo ssh nginx test -e /etc/nginx/conf.d/default.conf && sudo ssh nginx rm /etc/nginx/conf.d/default.conf
curl --silent --remote-name-all --output-dir /tmp https://raw.githubusercontent.com/learnf5/nlb32/main/lab06/main.conf
sudo scp /tmp/main.conf nginx:/etc/nginx/conf.d/
curl --silent --remote-name-all --output-dir /tmp https://raw.githubusercontent.com/learnf5/nlb32/main/lab06/tcp_lb.conf
sudo scp /tmp/tcp_lb.conf nginx:/etc/nginx/conf.d/
curl --silent --remote-name-all --output-dir /tmp https://raw.githubusercontent.com/learnf5/nlb32/main/lab06/nginx.conf
sudo scp /tmp/nginx.conf nginx:/etc/nginx/

#Add nginx license to nginx2 lab system, required for keepalived setup
sudo scp /tmp/nginx-repo* nginx2:/etc/ssl/nginx/
