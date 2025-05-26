-- Table creation and Sample data insertion

CREATE TABLE rangers (
    ranger_id SERIAL UNIQUE PRIMARY KEY,
    name TEXT,
    region TEXT
);

INSERT INTO rangers (name, region) VALUES 
    ('Alice Green', 'Northern Hills'),
    ('Bob White', 'River Delta'),
    ('Carol King', 'Mountain Range');

CREATE TABLE species (
    species_id SERIAL UNIQUE PRIMARY KEY,
    common_name TEXT,
    scientific_name TEXT,
    discovery_date TIMESTAMP,
    conservation_status TEXT
);

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
    ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
    ('Bengal Tiger', 'Panthera tigris', '1758-01-01', 'Endangered'),
    ('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
    ('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

CREATE TABLE sightings (
    sighting_id SERIAL UNIQUE PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    species_id INTEGER REFERENCES species(species_id),
    sighting_time TIMESTAMP without time zone,
    location TEXT,
    notes TEXT
);

INSERT INTO sightings (ranger_id, species_id, sighting_time, location, notes) VALUES
    (1, 1, '2024-05-10 07:45:00', 'Peak Ridge', 'Camera trap image captured'),
    (2, 2, '2024-05-12 16:20:00', 'Bankwood Area', 'Juvenile seen'),
    (3, 3, '2024-05-15 09:10:00', 'Bamboo Grove East', 'Feeding observed'),
    (2, 1, '2024-05-18 18:30:00', 'Snowfall Pass', NULL);


-- Problem 1
INSERT INTO rangers (name, region) VALUES ('Derek Fox', 'Coastal Plains');


-- Problem 2
SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings;


-- Problem 3
SELECT * FROM sightings
    WHERE location LIKE '%Pass%';


-- Problem 4
SELECT name, total_sightings FROM rangers
    JOIN (SELECT ranger_id, COUNT(*) AS total_sightings FROM sightings GROUP BY ranger_id) AS counts_by_id
    ON rangers.ranger_id = counts_by_id.ranger_id;


-- Problem 5
SELECT common_name AS never_been_sighted FROM species
    FULL JOIN sightings
    ON species.species_id = sightings.species_id
WHERE sighting_time IS NULL;


-- Problem 6
SELECT common_name, sighting_time, name FROM
    (
        SELECT * FROM sightings
            JOIN species ON sightings.species_id = species.species_id
            JOIN rangers ON sightings.ranger_id = rangers.ranger_id
    )
ORDER BY sighting_time DESC LIMIT 2;


-- Problem 7
UPDATE species
    SET conservation_status = 'Historic'
    WHERE EXTRACT(YEAR FROM discovery_date) < 1800;


-- Problem 8
CREATE OR REPLACE FUNCTION period_of_day(date_time TIMESTAMP)
RETURNS TEXT
LANGUAGE PLPGSQL
AS
$$
    BEGIN
        IF date_time::TIME < '12:00:00' THEN RETURN 'Morning';
        ELSIF date_time::TIME BETWEEN '12:00:00' AND '17:00:00' THEN RETURN 'Afternoon';
        ELSE RETURN 'Evening';
        END IF;
    END
$$

SELECT sighting_id, period_of_day(sighting_time) AS time_of_day FROM sightings;


-- Problem 9
DELETE FROM rangers
    WHERE ranger_id NOT IN (
        SELECT DISTINCT ranger_id FROM sightings
    );