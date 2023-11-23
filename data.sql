CREATE TABLE object(
    id_object VARCHAR(50) NOT NULL,
    name_object VARCHAR(50) NOT NULL,
    type_object VARCHAR(40) NOT NULL,
    category ENUM('pobre','comun','poco comun','raro'.'epico','legendario','artefacto') NOT NULL
);

ALTER TABLE object 
ADD CONSTRAINT UQ_object_name UNIQUE(name_object)
ADD CONSTRAINT PK_object PRIMARY KEY (id_object);

CREATE TABLE faction(
    id INT NOT NULL AUTO_INCREMENT,
    faction VARCHAR(20) NOT NULL
);

ALTER TABLE faction
ADD CONSTRAINT UQ_faction_faction UNIQUE(faction)
ADD CONSTRAINT PK_faction PRIMARY KEY (id);

CREATE TABLE buy(
    id_buy VARCHAR(30) NOT NULL,
    user_name VARCHAR(20) NOT NULL,
    id_object VARCHAR(50) NOT NULL
);

ALTER TABLE buy ADD CONSTRAINT PK_buy PRIMARY KEY (id_buy);

CREATE TABLE type_object(
    id INT NOT NULL AUTO_INCREMENT,
    type VARCHAR(255) NOT NULL
);

ALTER TABLE type_object ADD CONSTRAINT PK_type_object PRIMARY KEY (id);

CREATE TABLE stats_object(
    id_stats_object INT NOT NULL,
    id_object VARCHAR(255) NOT NULL,
    id_stats INT NOT NULL,
    value DOUBLE(8, 2) NOT NULL
);

ALTER TABLE stats_object ADD CONSTRAINT PK_stats_object PRIMARY KEY (id_stats_object)

CREATE TABLE inventory(
    id_inventory INT NOT NULL
    id_character INT NOT NULL,
    id_object VARCHAR(255) NOT NULL,
    amount INT NOT NULL,
);

ALTER TABLE inventory
ADD CONSTRAINT PK_inventory PRIMARY KEY (id_inventory);

CREATE TABLE statistics(
    id_statistics INT NOT NULL AUTO_INCREMENT,
    statistics_type VARCHAR(255) NOT NULL
);

ALTER TABLE statistics 
ADD CONSTRAINT PK_id_statistics PRIMARY KEY (id_statistics)
ADD CONSTRAINT UQ_statistics_type UNIQUE(statistics_type);

CREATE TABLE character(
    id_character VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    id_class INT NOT NULL,
    level_character INT NOT NULL,
    name_character VARCHAR(255) NOT NULL
);

ALTER TABLE character
ADD 

CREATE TABLE account(
    user_name VARCHAR(255) NOT NULL,
    password_account VARCHAR NOT NULL,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE stats_character(
    id_character VARCHAR(255) NOT NULL,
    id_stats INT NOT NULL,
    value VARCHAR(255) NOT NULL
);

CREATE TABLE user_account(
    email VARCHAR(255) NOT NULL,
    password_user VARCHAR(255) NOT NULL
);

CREATE TABLE race(
    id INT NOT NULL AUTO_INCREMENT,
    race VARCHAR(255) NOT NULL,
    faction_id INT NOT NULL
);

CREATE TABLE class(
    class_id INT NOT NULL AUTO_INCREMENT,
    race_id INT NOT NULL,
    class VARCHAR(255) NOT NULL
);
