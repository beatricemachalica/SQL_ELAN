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
WHERE prix_invent < 300
AND prix_invent > 100
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
FROM fournisseurs, acheter
WHERE fournisseurs.num_fournisseur = acheter.num_fournisseur
AND delai > 20
-- je sais pas si c'est faux ou pas

-- f) Nombre d'articles référencés ?
SELECT COUNT(*) AS NbArticles
FROM articles
-- Résultats
NbArticles
9

-- g) Valeur du stock ?

-- h) Numéros et libellés des articles triés dans l'ordre décroissant des stocks ?

-- i) Liste pour chaque article (numéro et libellé) du prix d'achat maximum, minimum et moyen ?

-- j) Délai moyen pour chaque fournisseur proposant au moins 2 articles ?


-- ********************************************************************************************************
-- Exercice 4
-- Schéma UML sur le document PDF des consignes
-- Donnez le résultat SQL des éléments suivants :

-- a) Liste de tous les étudiants
SELECT nom AS num_etudiant
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
SELECT libelle, coef
FROM matiere
PAS FINIS

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

-- g) Liste des épreuves dont la date se situe entre le 1er janvier et le 30 juin 2014

-- h) Nom, prénom et ville des étudiants dont la ville contient la chaîne "ll" (LL)

-- i) Prénoms des étudiants de nom Dupont, Durand ou Martin

-- j) Somme des coefficients de toutes les matières

-- k) Nombre total d'épreuves

-- l) Nombre de notes indéterminées (NULL)

-- m) Liste des épreuves (numéro, date et lieu) incluant le libellé de la matière

-- n) Liste des notes en précisant pour chacune le nom et le prénom de l'étudiant qui l'a obtenue

-- o) Liste des notes en précisant pour chacune le nom et le prénom de l'étudiant qui l'a
-- obtenue et le libellé de la matière concernée

-- p) Nom et prénom des étudiants qui ont obtenu au moins une note égale à 20

-- q) Moyennes des notes de chaque étudiant (indiquer le nom et le prénom)

-- r) Moyennes des notes de chaque étudiant (indiquer le nom et le prénom), classées de la
-- meilleure à la moins bonne

-- s) Moyennes des notes pour les matières (indiquer le libellé) comportant plus d'une épreuve

-- t) Moyennes des notes obtenues aux épreuves (indiquer le numéro d'épreuve) où moins de 6
-- étudiants ont été notés

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

-- b) Supprimer tous les produits de couleur noire et dont le poids est > à 30
DELETE FROM produits
WHERE couleur = 'noir' AND poids > 30;

-- c) Changer la ville du fournisseur 3 par Mulhouse
UPDATE fournisseur
SET Ville_F = REPLACE(Ville_F, 'Strasbourg', 'Mulhouse')
WHERE Num_F = 3
