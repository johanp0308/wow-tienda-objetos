DROP DATABASE IF EXISTS wowShop;
CREATE DATABASE wowShop;
USE wowShop;

DROP TABLE IF EXISTS locker_object;
DROP TABLE IF EXISTS stats_object;
DROP TABLE IF EXISTS statistics;
DROP TABLE IF EXISTS catalogue;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS buy;
DROP TABLE IF EXISTS object;
DROP TABLE IF EXISTS locker;
DROP TABLE IF EXISTS character_wow;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS race;
DROP TABLE IF EXISTS faction;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS use_account;


CREATE TABLE object(
    id_object VARCHAR(50) NOT NULL,
    name_object VARCHAR(50) NOT NULL,
    type_object ENUM('BlizzObject','at a distance','Trinket','bag','head','shirt','waist','neck','finger','two hands','shield','back','shoudler','right hand','left hand','hands','dolls','feet','tabard','torso','a hand','consumable') NOT NULL,
    level_object INT NOT NULL,
    category ENUM('poor','common','rare','queer','epic','legendary','artifact') NOT NULL,
    id_class INT NULL
);

ALTER TABLE object
ADD CONSTRAINT PK_object PRIMARY KEY (id_object);

CREATE TABLE faction(
    id INT NOT NULL,
    faction_name VARCHAR(20) NOT NULL
);

ALTER TABLE faction 
ADD CONSTRAINT PK_faction PRIMARY KEY (id),
ADD CONSTRAINT UQ_faction UNIQUE (faction_name);

CREATE TABLE buy(
    id_buy INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(20) NOT NULL,
    id_object VARCHAR(50) NOT NULL,
    token_account VARCHAR(50) NOT NULL
);


CREATE TABLE stats_object(
    id_stats_object INT NOT NULL,
    id_object VARCHAR(50) NOT NULL,
    id_stats INT NOT NULL,
    value DOUBLE NOT NULL
);

ALTER TABLE stats_object
ADD CONSTRAINT PK_stats_object PRIMARY KEY (id_stats_object);

CREATE TABLE inventory(
    id_inventory INT NOT NULL,
    id_character_wow INT NOT NULL,
    id_object VARCHAR(30) NOT NULL,
    amount INT NOT NULL
);

ALTER TABLE inventory
ADD CONSTRAINT PK_inventory PRIMARY KEY (id_inventory);

CREATE TABLE statistics(
    id_statistics INT NOT NULL,
    statistics_type VARCHAR(20) NOT NULL
);

ALTER TABLE statistics
ADD CONSTRAINT PK_statistics PRIMARY KEY (id_statistics),
ADD CONSTRAINT UQ_statistics_type UNIQUE (statistics_type);

CREATE TABLE character_wow(
    id_character_wow INT NOT NULL,
    user_name VARCHAR(30) NOT NULL,
    id_class INT NOT NULL,
    level INT NOT NULL,
    name_character_wow VARCHAR(20) NOT NULL
);

ALTER TABLE character_wow
ADD CONSTRAINT PK_character_wow PRIMARY KEY (id_character_wow),
ADD CONSTRAINT UQ_name_character_wow UNIQUE(name_character_wow);

CREATE TABLE account(
    user_name VARCHAR(20) NOT NULL,
    password_account VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    wow_currency DOUBLE NOT NULL,
    token_account VARCHAR(30) NOT NULL
);

ALTER TABLE account
ADD CONSTRAINT PK_account PRIMARY KEY (user_name);

CREATE TABLE user_account(
    email VARCHAR(50) NOT NULL,
    password_user VARCHAR(30) NOT NULL
);

ALTER TABLE user_account
ADD CONSTRAINT PK_user PRIMARY KEY (email);

CREATE TABLE locker_object(
    id_locker INT NOT NULL,
    id_object VARCHAR(50) NOT NULL
);

CREATE TABLE catalogue(
    id_producto INT NOT NULL,
    value_wc DOUBLE(8, 2) NOT NULL,
    id_object VARCHAR(30) NOT NULL
);

ALTER TABLE catalogue
ADD CONSTRAINT PK_catalogue PRIMARY KEY (id_producto);

CREATE TABLE locker(
    id_locker INT NOT NULL,
    id_account VARCHAR(20) NOT NULL
);

ALTER TABLE locker
ADD CONSTRAINT PK_locker PRIMARY KEY (id_locker);

CREATE TABLE race(
    id INT NOT NULL,
    race VARCHAR(30) NOT NULL,
    faction_id INT NULL
);

ALTER TABLE race
ADD CONSTRAINT PK_race PRIMARY KEY (id),
ADD CONSTRAINT UQ_race UNIQUE (race);


CREATE TABLE class(
    class_id INT NOT NULL,
    race_id INT NOT NULL,
    class VARCHAR(30) NOT NULL
);

ALTER TABLE class
ADD CONSTRAINT PK_class PRIMARY KEY (class_id);


-- Foreign Keys

ALTER TABLE object
ADD CONSTRAINT FK_object_to_class FOREIGN KEY (id_class) REFERENCES class(class_id);

ALTER TABLE buy 
ADD CONSTRAINT FK_buy_to_object FOREIGN KEY (id_object) REFERENCES object(id_object);

ALTER TABLE stats_object
ADD CONSTRAINT FK_stats_object_to_object FOREIGN KEY (id_object) REFERENCES object(id_object),
ADD CONSTRAINT FK_stats_object_to_statistics FOREIGN KEY (id_stats) REFERENCES statistics(id_statistics);

ALTER TABLE inventory
ADD CONSTRAINT FK_inventory_to_object FOREIGN KEY (id_object) REFERENCES object(id_object),
ADD CONSTRAINT FK_inventory_to_character_wow FOREIGN KEY (id_character_wow) REFERENCES character_wow(id_character_wow);

ALTER TABLE character_wow
ADD CONSTRAINT FK_character_wow_to_account FOREIGN KEY (user_name) REFERENCES account(user_name),
ADD CONSTRAINT FK_character_wow_to_class FOREIGN KEY (id_class) REFERENCES class(class_id);

ALTER TABLE account
ADD CONSTRAINT FK_account_to_email FOREIGN KEY (email) REFERENCES user_account(email);

ALTER TABLE locker_object
ADD CONSTRAINT FK_locker_object_to_locker FOREIGN KEY (id_locker) REFERENCES locker(id_locker),
ADD CONSTRAINT FK_locker_object_to_object FOREIGN KEY (id_object) REFERENCES object(id_object);

ALTER TABLE catalogue
ADD CONSTRAINT FK_catalogue_to_object FOREIGN KEY (id_object) REFERENCES object(id_object);

ALTER TABLE locker
ADD CONSTRAINT FK_locker_to_account FOREIGN KEY (id_account) REFERENCES account(user_name);

ALTER TABLE race
ADD CONSTRAINT FK_race_to_factio FOREIGN KEY (faction_id) REFERENCES faction(id);

ALTER TABLE class
ADD CONSTRAINT FK_class_to_race FOREIGN KEY (race_id) REFERENCES race(id);


