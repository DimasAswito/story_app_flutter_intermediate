# Story App

A Flutter application for sharing stories, built as an intermediate project. The app allows users to register, log in, view a list of stories, and share their own stories with an image, description, and optional location.

## Features

- **Authentication**: User registration and login functionality.
- **Session Management**: Securely persists user sessions using `shared_preferences`.
- **Declarative Navigation**: Utilizes `go_router` for robust and state-driven navigation.
- **Story Feed**: Displays a list of stories from an API with infinite scrolling pagination.
- **Story Details**: View detailed information for each story.
- **Add New Story**: Users can upload new stories with an image and description.
- **Maps Integration**: 
    - View story locations on a map in the detail page.
    - Pick a location from a map when adding a new story.
    - Get the user's current location.
- **Build Variants (Flavors)**: The app is configured with `free` and `paid` versions:
    - **Free**: Cannot add location data to new stories.
    - **Paid**: Can add location data to new stories.
- **Modern UI**: 
    - Clean user interface following Material Design guidelines.
    - Includes loading indicators, error messages, and empty state messages.
    - Pull-to-refresh functionality on the story list.
- **Code Generation**: Models use `json_serializable` for type-safe and efficient JSON parsing.

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Flutter SDK (version 3.x or higher)
- An editor like Android Studio or VS Code with the Flutter plugin.
- A Google Maps API Key.

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/your-username/story_app_flutter_intermediate.git
   cd story_app_flutter_intermediate
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Add Google Maps API Key:**
   - **For Android**: Open `android/app/src/main/AndroidManifest.xml` and replace `"YOUR_KEY_HERE"` with your Google Maps API Key.
   - **For iOS**: Open `ios/Runner/AppDelegate.swift` and replace `"YOUR_KEY_HERE"` with your Google Maps API Key.

4. **Run Code Generation:**
   This step is necessary to generate the JSON serialization boilerplate code.
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Running the App with Flavors

The application has two different build variants (flavors): `free` and `paid`. You must specify which flavor to run.

--- 

### Free Version

In this version, the user **cannot** add location information when creating a new story.

**Run command:**
```sh
flutter run --flavor free -t lib/main_free.dart
```

--- 

### Paid Version

In this version, the user **can** add location information when creating a new story.

**Run command:**
```sh
flutter run --flavor paid -t lib/main_paid.dart
```
