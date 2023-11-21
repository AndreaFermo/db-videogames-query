--SELECT

--1- Selezionare tutte le software house americane

SELECT *
FROM `software_houses`
WHERE `country` = 'United States';

--2- Selezionare tutti i giocatori della città di 'Rogahnland';

SELECT *
FROM `players`
WHERE `city` = 'Rogahnland';

--3- Selezionare tutti i giocatori il cui nome finisce per "a" (220)

SELECT *
FROM `players`
WHERE `name` LIKE '%a';


--4- Selezionare tutte le recensioni scritte dal giocatore con id = 800 (11)

SELECT *
FROM `reviews`
WHERE `player_id` = '800';

--5- Contare quanti tornei ci sono stati nell'anno 2015 (9)

SELECT COUNT(*) AS numero_di_tornei
FROM `tournaments`
WHERE `year` = 2015;

--6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)

SELECT *
FROM `awards`
WHERE `description` LIKE '%facere%';

--7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'id) (287)

SELECT DISTINCT `videogames`.`id`
FROM `videogames`
JOIN `category_videogame` ON `videogames`.`id` = `category_videogame`.`videogame_id`
WHERE `category_videogame`.`category_id` IN (2, 6);

--8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)

SELECT *
FROM `reviews`
WHERE `rating` BETWEEN 2 AND 4;

--9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)

SELECT *
FROM `videogames`
WHERE YEAR(`release_date`) = 2020;

--10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)

SELECT DISTINCT `videogame_id`
FROM `reviews`
WHERE `rating` = 5;

--*********** BONUS ***********

--11- Selezionare il numero e la media delle recensioni per il videogioco con id = 412 (review number = 12, avg_rating = 3.16 circa)

SELECT
    COUNT(*) AS `numero_di_recensioni`,
    AVG(`rating`) AS `media_dei_voti`
FROM
    `reviews`
WHERE
    `videogame_id` = 412;

--12- Selezionare il numero di videogame che la software house con id = 1 ha rilasciato nel 2018 (13)

SELECT COUNT(*) AS numero_di_videogiochi
FROM `videogames`
WHERE YEAR(`release_date`) = 2018
AND `software_house_id` = 1;


--GROUP BY

--1- Contare quante software house ci sono per ogni paese (3)

SELECT `country`, COUNT(*) AS `numero_di_software_house`
FROM `software_houses`
GROUP BY `country`;

--2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'id) (500)

SELECT `videogame_id`, COUNT(*) AS numero_di_recensioni
FROM `reviews`
GROUP BY `videogame_id`;

--3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'id) (13)

SELECT `pegi_label_videogame`.`pegi_label_id`, COUNT(*) AS numero_di_videogiochi
FROM `pegi_label_videogame` 
JOIN `videogames` ON `pegi_label_videogame`.`videogame_id` = `videogames`.`id`
GROUP BY `pegi_label_videogame` .`pegi_label_id`;

--4- Mostrare il numero di videogiochi rilasciati ogni anno (11)

SELECT YEAR(`release_date`) AS anno, COUNT(*) AS numero_di_videogiochi
FROM `videogames`
GROUP BY YEAR(`release_date`);

--5- Contare quanti videogiochi sono disponbili per ciascun device (del device vogliamo solo l'id) (7)

SELECT `device_videogame`.`device_id`, COUNT(*) AS numero_di_videogiochi
FROM `device_videogame`
JOIN `devices` ON `device_videogame`.`device_id` = `devices`.`id`
GROUP BY `device_videogame`.`device_id`;

--6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'id) (500)

SELECT `videogames`.`id`, AVG(`reviews`.`rating`) AS `media_recensioni`
FROM `videogames`
JOIN `reviews` ON `videogames`.`id` = `reviews`.`videogame_id`
GROUP BY `videogames`.`id`
ORDER BY `media_recensioni` DESC;

JOIN

--1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)

SELECT DISTINCT `players`.*
FROM `players` 
JOIN `reviews` ON `players`.`id` = `reviews`.`player_id`;

--2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)

SELECT DISTINCT `videogames`.*
FROM `videogames`
JOIN `tournament_videogame` ON `videogames`.`id` = `tournament_videogame`.`videogame_id`
JOIN `tournaments` ON `tournament_videogame`.`tournament_id` = `tournaments`.`id`
WHERE `tournaments`.`year` = 2016;

--3- Mostrare le categorie di ogni videogioco (1718)

SELECT `videogames`.`id` AS `id_videogioco`, `categories`.`name` AS `categoria`
FROM `videogames` 
JOIN `category_videogame` ON `videogames`.`id` = `category_videogame`.`videogame_id`
JOIN `categories` ON `category_videogame`.`category_id` = `categories`.`id`;

--4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)

SELECT DISTINCT `software_houses`.*
FROM `software_houses`
JOIN `videogames` ON `software_houses`.`id` = `videogames`.`software_house_id`
WHERE YEAR(`videogames`.`release_date`) > 2020

--5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)

SELECT
    `software_houses`.`name`,
    `awards`.`name`
FROM
    `software_houses`
JOIN
    `videogames` ON `software_houses`.`id` = `videogames`.`software_house_id`
JOIN
    `award_videogame` ON `videogames`.`id` = `award_videogame`.`videogame_id`
JOIN
    `awards` ON `award_videogame`.`award_id` = `awards`.`id`;

--6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)

SELECT DISTINCT
    `categories`.`name` AS `categoria`,
    `pegi_labels`.`name` AS `classificazione_pegi`,
    `videogames`.`name` AS `videogames_name`
FROM
    `videogames`
JOIN
    `category_videogame` ON `videogames`.`id` = `category_videogame`.`videogame_id`
JOIN
    `categories` ON `category_videogame`.`category_id` = `categories`.`id`
JOIN
    `pegi_label_videogame` ON `videogames`.`id` = `pegi_label_videogame`.`videogame_id`
JOIN
    `pegi_labels` ON `pegi_label_videogame`.`pegi_label_id` = `pegi_labels`.`id`
JOIN
    `reviews` ON `videogames`.`id` = `reviews`.`videogame_id`
WHERE
    `reviews`.`rating` IN (4, 5);

--7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)

SELECT DISTINCT
    `videogames`.*
FROM
    `videogames`
JOIN
    `tournament_videogame` ON `videogames`.`id` = `tournament_videogame`.`videogame_id`
JOIN
    `tournaments` ON `tournament_videogame`.`tournament_id` = `tournaments`.`id`
JOIN
    `player_tournament` ON `tournaments`.`id` = `player_tournament`.`tournament_id`
JOIN
    `players` ON `player_tournament`.`player_id` = `players`.`id`
WHERE
    `players`.`name` LIKE 'S%';

--8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)

SELECT DISTINCT
    t.`city`
FROM
    `tournaments` t
JOIN
    `tournament_videogame` tv ON t.`id` = tv.`tournament_id`
JOIN
    `videogames` vg ON tv.`videogame_id` = vg.`id`
JOIN
    `award_videogame` av ON vg.`id` = av.`videogame_id`
JOIN
    `awards` a ON av.`award_id` = a.`id`

WHERE
    a.`name` = "Gioco dell'anno"
    AND av.`year` = 2018;


--9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (991)

SELECT DISTINCT
    p.`nickname`
FROM
    `players` p
JOIN
    `player_tournament` pt ON p.`id` = pt.`player_id`
JOIN
    `tournaments` t ON pt.`tournament_id` = t.`id`
JOIN
    `tournament_videogame` tv ON t.`id` = tv.`tournament_id`
JOIN
    `videogames` vg ON tv.`videogame_id` = vg.`id`
JOIN
    `award_videogame` av ON vg.`id` = av.`videogame_id`
JOIN
    `awards` a ON av.`award_id` = a.`id`
WHERE
    a.`name` = 'Gioco più atteso'
    AND av.`year` = 2018
    AND t.`year` = 2019;

--*********** BONUS ***********

--10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)

SELECT
    sh.*,
    vg.*
FROM
    `software_houses` sh
JOIN
    `videogames` vg ON sh.`id` = vg.`software_house_id`
ORDER BY
    vg.`release_date`
LIMIT 1;

--11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : potrebbe uscire 449 o 398, sono entrambi a 20)

SELECT
    vg.`id` AS game_id,
    vg.`name` AS game_name,
    vg.`release_date` AS release_date,
    COUNT(r.`id`) AS total_reviews
FROM
    `videogames` vg
JOIN
    `reviews` r ON vg.`id` = r.`videogame_id`
GROUP BY
    vg.`id`, vg.`name`, vg.`release_date`
ORDER BY
    total_reviews DESC
LIMIT 1;

--12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : potrebbe uscire 3 o 1, sono entrambi a 3)

SELECT
    sh.`id` AS software_house_id,
    sh.`name` AS software_house_name,
    COUNT(DISTINCT a.`id`) AS total_awards
FROM
    `software_houses` sh
JOIN
    `videogames` vg ON sh.`id` = vg.`software_house_id`
JOIN
    `award_videogame` av ON vg.`id` = av.`videogame_id`
JOIN
    `awards` a ON av.`award_id` = a.`id`
WHERE
    av.`year` BETWEEN 2015 AND 2016
GROUP BY
    sh.`id`, sh.`name`
ORDER BY
    total_awards DESC
LIMIT 1;

--13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 2 (10)

SELECT DISTINCT
    c.`name` AS category_name
FROM
    `categories` c
JOIN
    `category_videogame` cvg ON c.`id` = cvg.`category_id`
JOIN
    `videogames` vg ON cvg.`videogame_id` = vg.`id`
JOIN
    `reviews` r ON vg.`id` = r.`videogame_id`
GROUP BY
    vg.`id`, c.`name`
HAVING
    AVG(r.`rating`) < 2;