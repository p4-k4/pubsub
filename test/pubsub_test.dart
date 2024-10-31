import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubsub/pubsub.dart';

// Test state class
class Counter extends Pub {
  int _count = 0;
  int get count => get(_count);

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}

void main() {
  group('Publisher Tests', () {
    late Counter counter;

    setUp(() {
      counter = Counter();
    });

    test('initial state is correct', () {
      expect(counter.count, 0);
    });

    test('increment updates state', () {
      counter.increment();
      expect(counter.count, 1);
    });

    test('decrement updates state', () {
      counter.decrement();
      expect(counter.count, -1);
    });

    test('multiple updates work correctly', () {
      counter.increment();
      counter.increment();
      counter.decrement();
      expect(counter.count, 1);
    });
  });

  group('Subscriber Widget Tests', () {
    late Counter counter;

    setUp(() {
      counter = Counter();
    });

    testWidgets('subscriber rebuilds when state changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Sub(
            (_) => Text('Count: ${counter.count}'),
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);

      counter.increment();
      await tester.pump();
      expect(find.text('Count: 1'), findsOneWidget);

      counter.decrement();
      await tester.pump();
      expect(find.text('Count: 0'), findsOneWidget);
    });

    testWidgets('multiple subscribers update independently', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              Sub(
                (_) => Text('Count: ${counter.count}'),
              ),
              Sub(
                (_) => Text('Square: ${counter.count * counter.count}'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);
      expect(find.text('Square: 0'), findsOneWidget);

      counter.increment();
      await tester.pump();
      expect(find.text('Count: 1'), findsOneWidget);
      expect(find.text('Square: 1'), findsOneWidget);

      counter.increment();
      await tester.pump();
      expect(find.text('Count: 2'), findsOneWidget);
      expect(find.text('Square: 4'), findsOneWidget);
    });

    testWidgets('subscriber properly disposes listeners', (tester) async {
      final listenerCountBefore = counter.hasListeners;

      await tester.pumpWidget(
        MaterialApp(
          home: Sub(
            (_) => Text('Count: ${counter.count}'),
          ),
        ),
      );

      expect(counter.hasListeners, true);

      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(),
        ),
      );

      expect(counter.hasListeners, false);
      expect(counter.hasListeners, equals(listenerCountBefore));
    });
  });

  group('Edge Cases', () {
    late Counter counter;

    setUp(() {
      counter = Counter();
    });

    testWidgets('subscriber handles rapid state changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Sub(
            (_) => Text('Count: ${counter.count}'),
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);

      // Rapid state changes
      counter.increment();
      counter.increment();
      counter.increment();
      await tester.pump();
      expect(find.text('Count: 3'), findsOneWidget);
    });

    testWidgets('subscriber handles removed and re-added widgets',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Sub(
            (_) => Text('Count: ${counter.count}'),
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);

      // Remove widget
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(),
        ),
      );

      // Add widget back
      await tester.pumpWidget(
        MaterialApp(
          home: Sub(
            (_) => Text('Count: ${counter.count}'),
          ),
        ),
      );

      counter.increment();
      await tester.pump();
      expect(find.text('Count: 1'), findsOneWidget);
    });

    test('publisher handles multiple listeners', () {
      final listeners = List.generate(3, (_) => () {});

      for (final listener in listeners) {
        counter.addListener(listener);
      }

      expect(counter.hasListeners, true);

      for (final listener in listeners) {
        counter.removeListener(listener);
      }

      expect(counter.hasListeners, false);
    });
  });

  group('Error Handling', () {
    late Counter counter;

    setUp(() {
      counter = Counter();
    });

    testWidgets('subscriber handles errors in builder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Sub(
            (_) => throw Exception('Test error'),
          ),
        ),
      );

      expect(tester.takeException(), isException);
    });

    testWidgets('subscriber handles null context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Sub(
            (_) => const Text('Test'),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });
  });
}
