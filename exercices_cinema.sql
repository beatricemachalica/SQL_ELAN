-- Vous rédigerez les requêtes SQL suivantes :

-- a. Liste des films (titre + réalisateur + durée + horaires) diffusés dans la salle 3
SELECT * FROM film
INNER JOIN seance ON film.id_film = seance.id_film
WHERE seance.id_salle = 3

-- b. Liste des séances (créneaux horaires) pour la journée d’aujourd’hui pour un film en particulier
SELECT * FROM seance s, film f
WHERE s.horaire LIKE '2021-04-21%'
AND s.id_film = f.id_film
AND f.titre = 'le roi lion'

-- c. Liste des films (mêmes champs que la question a) sans les horaires) qui durent plus de 2h
SELECT f.id_film, f.titre, f.dateSortie, f.duree FROM film f
WHERE f.duree > 120

-- d. Combien de films sont programmés par salle à partir d’aujourd’hui ?
SELECT COUNT(s.id_film), salle.id_salle AS numSalle  FROM seance s
INNER JOIN film ON film.id_film = s.id_film
INNER JOIN salle ON salle.id_salle = s.id_salle
WHERE s.horaire > '2021-04-21'
GROUP BY numSalle

-- e. Donner la programmation du cinéma pour la période du 18/09/2019 au 24/09/2019
SELECT * FROM seance s
WHERE s.horaire BETWEEN '2019-09-18'AND '2019-09-24'

-- f. Insérer le réalisateur Todd PHILIPS
INSERT INTO realisateur (nom, prenom) VALUES ('PHILIPS', 'Todd')

-- g. Insérer le film « The Joker » (122 min – Réalisateur : Todd PHILIPS) et programmer ce 
-- film le 09/10/2019 à 20h en salle 1 (le tarif de cette séance est fixé à 12€). Le film est 
-- diffusé en VOSTF et ce n’est pas une avant-première.
