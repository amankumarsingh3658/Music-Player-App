Music Player App
A cross-platform music player application built using Flutter with MVVM architecture, Riverpod for state management, Hive for local storage, and FastAPI with PostgreSQL for the backend. The app features a sleek dark theme for a modern user experience.

Features
Music Playback: Stream and play local or remote music files.

Playlist Management: Create, edit, and delete playlists.

Offline Support: Music playback even without an internet connection.

Dark Theme: Modern, consistent dark theme for night-time usage.

Backend API: Built with FastAPI to handle music data and playlists.

State Management: Managed by Riverpod for scalability and efficiency.

Database: Hive for local storage and PostgreSQL for storing user data and music metadata.
Tech Stack

Flutter: Cross-platform framework for mobile, web, and desktop apps.

FastAPI: Web framework for building APIs.

PostgreSQL: Relational database for storing user and music data.

Hive: Lightweight key-value store for local storage in Flutter.

Riverpod: Robust and flexible state management solution.

MVVM: Clean architecture pattern for maintainable code.

Generators: For automatic code generation to reduce boilerplate.

Architecture:-

MVVM Pattern
The app follows the MVVM architecture:

Model: Data structures for music, playlists, and users.

View: UI components displaying data.

ViewModel: Handles data transformation and state management.

State Management with Riverpod

StateProvider for managing simple states (e.g., current track, theme).

FutureProvider and StreamProvider for asynchronous data fetching.

Database & Local Storage

Hive is used for offline storage of music data and preferences.

PostgreSQL stores persistent data like user information and music metadata on the server.

Backend (FastAPI)

The backend, built with FastAPI, handles:

User authentication (login/signup).

Managing music metadata and playlists.

Serving music files and data to the Flutter app.

Dark Theme

The app features a dark theme, with a toggle for user preference, ensuring a consistent experience throughout.
