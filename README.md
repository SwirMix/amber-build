## Demo проекта
Репозиторий с демонстрационной сборкой \
[Demo build](https://github.com/SwirMix/amber-build/tree/main)

Демонстрационная админская учетная запись: \
<b>login: ponchick@gmail.com</b>\
<b>password: 1234567890</b>


### Установка Apache Ignite
<b>Выберите рабочую директорию</b>
Назовем ее IGNITE_BIN

1. Перейти в директорию IGNITE_BIN. Скачать официальный релиз apache ignite
```
wget https://archive.apache.org/dist/ignite/2.14.0/apache-ignite-2.14.0-bin.zip
```
2. Произвести распаковку скачанного архива в IGNITE_BIN.
```
unzip apache-ignite-2.14.0-bin.zip -d $IGNITE_BIN
```
3. Скопировать в рабочую директорию дополнительные библиотеки
```
unzip ${IGNITE_BIN}/libs.zip -d ${IGNITE_BIN}
export IGNITE_HOME=${IGNITE_BIN}/apache-ignite-2.14.0-bin
cp ${IGNITE_BIN}/libs/* ${IGNITE_HOME}/libs
```
4. Скорректировать конфигурацию сервера с учетом локального ip адреса\
   [datapool-server.xml](https://github.com/SwirMix/amber-build/blob/main/ignite/config/datapool-server.xml)\
   [jetty.xml](https://github.com/SwirMix/amber-build/blob/main/ignite/config/jetty.xml)\
   Заменить в данных файлах адрес 192.168.0.8 на ваш локальный

5. Произвести запуск тестовой ноды
```
chmod -R 777 ${IGNITE_HOME}/libs
export USER_LIBS=${IGNITE_HOME}/libs/ignite-prometheus-1.0-SNAPSHOT-jar-with-dependencies.jar
bash ${IGNITE_HOME}/bin/ignite.sh ${IGNITE_BIN}/config/datapool-server.xml
```

### Создание схемы PostgreSQL
Для работы системы требуется PostgreSQL база данных.
Вам необходимо проинициализировать схему для работы.
[init.sql](https://github.com/SwirMix/amber-build/blob/main/postgresql/2.%20Init%20Database/init.sql)

Желательно заранее произвести установку ip адресов
``` sql
INSERT INTO datapool.settings ("name",value) VALUES
	 ('jwt','1234567890'),
	 ('passwd_jwt','1234567890'),
	 ('master-token','1234567890'),
	 ('cache-manager-app','http://localhost:8083/'),
	 ('datapool-app','http://localhost:8084/'),
	 ('victoria-metrics','http://192.168.0.8:8428');
COMMIT;
```

### Дополнительно и очень желательно
Необходимо чтобы вы имели где-то установленную Victoria Metrics.
Её URL желательно прописать на предыдущем этапе.

### Запуск прикладных модулей

```
java -Dspring.config.additional-location=/api-controller-app.yaml -jar api-controller-app-1.0-SNAPSHOT.jar
```

```
java -Dspring.config.additional-location=/cache-manager-app.yaml -jar cache-manager-app-1.0-SNAPSHOT.jar
```

```
java -Dspring.config.additional-location=/datapool-app.yaml -jar datapool-app-1.0-SNAPSHOT.jar
```

После успешного запуска вам доступна будет административная панель по адресу http://localhost:8082\
![Image from alias](https://github.com/SwirMix/amber-build/blob/main/img/dashboard.png)

## Стратегии параметризации
| Стратегия   |                                                      Описание                                                       | Интерфейс |
|-------------|:-------------------------------------------------------------------------------------------------------------------:|----------:|
| CSV         |        Используя админ панель вы можете выгрузить кэш в CSV файл и после скачать для локального применения.         |  CSV file |
| RANDOM      |                                       Запрос случайной строки данных из кэша.                                       |      REST |
| SEQUENTIAL  |                       Запрос данных по порядку. Курсор является общим для всех потребителей.                        |      REST |      
| KEY         |                  Запрос конкретной строки из существующего кэша                                                     |      REST |
| HASH        |         Запрос дынных по их хэшу. Используется для идентификации данных на основе встроенного мониторинга.          |      REST |
| STACK       | Запрос последней строки данных из кэша. После потребления строка удаляется из кэша. Таким образом кэш опустошается. |      REST |
