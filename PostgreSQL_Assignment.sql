CREATE TABLE rangers (
    ranger_id SERIAL UNIQUE PRIMARY KEY,
    name TEXT,
    region TEXT
);

INSERT INTO rangers (name, region) VALUES 
    ('Alice Green', 'Northern Hills'),
    ('Bob White', 'River Delta'),
    ('Carol King', 'Mountain Range');