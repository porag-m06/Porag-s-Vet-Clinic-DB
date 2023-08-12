/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;


BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT sp1;
UPDATE animals SET weight_kg = weight_kg * -1;
SELECT * FROM animals;
ROLLBACK TO sp1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
SELECT * FROM animals;
COMMIT;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, AVG(escape_attempts) FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;


--What animals belong to Melody Pond?
SELECT a.name
FROM animals a
JOIN owners o
ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';


--List of all animals that are pokemon (their type is Pokemon).
SELECT a.name
FROM animals a
JOIN species s
ON a.species_id = s.id
WHERE s.name = 'Pokemon';


--List all owners and their animals, remember to include those that don't own any animal.
SELECT o.full_name, a.name
FROM owners o
LEFT JOIN animals a
ON o.id = a.owner_id;


--How many animals are there per species?
SELECT s.name, COUNT(a.id)
FROM species s
LEFT JOIN animals a
ON s.id = a.species_id
GROUP BY s.name;


--List all Digimon owned by Jennifer Orwell.
SELECT a.name
FROM animals a
JOIN species s
ON a.species_id = s.id
JOIN owners o
ON a.owner_id = o.id
WHERE s.name = 'Digimon' AND o.full_name = 'Jennifer Orwell';


--List all animals owned by Dean Winchester that haven't tried to escape.
SELECT a.name
FROM animals a
JOIN owners o
ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;


--Who owns the most animals?
SELECT o.full_name, COUNT(a.id) AS animal_count
FROM owners o
LEFT JOIN animals a
ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY animal_count DESC LIMIT 1;


--------------------------------------------------------------------
--JOIN TABLE QUERIES------------------------------------------------
--------------------------------------------------------------------

--Who was the last animal seen by William Tatcher?
SELECT a.name
FROM visits v
JOIN animals a
ON v.animal_id = a.id
JOIN vets vt
ON v.vet_id = vt.id
WHERE vt.name = 'William Tatcher'
ORDER BY v.date_of_visit DESC
LIMIT 1;


--How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT a.id)
FROM visits v
JOIN animals a
ON v.animal_id = a.id
JOIN vets vt
ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez';

--List all vets and their specialties, including vets with no specialties.
SELECT vt.name, s.name
FROM vets vt
LEFT JOIN specializations sp
ON vt.id = sp.vet_id
LEFT JOIN species s
ON sp.species_id = s.id;


--List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name, v.date_of_visit
FROM visits v
JOIN animals a
ON v.animal_id = a.id
JOIN vets vt
ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez' AND v.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';


--What animal has the most visits to vets?
SELECT a.name, COUNT(v.animal_id) AS visit_count
FROM visits v
JOIN animals a
ON v.animal_id = a.id
GROUP BY a.name
ORDER BY visit_count DESC LIMIT 1;


--Who was Maisy Smith's first visit?
SELECT a.name, MIN(v.date_of_visit)
FROM visits v
JOIN animals a
ON v.animal_id = a.id
JOIN vets vt
ON v.vet_id = vt.id
WHERE vt.name = 'Maisy Smith'
GROUP BY a.name;


--Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name, vt.name, MAX(v.date_of_visit)
FROM visits v
JOIN animals a
ON v.animal_id = a.id
JOIN vets vt
ON v.vet_id = vt.id
GROUP BY a.name, vt.name;


--How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*)
FROM visits v 
LEFT JOIN specializations sp 
ON v.vet_id = sp.vet_id 
JOIN animals a 
ON v.animal_id = a.id 
WHERE sp.species_id IS NULL OR sp.species_id != a.species_id;


--What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT s.name, COUNT(*) AS visit_count 
FROM visits v 
JOIN animals a 
ON v.animal_id = a.id 
JOIN species s 
ON a.species_id = s.id 
JOIN vets vt 
ON v.vet_id = vt.id 
WHERE vt.name = 'Maisy Smith' 
GROUP BY s.name 
ORDER BY visit_count DESC LIMIT 1;