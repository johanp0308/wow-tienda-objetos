
-- OBJECT _________________________________________________

-- CREATE and UPDATE
DROP PROCEDURE IF EXISTS create_object;
DELIMITER //
CREATE PROCEDURE create_object(
    in $id_object VARCHAR(50),
    in $name_object VARCHAR(50),
    in $type_object ENUM('BlizzObject','at a distance','Trinket','bag','head','shirt','waist','neck','finger','two hands','shield','back','shoulder','right hand','left hand','hands','dolls','feet','tabard','torso','a hand','consumable'),
    in $level_object INT,
    in $category enum('poor','common','rare','queer','epic','legendary','artifact'),
    in $id_class INT
)
BEGIN
    DECLARE var_id_object VARCHAR(50);
    SET @object_var = CONCAT('',$id_object,'');

    DECLARE exit HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'An error has occurred'
    END;

    SELECT o.id_object INTO var_id_object 
    FROM object o
    WHERE o.id_object LIKE @object_var;

    IF var_id_object IS NULL
    THEN
        INSERT INTO object
        (id_object,name_object,type_object,level_object,category,id_class) 
        VALUES ($id_object,$name_object,$type_object,$level_object,$category,$id_class);
    ELSE   
        UPDATE object
        SET 
            name_object = $name_object,
            type_object = $type_object,
            level_object = $level_object,
            category = $category,
            id_class = $id_class
        WHERE id_object = var_id_object;

    END IF;

    COMMIT;
END //
DELIMITER ;
-- DELETE_________ 
DROP PROCEDURE IF EXISTS delete_object_cascade;
DELIMITER //
CREATE PROCEDURE delete_object_cascade(IN i_id_object VARCHAR(50))
BEGIN
    DECLARE idObject VARCHAR(50);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'An error occurred' as Message;
    END;

    START TRANSACTION;

    SELECT o.id_object INTO idObject FROM object o WHERE o.id_object = i_id_object;

    IF idObject IS NOT NULL 
    THEN
        DELETE FROM stats_object so
        WHERE so.id_object = idObject;

        DELETE FROM locker_object lo
        WHERE lo.id_object = idObject;

        DELETE FROM buy b
        WHERE b.id_object = idObject;

        DELETE FROM catalogue c
        WHERE c.id_object = idObject;

        DELETE FROM object o
        WHERE o.id_object = idObject;
    ELSE
        SELECT 'Object not Found';
    END IF;

    COMMIT;
END //
DELIMITER ;
-- _______CRUD
DROP PROCEDURE IF EXISTS getAll_object_by_class;
DELIMITER //
CREATE PROCEDURE getAll_object_by_class(in class VARCHAR(30))
BEGIN
    SELECT *
    FROM object o
    WHERE o.id_class = (
      SELECT c.class_id 
      FROM class c
      WHERE c.class like class
   );
END //
DELIMITER ;
DROP PROCEDURE IF EXISTS getAll_category_and_type;
DELIMITER //
CREATE PROCEDURE getAll_category_and_type()
BEGIN
   SELECT o.category, GROUP_CONCAT(DISTINCT o.type_object)
   FROM object o
   WHERE o.category IN (SELECT category FROM object)
   AND o.type_object IN (SELECT type_object FROM object)
   GROUP BY o.category;
END //
DELIMITER ;
DROP PROCEDURE IF EXISTS getAll_object_order_by_level;
DELIMITER //
CREATE PROCEDURE getAll_object_order_by_level()
BEGIN
   SELECT o.*
   FROM object o
   ORDER BY o.level_object;
END //
DELIMITER ;
DROP PROCEDURE IF EXISTS getAll_object_order_by_level;
DELIMITER //
CREATE PROCEDURE getAll_object_order_by_level()
BEGIN
   SELECT o.*
   FROM object o
   ORDER BY o.level_object;
END //
DELIMITER ;
DROP PROCEDURE IF EXISTS getAll_object_category_buy;
DELIMITER //
CREATE PROCEDURE getAll_object_category_buy()
BEGIN
    SELECT o.category, COUNT(*) as count
    FROM object o
    WHERE o.id_object = ANY(SELECT b.id_object FROM buy b)
    GROUP BY o.category;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS getAll_object_class_race_faction;
DELIMITER //
CREATE PROCEDURE getAll_object_class_race_faction()
BEGIN
    SELECT o.id_object, o.name_object, c.class, r.race, f.faction_name 
    FROM object o,class c, race r, faction f
    WHERE o.id_class = c.class_id
    AND c.race_id = r.id
    AND r.faction_id = f.id;
END //
DELIMITER ;
-- ________________________________________________________OBJECT

-- FACTION_______________________________________________________
-- CRUD________
-- CREATE UPDATE
DROP PROCEDURE IF EXISTS create_faction;
DELIMITER //
CREATE PROCEDURE create_faction(
    IN in_id INT,
    IN in_faction_name VARCHAR(20)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'An error has occurred' as Message;
    END;

    START TRANSACTION;

    INSERT INTO faction (id, faction_name) 
    VALUES (in_id, in_faction_name)
    ON DUPLICATE KEY UPDATE 
        faction_name = in_faction_name;

    COMMIT;
    SELECT 'Stored data' as Message;
END //
DELIMITER ;

-- DELETE
DROP PROCEDURE IF EXISTS delete_faction;
DELIMITER //
CREATE PROCEDURE delete_faction(
    IN in_id_faction INT
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'An error has occurred' as Message;
    END;

    START TRANSACTION;

    DELETE FROM faction f
    WHERE f.id = in_id_faction;

    COMMIT;
END //
DELIMITER ;
-- ________CRUD
DROP PROCEDURE IF EXISTS character_factio_horde_lvl_greater_60;
DELIMITER //
CREATE PROCEDURE character_factio_horde_lvl_greater_60()
BEGIN
    SELECT COUNT(*)
    FROM character_wow c
    WHERE c.id_character_wow IN(
        SELECT ch.id_character_wow
        FROM faction f
        JOIN race r ON f.id = r.faction_id
        JOIN class cl ON r.id = cl.race_id
        JOIN character_wow ch ON cl.class_id = ch.id_class
        WHERE f.faction_name LIKE 'Horde'
        AND ch.level > 60
    );
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS faction_max_object_catalogue;
DELIMITER //
CREATE PROCEDURE faction_max_object_catalogue()
BEGIN
    SELECT f.faction_name
    FROM faction f
    WHERE f.id IN (
        SELECT f.id
        FROM catalogue c
        JOIN object o ON c.id_object = o.id_object
        JOIN class cl ON o.id_class = cl.class_id
        JOIN race r ON cl.race_id = r.id
        JOIN faction f ON r.faction_id = f.id
        GROUP BY f.id
        ORDER BY COUNT(*) DESC
    );
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS avarage_lvl_alliance_with_object_blizz;
DELIMITER //
CREATE PROCEDURE avarage_lvl_alliance_with_object_blizz()
BEGIN
    SELECT AVG(level)
    FROM character_wow ch
    WHERE ch.id_class IN(
        SELECT cl.class_id
        FROM faction f
        JOIN race r ON f.id = r.faction_id
        JOIN class cl ON r.id = cl.race_id
        AND f.faction_name = 'alliance')
    AND ch.id_character_wow IN (
        SELECT inv.id_character_wow
        FROM object o, inventory inv, character_wow cha
        WHERE inv.id_character_wow = cha.id_character_wow
        AND o.type_object = 'BlizzObject'
    );
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS faction_greate_object_rare;
DELIMITER //
CREATE PROCEDURE faction_greate_object_rare()
BEGIN
    SELECT f.faction_name
    FROM faction f
    WHERE f.id IN (
        SELECT f.id
        FROM object o
        JOIN class cl ON o.id_class = cl.class_id
        JOIN race r ON cl.race_id = r.id
        JOIN faction f ON r.faction_id = f.id
        WHERE o.category = 'rare'
        GROUP BY f.id
        ORDER BY COUNT(*) ASC
    )
    LIMIT 1;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS faction_charact_buy_epic_legendary;
DELIMITER //
CREATE PROCEDURE faction_charact_buy_epic_legendary()
BEGIN
    SELECT faction_object.faction_name
    FROM (
        SELECT f.faction_name as faction_name, COUNT(*) as count_object
        FROM faction f
        JOIN race r ON f.id = r.faction_id
        JOIN class cl ON r.id = cl.race_id
        JOIN object o ON cl.class_id = o.id_class
        JOIN buy b ON o.id_object = b.id_object
        GROUP BY f.faction_name
        ORDER BY count_object ASC
    ) as faction_object
    LIMIT 1;
END //
DELIMITER ;



-- _______________________________________________________FACTION


-- BUY___________________________________________________________
-- CRUD_______
-- CREATE UPDATE
DROP PROCEDURE IF EXISTS create_buy;
DELIMITER //
CREATE PROCEDURE create_buy(
    IN in_id_object VARCHAR(50),
    IN in_token_account VARCHAR(30),
    IN in_name_account VARCHAR(20)
)
BEGIN

    DECLARE var_object_id VARCHAR(50);
    DECLARE var_value_object DOUBLE(8,2);

    DECLARE var_user_valid VARCHAR(20);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Error when inserting purchase information.';
    END;

    SELECT c.id_object , c.value_wc INTO var_object_id, var_value_object
    FROM catalogue c
    WHERE c.id_object = in_id_object;

    SELECT a.user_name INTO var_user_valid
    FROM account a
    WHERE a.user_name = in_name_account
    AND a.token_account = in_token_account;

    IF var_object_id IS NOT NULL AND var_user_valid IS NOT NULL
    THEN
        INSERT INTO buy(user_name,id_object,token_accoun)
        VALUES (var_user_valid,in_id_object,in_token_account);
    END IF;
    COMMIT;
END //
DELIMITER ;
-- _______CRUD

-- 1

DROP PROCEDURE IF EXISTS object_buy_more_expnesive;
DELIMITER //
CREATE PROCEDURE object_buy_more_expnesive()
BEGIN
    SELECT b.*,c.value_wc
    FROM buy b,catalogue c
    WHERE b.id_object = c.id_object
    AND c.value_wc >= ALL(
        SELECT ca.value_wc
        FROM catalogue ca
        JOIN buy b ON ca.id_object = b.id_object
    );
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS buys_of_user_by_token;
DELIMITER //
CREATE PROCEDURE buys_of_user_by_token(IN token_user VARCHAR(30))
BEGIN
    SELECT b.*
    FROM buy b
    WHERE b.token_account = (
        SELECT a.token_account
        FROM account a
        WHERE a.token_account = token_user
    );
 
END //
DELIMITER ;


-- ______
DROP PROCEDURE IF EXISTS buys_by_object_id;
DELIMITER //
CREATE PROCEDURE buys_by_object_id(IN object_id VARCHAR(50))
BEGIN
    SELECT b.*
    FROM buy b
    WHERE b.id_object = (
        SELECT id_object
        FROM object
        WHERE id_object = object_id
    );
END //
DELIMITER ;

-- ______
DROP PROCEDURE IF EXISTS buys_by_type_object;
DELIMITER //
CREATE PROCEDURE buys_by_type_object(IN object_type VARCHAR(20))
BEGIN
    SELECT b.*
    FROM buy b
    WHERE b.id_object IN(
        SELECT id_object
        FROM object
        WHERE type_object = object_type
    );
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS object_most_purchase_item;
DELIMITER //
CREATE PROCEDURE object_most_purchase_item()
BEGIN
    SELECT id_object, count_by
    FROM (
        SELECT b.id_object as id_object, COUNT(b.id_object) as count_by
        FROM buy b
        GROUP BY b.id_object
        ORDER BY count_by DESC) as table_objects
    WHERE count_by >= ALL(
        SELECT COUNT(b.id_object) as count_by
        FROM buy b
        GROUP BY b.id_object
        ORDER BY count_by DESC
    );    
END //
DELIMITER ;

-- ___________________________________________________________BUY

-- __________________________________________________STATS_OBJECT

DROP PROCEDURE IF EXISTS better_average_statis_object;
DELIMITER //
CREATE PROCEDURE better_average_statis_object()
BEGIN
    SELECT table_average.id_object, table_average.average_object
    FROM (
        SELECT so.id_object as id_object, AVG(VALUE) as average_object
        FROM stats_object so
        GROUP BY so.id_object) as table_average
    WHERE table_average.average_object >= ALL(
        SELECT AVG(VALUE) as average_object
        FROM stats_object so
        GROUP BY so.id_object
    );
END //
DELIMITER ;
-- _____

DROP PROCEDURE IF EXISTS objec_statistics_heigth_armor;
DELIMITER //
CREATE PROCEDURE objec_statistics_heigth_armor()
BEGIN
    SELECT table_stats.id_object, table_stats.value
    FROM (
        SELECT so.id_object as id_object, so.value as value
        FROM stats_object so
        WHERE so.id_stats = (
            SELECT id_statistics
            FROM statistics 
            WHERE statistics_type = 'Armor'
        )) as table_stats
    WHERE table_stats.value >= (
        SELECT so.value as value
        FROM stats_object so
        WHERE so.id_stats = (
            SELECT id_statistics
            FROM statistics 
            WHERE statistics_type = 'Armor'
        )
    );    
END //
DELIMITER ;

-- _____

DROP PROCEDURE IF EXISTS object_with_more_statistics;
DELIMITER //
CREATE PROCEDURE object_with_more_statistics()
BEGIN
    SELECT tabla_stats.id_object,tabla_stats.cantidad
    FROM (
        SELECT so.id_object as id_object, SUM(so.value) as cantidad
        FROM stats_object so
        GROUP BY so.id_object
        ) as tabla_stats
    WHERE tabla_stats.cantidad >= ALL(
        SELECT SUM(so.value) as cantidad
        FROM stats_object so
        GROUP BY so.id_object
    );
END //
DELIMITER ;

-- ______
DROP PROCEDURE IF EXISTS average_statistics_all_objects;
DELIMITER //
CREATE PROCEDURE average_statistics_all_objects()
BEGIN
    SELECT s.statistics_type , AVG(so.value)
    FROM stats_object so
    JOIN statistics s ON so.id_stats = s.id_statistics
    GROUP BY s.statistics_type;
END //
DELIMITER ;

-- ___

DROP PROCEDURE IF EXISTS objet_more_statist_by_category_epic;
DELIMITER //
CREATE PROCEDURE name()
BEGIN
    SELECT tabla_stats.id_object, tabla_stats.average
    FROM (
        SELECT so.id_object as id_object, AVG(so.value) as average
        FROM stats_object so
        JOIN object o ON so.id_object = o.id_object
        WHERE o.category LIKE 'epic'
        GROUP BY so.id_object
    )  as tabla_stats
    WHERE tabla_stats.average >= ALL(
        SELECT AVG(so.value) as average
        FROM stats_object so
        JOIN object o ON so.id_object = o.id_object
        WHERE o.category LIKE 'epic'
        GROUP BY so.id_object
    );
END //
DELIMITER ;



-- STATS_OBJECT__________________________________________________

-- ______________________________________________________IVENTORY

DROP PROCEDURE IF EXISTS object_in_inventory_by_user;
DELIMITER //
CREATE PROCEDURE object_in_inventory_by_user(IN userName VARCHAR(50))
BEGIN
    SELECT o.*
    FROM inventory inv
    JOIN character_wow ch ON inv.id_character_wow = ch.id_character_wow
    JOIN object o ON inv.id_object = o.id_object
    WHERE ch.user_name LIKE userName;
END //
DELIMITER ;

-- ___

DROP PROCEDURE IF EXISTS object_in_user;
DELIMITER //
CREATE PROCEDURE object_in_user()
BEGIN
    SELECT ch.user_name
    FROM character_wow ch
    WHERE ch.id_character_wow IN (
        SELECT id_character_wow
        FROM inventory
        WHERE id_object = 'walkerboots026'
    );
END //
DELIMITER ;

-- ____

DROP PROCEDURE IF EXISTS object_by_account_by_character;
DELIMITER //
CREATE PROCEDURE object_by_account_by_character()
BEGIN
    SELECT a.user_name, ch.name_character_wow, COUNT(inv.id_object)
    FROM account a, character_wow ch, inventory inv
    WHERE a.user_name = ch.user_name AND ch.id_character_wow = inv.id_character_wow
    GROUP BY a.user_name, ch.name_character_wow;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS orfanized_object_category_character;
DELIMITER //
CREATE PROCEDURE orfanized_object_category_character(IN name_character VARCHAR(30))
BEGIN
    SELECT o.category, COUNT(o.id_object) as objects
    FROM object o
    JOIN inventory inv ON o.id_object = inv.id_object
    WHERE inv.id_character_wow = (
        SELECT id_character_wow
        FROM character_wow
        WHERE name_character_wow = name_character
    )
    GROUP BY o.category;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS object_in_catalogue_and_value;
DELIMITER //
CREATE PROCEDURE object_in_catalogue_and_value()
BEGIN
SELECT o.name_object,(
    SELECT c.value_wc 
    FROM catalogue c 
    WHERE c.id_object = o.id_object
    ) AS value_wc
FROM object o
JOIN inventory inv ON o.id_object = inv.id_object;
END //
DELIMITER ;

-- INVENTORY_____________________________________________________
-- ____________________________________________________statistics

DROP PROCEDURE IF EXISTS statistics_not_object;
DELIMITER //
CREATE PROCEDURE statistics_not_object()
BEGIN
    SELECT s.statistics_type
    FROM statistics s
    WHERE s.id_statistics NOT IN (
        SELECT so.id_stats 
        FROM stats_object so
    );
END //
DELIMITER ;

SELECT s.statistics_type
FROM statistics s
LEFT JOIN stats_object so ON s.id_statistics = so.id_stats
WHERE so.id_object IS NULL; 

SELECT s.statistics_type
FROM statistics s
WHERE s.id_statistics NOT IN (SELECT so.id_stats FROM stats_object so);

DROP PROCEDURE IF EXISTS statis_count_use;
DELIMITER //
CREATE PROCEDURE statis_count_use()
BEGIN
    SELECT
        s.statistics_type,
        (
            SELECT COUNT(so.id_stats) 
            FROM stats_object so 
            WHERE so.id_stats = s.id_statistics
        ) AS count_id_statistics
    FROM
        statistics s;
END //
DELIMITER ;




DROP PROCEDURE IF EXISTS statistics_not_object;
DELIMITER //
CREATE PROCEDURE statistics_not_object()
BEGIN
    SELECT cw.name_character_wow AS character_name,AVG(so.value) AS average_stats
    FROM character_wow cw
    JOIN inventory inv ON cw.id_character_wow = inv.id_character_wow
    JOIN object o ON inv.id_object = o.id_object
    JOIN stats_object so ON o.id_object = so.id_object
    GROUP BY cw.name_character_wow;
END //
DELIMITER ;


SELECT 
    cw.name_character_wow AS character_name,
    COUNT(inv.id_object) AS items,
    SUM(so.value) AS total_stats_value,
    AVG(so.value) AS average_stats_value
FROM character_wow cw
LEFT JOIN inventory inv ON cw.id_character_wow = inv.id_character_wow
LEFT JOIN stats_object so ON inv.id_object = so.id_object
GROUP BY cw.name_character_wow;

DROP PROCEDURE IF EXISTS statistics_not_object;
DELIMITER //
CREATE PROCEDURE statistc_general_for_character()
BEGIN
    SELECT 
        cw.name_character_wow AS character_name,
        COUNT(inv.id_object) AS items,
        SUM(so.value) AS total_stats_value,
        AVG(so.value) AS average_stats_value
    FROM character_wow cw
    LEFT JOIN inventory inv ON cw.id_character_wow = inv.id_character_wow
    LEFT JOIN stats_object so ON inv.id_object = so.id_object
    GROUP BY cw.name_character_wow;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS statistic_by_name;
DELIMITER //
CREATE PROCEDURE statistic_by_name(IN name VARCHAR(20))
BEGIN
    SELECT * 
    FROM statistics s
    WHERE s.statistics_type = name;
END //
DELIMITER ;
-- statistics_________________________________________________

-- _________________________________________________character_wow
DROP PROCEDURE IF EXISTS statistic_by_name;
DELIMITER //
CREATE PROCEDURE character_by_name(IN name VARCHAR(30))
BEGIN
    SELECT *
    FROM character_wow ch
    WHERE ch.name_character_wow =name;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS statistic_by_name;
DELIMITER //
CREATE PROCEDURE statistic_by_name()
BEGIN
SELECT cw.name_character_wow AS character_name,
    (
        SELECT class 
        FROM class 
        WHERE class_id = cw.id_class
    ) AS class_character,
    cw.level AS character_level,
    (
        SELECT race 
        FROM race 
        WHERE id = (
            SELECT race_id 
            FROM class 
            WHERE class_id = cw.id_class
            )
    ) AS race,
    (
        SELECT faction_name 
        FROM 
        faction 
        WHERE id = (
            SELECT faction_id 
            FROM race 
            WHERE id = (
                SELECT race_id 
                FROM class 
                WHERE class_id = cw.id_class
            )
        )
    ) AS character_faction
FROM character_wow cw;

END //
DELIMITER ;


DROP PROCEDURE IF EXISTS character_lvl_highest;
DELIMITER //
CREATE PROCEDURE character_lvl_highest()
BEGIN
    SELECT ch.name_character_wow, ch.level
    FROM character_wow ch
    WHERE level = (
        SELECT MAX(level)
        FROM character_wow
    );
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS character_more_objects;
DELIMITER //
CREATE PROCEDURE character_more_objects()
BEGIN
    SELECT *
    FROM character_wow
    WHERE id_character_wow = (
        SELECT c.id_character_wow
        FROM character_wow c
        JOIN inventory i ON c.id_character_wow = i.id_character_wow
        JOIN object o ON i.id_object = o.id_object
        WHERE o.category = 'epic'
        GROUP BY c.id_character_wow
        ORDER BY COUNT(o.id_object) DESC
        LIMIT 1
    );
END //
DELIMITER ;
CALL character_more_objects();

DROP PROCEDURE IF EXISTS character_by_account;
DELIMITER //
CREATE PROCEDURE character_by_account(IN account_name VARCHAR(20))
BEGIN
    SELECT ch.name_character_wow
    FROM character_wow ch
    WHERE ch.user_name = (
        SELECT user_name
        FROM account
        WHERE user_name = account_name
    );
END //
DELIMITER ;
CALL character_by_account('admin_user');


-- character_wow_________________________________________________

-- _______________________________________________________account

DROP PROCEDURE IF EXISTS average_race_currency;
DELIMITER //
CREATE PROCEDURE average_race_currency()
BEGIN
    SELECT race, (
    SELECT AVG(wow_currency)
    FROM account a
    JOIN character_wow c ON a.user_name = c.user_name
    JOIN class cl ON c.id_class = cl.class_id
    WHERE cl.race_id = r.id
    ) AS promedio_monedas
    FROM race r;
END //
DELIMITER ;
CALL average_race_currency();



DROP PROCEDURE IF EXISTS accont_more_currenyc;
DELIMITER //
CREATE PROCEDURE accont_more_currenyc()
BEGIN
    SELECT *
    FROM account
    WHERE wow_currency = (
        SELECT MAX(wow_currency)
        FROM account
    );
END //
DELIMITER ;
CALL accont_more_currenyc();



DROP PROCEDURE IF EXISTS account_by_token;
DELIMITER //
CREATE PROCEDURE account_by_token(IN token VARCHAR(30))
BEGIN
    SELECT *
    FROM account
    WHERE token_account = token;    
END //
DELIMITER ;
CALL account_by_token('token123');



DROP PROCEDURE IF EXISTS account_by_currency;
DELIMITER //
CREATE PROCEDURE account_by_currency(IN number double(8,2))
BEGIN
    SELECT user_name, wow_currency
    FROM account
    WHERE wow_currency > number;
END //
DELIMITER ;
CALL account_by_currency();



DROP PROCEDURE IF EXISTS account_number_charact;
DELIMITER //
CREATE PROCEDURE account_number_charact()
BEGIN
    SELECT a.user_name, (
    SELECT COUNT(c.id_character_wow)
    FROM character_wow c
    WHERE c.user_name = a.user_name
    ) AS total_characters
    FROM account a;
END //
DELIMITER ;
CALL account_number_charact();


-- account_______________________________________________________

-- __________________________________________________user_account

DROP PROCEDURE IF EXISTS user_account_value_wow_currency;
DELIMITER //
CREATE PROCEDURE user_account_value_wow_currency()
BEGIN
    SELECT 
    (
        SELECT email 
        FROM user_account 
        WHERE user_account.email = account.email
    ) AS email,
    (
        SELECT password_user 
        FROM user_account 
        WHERE user_account.email = account.email
    ) AS password_user,
    wow_currency
    FROM account;
END //
DELIMITER ;
CALL user_account_value_wow_currency();



DROP PROCEDURE IF EXISTS account_number_charact;
DELIMITER //
CREATE PROCEDURE account_number_charact()
BEGIN

END //
DELIMITER ;
CALL account_number_charact();



DROP PROCEDURE IF EXISTS account_number_charact;
DELIMITER //
CREATE PROCEDURE account_number_charact()
BEGIN

END //
DELIMITER ;
CALL account_number_charact();



DROP PROCEDURE IF EXISTS account_number_charact;
DELIMITER //
CREATE PROCEDURE account_number_charact()
BEGIN

END //
DELIMITER ;
CALL account_number_charact();



DROP PROCEDURE IF EXISTS account_number_charact;
DELIMITER //
CREATE PROCEDURE account_number_charact()
BEGIN

END //
DELIMITER ;
CALL account_number_charact();

-- user_account__________________________________________________