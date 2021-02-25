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

-- Exo 1) d) Donner la liste des titres des représentations, les lieux et les tarifs pour la journée du 15/02/2021
SELECT titre_representation, lieu, tarif 
FROM representation, programmer
WHERE programmer.date = '2021-02-15'
AND representation.numero_representation = programmer.numero_representation
-- Résultats
titre_representation / lieu / tarif pour le 15/02/2021
Celebrations Strasbourg 25

-- ********************************************************************************************************
-- Exercice 2

-- Soit le modèle relationnel suivant relatif à la gestion des notes annuelles d'une promotion
-- d'étudiants :
-- ETUDIANT (N°ETUDIANT, NOM, PRENOM)
-- MATIERE (CODEMAT, LIBELLEMAT, COEFFMAT)
-- EVALUER (N°ETUDIANT*, CODEMAT*, DATE, NOTE)
-- Affichez les résultats suivants avec une solution SQL :

-- Exercice 2) a) Quel est le nombre total d'étudiants ?
SELECT COUNT(*) 
FROM etudiant
-- Résultats
4

-- Exercice 2) b) Quelles sont, parmi l'ensemble des notes, la note la plus haute et la note la plus basse ?
SELECT MAX(note)
FROM evaluation
-- Résultats
20
-- --------------
SELECT MIN(note)
FROM evaluation
-- Résultats
1

-- Exercice 2) c) Quelles sont les moyennes de chaque étudiant dans chacune des matières ? (utilisez
-- CREATE VIEW)
CREATE VIEW notes_maths AS
SELECT note, numero_etudiant
FROM evaluation, matiere
WHERE matiere.code_mat = '1'
AND matiere.code_mat = evaluation.code_mat

-- pour voir le résultat du create view
SELECT *
FROM notes_maths

-- puis pour chaque numero_etudiant 1, 2, 3, 4
SELECT AVG(note), numero_etudiant
FROM notes_maths
WHERE numero_etudiant = 1

-- Exercice 2) d) Quelles sont les moyennes par matière ? (cf. question c)
SELECT AVG(note)
FROM notes_maths
-- Résultats
10.8

-- Exercice 2) e) Quelle est la moyenne générale de chaque étudiant ? (utilisez CREATE VIEW + cf. question 3)
CREATE VIEW MoyenneAlpha AS    
SELECT Numéro_Etudiant, Nom, Prénom 
FROM etudiant AS Etudiants
    UNION
    SELECT Numéro_Etudiant, Note, Code_Mat FROM evaluer AS Evaluation

-- Exercice 2) f) Quelle est la moyenne générale de la promotion ? (cf. question e)

-- Exercice 2) g) Quels sont les étudiants qui ont une moyenne générale supérieure ou égale à la moyenne
-- générale de la promotion ? (cf. question e)


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

-- g) Valeur du stock ?

-- h) Numéros et libellés des articles triés dans l'ordre décroissant des stocks ?

-- i) Liste pour chaque article (numéro et libellé) du prix d'achat maximum, minimum et moyen ?

-- j) Délai moyen pour chaque fournisseur proposant au moins 2 articles ?


-- ********************************************************************************************************
-- Exercice 4
-- Schéma UML sur le document PDF des consignes
-- Donnez le résultat SQL des éléments suivants :

-- a) Liste de tous les étudiants

-- b) Liste de tous les étudiants, classée par ordre alphabétique inverse

-- c) Libellé et coefficient (exprimé en pourcentage) de chaque matière

-- d) Nom et prénom de chaque étudiant

-- e) Nom et prénom des étudiants domiciliés à Lyon

-- f) Liste des notes supérieures ou égales à 10

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
