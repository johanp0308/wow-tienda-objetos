CREATE TABLE object(
    id_object VARCHAR(255) NOT NULL,
    name_object VARCHAR(255) NOT NULL,
    type_object VARCHAR(255) NOT NULL,
    category ENUM("comun",) NOT NULL
);

CREATE TABLE faction(
    id INT NOT NULL AUTO_INCREMENT,
    faction VARCHAR(255) NOT NULL
);

CREATE TABLE buy(
    id_compra VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    id_object VARCHAR(255) NOT NULL
);

CREATE TABLE type_object(
    id INT NOT NULL AUTO_INCREMENT,
    type VARCHAR(255) NOT NULL
);
CREATE TABLE stats_object(
    id_object VARCHAR(255) NOT NULL,
    id_stats INT NOT NULL,
    value DOUBLE(8, 2) NOT NULL
);

CREATE TABLE inventory(
    id_inventory INT NOT NULL
    id_character INT NOT NULL,
    id_object VARCHAR(255) NOT NULL,
    amount INT NOT NULL,
);

CREATE TABLE statistics(
    id_statistics INT NOT NULL AUTO_INCREMENT,
    statistics_type VARCHAR(255) NOT NULL
);


CREATE TABLE character(
    id_character VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    id_class INT NOT NULL,
    level INT NOT NULL,
    name_character VARCHAR(255) NOT NULL
);

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
