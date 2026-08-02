---
title: App Icon Setup
date: 2026-08-02
status: approved
---

# App Icon Setup

## Goal
Set app icon Android + iOS menggunakan `assets/images/logo.png` (drop biru).
Adaptive icon Android 8+ dengan foreground transparan.

## Assets
- **Input**: `assets/images/logo.png` (logo asli, tidak diubah)
- **Output**: `assets/launcher_icons/logo_foreground.png` (tetesan biru, bg transparan, 1024×1024)
  - Dihasilkan oleh script (Python Pillow atau Dart `image` package).
  - Trim tepi putih → re-center → zoom ke ~80% canvas.
- **Splash screen**: tidak disentuh, masih pakai `transparent.png`.

## Dependencies
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.4
```

## Konfigurasi
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

## Output
- **Android**: file di `android/app/src/main/res/mipmap-*` + adaptive icon.
- **iOS**: file di `ios/Runner/Assets.xcassets/AppIcon.appiconset/`.
- Tidak ada file di atas.

## Langkah
1. Tambah `flutter_launcher_icons` di `dev_dependencies`.
2. Tulis blok `flutter_launcher_icons` di `pubspec.yaml`.
3. Jalankan `dart run flutter_launcher_icons` (akan fail — belum ada foreground).
4. Generate `logo_foreground.png` via script.
5. Jalankan ulang `dart run flutter_launcher_icons`.
6. Build APK / run di emulator, verifikasi icon muncul.

## Scope
- Hanya setup icon. Tidak ubah splash screen, tidak ubah layout, tidak ubah fitur.
