DROP DATABASE IF EXISTS imdb;
CREATE DATABASE IF NOT EXISTS imdb;
USE imdb;
DROP TABLE IF EXISTS film;
DROP TABLE IF EXISTS actor;
DROP TABLE IF EXISTS film_actor;

CREATE TABLE IF NOT EXISTS film (
    film_id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(255),
    description TEXT,
    release_year INT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT film_id_pk PRIMARY KEY (film_id)
);


CREATE TABLE IF NOT EXISTS actor (
    actor_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT actor_id_pk PRIMARY KEY (actor_id)
);


CREATE TABLE film_actor (
    actor_id INT NOT NULL,
    film_id INT NOT NULL,

    CONSTRAINT film_actor_pk PRIMARY KEY (actor_id, film_id), 
    CONSTRAINT film_actor_actor_fk FOREIGN KEY (actor_id) REFERENCES actor (actor_id),
    CONSTRAINT film_actor_film_fk FOREIGN KEY (film_id) REFERENCES film (film_id)
);


INSERT INTO actor (first_name, last_name)
VALUES ('Ricardo', 'Darín'), ('Julieta', 'Díaz'), ('Ricardo', 'Luna');

INSERT INTO film (title, description, release_year)
VALUES ('El secreto de sus ojos', 'Un thriller dramático dirigido por Juan José Campanella', 2009),
       ('El ciudadano ilustre', 'Un filme argentino dirigido por Gastón Duprat y Mariano Cohn', 2016),
       ('Nueve Reinas', 'Un thriller policial argentino dirigido por Fabián Bielinsky', 2000);

INSERT INTO film_actor (actor_id, film_id)
VALUES (1, 1), (2, 1), (3, 2), (1, 3);
