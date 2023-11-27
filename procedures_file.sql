use wowShop;

-- OBJECT _________________________________________________

-- CREATE and UPDATE
SELECT * FROM class;
DROP PROCEDURE IF EXISTS create_object;
DELIMITER //
CREATE PROCEDURE create_object(
   in $id_object VARCHAR(50),
   in $name_object VARCHAR(50),
   in $type_object ENUM('BlizzObject','at a distance','Trinket','bag','head','shirt','waist','neck','finger','two hands','shield','back','shoudler','right hand','left hand','hands','dolls','feet','tabard','torso','a hand','consumable'),
   in $level_object INT,
   in $category enum('poor','common','rare','queer','epic','legendary','artifact'),
   in $id_class INT
)
BEGIN
   IF $id_object IS NULL
   THEN
      INSERT INTO object
      (id_object,name_object,type_object,level_object,category,id_class)
      VALUES ($id_object,$name_object,$type_object,$,'epic',1);
   ELSE THEN

END //
DELIMITER ;
CALL create_object('chestr1002','Wall of the fallen','torso',80,'epic',1);


DROP PROCEDURE IF EXISTS PROCEDURE getAll_object_by_class;
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
CALL getAll_object_by_class('Shaman');

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
CALL getAll_category_and_type();


DROP PROCEDURE IF EXISTS getAll_object_order_by_level;
DELIMITER //
CREATE PROCEDURE getAll_object_order_by_level()
BEGIN
   SELECT o.*
   FROM object o
   ORDER BY o.level_object;
END //
DELIMITER ;
CALL getAll_object_order_by_level();


DROP PROCEDURE IF EXISTS getAll_object_order_by_level;
DELIMITER //
CREATE PROCEDURE getAll_object_order_by_level()
BEGIN
   SELECT o.*
   FROM object o
   ORDER BY o.level_object;
END //
DELIMITER ;
CALL getAll_object_order_by_level();

DESCRIBE object;

-- ________________________________________________________OBJECT
