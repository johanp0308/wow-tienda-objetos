INSERT INTO user_account (email, password_user) VALUES ('john.doe@example.com', 'securepassword1');
INSERT INTO user_account (email, password_user) VALUES ('jane.smith@example.com', 'myp@ssw0rd');
INSERT INTO user_account (email, password_user) VALUES ('admin@example.com', 'admin123');
INSERT INTO user_account (email, password_user) VALUES ('alice.jones@example.com', 'qwerty789');
INSERT INTO user_account (email, password_user) VALUES ('bob.miller@example.com', 'letmein2022');

INSERT INTO account (user_name, password_account, email, wow_currency, token_account) VALUES ('john_doe', 'securepass123', 'john.doe@example.com', 100.0, 'token123');
INSERT INTO account (user_name, password_account, email, wow_currency, token_account) VALUES ('jane_smith', 'myp@ssw0rd', 'jane.smith@example.com', 150.0, 'token456');
INSERT INTO account (user_name, password_account, email, wow_currency, token_account) VALUES ('admin_user', 'adminpass123', 'admin@example.com', 200.0, 'token789');
INSERT INTO account (user_name, password_account, email, wow_currency, token_account) VALUES ('alice_jones', 'qwerty789', 'alice.jones@example.com', 120.0, 'tokenabc');
INSERT INTO account (user_name, password_account, email, wow_currency, token_account) VALUES ('bob_miller', 'letmein2022', 'bob.miller@example.com', 80.0, 'tokendef');

INSERT INTO locker (id_locker, id_account) VALUES (1, 'john_doe');
INSERT INTO locker (id_locker, id_account) VALUES (2, 'jane_smith');
INSERT INTO locker (id_locker, id_account) VALUES (3, 'admin_user');
INSERT INTO locker (id_locker, id_account) VALUES (4, 'alice_jones');
INSERT INTO locker (id_locker, id_account) VALUES (5, 'bob_miller');

-- Solo existen dos facciones en la World of Warcraft en la expansio que me base
INSERT INTO faction (id, faction_name) VALUES (1, 'horde');
INSERT INTO faction (id, faction_name) VALUES (2, 'alliance');

-- Races Horde
INSERT INTO race (id, race, faction_id) VALUES (1, 'Orc', 1);
INSERT INTO race (id, race, faction_id) VALUES (2, 'Troll', 1);
INSERT INTO race (id, race, faction_id) VALUES (3, 'Tauren', 1);
INSERT INTO race (id, race, faction_id) VALUES (4, 'Undead', 1);
INSERT INTO race (id, race, faction_id) VALUES (5, 'Blood Elf', 1);
INSERT INTO race (id, race, faction_id) VALUES (6, 'Goblin', 1);

-- Races of Alliance
INSERT INTO race (id, race, faction_id) VALUES (7, 'Human', 2);
INSERT INTO race (id, race, faction_id) VALUES (8, 'Dwarf', 2);
INSERT INTO race (id, race, faction_id) VALUES (9, 'Night Elf', 2);
INSERT INTO race (id, race, faction_id) VALUES (10, 'Gnome', 2);
INSERT INTO race (id, race, faction_id) VALUES (11, 'Draenei', 2);
INSERT INTO race (id, race, faction_id) VALUES (12, 'Worgen', 2);

-- Hord Classes
INSERT INTO class (class_id, race_id, class) VALUES (1, 1, 'Warrior'); -- Orc
INSERT INTO class (class_id, race_id, class) VALUES (2, 1, 'Shaman');  -- Orc
INSERT INTO class (class_id, race_id, class) VALUES (3, 2, 'Hunter');  -- Troll
INSERT INTO class (class_id, race_id, class) VALUES (4, 3, 'Druid');   -- Tauren
INSERT INTO class (class_id, race_id, class) VALUES (5, 4, 'Rogue');   -- Undead
INSERT INTO class (class_id, race_id, class) VALUES (6, 5, 'Mage');    -- Blood Elf
INSERT INTO class (class_id, race_id, class) VALUES (7, 6, 'Warlock'); -- Goblin

-- Alliance Classes
INSERT INTO class (class_id, race_id, class) VALUES (8, 7, 'Warrior');   -- Human
INSERT INTO class (class_id, race_id, class) VALUES (9, 7, 'Paladin');  -- Human
INSERT INTO class (class_id, race_id, class) VALUES (10, 8, 'Hunter');  -- Dwarf
INSERT INTO class (class_id, race_id, class) VALUES (11, 9, 'Night Elf'); -- Night Elf
INSERT INTO class (class_id, race_id, class) VALUES (12, 10, 'Rogue');  -- Gnome
INSERT INTO class (class_id, race_id, class) VALUES (13, 11, 'Priest'); -- Draenei
INSERT INTO class (class_id, race_id, class) VALUES (14, 12, 'Warrior'); -- Worgen

-- Main Statistics
INSERT INTO statistics (id_statistics, statistics_type) VALUES (1, 'Health');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (2, 'Attack Power');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (3, 'Spell Power');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (4, 'Armor');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (5, 'Critical Strike');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (6, 'Haste');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (7, 'Versatility');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (8, 'Mastery');

-- Secondary Statistics
INSERT INTO statistics (id_statistics, statistics_type) VALUES (9, 'Stamina');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (10, 'Agility');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (11, 'Intellect');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (12, 'Strength');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (13, 'Spirit');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (14, 'Dodge');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (15, 'Parry');
INSERT INTO statistics (id_statistics, statistics_type) VALUES (16, 'Block');


-- Personajes para la cuenta 'john_doe'
INSERT INTO character_wow (id_character_wow, user_name, id_class, level, name_character_wow) VALUES (1, 'john_doe', 1, 60, 'Thrall'); -- Guerrero Orc
INSERT INTO character_wow (id_character_wow, user_name, id_class, level, name_character_wow) VALUES (2, 'john_doe', 6, 55, 'Zapshot'); -- Brujo Goblin

-- Characters for the account 'jane_smith'
INSERT INTO character_wow (id_character_wow, user_name, id_class, level, name_character_wow) VALUES (3, 'jane_smith', 8, 70, 'Aegon'); -- Guerrero Humano
INSERT INTO character_wow (id_character_wow, user_name, id_class, level, name_character_wow) VALUES (4, 'jane_smith', 13, 63, 'Elara'); -- Sacerdotisa Draenei


-- Personajes para la cuenta 'admin_user'
INSERT INTO character_wow (id_character_wow, user_name, id_class, level, name_character_wow) VALUES (5, 'admin_user', 14, 80, 'Arthas'); -- Guerrero Worgen
INSERT INTO character_wow (id_character_wow, user_name, id_class, level, name_character_wow) VALUES (6, 'admin_user', 11, 75, 'Gimli'); -- Pícaro Enano

-- Characters for the account  'alice_jones'
INSERT INTO character_wow (id_character_wow, user_name, id_class, level, name_character_wow) VALUES (7, 'alice_jones', 4, 90, 'Baine'); -- Druida Tauren
INSERT INTO character_wow (id_character_wow, user_name, id_class, level, name_character_wow) VALUES (8, 'alice_jones', 10, 85, 'Elenor'); -- Mago Gnome

-- Characters for the account  'bob_miller'
INSERT INTO character_wow (id_character_wow, user_name, id_class, level, name_character_wow) VALUES (9, 'bob_miller', 7, 110, 'Sylvanas'); -- Brujo Elfo Nocturno
INSERT INTO character_wow (id_character_wow, user_name, id_class, level, name_character_wow) VALUES (10, 'bob_miller', 3, 105, 'Varian'); -- Cazador Trol




-- Objects

-- Consumible
INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('healthpotion011', 'Health Potion', 'consumable', 5, 'common', NULL);

INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('teleportscroll012', 'Teleport Scroll', 'consumable', 15, 'uncommon', NULL);

INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('elixir013', 'Elixir of Wisdom', 'consumable', 10, 'common', NULL);

INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('invisibilitypotion014', 'Invisibility Potion', 'consumable', 20, 'rare', NULL);

INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('energyfood015', 'Energetic Food', 'consumable', 8, 'common', NULL);

-- BlizzObject

-- Espada de Élite (Guerrero)
INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('eliteblade016', 'Elite Blade', 'BlizzObject', 40, 'rare', 1);

-- Orbe Arcano (Mago)
INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('arcaneorb017', 'Arcane Orb', 'BlizzObject', 35, 'uncommon', 6);

-- Arco Maestro (Cazador)
INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('masterbow018', 'Master Bow', 'BlizzObject', 45, 'epic', 3);

-- Bolsa Real (Consumible)
INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('royalbag019', 'Royal Bag', 'BlizzObject', 25, 'legendary', NULL);

-- Bastón de la Naturaleza (Druida)
INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('naturestaff020', 'Nature Staff', 'BlizzObject', 50, 'artifact', 4);


-- Armor

-- Yelmo de la Victoria (Cabeza)
INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('helm021', 'Victory Helm', 'head', 35, 'rare', 1);

-- Hombreras Élficas (Hombros)
INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('elfshoulders022', 'Elven Shoulders', 'shoulder', 40, 'epic', NULL);

-- Peto de Platino (Pecho)
INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('platinumchestplate023', 'Platinum Chestplate', 'torso', 45, 'legendary', 2);

-- Capa de las Sombras (Espalda)
INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('shadowcape024', 'Shadow Cape', 'back', 30, 'common', NULL);

-- Guantes de la Destreza (Manos)
INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('dexgloves025', 'Dexterity Gloves', 'hands', 38, 'rare', 3);

-- Botas del Caminante (Pies)
INSERT INTO object (id_object, name_object, type_object, level_object, category, id_class)
VALUES ('walkerboots026', 'Walker Boots', 'feet', 42, 'epic', NULL);


-- Datos del catálogo para objetos tipo 'BlizzObject' y consumibles
INSERT INTO catalogue (id_producto, value_wc, id_object)
VALUES (1, 29.99, 'eliteblade016'); -- Espada de Élite

INSERT INTO catalogue (id_producto, value_wc, id_object)
VALUES (2, 9.99, 'elixir013'); -- Elixir de Sabiduría

INSERT INTO catalogue (id_producto, value_wc, id_object)
VALUES (3, 3.99, 'energyfood015'); -- Comida Energética

INSERT INTO catalogue (id_producto, value_wc, id_object)
VALUES (4, 5.99, 'healthpotion011'); -- Poción de Salud

INSERT INTO catalogue (id_producto, value_wc, id_object)
VALUES (5, 15.99, 'invisibilitypotion014'); -- Poción de Invisibilidad

INSERT INTO catalogue (id_producto, value_wc, id_object)
VALUES (6, 39.99, 'masterbow018'); -- Arco Maestro

INSERT INTO catalogue (id_producto, value_wc, id_object)
VALUES (7, 59.99, 'naturestaff020'); -- Bastón de la Naturaleza

INSERT INTO catalogue (id_producto, value_wc, id_object)
VALUES (8, 79.99, 'royalbag019'); -- Bolsa Real



