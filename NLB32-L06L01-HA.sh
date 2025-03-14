# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

# update lab environment
sudo ssh nginx test -e /etc/nginx/conf.d/default.conf && sudo ssh nginx rm /etc/nginx/conf.d/default.conf
curl --silent --remote-name-all --output-dir /tmp https://raw.githubusercontent.com/learnf5/nlb32/main/lab05/main.conf
sudo scp /tmp/main.conf nginx:/etc/nginx/conf.d/
curl --silent --remote-name-all --output-dir /tmp https://raw.githubusercontent.com/learnf5/nlb32/main/lab06/nginx.conf
sudo scp /tmp/nginx.conf nginx:/etc/nginx/

#Add nginx license to nginx2 lab system, required for keepalived setup
sudo scp /tmp/nginx-one-eval.crt nginx2:/etc/ssl/nginx/nginx-repo.crt
sudo scp /tmp/nginx-one-eval.key nginx2:/etc/ssl/nginx/nginx-repo.key
sudo scp /tmp/nginx-one-eval.jwt nginx2:/etc/nginx/license.jwt

#This tcp directory created in lab 5, so it should carry on
sudo ssh nginx mkdir /etc/nginx/tcp
curl --silent --remote-name-all --output-dir /tmp https://raw.githubusercontent.com/learnf5/nlb32/main/lab06/tcp_lb.conf
sudo scp /tmp/tcp_lb.conf nginx:/etc/nginx/tcp

#Add nginx servers to /etc/hosts file
curl --silent --remote-name-all --output-dir /tmp https://raw.githubusercontent.com/learnf5/nlb32/main/lab06/hosts
sudo scp /tmp/hosts nginx:/etc/hosts
sudo scp /tmp/hosts nginx2:/etc/hosts

#Put Lab Guide onto both NGINX servers
# get lab-info.md for student guide bravais id
curl --silent https://raw.githubusercontent.com/learnf5/$COURSE_ID/main/lab-info.md --output /tmp/lab-info.md
brav_id=$(awk -F '|' "/$LAB_ID/"' {print $2}' /tmp/lab-info.md)

head -7 /home/student/Desktop/Lab_Guide.desktop > /tmp/NGINX_Lab_Guide.desktop
echo Exec=firefox https://f5.bravais.com/s/$brav_id >> /tmp/NGINX_Lab_Guide.desktop

sudo scp /tmp/NGINX_Lab_Guide.desktop nginx:/home/student/Desktop/Lab_Guide.desktop
sudo scp /tmp/NGINX_Lab_Guide.desktop nginx2:/home/student/Desktop/Lab_Guide.desktop

sudo ssh nginx chown student.student /home/student/Desktop/Lab_Guide.desktop
sudo ssh nginx chmod +x /home/student/Desktop/Lab_Guide.desktop
sudo ssh student@nginx gio set /home/student/Desktop/Lab_Guide.desktop metadata::trusted true

sudo ssh nginx2 chown student.student /home/student/Desktop/Lab_Guide.desktop
sudo ssh nginx2 chmod +x /home/student/Desktop/Lab_Guide.desktop
sudo ssh student@nginx2 gio set /home/student/Desktop/Lab_Guide.desktop metadata::trusted true
