sudo docker stop $(sudo docker ps -a -q) Остановка всех контейнеров  
sudo docker rm $(sudo docker ps -a -q) удаление всех контейнеров  
sudo docker exec -it 98259043ca4f /sh подключение к контейнеру 

Загрузка тестовых данных
psql -U perfcona -p 5432 -h localhost  -f ./aircraft.sql
Поднять контейнер
sudo docker-compose -f postgres-docker.yaml up
