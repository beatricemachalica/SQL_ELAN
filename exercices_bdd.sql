-- ********************************************************************************************************
-- Exercice 1
-- Soit le schéma relationnel suivant :
-- REPRESENTATION (N°REPRESENTATION, TITRE_REPRESENTATION, LIEU)
-- MUSICIEN (NOM, N°REPRESENTATION*)
-- PROGRAMMER (DATE, N°REPRESENTATION*, TARIF)
-- Affichez les résultats suivants avec une solution SQL pour les question a, b, c et d :

-- Exo 1) a) Donner la liste des titres des représentations
SELECT titre_representation
FROM representation
-- Résultats
titre_representation
Titanic
Cendrillon
etc.

-- Exo 1) b) Donner la liste des titres des représentations ayant lieu à Strasbourg
SELECT titre_representation
FROM representation
WHERE lieu = 'Strasbourg'
-- Résultats
titre_representation
Titanic
Celebrations

-- Exo 1) c) Donner la liste des noms des musiciens et des titres des représentations auxquelles ils participent
SELECT nom, titre_representation 
FROM musicien, representation
WHERE musicien.numero_representation = representation.numero_representation
-- Résultats
nom / titre_representation
Paul Cendrillon
Lucy Titanic
Indochine Celebrations
Sirkis Celebrations
Muse Cats
Hooper Cats
-- autre méthode avec un alias :
SELECT nom, titre_representation 
FROM musicien m, representation r
WHERE m.NUMERO_REPRESENTATION = r.NUMERO_REPRESENTATION

-- Exo 1) d) Donner la liste des titres des représentations, les lieux et les tarifs pour la journée du 15/02/2021
SELECT titre_representation, lieu, tarif 
FROM representation, programmer
WHERE programmer.date = '2021-02-15'
AND representation.numero_representation = programmer.numero_representation
-- Résultats
titre_representation / lieu / tarif pour le 15/02/2021
Celebrations Strasbourg 25

-- autre méthode avec un alias :
SELECT titre_representation, lieu, tarif 
FROM representation r, programmer p
WHERE p.DATE = '2021-02-15'
AND r.NUMERO_REPRESENTATION = p.NUMERO_REPRESENTATION

-- ********************************************************************************************************
-- Exercice 2

-- Soit le modèle relationnel suivant relatif à la gestion des notes annuelles d'une promotion
-- d'étudiants :
-- ETUDIANT (N°ETUDIANT, NOM, PRENOM)
-- MATIERE (CODEMAT, LIBELLEMAT, COEFFMAT)
-- EVALUER (N°ETUDIANT*, CODEMAT*, DATE, NOTE)
-- Affichez les résultats suivants avec une solution SQL :

-- Exercice 2) a) Quel est le nombre total d'étudiants ?
-- count() est une fonction d'agrégation
SELECT COUNT(*) 
FROM etudiant
-- Résultats
4
-- correction : on rajoute un alias pour pouvoir réutiliser les données
SELECT COUNT(numero_etudiant) AS NbEtudiants 
FROM etudiant

-- Exercice 2) b) Quelles sont, parmi l'ensemble des notes, la note la plus haute et la note la plus basse ?
SELECT MAX(e.NOTE), MIN(e.NOTE)
FROM evaluation e
-- Résultats
note max / note min
20 / 1

-- Exercice 2) c) Quelles sont les moyennes de chaque étudiant dans chacune des matières ? (utilisez
-- CREATE VIEW) = une vue est une table virtuelle

-- on va créer une vue MOY
-- si on a une fonction d'agrégation = group by
CREATE VIEW MOY AS
  SELECT numero_etudiant AS idEtudiant, m.code_mat AS Mat, AVG(note) AS moy_etu_mat
  FROM evaluation e, matiere m
  WHERE m.code_mat = e.code_mat
  GROUP BY idEtudiant, Mat

SELECT CONCAT(nom, " ", prenom) AS identite, libelle_mat, ROUND(moy_etu_mat,2) AS moyenne
FROM moy m, matiere ma, etudiant e
WHERE m.idEtudiant = e.numero_etudiant
AND ma.code_mat = m.Mat
ORDER BY identite ASC, ma.libelle_mat
-- Résultats
identite / libelle_mat / moyenne
Bochler Anthony / Biologie / 19.50
Bochler Anthony / Français / 15
Bochler Anthony / Histoire / 8.50
Bochler Anthony / Maths / 14.50
-- etc.

-- Exercice 2) d) Quelles sont les moyennes par matière ? (cf. question c)
SELECT libelle_mat, ROUND(AVG(moy_etu_mat),2) AS moyenne
FROM matiere ma, moy m
WHERE ma.code_mat = m.Mat
GROUP BY m.Mat
-- Résultats
libelle_mat / moyenne
Maths / 10.88
Français / 9.75
Histoire / 12.75
Biologie / 13.88

-- Exercice 2) e) Quelle est la moyenne générale de chaque étudiant ? (utilisez CREATE VIEW + cf. question 3)
CREATE VIEW moygen AS
SELECT CONCAT(nom, " ", prenom) AS identite, ROUND(SUM(m.moy_etu_mat * ma.coeff_mat)/ SUM(ma.coeff_mat),2) AS moy_gen_etu
FROM moy m, matiere ma, etudiant e
WHERE m.Mat = ma.code_mat
AND e.numero_etudiant = m.idEtudiant
GROUP BY identite
ORDER BY moy_gen_etu desc

SELECT identite, moy_gen_etu
FROM moygen
ORDER BY moy_gen_etu desc

-- Résultats
identite / moy_gen_etu
Bochler Anthony / 15.29
Machalica Béatrice / 13.67
Schweitzer Mathieu / 13.42
Goudowicz Marta / 5.25

-- Exercice 2) f) Quelle est la moyenne générale de la promotion ? (cf. question e)
SELECT ROUND(AVG(moy_gen_etu), 2) AS moyenne_promo
FROM moygen
-- Résultats
moyenne_promo
11.91
-- Exercice 2) g) Quels sont les étudiants qui ont une moyenne générale supérieure ou égale à la moyenne
-- générale de la promotion ? (cf. question e)

-- on doit faire une sous requête
SELECT identite, moy_gen_etu
FROM moygen
WHERE moy_gen_etu >= 
	(SELECT AVG(moy_gen_etu)
		FROM moygen)
-- Résultats
identite / moy_gen_etu
Bochler Anthony / 15.29
Machalica Béatrice / 13.67
Schweitzer Mathieu / 13.42

-- ********************************************************************************************************
-- Exercice 3
-- Soit le schéma relationnel suivant :
-- ARTICLES (NOART, LIBELLE, STOCK, PRIXINVENT)
-- FOURNISSEURS (NOFOUR, NOMFOUR, ADRFOUR, VILLEFOUR)
-- ACHETER (NOFOUR#, NOART#, PRIXACHAT, DELAI)
-- Affichez les résultats suivants avec une solution SQL :

-- a) Numéros et libellés des articles dont le stock est inférieur à 10 ?
SELECT num_article, libelle
FROM articles
WHERE stock < 10
-- Résultats
numéro / libellés
8 / praliné

-- b) Liste des articles dont le prix d'inventaire est compris entre 100 et 300 ?
SELECT libelle
FROM articles
WHERE prix_invent BETWEEN 100 AND 300
-- Résultats
libellés
diamant

-- c) Liste des fournisseurs dont on ne connaît pas l'adresse ?
SELECT nom, num_fournisseur
FROM fournisseurs
WHERE adresse IS NULL
-- Résultats
nom / num_fournisseur
Meiher / 3

-- ATTENTION : l’opérateur IS permet de filtrer les résultats qui contiennent la valeur NULL. 
-- Cet opérateur est indispensable car la valeur NULL est une valeur inconnue 
-- et ne peut par conséquent pas être filtrée par les opérateurs de comparaison 
-- (cf. égal, inférieur, supérieur ou différent).

-- d) Liste des fournisseurs dont le nom commence par "STE" ?
SELECT nom
FROM fournisseurs
WHERE nom LIKE 'STE%'
-- Résultats
stephane

-- e) Noms et adresses des fournisseurs qui proposent des articles pour lesquels le délai
-- d'approvisionnement est supérieur à 20 jours ?
SELECT nom, adresse, ville
FROM fournisseurs f, acheter a
WHERE f.num_fournisseur = a.num_fournisseur
AND delai > 20

-- f) Nombre d'articles référencés ?
SELECT COUNT(*) AS NbArticles
FROM articles
-- Résultats
NbArticles
9

-- g) Valeur du stock ?
SELECT SUM(stock*prix_invent) AS valeurStock
FROM articles
-- Résultats
valeurStock
12553

-- h) Numéros, libellés et stock des articles triés dans l'ordre décroissant des stocks ?
SELECT num_article, libelle, stock
FROM articles
ORDER BY stock desc

-- i) Liste pour chaque article (numéro et libellé) du prix d'achat maximum, minimum et moyen ?
SELECT a.num_article, libelle, max(prix_achat) as prixMax, min(prix_achat) as prixMin, avg(prix_achat) as prixMoyen
FROM articles a, acheter ac
WHERE a.num_article = ac.num_article
GROUP BY libelle, a.num_article

-- j) Délai moyen pour chaque fournisseur proposant au moins 2 articles ?
SELECT f.nom AS nomFournisseur, AVG(delai) AS delaiMoyen
FROM fournisseurs f, acheter a
WHERE f.num_fournisseur = a.num_fournisseur
GROUP BY f.nom
HAVING count(a.num_article) >= 2

-- ********************************************************************************************************
-- Exercice 4
-- Schéma UML sur le document PDF des consignes
-- Donnez le résultat SQL des éléments suivants :

-- a) Liste de tous les étudiants
SELECT *
FROM etudiant
-- Résultats
nom_etudiant
Bochler
Heimburger
Schmit

-- b) Liste de tous les étudiants, classée par ordre alphabétique inverse
SELECT nom
FROM etudiant
ORDER BY nom DESC
-- Résultats
nom_etudiant
Schmit
Heimburger
Bochler

-- c) Libellé et coefficient (exprimé en pourcentage) de chaque matière
SELECT libelle, coef*100/18
FROM matiere

-- d) Nom et prénom de chaque étudiant
SELECT nom, prenom
FROM etudiant
-- Résultats
nom / prenom
Bochler / Anthony
Heimburger / Bastien
Schmit / Florence

-- e) Nom et prénom des étudiants domiciliés à Dettwiller
SELECT nom, prenom
FROM etudiant
WHERE ville = "Dettwiller"
-- Résultats
nom / prenom
Bochler Anthony

-- f) Liste des notes supérieures ou égales à 10
SELECT note
FROM notation
WHERE note >= 10
-- Résultats
19.00
18.00
18.00
16.00
-- etc.

-- g) Liste des épreuves dont la date se situe entre deux dates au choix
SELECT m.libelle, e.date_epreuve
FROM matiere m, epreuve e
WHERE m.code_matiere = e.code_matiere
AND e.date_epreuve BETWEEN "2021-02-20" AND "2021-02-22"
-- Résultats
libelle / date_epreuve
Maths / 2021-02-22
Bio / 2021-02-21
Biochimie / 2021-02-20

-- h) Nom, prénom et ville des étudiants dont la ville contient la chaîne "ll" (LL)
SELECT *
FROM etudiant e
WHERE ville LIKE '%ll%'
-- Résultats
1 / bochler / anthony / 1991-04-30 / corbeau / 67100 / Dettwiller

-- i) Prénoms des étudiants de nom Bochler, Durand ou Schmit
SELECT e.prenom
FROM etudiant e
WHERE nom IN ("Bochler","Durand","Schmit") 
-- Résultats
Anthony

-- j) Somme des coefficients de toutes les matières
SELECT SUM(coeff)
FROM matiere
-- Résultats
16

-- k) Nombre total d'épreuves
SELECT COUNT(e.num_epreuve)
FROM epreuve e
-- Résultats
5

-- l) Nombre de notes indéterminées (NULL)
SELECT count(note)
FROM notation n
WHERE n.note IS null

-- m) Liste des épreuves (numéro, date et lieu) incluant le libellé de la matière
SELECT e.num_epreuve AS IdEpreuve, e.date_epreuve, e.lieu, m.libelle
FROM epreuve e, matiere m
WHERE e.code_matiere = m.code_matiere
-- Résultats
IdEpreuve / date_epreuve / lieu / libelle
1 / 2021 ... / Strasbourg / Maths
2 / 2021 ... / Strasbourg / Bio
3 / 2021 ... / Strasbourg / Biochimie
4 / 2021 ... / Strasbourg / Info
5 / 2021 ... / Strasbourg / Projet

-- n) Liste des notes en précisant pour chacune le nom et le prénom de l'étudiant qui l'a obtenue
SELECT n.note, n.num_etudiant, et.nom, et.prenom
FROM notation n, epreuve e, matiere m, etudiant et
WHERE n.num_epreuve = e.code_matiere
AND e.code_matiere = m.code_matiere
AND n.num_etudiant = et.num_etudiant
-- Résultats
note / num_etudiant / nom / prenom
19.00 / 1 / Bochler / Anthony
18.00 / 1 / Bochler / Anthony
18.00 / 1 / Bochler / Anthony
16.00 / 1 / Bochler / Anthony
16.00 / 1 / Bochler / Anthony
-- etc.

-- o) Liste des notes en précisant pour chacune le nom et le prénom de l'étudiant qui l'a
-- obtenue et le libellé de la matière concernée
SELECT n.note, n.num_etudiant, et.nom, et.prenom, n.num_epreuve, m.libelle
FROM notation n, epreuve e, matiere m, etudiant et
WHERE n.num_epreuve = e.code_matiere
AND e.code_matiere = m.code_matiere
AND n.num_etudiant = et.num_etudiant

-- p) Nom et prénom des étudiants qui ont obtenu au moins une note égale à 19
SELECT n.note, n.num_etudiant, et.nom, et.prenom, n.num_epreuve, m.libelle
FROM notation n, epreuve e, matiere m, etudiant et
WHERE n.num_epreuve = e.code_matiere
AND e.code_matiere = m.code_matiere
AND n.num_etudiant = et.num_etudiant
AND n.note >= 19
-- Résultats
note / num_etudiant / nom / prenom / num_epreuve / libelle
19.00 / 1 / Bochler / Anthony / 1 / Maths

-- q) Moyennes des notes de chaque étudiant (indiquer le nom et le prénom)
SELECT n.num_etudiant AS idEtudiant, et.nom, et.prenom, m.code_matiere, round(AVG(note),2) AS moy_etu_mat
FROM notation n, etudiant et, matiere m, epreuve e
WHERE n.num_etudiant = et.num_etudiant
AND e.num_epreuve = n.num_epreuve
GROUP BY idEtudiant, m.code_matiere


-- r) Moyennes des notes de chaque étudiant (indiquer le nom et le prénom), classées de la
-- meilleure à la moins bonne
SELECT n.num_etudiant AS idEtudiant, et.nom, et.prenom, m.code_matiere, round(AVG(note),2) AS moy_etu_mat
FROM notation n, etudiant et, matiere m, epreuve e
WHERE n.num_etudiant = et.num_etudiant
AND e.num_epreuve = n.num_epreuve
GROUP BY idEtudiant, m.code_matiere
ORDER BY idEtudiant DESC

-- s) Moyennes des notes pour les matières (indiquer le libellé) comportant plus d'une épreuve
SELECT libelle, AVG(note)
FROM matiere m, notation n, epreuve e
WHERE m.code_mat = e.code_mat
AND n.num_epreuve = e.num_epreuve
GROUP BY libelle
HAVING count(DISTINCT e.num_epreuve) >= 2

-- t) Moyennes des notes obtenues aux épreuves (indiquer le numéro d'épreuve) où moins de 6
-- étudiants ont été notés
SELECT n.num_epreuve, AVG(note)
FROM notation n
WHERE note IS NOT NULL
GROUP BY n.num_epreuve
HAVING count(*) < 6

-- ********************************************************************************************************
-- Exercice 5
-- Soit la base relationnelle de données LIVRAISON de schéma :
-- USINE (NumU, NomU, VilleU)
-- PRODUIT (NumP, NomP, Couleur, Poids)
-- FOURNISSEUR (NumF, NomF, Statut, VilleF)
-- LIVRAISON (NumP, NumU, NumF, Quantité)

-- a) Ajouter un nouveau fournisseur avec les attributs de votre choix
INSERT INTO fournisseur (Nom_F,Statut,Ville_F)
 VALUES
 ('Conforama', 'Grand', 'Mulhouse'),
 ('Michelle', 'Petit', 'Cernay');

--  autre solution mais attention à la clé qu'il faut indiquer ici !
INSERT INTO fournisseur
 VALUES
 (45,'truc', 'Grand', 'Mulhouse'),
 (46,'machin', 'Petit', 'Cernay');

-- b) Supprimer tous les produits de couleur noire et dont le poids est > à 30
DELETE FROM produits
WHERE couleur = 'noir' AND poids > 30;

-- c) Changer la ville du fournisseur 3 par Mulhouse
UPDATE fournisseur
SET Ville_F = REPLACE(Ville_F, 'Strasbourg', 'Mulhouse')
WHERE Num_F = 3

-- ou bien sans le REPLACE
UPDATE fournisseur
SET Ville_F = 'Strasbourg'
WHERE Num_F = 8

-- ********************************************************************************************************
-- Exercice des Gaulois

-- 1) Nombre de gaulois par lieu (trié par nombre de gaulois décroissant)
SELECT COUNT(v.NOM) AS NombreGaulois, l.NOM_LIEU
FROM villageois v, lieu l
WHERE v.ID_LIEU = l.ID_LIEU
GROUP BY v.ID_LIEU
ORDER BY NombreGaulois desc

-- avec INNER JOIN
SELECT COUNT(v.NOM) AS NombreGaulois, l.NOM_LIEU
FROM villageois v INNER JOIN lieu l
ON v.ID_LIEU = l.ID_LIEU
GROUP BY v.ID_LIEU
ORDER BY NombreGaulois desc

-- 2) Nom des gaulois + spécialité + village
SELECT v.NOM, s.NOM_SPECIALITE, l.NOM_LIEU
FROM villageois v, specialite s, lieu l
WHERE v.ID_LIEU = l.ID_LIEU
AND s.ID_SPECIALITE = v.ID_SPECIALITE

-- avec INNER JOIN
SELECT v.NOM, s.NOM_SPECIALITE, l.NOM_LIEU
FROM villageois v INNER JOIN specialite s
ON v.ID_SPECIALITE = s.ID_SPECIALITE
INNER JOIN lieu l
ON v.ID_LIEU = l.ID_LIEU

-- 3) Nom des spécialités avec nombre de gaulois par spécialité (trié par nombre de gaulois
-- décroissant)
SELECT COUNT(v.NOM) AS NombreGaulois, s.NOM_SPECIALITE
FROM villageois v, specialite s
WHERE v.ID_SPECIALITE = s.ID_SPECIALITE
GROUP BY s.NOM_SPECIALITE
ORDER BY NombreGaulois DESC

-- avec INNER JOIN
SELECT COUNT(v.NOM) AS NombreGaulois, s.NOM_SPECIALITE
FROM villageois v INNER JOIN specialite s
ON v.ID_SPECIALITE = s.ID_SPECIALITE
GROUP BY s.NOM_SPECIALITE
ORDER BY NombreGaulois DESC

-- 4) Nom des batailles + lieu de la plus récente à la plus ancienne (dates au format jj/mm/aaaa)
SELECT b.NOM_BATAILLE, l.NOM_LIEU, DATE_FORMAT(DATE_BATAILLE, "%d/%m/%Y")
FROM bataille b, lieu l
WHERE l.ID_LIEU = b.ID_LIEU
ORDER BY b.DATE_BATAILLE asc

-- 5) Nom des potions + coût de réalisation de la potion (trié par coût décroissant)
SELECT p.NOM_POTION, sum(i.COUT_INGREDIENT) AS cout
FROM potion p, compose c, ingredient i
WHERE p.ID_POTION = c.ID_POTION
AND c.ID_INGREDIENT = i.ID_INGREDIENT
GROUP BY p.NOM_POTION
ORDER BY cout desc

-- 6) Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Potion V'
SELECT i.NOM_INGREDIENT, c.QTE, i.COUT_INGREDIENT
FROM ingredient i, potion p, compose c
WHERE p.NOM_POTION = "Potion V" 
AND p.ID_POTION = c.ID_POTION 
AND i.ID_INGREDIENT = c.ID_INGREDIENT

-- 7) Nom du ou des villageois qui ont pris le plus de casques dans la bataille 'Babaorum'
SELECT v.NOM, pc.QTE
FROM villageois v, bataille b, prise_casque pc
WHERE b.NOM_BATAILLE ='Babaorum'
AND pc.ID_BATAILLE = b.ID_BATAILLE
AND v.ID_VILLAGEOIS = pc.ID_VILLAGEOIS
ORDER BY qte desc

-- 8) Nom des villageois et la quantité de potion bue (en les classant du plus grand buveur au plus
-- petit)
SELECT v.NOM, sum(b.DOSE) AS Quantité
FROM villageois v, boit b
WHERE v.ID_VILLAGEOIS = b.ID_VILLAGEOIS
GROUP BY v.NOM
ORDER BY Quantité desc

-- 9) Nom de la bataille où le nombre de casques pris a été le plus important
SELECT b.NOM_BATAILLE, SUM(p.QTE) AS Quantite
FROM bataille b, prise_casque p
WHERE b.ID_BATAILLE = p.ID_BATAILLE
GROUP BY b.NOM_BATAILLE
ORDER BY Quantité DESC
LIMIT 1

-- 10) Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par nombre
-- décroissant)
SELECT tc.NOM_TYPE_CASQUE AS nom, COUNT(c.ID_TYPE_CASQUE) AS nombre, SUM(c.COUT_CASQUE) AS cout
FROM type_casque tc, casque c
WHERE c.ID_TYPE_CASQUE = tc.ID_TYPE_CASQUE
GROUP BY nom

-- 11) Noms des potions dont un des ingrédients est la cerise
SELECT p.NOM_POTION AS nom
FROM potion p, compose c, ingredient i
WHERE c.ID_POTION = p.ID_POTION
AND c.ID_INGREDIENT = i.ID_INGREDIENT
AND i.NOM_INGREDIENT = 'cerise'
GROUP BY nom

-- 12) Nom du / des village(s) possédant le plus d'habitants
SELECT l.NOM_LIEU, COUNT(v.ID_VILLAGEOIS) AS nombre
FROM lieu l, villageois v
WHERE l.ID_LIEU = v.ID_LIEU
GROUP BY l.NOM_LIEU
ORDER BY nombre DESC
LIMIT 3

-- 13) Noms des villageois qui n'ont jamais bu de potion
SELECT v.ID_VILLAGEOIS AS id, v.NOM
FROM villageois v
WHERE v.ID_VILLAGEOIS NOT IN (SELECT boit.ID_VILLAGEOIS FROM boit)
ORDER BY v.ID_VILLAGEOIS asc

-- 14) Noms des villages qui contiennent la particule 'um'
SELECT l.NOM_LIEU AS nom
FROM lieu l
WHERE l.NOM_LIEU LIKE '%um%'

-- 15) Nom du / des villageois qui n'ont pas le droit de boire la potion 'Rajeunissement II'
SELECT p.NOM_POTION AS potionInterdite, v.NOM
FROM peut, potion p, villageois v
WHERE peut.ID_POTION = p.ID_POTION
AND peut.ID_VILLAGEOIS = v.ID_VILLAGEOIS
AND p.NOM_POTION = 'Rajeunissement II'
AND peut.A_LE_DROIT = 0