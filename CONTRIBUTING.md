# Comment Contribuer à One Kind Message

Tout d'abord, merci de prendre le temps de contribuer ! ❤️

**One Kind Message** est plus qu'une simple application ; c'est un projet open-source visant à créer un espace numérique sain, minimaliste et apaisant. Vos contributions nous aident à maintenir et améliorer cet espace.

Ce document fournit les directives pour contribuer au projet.

## 📜 Code de Conduite

En participant à ce projet, vous acceptez de maintenir un environnement respectueux, bienveillant et inclusif, à l'image des valeurs portées par l'application.

## 💡 Comment puis-je contribuer ?

### 🐛 Signaler un bug
Si vous trouvez un bug, veuillez ouvrir une "Issue" sur GitHub en incluant :
- Une description claire du problème.
- Les étapes pour reproduire le bug.
- Le comportement attendu vs le comportement actuel.
- Les informations sur votre appareil et votre version d'OS.

### ✨ Suggérer une amélioration
Vos idées sont les bienvenues ! Gardez à l'esprit que notre philosophie est le **minimalisme**. Toute fonctionnalité ajoutant de la complexité sociale (likes, commentaires, profils publics) sera refusée par design.
Pour proposer une idée, ouvrez une "Issue" avec le tag `enhancement`.

### 🛠️ Contribuer au code

1. **Forkez** le dépôt.
2. Créez une branche pour votre fonctionnalité : `git checkout -b feature/ma-nouvelle-fonctionnalite` ou `fix/correction-du-bug`.
3. Codez et testez.
4. Poussez votre branche : `git push origin feature/ma-nouvelle-fonctionnalite`.
5. Ouvrez une **Pull Request** (PR).

## 🏗️ Standards de Développement

Pour maintenir une base de code propre, maintenable ("Production Ready"), nous avons établi des règles strictes. **Toute PR ne respectant pas ces standards verra son intégration retardée.**

### 1. Architecture Clean
Le projet suit strictement l'architecture en couches de l'Oncle Bob (Clean Architecture) :
- **Domain** : Entités et Use Cases. Totalement indépendant d'autres couches. Aucune dépendance à Flutter.
- **Infrastructure** : Datasources (Supabase) et Models (DTOs).
- **Application** : State Management (Riverpod `AsyncNotifier`). Fait le lien entre Presentation et Domain.
- **Presentation** : Widgets et Screens Flutter. 

*Ne contournez jamais cette architecture (ex: N'appelez pas Supabase directement depuis un Widget ou un Controller).*

### 2. State Management (Riverpod)
- Utilisez Riverpod 2.x.
- Privilégiez les `AsyncNotifierProvider` pour gérer les états asynchrones.
- Utilisez `ref.watch()` dans la méthode `build` et `ref.read()` dans les callbacks (comme `onPressed`).

### 3. Qualité du Code & Linting
Nous utilisons les règles de linting strictes de Flutter (`flutter_lints`).
- **Avant toute PR**, assurez-vous que `flutter analyze` retourne `0 issues`.
- Utilisez `const` autant que possible pour optimiser les performances.
- N'utilisez **jamais** de `print()`. Utilisez la classe utilitaire `AppLogger` (`lib/core/utils/logger.dart`).

### 4. Tests
*(Section en cours de développement)* : Si vous ajoutez une nouvelle fonctionnalité métier lourde (ex: un nouveau Use Case), veuillez inclure des tests unitaires correspondants.

### 5. UI et Design System
- N'utilisez pas de couleurs en dur (hardcodées). Utilisez `AppColors` (`lib/core/theme/app_colors.dart`).
- Utilisez les styles typographiques définis dans `AppTypography`.
- L'application supporte nativement le mode Clair et le mode Sombre. Assurez-vous que votre UI s'adapte correctement via `Theme.of(context)`.

## 📤 Processus de Pull Request

1. Assurez-vous que votre code compile et que l'analyse statique est vierge : `flutter analyze`.
2. Documentez vos Use Cases et Controllers avec des commentaires de documentation Dart (`///`).
3. Décrivez clairement les changements dans la description de la PR. Si des changements UI sont impliqués, ajoutez des captures d'écran (Avant/Après).
4. Un membre de l'équipe (ou un bot) fera une revue de code avant de fusionner.

Merci d'aider à faire de ce monde un endroit un peu plus bienveillant, une ligne de code à la fois. ✨
