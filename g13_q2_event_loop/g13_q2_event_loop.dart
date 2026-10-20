import 'dart:async';
import 'dart:isolate';

int heavyWork() {
  int sum = 0;
  for (int i = 0; i < 500000000; i++) {
    sum += i;
  }
  return sum;
}

Future<void> main() async {
  // --- Event loop order ---
  print('1: main starts');
  Future(() => print('4: event queue task'));
  scheduleMicrotask(() => print('3: microtask'));
  print('2: main ends (synchronous code finished)');

  await Future.delayed(const Duration(milliseconds: 100));

  // --- Heavy work in a separate isolate ---
  final result = await Isolate.run(heavyWork);
  print('5: heavy work finished in another isolate: $result');
}
