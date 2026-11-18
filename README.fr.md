# Accueil : un lanceur minimaliste et rapide pour Android TV

*English version: [README.md](README.md)*

Un écran d'accueil épuré pour Android TV / Google TV avec un dock de favoris, des fonds d'écran qui tournent avec
un lent mouvement « Ken Burns », et quelques widgets en direct. L'APK entier fait environ 100 Ko, sans pub, sans
pistage, sans compte et sans bibliothèque tierce.

## Disclamer
Tout le code de ce projet a été écrit par Claude, l’IA d’Anthropic, à partir de mes idées et de mes demandes. J’ai imaginé l’appli, décidé de chaque fonction et du design, et tout testé sur mes télés, mais je n’ai pas écrit le code moi-même.

<!-- Ajoute des captures ici : docs/capture-1.jpg … -->

## Fonctions

- **Dock de favoris** en tuiles noir et blanc, avec un contour néon animé à la sélection, plus une grille
  « Toutes les applis » (appui long sur OK pour ajouter ou retirer un favori).
- **Fonds d'écran** : tes photos, l'image du jour Bing, ou les deux, avec un zoom et un déplacement lents qui
  durent tout le temps d'affichage.
  - **Import depuis le téléphone** : scanne le QR code sur la télé et choisis tes photos.
- **Widgets** :
  - heure et date, qui ouvrent un **planning de la semaine** tiré de l'agenda du compte Google de la télé ;
  - **météo** avec icônes animées et prévisions par heure et par jour ;
  - **lecture en cours** (Spotify ou n'importe quelle appli de musique) avec pochette, boutons et égaliseur à LED.
- **Paroles synchronisées** pendant la musique.
- **Particules d'ambiance** (bokeh) au-dessus du dock, qui réagissent à la télécommande et aux basses. Elles ont
  plusieurs thèmes de couleurs, dont un qui suit les couleurs du fond d'écran.
- **Contour néon de l'écran** : toujours, seulement pendant la musique, ou jamais.
- **Animations d'allumage** (épurée, ou une petite mascotte télé rétro) avec un son synthétisé.
- **Menu de réglages** à la télécommande. L'interface est en français, anglais et espagnol, ou suit la langue de
  la télé. La taille de l'interface est réglable.

  ## Captures

<img width="1920" height="1080" alt="capture01" src="https://github.com/user-attachments/assets/52e21784-70a7-4b4c-ac9e-a18c1f5e7fa3" />
<img width="1920" height="1080" alt="capture02" src="https://github.com/user-attachments/assets/236e4f66-5835-4fd6-9662-83c9bcfe4d37" />
<img width="1920" height="1080" alt="capture03" src="https://github.com/user-attachments/assets/108aba7a-39c1-43ab-bd1a-26f1ab575b00" />
<img width="1920" height="1080" alt="capture04" src="https://github.com/user-attachments/assets/2421d98b-5adb-4d3b-822d-ffc23a18db0c" />
<img width="1920" height="1080" alt="capture05" src="https://github.com/user-attachments/assets/fd2408a7-f474-4eac-937b-342919ce7eff" />
<img width="1920" height="1080" alt="capture06" src="https://github.com/user-attachments/assets/6e73f00e-35cf-4c03-b834-c90782b9d588" />
<img width="1920" height="1080" alt="capture07" src="https://github.com/user-attachments/assets/df30f236-94a6-4e86-b403-5a2ea8b941bb" />

## Installation

Voir **[INSTALL.fr.md](INSTALL.fr.md)** : sauvegarder le lanceur actuel, installer, donner les autorisations et
le mettre par défaut, avec un script ou étape par étape. Tout est réversible.

## Compiler soi-même

Pas de Gradle ni d'Android Studio : il suffit d'un JDK (17+) et des outils en ligne de commande du SDK Android
(build-tools + une plateforme, API 30 ou plus récente).

```powershell
powershell -ExecutionPolicy Bypass -File build.ps1 -Sdk C:\chemin\vers\android-sdk   # Windows
```
```bash
ANDROID_HOME=~/Android/Sdk ./build.sh                                             # macOS / Linux
```

L'APK est créé dans `dist/Accueil.apk`. À la première compilation, une clé de signature `release.keystore` est
créée et tu choisis son mot de passe. **Garde ce fichier et ce mot de passe pour toi, ne les mets jamais sur
GitHub** : Android n'accepte une mise à jour que si elle est signée avec la même clé.

Les commentaires du code sont en français. La carte des fichiers est dans le [README anglais](README.md#code-map-appsrccomminimalaccueil).

## Vie privée

L'appli n'a pas de serveur et ne collecte rien. Depuis la télé, elle contacte seulement :
- Open-Meteo (météo, recherche de ville) ;
- LRCLIB (titre et artiste du morceau en cours, pour les paroles) ;
- Bing (image du jour, si activée).

La lecture en cours, l'analyse du son et l'agenda sont lus **uniquement sur la télé**. Le serveur d'import ne
tourne que tant que son écran est ouvert, sur ton réseau local, derrière une adresse aléatoire à usage unique.

## Licences

| Quoi | Licence |
|---|---|
| **Ce projet** (code, scripts, docs) | **[MIT](LICENSE)** : libre d'utiliser, copier, modifier, partager et redistribuer ; garde la mention de licence |
| Générateur de QR code (`QrCode.java`) | Implémentation indépendante, sur la structure du [QR Code generator de Project Nayuki](https://www.nayuki.io/page/qr-code-generator-library) (MIT) |
| SDK Android (compilation seulement, non inclus) | [Licence du SDK Android](https://developer.android.com/studio/terms) / Apache 2.0 |
| Météo et géocodage : [Open-Meteo](https://open-meteo.com/) | Données **CC BY 4.0**, gratuit pour un usage non commercial (noms de lieux : GeoNames, CC BY 4.0) |
| Paroles : [LRCLIB](https://lrclib.net/) | API publique gratuite. Paroles © leurs auteurs et éditeurs, affichées seulement, jamais stockées |
| Image du jour Bing | Images © Microsoft et/ou leurs photographes, pour un usage personnel en fond d'écran. Désactivable |

Le détail complet, les attributions et les marques sont dans **[THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md)**.

*Android, Android TV, Google TV et Google Agenda sont des marques de Google LLC. Spotify est une marque de
Spotify AB. Bing est une marque de Microsoft. Philips et Ambilight sont des marques de Koninklijke Philips N.V.
Ce projet n'est ni affilié à ces sociétés, ni approuvé par elles.*

## Avertissement

Projet perso, fourni **tel quel, sans aucune garantie**. ADB donne un accès profond à la télé : lis les commandes
avant de les lancer. Tout ce que fait le script d'installation s'annule avec le script de restauration.
