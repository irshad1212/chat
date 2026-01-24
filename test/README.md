# Test Suite Documentation

This project contains a complete test suite covering the core logic of the application.

## 🧪 Overview

*   **Unit Tests**: Cover Models, DTOs, Repositories, and ViewModels (Notifiers).
*   **Widget Tests**: Verify UI components render correctly and handle interactions.
*   **Integration Tests**: Verify interactions between components.
*   **Coverage**: High test coverage across `chat`, `dictionary`, and `home` modules.

## 📁 Test Structure

```
test/
├── src/
│   ├── chat/
│   │   ├── notifiers/          # ChatNotifier tests
│   │   ├── repository/         # ChatRepository tests
│   │   ├── models/             # ChatMessage model tests
│   │   └── chat_integration_test.dart
│   ├── dictionary/
│   │   ├── notifiers/          # DictionaryNotifier tests
│   │   └── models/             # WordDefinition model tests
│   └── home/
│       ├── views/widgets/      # Widget tests (ChatTile, etc.)
│       └── ...                 # Notifier and repository tests
└── README.md
```

## 🏃 Commands

Run all tests:
```bash
flutter test
```

Run tests for a specific feature (e.g., chat):
```bash
flutter test test/src/chat/
```

Check test coverage:
```bash
flutter test --coverage
```
