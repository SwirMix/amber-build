CREATE SCHEMA datapool AUTHORIZATION perfcona;
CREATE SCHEMA profile AUTHORIZATION perfcona;
COMMIT;
create table datapool.users (
    id varchar(36) primary key,
    registration timestamptz,
    email varchar(200) not null unique,
    login varchar(200) not null,
    password varchar(200) not null,
    active boolean default true,
    global_admin boolean default false
);
COMMIT;

create table datapool.projects (
    id varchar(36) primary key,
    name varchar(128) not null,
    description varchar(500) default '',
    created date,
    active boolean default true
);
COMMIT;

create table datapool.project_permissions (
    project_id varchar(36) references datapool.projects(id),
    user_id varchar(36) references datapool.users(id),
    role integer,
    primary key (project_id, user_id)
);
COMMIT;

create table datapool.settings (
    name varchar(256) primary key,
    value text
);
COMMIT;

create table datapool.datasource (
    id varchar(100) primary key,
	project_id varchar(64) references datapool.projects(id),
	name varchar(64) NOT NULL,
	properties jsonb
);
COMMIT;

create table datapool.tokens (
    token text,
	project_id varchar(64) references datapool.projects(id),
	name varchar(128) primary key,
	create_date timestamptz,
	creator text references datapool.users(email)
);
COMMIT;

create table datapool.cache_log (
    id text primary key,
	project_id varchar(64) references datapool.projects(id),
	cache_name varchar(128),
	type varchar(30),
	date timestamptz,
	data jsonb
);
COMMIT;

create view datapool.last_cache_actions as
select
	id,
	project_id,
	log.cache_name,
	log.type,
	log.date,
	data
from datapool.cache_log as log join (
	select max(date) as date, cache_name, type from datapool.cache_log cl group by cache_name, type
) as last_create on log.cache_name = last_create.cache_name and log.type = last_create.type and log.date = last_create.date;
COMMIT;

INSERT INTO datapool.users (id,email,login,"password",active,registration,global_admin) VALUES ('d8e35c03-0c4e-435c-860b-361aaa6b81dc','ponchick@gmail.com','ponchick','eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJwYXNzd29yZCI6IjEyMzQ1Njc4OTAiLCJ0aW1lc3RhbXAiOjE2ODE2NDk3Mjc0NDJ9.3yv8ETx7PQ9zsRx1IJrTa_9vi6ScdtVjstNrgqdMsueOAO36vjYkhTehv56GdnPq40oJaIxifZbCZFcJzab1-g',true,'2023-04-16 15:55:27.442+03',true);
COMMIT;
INSERT INTO datapool.settings ("name",value) VALUES
	 ('jwt','1234567890'),
	 ('passwd_jwt','1234567890'),
	 ('master-token','1234567890'),
	 ('cache-manager-app','http://localhost:8083/'),
	 ('datapool-app','http://localhost:8084/'),
	 ('victoria-metrics','http://192.168.0.8:8428');
COMMIT;
INSERT INTO datapool.projects (id,"name",description,created,active) VALUES
	 ('711bff9d-a873-4497-873f-fbfceb220071','default','hello world','2023-07-24',true);
COMMIT;
INSERT INTO datapool.project_permissions (project_id,user_id,"role") VALUES
	 ('711bff9d-a873-4497-873f-fbfceb220071','d8e35c03-0c4e-435c-860b-361aaa6b81dc',0);
COMMIT;
