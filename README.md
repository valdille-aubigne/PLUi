# Gestion du PLUi en base de données

L'objectif de la structuration en base est triple :
- Éviter la saisie d'informations redondantes à chaque saisie d'objet (le libellé long dans la couche zonage par exemple)
- Conserver un historique des versions du document avec une optimisation des données stockées
- Préparer les futures versions du document

Tout en conservant une compatibilité totale avec le standard d'échange CNIG

## Modèle conceptuel de données :
![MCD DDU](https://github.com/valdille-aubigne/PLUi/blob/master/MCD_DDU.png?raw=true)
lien vers le MCD : https://dbdiagram.io/d/6007f71180d742080a3719e8
