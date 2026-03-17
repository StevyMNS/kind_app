# 🕊️ One Kind Message

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-2.x-1C88C6?style=for-the-badge)
![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Clean Architecture](https://img.shields.io/badge/Architecture-Clean-FF9900?style=for-the-badge)

**One Kind Message** est une application minimaliste et contemplative conçue pour propager la bienveillance à travers le monde.

Le concept est simple : écrivez un message positif (une prière, un verset, un encouragement), et envoyez-le anonymement dans le monde. En retour, vous recevez un message écrit par un autre inconnu. 

Pas de likes, pas de commentaires, pas de profils publics. Juste des mots qui font du bien.

## ✨ Fonctionnalités Principales

* **Minimalisme & Sérénité** : Une interface épurée avec un thème "Midnight Blue" et des accents dorés pour encourager la contemplation.
* **100% Anonyme** : Aucune donnée personnelle n'est requise. L'authentification est transparente et silencieuse.
* **Limites de Bien-être** : Pour préserver la valeur de chaque message, l'application limite l'envoi et la réception à **un seul message par jour**.
* **Historique Personnel** : Retrouvez les messages que vous avez envoyés et ceux qui ont illuminé votre journée.
* **Statistiques "Mon Parcours"** : Suivez votre régularité avec un compteur de "Jours Actifs" (Streak).
* **Mode Sombre & Clair** : Transitions douces et support natif du mode sombre.

## 🏗️ Stack Technique

Ce projet est développé avec des standards de production stricts :

* **Framework** : Flutter 3.x
* **State Management** : Riverpod 2.x (AsyncNotifier)
* **Routing** : GoRouter (avec `StatefulShellRoute` pour une navigation BottomBar persistante)
* **Backend as a Service** : Supabase (Authentification Anonyme, Base de données PostgreSQL, Row Level Security)
* **Architecture** : Clean Architecture orientée Feature (Layer-first approach)
* **Code Quality** : Règles de linting strictes et typage fort (null safety).

## 📁 Architecture du Projet

Le projet suit une **Clean Architecture** organisée par couches :

```text
lib/
├── application/       # Riverpod Providers et Controllers (AsyncNotifier)
├── core/              # Composants partagés (Thème, Routeur, Erreurs, Constantes)
├── domain/            # Cœur de métier : Entités, Repositories (interfaces), Use Cases
├── infrastructure/    # Implémentations techniques : DTOs (Models), DataSources, Repositories Impl
├── presentation/      # UI : Écrans et Widgets réutilisables
└── main.dart          # Point d'entrée, initialisation
```

## 🚀 Démarrage Rapide

### Prérequis

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x ou supérieur)
* Un compte [Supabase](https://supabase.com/)

### Installation

1. **Cloner le dépôt**
   ```bash
   git clone https://github.com/votre-organisation/kind_app.git
   cd kind_app
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Configuration de l'environnement**
   Créez un fichier `.env` à la racine du projet en utilisant `.env.example` comme modèle :
   ```env
   SUPABASE_URL=https://votre-projet.supabase.co
   SUPABASE_ANON_KEY=votre_cle_anonyme
   ```

4. **Configuration de Supabase**
   Exécutez les migrations SQL situées dans le dossier `supabase/migrations/` via le Dashboard Supabase ou la CLI Supabase pour créer les tables `users`, `messages`, `deliveries` et configurer le RLS.
   *Assurez-vous également d'activer l'Authentification Anonyme dans les paramètres de votre projet Supabase.*

5. **Lancer l'application**
   ```bash
   flutter run
   ```

## 🤝 Contribution

Nous accueillons chaleureusement les contributions qui respectent la vision minimaliste de l'application !

Veuillez consulter notre fichier [CONTRIBUTING.md](CONTRIBUTING.md) pour découvrir comment configurer votre environnement de développement, nos conventions de code et la marche à suivre pour soumettre une Pull Request.

## 📄 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.
