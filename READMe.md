# Item Shop (World of Warcraft)


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
- race (VARCHAR(50) UNIQUE)

3. class
- class_id (INT PK)
- race_id (INT FK)
- faction_id (INT FK)

4. user_account
- email (VARCHAR(50) PK)
- password (VARCHAR(50))

5. account
- user_name (VARCHAR(20) PK)
- password_account (VARCHAR(30))
- email (VARCHAR(50) FK)

6. type_object
- id (INT PK)
- type (VARCHAR(30))

7. object
- id_object (VARCHAR(50) PK)
- name_object (VARCHAR(50) UNIQUE)
- leve_object (INT)
- category (ENUM('pobre','comun','poco comun','raro','epico','legendario','artefacto'))

8. inventory
- id_inventory(INT PK)
- id_character (INT FK)
- id_object (VARCHAR(50) FK)
- amount (INT)

9. statistics
- id_statistics (INT PK)
- statistics_type (VARCHAR(20) UNIQUE)

10. stats_object
- id_stats_object (INT PK)
- id_object (INT FK)
- id_stats (INT FK)
- value (double)

11. stats_character
- id_stat_chara (INT PK)
- id_character (INT FK)
- id_stats (INT FK)
- value (double)

12. buy
- id_buy (VARCHAR(30) PK)
- user_name (VARCHAR(20) FK)
- id_object (VARCHAR(50) FK)