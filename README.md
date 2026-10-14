# Flutter Tricky Questions 🧠

Two ⭐⭐⭐ Flutter questions that look easy but have a hidden trick, like competitive programming problems.

| # | Question | Folder |
|---|----------|--------|
| 1 | Swap the Boxes 🔄 | `swap_boxes/` |
| 2 | The Slow Counter ⏳ | `slow_counter/` |

> ⚠️ **Spoiler warning:** each folder contains the full solution in `lib/main.dart`. Try to solve the question yourself first.

---

## Part 1: Install Flutter (Windows)

Choose **Option A (terminal)** or **Option B (zip file)**. Both give the same result.

### Option A: Install with the terminal (Git)

1. Install Git from https://git-scm.com/download/win (keep the default options).
2. Open PowerShell and run:
   ```powershell
   mkdir C:\src
   cd C:\src
   git clone https://github.com/flutter/flutter.git -b stable
   ```
3. Your Flutter folder is now `C:\src\flutter`. Continue to **Add Flutter to PATH** below.

### Option B: Install with the zip file

1. Go to https://docs.flutter.dev/get-started/install/windows and download the Flutter SDK zip file.
2. Extract it to `C:\src\flutter`. Use a simple path with **no spaces** (do not use `Program Files` or a folder like `New folder (2)`).
3. Check that this file exists: `C:\src\flutter\bin\flutter.bat`
4. Continue to **Add Flutter to PATH** below.

### Add Flutter to PATH

1. Press the **Windows key**, type `environment variables`, and open **Edit the system environment variables**.
2. Click **Environment Variables...**
3. Under **User variables**, select **Path**, then click **Edit**.
4. Click **New** and paste:
   ```
   C:\src\flutter\bin
   ```
5. Click **OK** on all windows.
6. **Close PowerShell completely and open a new one.**

### Check the installation

```powershell
flutter --version
flutter doctor
```

You only need green ticks for **Flutter** and **Chrome**. The red **Android toolchain** item can be ignored, because we run the apps in Chrome.

---

## Part 2: The Questions

### Question 1: Swap the Boxes 🔄

**Difficulty:** ⭐⭐⭐
**Time:** 30 minutes

Build a screen with two boxes side by side: a red box labeled **A** and a blue box labeled **B**. Each box counts how many times it has been tapped and shows the number under its label. Add a **Swap** button below that swaps the two boxes' positions.

**Requirements:**
- Each box is its own `StatefulWidget` that stores its own tap count
- Tapping a box increases only that box's count
- Pressing Swap moves the boxes to each other's positions
- After swapping, each box must still show its own letter, its own color, and its own tap count

**Test cases (your app must pass all):**
1. Tap A three times, so A shows 3. Press Swap. A is now on the right and must still show 3.
2. Tap B once. Press Swap twice. Everything must be back as before, with A = 3 and B = 1.

**Learning Goals:**
- How Flutter decides which widget keeps which `State`
- Understanding why the same code can behave "wrongly" even with no error message
- Using `Key` correctly

---

### Question 2: The Slow Counter ⏳

**Difficulty:** ⭐⭐⭐
**Time:** 30 minutes

Build a two-screen app. The first screen has an "Open Counter" button. The second screen shows a counter (starting at 0) and two buttons:
- **+1**: adds 1 immediately
- **+3 Slowly**: adds 1 to the counter every second, three times in total

**Requirements:**
- The counter must keep its value while the screen is open and the buttons are used
- The app must not show any error or crash in the console in any of the test cases below

**Test cases (your app must pass all):**
1. Press **+3 Slowly** once and wait. The counter must end at exactly 3.
2. Press **+3 Slowly**, and immediately press it again several times. The total must still be exactly 3, not 6 or 9.
3. Press **+3 Slowly**, then immediately press the Back button before 3 seconds pass. There must be no error in the console.
4. Press **+1** five times. The counter must show 5.

**Learning Goals:**
- Where to declare state variables (inside `State`, not inside `build()`)
- `async/await` with `setState()`
- The `mounted` property
- Preventing duplicate actions by disabling a button

---

## Part 3: Create, Run and Test

Do each question in its own project.

### Question 1: Swap the Boxes

**Step 1: Create the project**
```powershell
cd F:\
mkdir "Flutter Question"
cd "Flutter Question"
flutter create swap_boxes
cd swap_boxes
code .
```

**Step 2: Write the code**
Open `lib/main.dart`, press **Ctrl+A**, press **Delete**, paste your solution, and save with **Ctrl+S**. (A working solution is already in `swap_boxes/lib/main.dart` in this repo.)

**Step 3: Run it in Chrome**
```powershell
flutter run -d chrome
```
The first run can take a minute or two.

**Step 4: Test it**
- Test 1: Tap **A** three times, then press **Swap**. A moves to the right and must still show **3**.
- Test 2: Tap **B** once, then press **Swap** twice. A = 3 and B = 1 must be back in their original places.

**Step 5: See the trap (optional)**
1. Delete `key: ValueKey('A'),` and `key: ValueKey('B'),` from the code.
2. Press `R` (capital, hot restart) in the terminal.
3. Tap A three times, tap B once, press Swap.
4. The letters and colors move, but the numbers stay behind. This is the bug. Put the keys back to fix it.

**Why:** Flutter matches widgets to their old `State` by type and position. Both boxes are `CounterBox`, so without keys Flutter keeps each `State` in its old position. A unique `Key` tells Flutter which `State` belongs to which box.

---

### Question 2: The Slow Counter

**Step 1: Create the project**
```powershell
cd "F:\Flutter Question"
flutter create slow_counter
cd slow_counter
code .
```

**Step 2: Write the code**
Open `lib/main.dart`, press **Ctrl+A**, press **Delete**, paste your solution, and save. (A working solution is already in `slow_counter/lib/main.dart` in this repo.)

**Step 3: Run it in Chrome**
```powershell
flutter run -d chrome
```

**Step 4: Test it**
- Test 1: Press **Open Counter**, then **+3 Slowly** once and wait. The counter goes 1, 2, 3 and stops at exactly **3**.
- Test 2: While it is running, click **+3 Slowly** again. The button shows "Running..." and is disabled, so the total stays at 3.
- Test 3: Press **+3 Slowly**, then press the back arrow immediately. The terminal must show **no red error**.
- Test 4: Press **+1** five times. The counter must show **5**.

> Tip: press `R` (capital) in the terminal before each test to reset the counter to 0.

**The 3 tricks:**
1. `int counter = 0;` must be a field of the `State` class. If it is inside `build()`, it resets to 0 on every `setState()`.
2. Use a `running` flag and set `onPressed: null` while running, so several loops cannot start at once.
3. Write `if (!mounted) return;` after every `await`, so `setState()` is never called on a closed screen.

---

## Useful keys while the app is running

| Key | Action |
|-----|--------|
| `r` | Hot reload (keeps state) |
| `R` | Hot restart (resets state) |
| `q` | Quit the app |

## Common problems

- **`flutter` is not recognized:** the PATH is wrong or you did not open a new PowerShell window. Add `C:\src\flutter\bin` and restart PowerShell.
- **Red errors in the editor:** old default code is still in `main.dart`. Delete everything and paste again.
- **No device found:** run `flutter devices`, then use `flutter run -d chrome`.
