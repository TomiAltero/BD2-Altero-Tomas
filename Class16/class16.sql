--Altero Tomas - Class 16

-- 1: Inserción con manejo de valor NULL en una columna con restricción NOT NULL
BEGIN
    DECLARE exit handler for SQLEXCEPTION
    BEGIN
        -- Manejar el error aquí si es necesario
    END;
    
    INSERT INTO employees (firstName, lastName, email)
    SELECT 'Facu', 'Bisio', NULL
    WHERE NOT EXISTS (SELECT 1 FROM employees WHERE email IS NULL);
END;
/* Este bloque intentará insertar una fila, pero evitará la inserción y manejará el error si el valor de email es NULL. */

-- 2: Evitar duplicados al actualizar claves primarias
UPDATE employees SET employeeNumber = employeeNumber - 20
WHERE employeeNumber NOT IN (SELECT employeeNumber FROM employees WHERE employeeNumber - 20 = employeeNumber);
/* Este enfoque previene la creación de duplicados al verificar si restar 20 crearía un conflicto antes de realizar la actualización. */

-- 3: Añadir una columna con restricción CHECK
ALTER TABLE employees ADD age INT;
ALTER TABLE employees ADD CONSTRAINT chk_age CHECK (age BETWEEN 16 AND 70);
/* La restricción CHECK se agrega después de añadir la columna, de forma más explícita. */

-- 4: Explicación de la tabla de relación muchos a muchos
/* La relación entre 'films' y 'film_actor' se gestiona con una tabla intermedia debido a la naturaleza muchos a muchos.
   Una película puede tener múltiples actores y un actor puede participar en múltiples películas.
   Utilizar una tabla intermedia como 'film_actor' permite gestionar esta relación de manera eficiente,
   evitando prácticas como concatenación de valores o uso de campos NULL. */

-- 5: Crear columnas y triggers para actualización automática de metadatos
ALTER TABLE employees ADD COLUMN lastUpdate DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE employees ADD COLUMN lastUpdateUser VARCHAR(100) DEFAULT USER();

CREATE TRIGGER before_employee_update
    BEFORE UPDATE ON employees
    FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = USER();
END;

CREATE TRIGGER before_employee_insert
    BEFORE INSERT ON employees
    FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = USER();
END;
/* Estas definiciones aseguran que las columnas lastUpdate y lastUpdateUser se actualicen automáticamente antes de cada operación de inserción o actualización. */

-- 6: Mostrar los triggers definidos
SHOW TRIGGERS;

/* Triggers adicionales en otras tablas como ejemplos de lógica aplicada a inserciones, eliminaciones y actualizaciones:

CREATE TRIGGER set_create_date_before_insert
    BEFORE INSERT ON customer
    FOR EACH ROW
BEGIN
    SET NEW.create_date = NOW();
END;

CREATE TRIGGER delete_film_after_delete
    AFTER DELETE ON film
    FOR EACH ROW
BEGIN
    DELETE FROM film_text WHERE film_id = OLD.film_id;
END;

CREATE TRIGGER insert_film_text_after_insert
    AFTER INSERT ON film
    FOR EACH ROW
BEGIN
    INSERT INTO film_text (film_id, title, description)
    VALUES (NEW.film_id, NEW.title, NEW.description);
END;

CREATE TRIGGER update_film_text_after_update
    AFTER UPDATE ON film
    FOR EACH ROW
BEGIN
    IF OLD.title != NEW.title OR OLD.description != NEW.description OR OLD.film_id != NEW.film_id THEN
        UPDATE film_text
        SET title = NEW.title, description = NEW.description, film_id = NEW.film_id
        WHERE film_id = OLD.film_id;
    END IF;
END;

CREATE TRIGGER set_payment_date_before_insert
    BEFORE INSERT ON payment
    FOR EACH ROW
BEGIN
    SET NEW.payment_date = NOW();
END;
*/
