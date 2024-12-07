## Vishisht Dashboard App

The Vishisht Dashboard App is a Flutter-based mobile application designed to showcase a list of posts with infinite scrolling, user authentication, and theming capabilities. Users can view detailed information about posts, toggle between light and dark themes, and log in or out seamlessly.


## Features

- User Authentication: Allows users to log in and out, with their email displayed on the dashboard.
- Infinite Scrolling: Automatically loads more posts as the user scrolls down the list.
- Post Details: Displays detailed information about each post when selected.
- Theming: Supports switching between light and dark modes.
- Responsive UI: A beautiful and user-friendly interface optimized for all screen sizes.


## Getting Started

Follow the steps below to run the app on your local machine.

Prerequisites
Ensure you have the following installed:

- Flutter SDK: Download Flutter
- Dart SDK (included with Flutter)
- Visual Studio Code
- Android Emulator or Physical Device

## Installation Steps
1. Clone the repository:
git clone https://github.com/your-repo/vishisht_project.git
cd vishisht_project

2. Install dependencies:
flutter pub get

3. Run the app:

- For an emulator:
flutter run

## Folder Structure

vishisht_project/
├── lib/
│   ├── screen/              # Screens and UI components
│   ├── bloc/                # BLoC logic for state management
│   ├── constant/            # Constants like colors and styles
│   └── main.dart            # Entry point of the app
├── pubspec.yaml             # Flutter dependencies and assets
└── README.md                # Project documentation

## How It Works

1. Dashboard: Displays a welcome message, a list of posts, and options for theme toggle and logout.
2. Post Details: Tapping on a post opens a detailed view with its title and content.
3. Authentication: Uses SharedPreferences to manage user login sessions.

