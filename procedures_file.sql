
-- OBJECT _________________________________________________

-- CREATE and UPDATE
SELECT * FROM class;
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
-- _______________________________________________________FACTION

-- BUY___________________________________________________________
-- CRUD_______
-- CREATE UPDATE
DROP PROCEDURE IF EXISTS create_buy;
DELIMITER //
CREATE PROCEDURE create_buy(
    IN id_buy INT
    IN in_id_object VARCHAR(50),
    IN token_account,
    IN in_name_account
)
BEGIN
    DECLARE $object_id VARCHAR(50);
    DECLARE $msg_error VARCHAR(40);
    DECLARE $value_object DOUBLE(8,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Error when inserting purchase information.';
    END;

    SELECT c.id_object , c.value_wc INTO $object_id, $value_object
    FROM catalogue c
    WHERE c.id_object = in_id_object;

    IF $object IS NOT NULL
    THEN
        INSERT INTO buy(user_name,id_object,token_accoun)
        VALUES ()
    END IF;

    COMMIT;
END //
DELIMITER ;

describe catalogue;
-- _______CRUD


-- ___________________________________________________________BUY