sudo docker build -t datapool/ignite:1.0 .
sudo docker-compose -f compose.yml up

Массовая остановка и удаление контейнеров
sudo docker rm $(sudo docker ps -a -q)
sudo docker stop $(sudo docker ps -a -q)
