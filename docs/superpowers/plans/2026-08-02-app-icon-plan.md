# App Icon Setup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Set app icon Android + iOS from `assets/images/logo.png` with adaptive icon support (foreground transparan).

**Architecture:** Use `flutter_launcher_icons` package. Generate `logo_foreground.png` from `logo.png` using a script (Python Pillow or Dart). Add package, configure, generate foreground, run generator.

**Tech Stack:** Flutter, Python 3 + Pillow (or Dart `image` package), `flutter_launcher_icons`.

## Global Constraints

- Do NOT modify `assets/images/logo.png` (original logo).
- Do NOT touch splash screen (`transparent.png`, splash config).
- `logo_foreground.png` must be 1024x1024 px, transparent background, logo visible and centered.
- Scope: app icon only. No other features changed.

---

### Task 1: Add `flutter_launcher_icons` and Configure

**Files:**
- Modify: `pubspec.yaml` (add dev_dependency + flutter_launcher_icons block)

**Interfaces:**
- Consumes: Existing `pubspec.yaml`.
- Produces: Configured `pubspec.yaml` ready for foreground file.

- [ ] **Step 1: Add dependency**

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.4
```

Insert under existing `dev_dependencies:` block (after other dev_dependencies).

- [ ] **Step 2: Add `flutter_launcher_icons` config block**

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: assets/launcher_icons/logo_foreground.png
  adaptive_icon: true
  adaptive_icon_foreground: assets/launcher_icons/logo_foreground.png
  adaptive_icon_background: "#FFFFFF"
  remove_alpha_ios: true
```

Add at end of `pubspec.yaml`. Verify indentation (2 spaces).

- [ ] **Step 3: Verify config loads**

Run: `flutter pub get && flutter pub deps | findstr /R "launcher"`
Expected: No errors. `[findstr]` filter may vary by shell; manual check if needed.

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml
git commit -m "chore: add flutter_launcher_icons dependency and config"
```

---

### Task 2: Generate `logo_foreground.png` from `logo.png`

**Files:**
- Create: `assets/launcher_icons/logo_foreground.png` (final icon, 1024x1024)
- Create: `tools/gen_foreground.py` (script) — or `tools/gen_foreground.dart` if using Dart. [Option 1: Python Pillow]

**Interfaces:**
- Consumes: `assets/images/logo.png` (original).
- Produces: `assets/launcher_icons/logo_foreground.png` — transparent background with blue drop centered, zoomed to ~80% of canvas.

- [ ] **Step 1: Check Python/Pillow availability**

Run: `python --version && python -c "import PIL; print(PIL.__version__)"`
Expected: Version info printed. If not, fallback to Dart `image` package.

- [ ] **Step 2: Write generation script** (Python)

```python
from PIL import Image
import numpy as np

# Load original logo
src_path = 'assets/images/logo.png'
dst_path = 'assets/launcher_icons/logo_foreground.png'

img = Image.open(src_path).convert('RGBA')
w, h = img.size

# Find bounding box of non-transparent pixels
bbox = img.getbbox()
if bbox:
    left, top, right, bottom = bbox
    cropped = img.crop(bbox)  # remove white margins

# Calculate scale so that logo occupies ~80% of 1024x1024 canvas
canvas_size = 1024
logo_size = max(cropped.width, cropped.height)
scale = canvas_size * 0.8 / logo_size
new_w = int(cropped.width * scale)
new_h = int(cropped.height * scale)
logo_resized = cropped.resize((new_w, new_h), Image.LANCZOS)

# Center on transparent canvas
canvas = Image.new('RGBA', (canvas_size, canvas_size), (255, 255, 255, 0))
offset_x = (canvas_size - new_w) // 2
offset_y = (canvas_size - new_h) // 2
canvas.paste(logo_resized, (offset_x, offset_y), logo_resized)
canvas.save(dst_path)
print(f"Generated {dst_path} ({new_w}x{new_h} logo on {canvas_size}x{canvas_size})")
```

- [ ] **Step 3: Run the script**

```bash
python tools/gen_foreground.py
```

Expected: `assets/launcher_icons/logo_foreground.png` created, ~1024×1024 with blue drop centered.

- [ ] **Step 4: Visual check (optional)**

```bash
# Open the file to verify size and appearance
start assets/launcher_icons/logo_foreground.png
```

- [ ] **Step 5: Commit the script and asset**

```bash
git add tools/gen_foreground.py assets/launcher_icons/logo_foreground.png
git commit -m "feat: generate adaptive icon foreground from logo"
```

---

### Task 3: Run `flutter_launcher_icons` and Verify Output

**Files:**
- Modify: `pubspec.yaml` (already done in Task 1)
- Create: Files written by `flutter_launcher_icons` (Android + iOS icon sets)

**Interfaces:**
- Consumes: `assets/launcher_icons/logo_foreground.png` (Task 2), `pubspec.yaml` block (Task 1).
- Produces: Android `mipmap-*`/`drawable-*` icons, iOS `AppIcon.appiconset` files.

- [ ] **Step 1: Run the generator**

```bash
dart run flutter_launcher_icons
```

Expected: `[Android] Icons created at android/app/src/main/res/mipmap-*/...` and `[iOS] Icons created at ios/Runner/Assets.xcassets/AppIcon.appiconset/...` messages. No errors.

- [ ] **Step 2: Verify output**

```bash
ls android/app/src/main/res/mipmap-*/ic_launcher.* | head -5
ls ios/Runner/Assets.xcassets/AppIcon.appiconset/ic_*.png | head -5
```

Expected: Icon files listed. Sizes vary per density.

- [ ] **Step 3: Commit generated files**

```bash
git add android/app/src/main/res/mipmap-*/ic_launcher.* android/app/src/main/res/drawable-*/*.png ios/Runner/Assets.xcassets/AppIcon.appiconset/*
git commit -m "feat: generate app icons from logo_foreground"
```

---

### Task 4: Build and Visual Verify

**Files:**
- No file changes; purely verification.

**Interfaces:**
- Consumes: Generated icons from Task 3.
- Produces: Working app with correct icon.

- [ ] **Step 1: Build APK (debug)**

```bash
flutter build apk --debug
```

Expected: Build succeeds.

- [ ] **Step 2: Install on emulator or device**

```bash
flutter install --debug
```

Expected: App installs.

- [ ] **Step 3: Visual check**

Check launcher icon on device/emulator: blue drop centered on white background, not clipped or too small.

- [ ] **Step 4: Commit if changes were made**

```bash
git status --porcelain
git add <any changed files>
git commit -m "chore: verify app icon on device"
```
