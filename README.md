# ⚡ Trak Sy Ra

A sleek, modern **task management app** built with Flutter — featuring a neon-accented dark UI, responsive grid layout, and smooth animations.

---

## ✨ Features

- **Add Tasks** — Create tasks with a title and optional description via a smooth bottom sheet
- **Grid Layout** — Responsive card grid that adapts from 2 to 5 columns based on screen size
- **Expandable Cards** — Tap any task card to open a full detail overlay with blur backdrop
- **Mark as Done** — Toggle task completion with animated visual feedback
- **Delete Tasks** — Remove tasks from the grid or expanded view
- **Progress Tracker** — Live progress bar and counter in the header
- **Empty State** — Friendly prompt when no tasks exist
- **Neon UI** — Cyan + purple gradient background with amber accents

---

## 🛠️ Built With

| Technology | Purpose |
|---|---|
| [Flutter](https://flutter.dev) | Cross-platform UI framework |
| Dart | Programming language |
| `dart:ui` | Backdrop blur effects |
| Material Design 3 | UI components |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code
- A connected device or emulator

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/bv-vaibhavi/trak-sy-ra.git

# 2. Navigate into the project
cd trak-sy-ra

# 3. Get dependencies
flutter pub get

# 4. Run the app
flutter run
```

---

## 📁 Project Structure

```
trak_sy_ra/
├── lib/
│   └── main.dart          # All app logic and UI
├── android/               # Android-specific config
├── ios/                   # iOS-specific config
├── pubspec.yaml           # Dependencies & metadata
└── README.md
```

---

## 🎨 Color Palette

| Name | Hex | Usage |
|---|---|---|
| Black | `#000000` | Backgrounds, overlays |
| Navy | `#14213D` | Header, cards |
| Amber | `#FCA311` | Accents, buttons, logo |
| Light | `#E5E5E5` | Subtle text |
| Neon Cyan | `#00F5FF` | Glow effects |
| Neon Purple | `#B400FF` | Gradient tint |

---

## 📐 Responsive Breakpoints

| Screen Width | Grid Columns |
|---|---|
| > 1200px | 5 columns |
| > 900px | 4 columns |
| > 600px | 3 columns |
| ≤ 600px | 2 columns |

---

## 🔮 Planned Features

- [ ] Task categories / labels
- [ ] Due dates and reminders
- [ ] Drag to reorder cards
- [ ] Local storage with Hive or SharedPreferences
- [ ] Dark / light mode toggle
- [ ] Cloud sync

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.

```bash
# Create a new branch
git checkout -b feature/your-feature-name

# Commit your changes
git commit -m "feat: add your feature"

# Push and open a PR
git push origin feature/your-feature-name
```

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Vaibhavi Sharma**  
GitHub: [@bv-vaibhavi](https://github.com/bv-vaibhavi)

---

> _"Track it. Manage it. Conquer it."_ ⚡
