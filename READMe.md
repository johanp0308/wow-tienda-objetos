# Tienda de objetos (World of Warcraft)


Se busca desarrollar un sistema integral para la gestión de la venta de objetos en el contexto de World of Warcraft. Los usuarios tienen la posibilidad de poseer múltiples cuentas, cada una de las cuales puede crear hasta un máximo de 10 personajes. Es importante destacar que los objetos adquiridos están vinculados exclusivamente a la cuenta del usuario.

La implementación de este sistema implica un control detallado de las cuentas y los personajes, con el objetivo de restringir el uso o la cantidad máxima permitida de un objeto específico. Esta medida garantiza un manejo eficiente y equitativo de los recursos virtuales, promoviendo un entorno de juego balanceado.

Adicionalmente, los objetos poseen un nivel asociado que determina su utilización, estando condicionado por el nivel del personaje correspondiente. Esta característica añade una capa de complejidad estratégica al juego, ya que los jugadores deben considerar no solo la adquisición de objetos, sino también su nivel de habilidad para aprovechar al máximo su potencial en el campo de batalla.

En resumen, la implementación de este sistema no solo busca facilitar la transacción de objetos en el universo de World of Warcraft, sino que también procura establecer medidas de control y equilibrio para asegurar una experiencia de juego justa y enriquecedora para todos los usuarios.


![](./img/modelo_conceptual.png)


## Modelo Logico

1. faction
- id (INT PK)
- faction (VARCHAR(20) UNIQUE)

2. race
- id (INT PK)
- race (VARCHAR(30) UNIQUE)

3. class
- class_id (INT PK)
- race_id (INT FK)
- class (VARCHAR(30) UNIQUE)

4. user_account
- email (VARCHAR(50) PK)
- password (VARCHAR(50))

5. account
- user_name (VARCHAR(20) PK)
- password_account (VARCHAR(30))
- email (VARCHAR(50) FK)
- wow_currency (double)
- token_account (VARCHAR(30))

6. type_object
- id (INT PK)
- type (VARCHAR(30))

7. object
- id_object (VARCHAR(50) PK)
- name_object (VARCHAR(50) UNIQUE)
- type_object (ENUM('BlizzObject','at a distance','Trinket','bag','head','shirt','waist','neck','finger','two hands','shield','back','shoudler','right hand','left hand','hands','dolls','feet','tabard','torso','a hand','consumable'))
- leve_object (INT)
- category (ENUM('poor','common','rare','queer','epic','legendary','artifact'))

8. inventory
- id_inventory(INT PK)
- id_character_wow (INT FK)
- id_object (VARCHAR(50) FK)
- amount (INT)

9. statistics
- id_statistics (INT PK)
- statistics_type (VARCHAR(20) UNIQUE)

10. stats_object
- id_stats_object (INT PK)
- id_object (VARCHAR(50) FK)
- id_stats (INT FK)
- value (double)

11. buy
- id_buy (INT PK)
- user_name (VARCHAR(20) FK)
- id_object (VARCHAR(50) FK)
- token_account (VARCHAR(50) FK)

12. character_wow
- id_character_wow (INT PK)
- user_name (VARCHAR(30))
- id_class (INT FK)
- level (INT)
- name_character_wow (VARCHAR(20) UNIQUE)

13.  locker
- id_locker (INT PK)
- id_account (VARCHAR(30))

14.  locker_object
- id_locker (INT FK)
- id_object (INT FK)

15.  catalogue
- id_producto (INT PK)
- value_wc (DOUBLE)
- id_object (VARCHAR(50) FK)


## Queries

1. Table: `object`
   CRUD:
   CREATE and UPDATE
   - **Procedimiento:** `create_object`
   ```sql
   -- CREATE, UPDATE
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
      DECLARE var_id_object VARCHAR(50);
      SET @object_var = CONCAT('',$id_object,'');

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
   END //
   DELIMITER ;
   ```

   DELETE
     - **Procedimiento:** `delete_object_cascade`
     - **Parametros:** `IN i_id_object VARCHAR(50)`
     ```sql
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
     ```

   SELECT
      ```sql
      SELECT * FROM object;
      ```
   1. Consigue todos los objetos de una clase.
   - **Procedimiento:**  `getAll_object_by_class`
   - **Parametros:** `class`
   example:
   ```sql
    SELECT *
    FROM object o
    WHERE o.id_class = (
      SELECT cclass_id 
      FROM class c
      WHERE c.class like 'Shaman'
   );
   ```
   2. Obtener categoría y tipos que no tienen objetos.
   - **Procedimiento:**  `getAll_category_and_type`
   ```sql
   SELECT o.category, GROUP_CONCAT(DISTINCT o.type_object)
   FROM object o
   WHERE o.category IN (SELECT category FROM object)
   AND o.type_object IN (SELECT type_object FROM object)
   GROUP BY o.category;
   ```
   3. Consigue todos los objetos y ordénalos por nivel.
   - **Procedimiento:**  `getAll_object_order_by_level`
   ```sql
   SELECT o.*
   FROM object o
   ORDER BY o.level_object; 
   ```
   4. Obtener las categorias de los objetos que han sido comprados
   - **Procedimiento:**  ``
   ```sql
    SELECT o.category, COUNT(*) as count
    FROM object o
    WHERE o.id_object = ANY(SELECT b.id_object FROM buy b)
    GROUP BY o.category;
   ```
   5. Obténer id de los objetos con ssu clase, raza y facción.
   - **Procedimiento:**  `getAll_object_class_race_faction`
   ```sql
    SELECT o.id_object, o.name_object, c.class, r.race, f.faction_name 
    FROM object o,class c, race r, faction f
    WHERE o.id_class = c.class_id
    AND c.race_id = r.id
    AND r.faction_id = f.id;
   ```

2. Table: `faction`

   CRUD:
   CREATE - UPDATE
   - **Procedimiento:** `create_faction`
   - **Parametro:** `IN in_id INT,IN in_faction_name VARCHAR(20)`
      ```sql
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
      ```
   DELETE
   - **Procedimiento:** `delete_faction`
   - **Parametros:** `IN in_id_faction INT`
         ```sql
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
      ```
   SELECT
      ```sql
      SELECT * FROM faction
      ```
   1. Cantidad de personajes de la faccion Horda que tienen un nivel superior a 60.
   - **Procedimiento:**  `character_factio_horde_lvl_greater_60`
   ```sql
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
   ```
   2. Nombre de la facción con el mayor numero de objetos disponibles en el catálogo
   - **Procedimiento:**  `faction_max_object_catalogue`
   ```sql
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
   ```
   3. Media del nivel de los personajes de la facción Alianza que tienen un objeto de tipo BlizzObject
   - **Procedimiento:**  `avarage_lvl_alliance_with_object_blizz`
   ```sql
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
   ```
   4. Nombre de la faccion con el menor numero de objetos de categoria rare.
   - **Procedimiento:**  `faction_greate_object_rare`
   ```sql
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
   ```
   5. Encuentra la facción con más personajes que hayan comprado objetos de la categoria `epic` o `legendary`  
   - **Procedimiento:**  ``
   ```sql
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
   ```
3. Table: `buy`
   
   CRUD:

   CREATE:
   - **Procedimiento:** ``
   ```sql
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
   ```
   UPDATE:
   - **Procedimiento:** ``
   ```sql
   UPDATE buy b
   SET 
      b.user_name = 'userName',
      b.id_object = 'qdwqwd54',
      b.token_account = 'asdqw'
   WHERE b.id_buy = 1;
   ```
****
   DELETE:
   ```sql
   DELETE FROM buy b WHERE b.id_buy = 1;
   ```

   SELECT:
   ```sql
   SELECT * FROM buy;
   ```
   1. La compra de un objeto mas cara.
   - **Procedimiento:**  `object_buy_more_expnesive`
   ```sql
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
   ```

   2. Todas las compras de un Usuario.(Se usa el token de la compra)
   - **Procedimiento:**  `buys_of_user_by_token`
   - **Parametro:** `IN token_user VARCHAR(30)`
   ```sql
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
   ```
   3. Compras de un determinado objeto por su identificador.
   - **Procedimiento:**  `buys_by_object_id`
   - **Parametro:** `IN object_id VARCHAR(50)`
   ```sql
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
   ```

   4. Compras de objetos por tipo
   - **Procedimiento:**  `buys_by_type_object`
   - **Parametro:** `IN object_type VARCHAR(20)`
   ```sql
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
   ```
   5. El Objeto mas Comprado
   - **Procedimiento:**  ``
   ```sql
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
   ```
4. Table: `stats_object`
   
   CREATE:
   ```sql
   INSERT INTO stats_object(id_stats_object,id_object,id_stats,value) VALUES(1,'elixir013',11,500);
   ```

   UPDATE:
   ```sql
   UPDATE stats_object
   SET
      id_object = 'acr23',
      id_stats = 1,
      value = 52.01
   WHERE id_stats_object = 1;

   ```
   DELETE:
   ```sql
   DELETE FROM stats_object WHERE id_stats_object = 1;
   ```
   CRUD:
   ```sql
   ```
   1. Objeto con el mejor promedio de estadisticas.
   - **Procedimiento:**  `better_average_statis_object`
   ```sql
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
   ```
   2. Id del Objetp con estadistica fueza mas alta.
   - **Procedimiento:**  `objec_statistics_heigth_armor`
   ```sql
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
   ```
   3. Objeto con mas estadisticas.
   - **Procedimiento:**  ``
   ```sql
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
   ```

   4. Estadistica promedio de todos los objetos
   - **Procedimiento:**  ``
   ```sql
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
   ```
   5. a
   - **Procedimiento:**  ``
   ```sql
   ```
5. Table: `inventory`
   CRUD:
   ```sql
   ```
   1. query 1
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 2
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 3
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 4
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 5
   - **Procedimiento:**  ``
   ```sql
   ```
6. Table: `statistics`
   CRUD:
   ```sql
   ```
   1. query 1
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 2
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 3
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 4
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 5
   - **Procedimiento:**  ``
   ```sql
   ```
7. Table: `character_wow`
   CRUD:
   ```sql
   ```
   1. query 1
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 2
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 3
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 4
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 5
   - **Procedimiento:**  ``
   ```sql
   ```
8. Table: `account`
   CRUD:
   ```sql
   ```
   1. query 1
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 2
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 3
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 4
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 5
   - **Procedimiento:**  ``
   ```sql
   ```
9.  Table: `user_account`
   CRUD:
   ```sql
   ```
   1. query 1
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 2
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 3
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 4
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 5
   - **Procedimiento:**  ``
   ```sql
   ```
10. Table: `locker_object`
   CRUD:
   ```sql
   ```
   1. query 1
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 2
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 3
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 4
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 5
   - **Procedimiento:**  ``
   ```sql
   ```
11. Table: `catalogue`
   CRUD:
   ```sql
   ```
   1. query 1
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 2
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 3
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 4
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 5
   - **Procedimiento:**  ``
   ```sql
   ```
12. Table: `locker`
   CRUD:
   ```sql
   ```
   1. query 1
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 2
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 3
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 4
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 5
   - **Procedimiento:**  ``
   ```sql
   ```
13. Table: `race`
   CRUD:
   ```sql
   ```
   1. query 1
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 2
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 3
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 4
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 5
   - **Procedimiento:**  ``
   ```sql
   ```
14. Table: `class`
   CRUD:
   ```sql
   ```
   1. query 1
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 2
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 3
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 4
   - **Procedimiento:**  ``
   ```sql
   ```
   1. query 5
   - **Procedimiento:**  ``
   ```sql
   ```
