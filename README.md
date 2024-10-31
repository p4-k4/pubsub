# pub_sub

A lightweight and efficient state management solution for Flutter, implementing the Publisher-Subscriber pattern with minimal boilerplate.

## Features

- 🪶 Lightweight implementation (less than 100 lines of code)
- 🚀 Zero external dependencies
- 💡 Intuitive API with minimal boilerplate
- ⚡ Efficient updates with automatic subscription management
- 🎯 Type-safe state management
- 📱 Flutter-first design

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  pub_sub: ^1.0.0
```

## Usage

### Basic Counter Example

```dart
// Define your state
class Counter extends Pub {
  int _count = 0;
  
  int get count => get(_count);
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

// Create an instance
final counter = Counter();

// Use in your UI
class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sub(
      (_) => Text('Count: ${counter.count}'),
    );
  }
}
```

### Multiple Subscribers

Multiple widgets can subscribe to the same state:

```dart
Widget build(BuildContext context) {
  return Column(
    children: [
      // First subscriber
      Sub(
        (_) => Text('Count: ${counter.count}'),
      ),
      // Second subscriber
      Sub(
        (_) => Text('Is even: ${counter.count.isEven}'),
      ),
    ],
  );
}
```

## How It Works

`pub_sub` uses a simple yet powerful implementation of the Publisher-Subscriber pattern:

1. `Pub` (Publisher) classes manage state and notify subscribers of changes
2. `Sub` (Subscriber) widgets automatically subscribe to state changes and rebuild when needed
3. Subscriptions are automatically managed - no manual cleanup required

## Best Practices

- Create singleton instances for global state
- Use `notifyListeners()` after state changes
- Keep state logic in `Pub` classes
- Use `Sub` widgets for UI that depends on state

## Comparison with Other Solutions

| Feature | pub_sub | Provider | Riverpod | GetX |
|---------|---------|----------|-----------|------|
| Setup Complexity | Minimal | Moderate | Moderate | Minimal |
| Boilerplate | Very Low | Low | Moderate | Low |
| Learning Curve | Shallow | Moderate | Steep | Moderate |
| Dependencies | None | Few | Several | Many |

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## Author

[Paurini Taketakehikuroa Wiringi](https://gitsub.com/p4-k4)