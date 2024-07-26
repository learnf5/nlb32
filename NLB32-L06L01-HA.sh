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
sudo scp /tmp/nginx-repo* nginx2:/etc/ssl/nginx/

#This tcp directory created in lab 5, so it should carry on
sudo ssh nginx mkdir /etc/nginx/tcp
curl --silent --remote-name-all --output-dir /tmp https://raw.githubusercontent.com/learnf5/nlb32/main/lab06/tcp_lb.conf
sudo scp /tmp/tcp_lb.conf nginx:/etc/nginx/tcp


#Put Lab Guide onto both NGINX servers
# get lab-info.md for student guide bravais id
curl --silent https://raw.githubusercontent.com/learnf5/$COURSE_ID/main/lab-info.md --output /tmp/lab-info.md
brav_id=$(awk -F '|' "/$LAB_ID/"' {print $2}' /tmp/lab-info.md)

sudo scp /home/student/Desktop/Lab_Guide.desktop nginx:/home/student/Desktop/Lab_Guide.desktop
sudo scp /home/student/Desktop/Lab_Guide.desktop nginx2:/home/student/Desktop/Lab_Guide.desktop
echo Exec=firefox --app=https://f5.bravais.com/s/$brav_id >>/home/student/Desktop/Lab_Guide.desktop
ssh nginx gio set /home/student/Desktop/Lab_Guide.desktop /home/student/Desktop/Lab_Guide.desktop::trusted true
ssh nginx chmod +x /home/student/Desktop/Lab_Guide.desktop

echo Exec=firefox --app=https://f5.bravais.com/s/$brav_id >>/home/student/Desktop/Lab_Guide.desktop
ssh nginx2 gio set /home/student/Desktop/Lab_Guide.desktop /home/student/Desktop/Lab_Guide.desktop::trusted true
ssh nginx2 chmod +x /home/student/Desktop/Lab_Guide.desktop
