/* Database schema to keep the structure of entire database. */
CREATE DATABASE vet_clinic;

USE vet_clinic;

CREATE TABLE animals(
    id INT PRIMARY KEY,
    name VARCHAR(255),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL(5,2)
);

ALTER TABLE animals ADD COLUMN species VARCHAR(255);

CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(255),
  age INT
);

CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

ALTER TABLE animals
  DROP COLUMN species,
  ADD COLUMN species_id INT,
  ADD COLUMN owner_id INT;

ALTER TABLE animals
  ADD CONSTRAINT fk_species_id FOREIGN KEY (species_id) REFERENCES species (id),
  ADD CONSTRAINT fk_owner_id FOREIGN KEY (owner_id) REFERENCES owners (id);

CREATE SEQUENCE animals_id_seq;
ALTER TABLE animals ALTER COLUMN id SET DEFAULT nextval('animals_id_seq');

CREATE TABLE vets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    age INT,
    date_of_graduation DATE
);

CREATE TABLE specializations (
    species_id INT,
    vet_id INT,
    FOREIGN KEY (species_id) REFERENCES species(id),
    FOREIGN KEY (vet_id) REFERENCES vets(id)
);

CREATE TABLE visits (
    animal_id INT,
    vet_id INT,
    date_of_visit DATE,
    FOREIGN KEY (animal_id) REFERENCES animals(id),
    FOREIGN KEY (vet_id) REFERENCES vets(id)
);