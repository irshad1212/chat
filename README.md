# Flutter Chat Application - Machine Test Submission

This project is a submission for the technical machine test. It implements a chat application with additional required features using **Flutter** and **MVVM Architecture**.

## 📌 Features Implemented

*   **Chat Module**: Real-time-like messaging UI with support for text messages, typing indicators, and message status (sent, delivered, seen).
*   **Dictionary Module**: Word lookup functionality with definitions, phonetics, and examples.
*   **Home Module**: User listing with online status and chat history.
*   **Architecture**: Built using **MVVM Architecture** with **Repository Pattern** adhering to **SOLID** principles.
*   **State Management**: **Riverpod** for dependency injection and state management.
*   **MVVM**: Separation of UI and business logic using Notifiers and ViewModels.

## 🛠️ Tech Stack

*   **Flutter**: 3.38.7
*   **Dart**: 3.10.7
*   **State Management**: Riverpod (with `riverpod_generator` & `freezed`)
*   **Testing**: Extensive Unit and Integration tests.

## Project Structure

This project follows a modular **Clean Architecture** approach:

```
lib/
├── core/                   # Shared utilities, theme, and constants
├── data/                   # Data layer (Remote sources)
├── src/                    # Feature modules
│   ├── chat/               # Chat feature (Presentation, Domain, Data)
│   ├── dictionary/         # Dictionary feature
│   └── home/               # Home feature
├── utils/                  # Helper classes
└── main.dart               # App entry point
```

## 🚀 Getting Started

1.  **Clone the repository:**
    ```bash
    git clone [repo_url]
    cd chat
    ```

2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Generate Code:**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the Application:**
    ```bash
    flutter run
    ```

## 🧪 Testing

The project includes a comprehensive test suite covering Models, Repositories, Notifiers, and UI widgets.

**Test Structure:**
```
test/
├── src/
│   ├── chat/           # Unit, integration, and model tests
│   ├── dictionary/     # Notifier and model tests
│   └── home/           # Widget tests (ChatTile, etc.)
└── README.md
```

To run all tests:
```bash
flutter test
```

For more details on testing, check [test/README.md](test/README.md).

## 👨‍💻 Author

**Irshad KP**
- Flutter Developer
