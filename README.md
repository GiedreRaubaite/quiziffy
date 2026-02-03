# Quizzify App

Quizzify App is a Flutter-based application that allows users to create, manage, and take quizzes. The app leverages AI to generate quiz questions based on user-provided topics or inputs, making quiz creation fast and intuitive.

## Features

- **AI-Powered Quiz Creation**: Generate quiz questions and answers using AI based on a topic or input provided by the user.
- **Quiz Dashboard**: View and manage all created quizzes in one place.
- **Interactive Quiz Taking**: Take quizzes and get instant feedback on your answers.
- **State Management**: Built with Riverpod for efficient and scalable state management.
- **Navigation**: Seamless navigation using GoRouter.

## Getting Started

### Prerequisites
- Flutter SDK installed on your system. [Install Flutter](https://docs.flutter.dev/get-started/install)
- Dart SDK (comes with Flutter).

### Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd quizzify_app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App
To run the app on an emulator or physical device:
```bash
flutter run
```

## Folder Structure

- `lib/core`: Contains core utilities, such as routing and shared configurations.
- `lib/features`: Contains feature-specific code, such as quiz creation and display.

## Technologies Used

- **Flutter**: For building the cross-platform app.
- **Riverpod**: For state management.
- **GoRouter**: For navigation.
- **OpenAI API**: For AI-powered quiz generation.

## Contributing
Contributions are welcome! Feel free to open issues or submit pull requests.

## License
This project is licensed under the MIT License.
