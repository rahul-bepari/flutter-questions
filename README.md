# Flutter Group Assessment: Questions, Answers and Code 🧠

All 13 groups' questions with answers, runnable code, and test steps.

**Our group is Group 6.** Our two ⭐⭐⭐ tricky questions are in `swap_boxes/` and `slow_counter/`.

## Contents

1. [Install Flutter](#part-1-install-flutter-windows)
2. [How to run any code example](#part-2-how-to-run-any-code-example)
3. [Group 6: our questions (Swap the Boxes, The Slow Counter)](#part-3-group-6-our-questions)
4. [Answers for Groups 1 to 5 and 7 to 13](#part-4-answers-to-the-other-groups-questions)

---

## Part 1: Install Flutter (Windows)

Choose **Option A (terminal)** or **Option B (zip file)**.

### Option A: Terminal (Git)
1. Install Git from https://git-scm.com/download/win
2. Open PowerShell and run:
   ```powershell
   mkdir C:\src
   cd C:\src
   git clone https://github.com/flutter/flutter.git -b stable
   ```
3. Flutter is now in `C:\src\flutter`. Continue to "Add Flutter to PATH".

### Option B: Zip file
1. Download the Flutter SDK zip from https://docs.flutter.dev/get-started/install/windows
2. Extract it to `C:\src\flutter` (a path with **no spaces**; avoid `Program Files`).
3. Check that `C:\src\flutter\bin\flutter.bat` exists.

### Add Flutter to PATH
1. Press the Windows key, type `environment variables`, open **Edit the system environment variables**.
2. Click **Environment Variables...**
3. Under **User variables** select **Path**, click **Edit**, then **New**, and paste `C:\src\flutter\bin`.
4. Click **OK** on all windows, then **close PowerShell and open a new one**.

### Check it
```powershell
flutter --version
flutter doctor
```
You only need green ticks for **Flutter** and **Chrome**. The red "Android toolchain" can be ignored because we run in Chrome.

---

## Part 2: How to run any code example

Every example below follows the same steps. Each example gives a **project name** (for example `g2_q1_button`).

```powershell
cd "F:\Flutter Question"
flutter create <project_name>
cd <project_name>
code .
```

1. In VS Code open **`lib/main.dart`**.
2. Press **Ctrl+A**, then **Delete**.
3. Paste the full code from the example and save with **Ctrl+S**.
4. If the example says "add a package", run that command in the terminal first (inside the project folder).
5. Run it:
   ```powershell
   flutter run -d chrome
   ```
6. Test it with the "How to test" steps under the example.

Keys while the app is running: `r` hot reload, `R` hot restart (resets state), `q` quit.

Dart-only examples (no UI) can be pasted into https://dartpad.dev and run with the Run button.

---

## Part 3: Group 6, our questions

> ⚠️ Spoiler: the full solutions are in `swap_boxes/lib/main.dart` and `slow_counter/lib/main.dart`.

### Question 1: Swap the Boxes 🔄
**Difficulty:** ⭐⭐⭐  **Time:** 30 minutes

Build a screen with two boxes side by side: a red box labeled **A** and a blue box labeled **B**. Each box counts how many times it has been tapped and shows the number under its label. A **Swap** button below swaps their positions.

**Requirements:**
- Each box is its own `StatefulWidget` that stores its own tap count
- Tapping a box increases only that box's count
- Swap exchanges the two boxes' positions
- After swapping, each box still shows its own letter, color, and tap count

**Test cases:**
1. Tap A three times (A = 3). Press Swap. A is on the right and must still show 3.
2. Tap B once. Press Swap twice. Everything is back as before, with A = 3 and B = 1.

**Learning goals:** how Flutter decides which widget keeps which `State`; why code can be wrong with no error message; using `Key` correctly.

**The trick:** Flutter matches a widget to its old `State` by **type and position**. Both boxes are `CounterBox`, so without keys the numbers stay behind. Adding `key: ValueKey('A')` and `key: ValueKey('B')` fixes it.

**Run:** project `swap_boxes`, steps in Part 2. Test with the two test cases. To see the bug, delete the two keys, press `R`, and repeat test 1.

### Question 2: The Slow Counter ⏳
**Difficulty:** ⭐⭐⭐  **Time:** 30 minutes

Build a two-screen app. The first screen has an "Open Counter" button. The second screen shows a counter (starting at 0) with two buttons:
- **+1**: adds 1 immediately
- **+3 Slowly**: adds 1 every second, three times in total

**Requirements:**
- The counter keeps its value while the screen is open
- No error or crash in the console in any test case

**Test cases:**
1. Press **+3 Slowly** once and wait. The counter ends at exactly 3.
2. Press **+3 Slowly** and press it again several times quickly. The total is still exactly 3, not 6 or 9.
3. Press **+3 Slowly**, then immediately press Back before 3 seconds. No error in the console.
4. Press **+1** five times. The counter shows 5.

**Learning goals:** where to declare state (inside `State`, not `build()`); `async/await` with `setState()`; the `mounted` property; preventing duplicate actions by disabling a button.

**The 3 tricks:**
1. `int counter = 0;` must be a field of the `State` class, not inside `build()`.
2. Use a `running` flag and `onPressed: null` while running, so loops don't stack.
3. Write `if (!mounted) return;` after every `await`.

**Run:** project `slow_counter`, steps in Part 2. Press `R` before each test to reset the counter.

---

## Part 4: Answers to the other groups' questions

---

# Group 1

## Q1. Declarative routing (Router) vs imperative Navigator

**Answer:**

| | Imperative `Navigator` (1.0) | Declarative `Router` (2.0) |
|---|---|---|
| Idea | You give **commands**: `push`, `pop`. | You describe **what the stack should be** for the current app state. |
| Who owns navigation state | The `Navigator` hides the stack inside itself. | **Your app** owns it (a list of pages), and Flutter rebuilds the stack from it. |
| URL / web support | Weak. The browser URL is not the source of truth. | Strong. The URL (`RouteInformation`) is parsed into app state and back. |
| Deep links, back button | Hard to control. | Handled by `RouteInformationParser` and `RouterDelegate`. |
| Changing the stack | Many separate calls (`push`, `pop`, `pushReplacement`). | Change the state once, and the whole stack updates. |

**Fundamental difference:** with `Navigator.push` the stack is a **side effect of commands**. With `Router` the stack is a **function of state** (`stack = f(state)`), the same way `build()` is a function of state. Pieces: `Router` widget, `RouteInformationParser` (URL to state), `RouterDelegate` (state to a `Navigator` with a `pages` list).

**Example (using the `go_router` package, which wraps the Router API).**
Project: `g1_q1_router`. Add the package first: `flutter pub add go_router`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/details/:id',
      builder: (context, state) =>
          DetailsPage(id: state.pathParameters['id']!),
    ),
  ],
);

void main() => runApp(MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    ));

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/details/5'), // go to a state/URL
          child: const Text('Open details 5'),
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final String id;
  const DetailsPage({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details $id')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: const Text('Back home'),
        ),
      ),
    );
  }
}
```
**How to test:** press the button. In Chrome the address bar changes to `/details/5`. Edit the URL by hand to `/details/9` and the page opens with id 9. This is something imperative `Navigator.push` cannot do easily.

## Q2. StatelessWidget vs StatefulWidget
See **Group 8, Q1** for the full answer and code.

---

# Group 2

## Q1. Button and Interaction

**(a) Purpose of `ElevatedButton`:** it is a Material Design button with a raised look. It shows a label (or icon) and runs the `onPressed` function when the user taps it. If `onPressed` is `null`, the button is disabled.

**(b) Code.** Project: `g2_q1_button`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HelloPage(),
    ));

class HelloPage extends StatefulWidget {
  const HelloPage({super.key});

  @override
  State<HelloPage> createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {
  String message = 'Hello';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Button Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  message = 'Button Pressed';
                });
              },
              child: const Text('Press Me'),
            ),
          ],
        ),
      ),
    );
  }
}
```
**How to test:** the screen shows "Hello". Press the button and the text changes to "Button Pressed".

## Q2. TextField Widget

**(a) Purpose of `TextField`:** it lets the user type text. A `TextEditingController` reads or sets the text, and `onChanged` reports every change. `decoration` adds a label, hint, and border.

**(b) Code.** Project: `g2_q2_textfield`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NamePage(),
    ));

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final TextEditingController controller = TextEditingController();
  String shownName = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TextField Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  shownName = controller.text.trim();
                });
              },
              child: const Text('Show Name'),
            ),
            const SizedBox(height: 20),
            Text(
              shownName.isEmpty ? '' : 'Hello, $shownName!',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
```
**How to test:** type a name, press **Show Name**, and "Hello, <name>!" appears.

---

# Group 3

## Q1. `Form`, `TextFormField`, and `GlobalKey<FormState>`

**Answer:**
- `Form` groups several input fields so they can be **validated and saved together**.
- `TextFormField` is a `TextField` that works inside a `Form` and has a `validator` function. The validator returns an error string (shown under the field) or `null` if the value is valid.
- `GlobalKey<FormState>` is a key attached to the `Form`. It gives access to the `FormState` from outside, so `formKey.currentState!.validate()` runs **all** validators at once and returns `true` only if every field is valid. `save()` and `reset()` work the same way.

Project: `g3_q1_form`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignupPage(),
    ));

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Validation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form is valid')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
**How to test:** press Submit with empty fields and both errors appear. Enter a name and an email containing `@`, press Submit, and "Form is valid" appears.

## Q2. Responsive cards with `LayoutBuilder`

**Answer:** `LayoutBuilder` gives the child's `build` function the **`BoxConstraints`** from its parent (`constraints.maxWidth`). In the code, if `maxWidth` is at least 600 there is enough room, so the two cards go in a `Row` (side by side). Otherwise they go in a `Column` (stacked). When the window is resized, the constraints change, `LayoutBuilder` rebuilds, and the layout switches automatically.

Project: `g3_q2_layoutbuilder`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CardsPage(),
    ));

class InfoCard extends StatelessWidget {
  final String title;
  final Color color;
  const InfoCard({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: SizedBox(
        height: 120,
        child: Center(
          child: Text(title, style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LayoutBuilder')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const card1 = InfoCard(title: 'Card 1', color: Colors.lightBlue);
          const card2 = InfoCard(title: 'Card 2', color: Colors.orange);

          if (constraints.maxWidth >= 600) {
            // Enough width: side by side
            return const Row(
              children: [
                Expanded(child: card1),
                Expanded(child: card2),
              ],
            );
          } else {
            // Small width: vertical
            return const Column(
              children: [card1, card2],
            );
          }
        },
      ),
    );
  }
}
```
**How to test:** run in Chrome with a wide window and the cards are side by side. Drag the window narrower than 600 px and they stack vertically.

## Q3. Dart inheritance: `extends`, `implements`, `with` (unnumbered in the list; appears after Group 3)

**Answer:**

| Keyword | What the subclass gets | What it must override |
|---|---|---|
| `extends` | **Fields and method implementations** of one parent class (single inheritance). | Only abstract members (and anything it wants to change). |
| `implements` | **Nothing.** The class is treated as an *interface*. | **Every** member (fields, getters, methods) of the class. |
| `with` | The fields and methods of one or more **mixins**. | Nothing, unless the mixin declares abstract members. |

**Example (Dart only).** Paste into https://dartpad.dev:
```dart
abstract class Vehicle {
  String name;
  Vehicle(this.name);

  void start() => print('$name starts');   // shared code (inherited by extends)
  void honk();                              // abstract: subclasses MUST override
}

mixin Electric {
  int battery = 100;
  void charge() => print('Charging... battery at $battery%');
}

class Car extends Vehicle with Electric {
  Car() : super('Car');
  @override
  void honk() => print('Car: Beep beep');
}

class Motorcycle extends Vehicle {
  Motorcycle() : super('Motorcycle');
  @override
  void honk() => print('Motorcycle: Vroom');
}

// implements: no code is inherited, so EVERYTHING must be written again
class ToyVehicle implements Vehicle {
  @override
  String name = 'Toy';
  @override
  void start() => print('Toy rolls');
  @override
  void honk() => print('Toy: squeak');
}

void main() {
  final car = Car();
  car.start();
  car.honk();
  car.charge();
  Motorcycle().honk();
  ToyVehicle().start();
}
```
**Output:** `Car starts`, `Car: Beep beep`, `Charging... battery at 100%`, `Motorcycle: Vroom`, `Toy rolls`.

**When to make `Vehicle` abstract instead of a mixin:**
- Make it **abstract** when it describes what something **is** ("a Car *is a* Vehicle"), needs a **constructor** or shared fields like `name`, and defines a template that subclasses must complete. A class can extend only one parent.
- Use a **mixin** for an ability that **unrelated** classes can share ("can charge", "can fly"). Mixins have no constructors, and a class can use many.

---

# Group 4

## Q1. Smart search with debouncing

**(a) What is debouncing:** debouncing waits until the user has **stopped** doing something for a set time before running an action. In search, without it every keystroke ("f", "fl", "flu"...) triggers a search or API call. With a 500 ms debounce, only the final text is searched. This reduces network calls, saves battery and server load, and avoids flickering results.

**(b) Code.** Project: `g4_q1_debounce`

**How `Timer` and `dispose()` work:** on every change we `cancel()` the old timer and start a new 500 ms `Timer`. Only if the user stops typing for 500 ms does the timer fire and run the search. In `dispose()` we cancel any pending timer and dispose the controller. Otherwise the timer could fire after the screen is closed (a leak and an error from `setState` on a removed screen).

**`lib/main.dart`**
```dart
import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchPage(),
    ));

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String _result = 'Type to search';
  int _searchCount = 0;

  void _onChanged(String text) {
    _debounce?.cancel(); // cancel the previous timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // runs only if the user stopped typing for 500 ms
      setState(() {
        _searchCount++;
        _result = 'Searched for: "$text"';
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debounced Search')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: _onChanged,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(_result, style: const TextStyle(fontSize: 20)),
            Text('Searches executed: $_searchCount'),
          ],
        ),
      ),
    );
  }
}
```
**How to test:** type "flutter" quickly and stop. "Searches executed" goes up by **1**, not 7. Type, pause 1 second, type again, and it goes up by 1 each time.

## Q2. Undo and Redo

**(a) Answer:** with `setState()` we keep three things:
- **Current state:** the text now shown in the editor.
- **Undo stack:** a list of earlier texts. On each user change we push the old current text onto it.
- **Redo stack:** texts that were undone. **Undo** moves the current text to the redo stack and pops the undo stack into current. **Redo** does the opposite. Any **new edit clears the redo stack**, because the old "future" no longer exists.

`setState()` tells Flutter to rebuild, so the TextField and the enabled/disabled state of the buttons update.

**(b) Code.** Project: `g4_q2_undo_redo`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditorPage(),
    ));

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final TextEditingController controller = TextEditingController();
  final List<String> undoStack = [];
  final List<String> redoStack = [];
  String current = '';

  void onChanged(String value) {
    setState(() {
      undoStack.add(current); // save the old text
      current = value;
      redoStack.clear();      // a new edit removes the redo history
    });
  }

  void undo() {
    if (undoStack.isEmpty) return;
    setState(() {
      redoStack.add(current);
      current = undoStack.removeLast();
      _showText();
    });
  }

  void redo() {
    if (redoStack.isEmpty) return;
    setState(() {
      undoStack.add(current);
      current = redoStack.removeLast();
      _showText();
    });
  }

  void _showText() {
    controller.text = current;
    controller.selection = TextSelection.collapsed(offset: current.length);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Undo / Redo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              onChanged: onChanged,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Type here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: undoStack.isEmpty ? null : undo,
                  icon: const Icon(Icons.undo),
                  label: const Text('Undo'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: redoStack.isEmpty ? null : redo,
                  icon: const Icon(Icons.redo),
                  label: const Text('Redo'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Undo stack: ${undoStack.length}   Redo stack: ${redoStack.length}'),
          ],
        ),
      ),
    );
  }
}
```
**How to test:** type "abc" (each letter is one step). Press **Undo** and the text becomes "ab". Press **Redo** and it returns to "abc". Undo once, then type a new letter, and Redo becomes disabled (the redo stack was cleared).

---

# Group 5

## Q1. `Text` and `Container`

**(a) Purposes:**
- `Text` displays a string on screen and can be styled with `TextStyle` (size, color, weight).
- `Container` is a box widget used to add **color, size, padding, margin, borders, and alignment** around a child.

**(b) Code.** Project: `g5_q1_container`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Container')),
        body: Center(
          child: Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(24),
            child: const Text(
              'Hello Flutter',
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
          ),
        ),
      ),
    ));
```
**How to test:** a blue box with white "Hello Flutter" appears in the center.

## Q2. `Row` and `Column`

**(a) Difference:** `Row` places children **horizontally** (main axis = left to right). `Column` places children **vertically** (main axis = top to bottom). The cross axis is the other direction. Both use `mainAxisAlignment` and `crossAxisAlignment`.

**(b) Code.** Project: `g5_q2_column`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Column')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('First', style: TextStyle(fontSize: 24)),
              Text('Second', style: TextStyle(fontSize: 24)),
              Text('Third', style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    ));
```
**How to test:** three texts appear one under the other. Change `Column` to `Row` and they line up horizontally.

---

# Group 7

## Q1. Update a product's total price without rebuilding the whole screen

**Answer:** keep the quantity in a `ValueNotifier<int>` and wrap **only the total price widget** in a `ValueListenableBuilder`. When the quantity changes, only that small builder re-runs. The rest of the screen is not rebuilt, because we never call `setState()` on the whole page. (Other options: Provider/Riverpod `Consumer`, or moving the changing part into its own small `StatefulWidget`.)

Project: `g7_q1_price`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CartPage(),
    ));

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const double unitPrice = 25.0;
  final ValueNotifier<int> quantity = ValueNotifier<int>(1);

  @override
  void dispose() {
    quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('WHOLE SCREEN built'); // prints only once
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Product price: \$25', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity.value > 1) quantity.value--;
                  },
                ),
                ValueListenableBuilder<int>(
                  valueListenable: quantity,
                  builder: (context, qty, _) => Text('$qty',
                      style: const TextStyle(fontSize: 24)),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => quantity.value++,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<int>(
              valueListenable: quantity,
              builder: (context, qty, _) {
                debugPrint('Only the TOTAL rebuilt');
                return Text('Total: \$${(qty * unitPrice).toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold));
              },
            ),
          ],
        ),
      ),
    );
  }
}
```
**How to test:** press + and −. The total updates. In the Debug Console "WHOLE SCREEN built" appears **once**, while "Only the TOTAL rebuilt" appears on every change.

## Q2. Checkboxes appear beside the wrong tasks, and `ValueKey`

**Answer:** each task row is a `StatefulWidget` that stores its own checkbox state (`done`) in its `State`. When you delete or reorder items **without keys**, Flutter matches widgets to their old `State` **by type and position**. The row that moves into position 0 receives the old position-0 `State`, so the tick stays at the position and ends up beside the wrong task. This is the same bug as our Group 6 "Swap the Boxes" question.

With `key: ValueKey(task.id)`, Flutter matches by the **unique key**, so each `State` stays with its own task.

Project: `g7_q2_valuekey`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskPage(),
    ));

class Task {
  final int id;
  final String title;
  Task(this.id, this.title);
}

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;
  const TaskTile({super.key, required this.task, required this.onDelete});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool done = false; // this state belongs to the State object

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: done,
        onChanged: (v) => setState(() => done = v!),
      ),
      title: Text(widget.task.title),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: widget.onDelete,
      ),
    );
  }
}

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<Task> tasks = [
    Task(1, 'Buy milk'),
    Task(2, 'Study Flutter'),
    Task(3, 'Call mom'),
    Task(4, 'Go for a walk'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: ListView(
        children: tasks
            .map((t) => TaskTile(
                  key: ValueKey(t.id), // <-- delete this line to see the bug
                  task: t,
                  onDelete: () => setState(() => tasks.remove(t)),
                ))
            .toList(),
      ),
    );
  }
}
```
**How to test:**
1. Tick "Buy milk" (the first task), then delete it.
2. **With the key:** "Study Flutter" is unticked. Correct.
3. **Remove the key line**, press `R`, repeat: "Study Flutter" is now ticked. This is the bug.

## Q3. `Future`, `async`, `await` for API requests, and error handling

**Answer:**
- A `Future` represents a value that will arrive later. `await` pauses **only that function** until the Future completes. Dart's event loop keeps running, so the UI and other tasks are **not blocked** while the network request waits.
- Handle errors with `try / catch / finally`. Also: check `statusCode`, set a `timeout`, and use `mounted` before `setState()`.

Project: `g7_q3_api`. Add the package first, inside the project folder: `flutter pub add http`

**`lib/main.dart`**
```dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ApiPage(),
    ));

class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  bool loading = false;
  String message = 'Press the button';

  Future<void> loadData() async {
    setState(() {
      loading = true;
      message = '';
    });
    try {
      final res = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'))
          .timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) {
        throw Exception('Server error: ${res.statusCode}');
      }
      final data = jsonDecode(res.body);
      if (!mounted) return;
      setState(() => message = data['title']);
    } on TimeoutException {
      if (mounted) setState(() => message = 'Request timed out. Try again.');
    } catch (e) {
      if (mounted) setState(() => message = 'Error: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Future / async / await')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading) const CircularProgressIndicator(),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : loadData,
                child: const Text('Load Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
**How to test:** press **Load Data**. A spinner shows, then a post title appears. To test the error path, turn off your internet and press again. An error message appears and the app does not crash.

---

# Group 8

## Q1. StatelessWidget vs StatefulWidget

**Answer:**

| | `StatelessWidget` | `StatefulWidget` |
|---|---|---|
| Data that changes | No. It is built from its inputs only and is immutable. | Yes. It has a separate `State` object that survives rebuilds. |
| Rebuilds when | The parent gives it new inputs. | The parent changes **or** `setState()` is called. |
| Classes | One class, one `build()`. | Two classes: the widget and its `State`. |
| Examples | `Text`, `Icon`, a fixed title, a profile card. | Counter, checkbox, form, animation, anything that changes after user input. |

**When to use each:** use **Stateless** when the UI depends only on the data passed in. Use **Stateful** when the widget must remember something that changes over time (a counter, a tick, typed text, loaded data).

Project: `g8_stateless_stateful`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

// STATELESS: never changes after it is built
class Greeting extends StatelessWidget {
  final String name;
  const Greeting({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!', style: const TextStyle(fontSize: 24));
  }
}

// STATEFUL: remembers a number that changes
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $count', style: const TextStyle(fontSize: 24)),
        ElevatedButton(
          onPressed: () => setState(() => count++),
          child: const Text('Add 1'),
        ),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stateless vs Stateful')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Greeting(name: 'Rahul'),
            SizedBox(height: 30),
            Counter(),
          ],
        ),
      ),
    );
  }
}
```
**How to test:** the greeting never changes. The counter goes up with every press.

## Q2. How `setState()` works

**Answer:** `setState(() { ... })` does two things:
1. It runs the function you give it, which **changes the variables**.
2. It calls `markNeedsBuild()` on the widget's **Element**, which adds that element to the framework's **dirty list**, and Flutter schedules a new frame.

In the next frame Flutter calls `build()` again **only for dirty elements**, creates new widget descriptions, compares them to the old ones (type and key), and updates only what changed on screen. `setState` does not change the screen directly. It only asks for a rebuild.

**Practical example:** the `Counter` in Q1 above. Pressing the button runs `count++` inside `setState`, Flutter rebuilds `_CounterState`, and the `Text` shows the new number. If you write `count++` **without** `setState`, the variable changes but the screen stays the same.

---

# Group 9

## Q1. StatelessWidget vs StatefulWidget

**(a)** See the table in **Group 8, Q1**.

**(b)** A counter, or a button that changes on the screen when tapped, **must be a `StatefulWidget`**, because:
- the displayed value (or button appearance) **changes over time**, and a `StatelessWidget` is immutable;
- the value must be **remembered** between rebuilds, and the `State` object does that;
- `setState()` is available only in a `State` class, and it triggers the rebuild that shows the new value.

The `Counter` in **Group 8** is the working example: run it and tap the button.

---

# Group 10

## Q1. The "Like" button that never updates

**(a) Why the screen does not update:**
- A `StatelessWidget` is **immutable**. It has no `State` and nothing tells Flutter to rebuild it.
- `likes++` changes a variable, but **no rebuild is triggered**, so `build()` is not called again and the old number stays on screen.
- Even if the widget were rebuilt by its parent, a new instance would reset `likes` to 0, because the variable lives in a short-lived widget and not in a `State`.

**Broken code (for demonstration):**
```dart
class LikeButton extends StatelessWidget {
  LikeButton({super.key});
  int likes = 0; // never updates the screen

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => likes++,
      child: Text('Likes: $likes'),
    );
  }
}
```

**(b) Fixed code.** Project: `g10_q1_like`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: LikeButton())),
    ));

class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  int likes = 0; // lives in the State, so it survives rebuilds

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          likes++;
        });
      },
      icon: const Icon(Icons.thumb_up),
      label: Text('Likes: $likes'),
    );
  }
}
```
**How to test:** every tap increases the number on the button.

**(c) What `setState()` does behind the scenes, and why not inside `build()`:**
- `setState()` runs your function, then calls `markNeedsBuild()` on the Element, puts it in the dirty list, and schedules a frame. The next frame calls `build()` for the dirty element and updates the screen.
- Calling `setState()` **inside `build()`** is a mistake because it asks for **another rebuild while a build is already running**. That causes an infinite loop of rebuilds, or Flutter throws the error *"setState() or markNeedsBuild() called during build"*. `build()` must be a **pure function** that only describes the UI. Put `setState()` in event handlers like `onPressed`.

## Q2. `RenderFlex overflowed` in a Row

**(a) Why it happens:** Flutter's layout rule is **"constraints go down, sizes go up, parent sets position."**
1. The `Row` receives constraints from its parent: a maximum **width** equal to the screen width.
2. A `Row` gives each non-flexible child **unbounded width** (it lets them be as wide as they want).
3. The `CircleAvatar` reports its size, and the long `Text` reports a size equal to the **full length of the text on one line**, which is wider than the screen.
4. The sum of the children's widths is greater than the `Row`'s maximum width, so the parent cannot place them all inside its box, and Flutter paints the yellow-and-black overflow stripes.

**Broken code (for demonstration):**
```dart
Row(
  children: [
    CircleAvatar(radius: 30, child: Icon(Icons.person)),
    SizedBox(width: 12),
    Text('A very long bio ... ' * 5),
  ],
)
```

**(b) Two ways to fix it.** Project: `g10_q2_overflow`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    ));

const String bio =
    'I am a computer science student who loves building apps with Flutter. '
    'I enjoy solving problems, learning new tools, and sharing what I learn '
    'with my classmates.';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Overflow fixes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fix 1: Expanded around the Text',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(radius: 30, child: Icon(Icons.person)),
                SizedBox(width: 12),
                Expanded(child: Text(bio)), // text now wraps to the free width
              ],
            ),
            const SizedBox(height: 32),
            const Text('Fix 2: Change the layout (Column)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 30, child: Icon(Icons.person)),
                SizedBox(height: 12),
                Text(bio), // a Column gives the text the full width
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```
**How to test:** make the Chrome window narrow. There are no stripes and the text wraps. To see the original bug, replace the `Expanded(child: Text(bio))` line with `Text(bio)` and the stripes appear.

**(c) `Expanded` vs `Flexible`:**

| | `Expanded` | `Flexible` |
|---|---|---|
| Fit | **Tight:** the child **must fill** its share of the free space. | **Loose** by default: the child **can be smaller**, but not bigger, than its share. |
| Equivalent to | `Flexible(fit: FlexFit.tight)` | `Flexible(fit: FlexFit.loose)` |
| Use when | You want the child to **take all remaining space** (a text field next to an icon, equal-width columns). | You want the child to **shrink-to-fit but never overflow** (a short label that should not stretch). |

Both accept `flex` to share space in proportion (for example `flex: 2` gets twice the space of `flex: 1`).

---

# Group 11

## Q1. StatelessWidget vs StatefulWidget, and when to choose StatefulWidget
See **Group 8, Q1**. Choose `StatefulWidget` when the widget must **remember and change data over time**, for example a counter, a checkbox, a form, or an animation. Run the code in Group 8.

## Q2. Purpose of `setState()` and what happens under the hood
See **Group 8, Q2** and **Group 10, Q1 (c)**.

**Short version:** `setState()` runs your update function, marks the widget's Element as **dirty** (`markNeedsBuild`), and schedules a new frame. In that frame Flutter calls `build()` on dirty elements, compares the new widgets with the old ones, and repaints only what changed.

---

# Group 12

## Q1. `Image.asset()` vs `Image.network()`

**Answer:**

| | `Image.asset()` | `Image.network()` |
|---|---|---|
| Source | A file **bundled inside the app** | A **URL** on the internet |
| Setup | Add the file to an `assets/` folder and list it in `pubspec.yaml` | Nothing to declare (needs internet, and on Android the INTERNET permission is already in debug builds) |
| Internet needed | No. Works **offline**. | Yes |
| Speed | Fast, always available | Depends on the connection. Show a loading and error state. |
| App size | Makes the app larger | No effect on app size |
| Use for | Logos, icons, onboarding pictures that never change | User photos, product images, content that changes |

Project: `g12_q1_images`

**For the asset image:** create a folder `assets` in the project root (next to `lib`), put a picture named `logo.png` in it, then open **`pubspec.yaml`** and add (keep the same indentation as `uses-material-design`, and it must be under the `flutter:` section):
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/logo.png
```
Then run `flutter pub get`.

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImagePage(),
    ));

class ImagePage extends StatelessWidget {
  const ImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image.asset vs Image.network')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Image.asset (works offline)'),
            const SizedBox(height: 8),
            Image.asset(
              'assets/logo.png',
              height: 120,
              errorBuilder: (context, error, stack) =>
                  const Text('Add assets/logo.png and list it in pubspec.yaml'),
            ),
            const SizedBox(height: 32),
            const Text('Image.network (needs internet)'),
            const SizedBox(height: 8),
            Image.network(
              'https://flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png',
              height: 120,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const CircularProgressIndicator();
              },
              errorBuilder: (context, error, stack) =>
                  const Text('Could not load the image'),
            ),
          ],
        ),
      ),
    );
  }
}
```
**How to test:** both images show. Turn off the internet and refresh: the asset image stays and the network image shows "Could not load the image".

## Q2. Content cut off on a smaller phone (responsive UI)

**Answer:** the problem is usually **fixed sizes** (fixed `width`/`height`, a long `Row`, or content taller than the screen). Techniques:

| Technique | How it helps |
|---|---|
| `Expanded` / `Flexible` | Children share the available space instead of using a fixed size. |
| `SingleChildScrollView` / `ListView` | Content taller than the screen **scrolls** instead of being cut off. |
| `Wrap` | Items **move to the next line** when there is no space. |
| `LayoutBuilder` | Reads the parent's constraints and **switches layout** (for example Row to Column). |
| `MediaQuery` | Reads the screen width/height/orientation to choose sizes. |
| `FittedBox`, `AspectRatio` | Scales a child to fit, or keeps its proportions. |

Project: `g12_q2_responsive`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResponsivePage(),
    ));

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Width: ${screenWidth.toStringAsFixed(0)} px')),
      // 1) SingleChildScrollView: tall content scrolls instead of being cut off
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2) LayoutBuilder: Row on wide screens, Column on narrow screens
            LayoutBuilder(
              builder: (context, constraints) {
                final panels = [
                  Container(
                      height: 100,
                      color: Colors.lightBlue,
                      alignment: Alignment.center,
                      child: const Text('Panel 1')),
                  Container(
                      height: 100,
                      color: Colors.orange,
                      alignment: Alignment.center,
                      child: const Text('Panel 2')),
                ];
                if (constraints.maxWidth > 600) {
                  return Row(
                    children: panels.map((p) => Expanded(child: p)).toList(),
                  );
                }
                return Column(children: panels);
              },
            ),
            const SizedBox(height: 24),
            // 3) Wrap: chips flow to the next line when space runs out
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                12,
                (i) => Chip(label: Text('Chip ${i + 1}')),
              ),
            ),
            const SizedBox(height: 24),
            // 4) More content than the screen height: scrolls thanks to (1)
            ...List.generate(
              10,
              (i) => ListTile(title: Text('Item ${i + 1}')),
            ),
          ],
        ),
      ),
    );
  }
}
```
**How to test:** resize the Chrome window. The panels switch between side by side and stacked, the chips wrap, and the page scrolls. Nothing is cut off.

---

# Group 13

## Q1. `InheritedWidget` and efficient `BuildContext` lookup

**Role of `InheritedWidget`:** it **shares data down the widget tree** so any descendant can read it without passing it through every constructor. When the data changes, only the descendants that **depend on it** are rebuilt. `Theme`, `MediaQuery`, and Provider are built on it.

**How the lookup is efficient (no walking the whole tree):**
- Every `Element` keeps a **map** (`_inheritedElements`) from widget **type** to the nearest `InheritedElement` of that type above it.
- A parent **passes this map to its children** when they are mounted, adding its own entry if it is an `InheritedWidget`.
- `context.dependOnInheritedWidgetOfExactType<T>()` therefore does a **hash map lookup in O(1)** by type, not a search up the tree.
- The call also **registers the calling element as a dependent**. When the `InheritedWidget` is rebuilt and `updateShouldNotify` returns `true`, only the registered dependents are rebuilt.
- Use `getInheritedWidgetOfExactType` (or `context.read`-style access) to read **without** registering a dependency.

Project: `g13_q1_inherited`

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

// 1) The InheritedWidget that holds shared data
class AppColor extends InheritedWidget {
  final Color color;

  const AppColor({super.key, required this.color, required super.child});

  // Read it from any descendant (a map lookup, not a tree walk)
  static AppColor of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppColor>();
    assert(result != null, 'No AppColor found above this context');
    return result!;
  }

  // Rebuild dependents only when the color really changed
  @override
  bool updateShouldNotify(AppColor oldWidget) => color != oldWidget.color;
}

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Root(),
    ));

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  Color color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return AppColor(
      color: color,
      child: Scaffold(
        appBar: AppBar(title: const Text('InheritedWidget')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DeepChild(), // reads the color without constructor passing
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => setState(() {
                  color = color == Colors.blue ? Colors.red : Colors.blue;
                }),
                child: const Text('Change color'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeepChild extends StatelessWidget {
  const DeepChild({super.key});

  @override
  Widget build(BuildContext context) {
    final Color c = AppColor.of(context).color; // registers a dependency
    return Container(width: 120, height: 120, color: c);
  }
}
```
**How to test:** press **Change color**. The box changes color although `DeepChild` has no color in its constructor.

## Q2. Event loop, microtask queue, `Future` vs `Isolate`

**Event loop and queues:** Dart runs your code in **one thread per isolate**. After `main()` finishes, the event loop runs:
1. The **microtask queue** first. It holds very short tasks (`scheduleMicrotask`, `Future.microtask`, and the continuation after an already-completed `await`). **All** microtasks are drained before anything else.
2. Then **one task from the event queue** (timers, I/O, `Future(...)`, user taps, network responses).
3. After each event, the microtasks queue is drained again, and the loop repeats.

So the order is: synchronous code, then all microtasks, then events.

**`Future` vs `Isolate`:**

| | `Future` / `async-await` | `Isolate` |
|---|---|---|
| Thread | The **same isolate** and thread, only **scheduled** later | A **separate isolate**, running in parallel (its own memory and event loop) |
| Good for | Waiting for I/O: network, files, timers | **Heavy CPU work**: JSON parsing of huge data, image processing, encryption |
| Heavy computation | **Still blocks the UI**, because the work runs on the same thread | **UI stays smooth**, because the work runs elsewhere |
| Memory | Shared | **Not shared.** Data is passed by messages (copied or transferred). |

Key point: `async/await` gives **concurrency** (do other things while waiting), not **parallelism**. A long `for` loop inside an `async` function still freezes the UI.

**Code (Dart only).** Paste into https://dartpad.dev or run `dart run`:
```dart
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
```
**Expected output order:** `1`, `2`, `3` (microtask first), `4` (event queue), then `5`.

In Flutter, use `compute(heavyWork, ...)` or `Isolate.run(...)` for heavy work so the UI keeps running at 60 fps.

---

## Common problems

- **`flutter` is not recognized:** add `C:\src\flutter\bin` to PATH and open a **new** PowerShell window.
- **Red errors in the editor:** old default code is still in `main.dart`. Delete everything and paste again.
- **Package error (`http`, `go_router`):** run `flutter pub add <package>` inside the project folder.
- **No device found:** run `flutter devices`, then use `flutter run -d chrome`.
