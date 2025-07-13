
# Hybrid Timer App ⏱️

A futuristic, wellness-inspired productivity app that blends a **stopwatch** and a **timer** in one seamless experience. Built with **Flutter**, it offers highly customizable modes like Pomodoro, gym intervals, study sprints, and more — with voice interaction and dynamic visuals.

---

## 🌟 Features

- 🕒 **Dual-Mode Core**: Start as a stopwatch, switch to a break timer with one tap or voice command.
- 🧘‍♂️ **Wellness Design**: Dark theme with glowing neon accents and ambient animated blob visuals.
- 🔁 **Customizable Modes**: Includes built-in presets (Pomodoro, Gym, Study...) or create your own.
- 🗣️ **Voice Command Support**: Say "stop" to trigger a break — custom commands supported.
- 🎵 **Audio Cues**: Timed transitions with personalized sound effects.
- ⚙️ **Smart Settings**: break/work duration config, theme and sound preferences.
- 📊 **Stats Page**: Track session history and usage (optional).
- 🛡️ **Offline & Private**: All data stored locally using Hive — no internet required.

---

## 🖥️ Screens

| Screen         | Description                                         |
|----------------|-----------------------------------------------------|
| `Main Timer`   | Core stopwatch/timer with glowing timer and mode selector popup. |
| `Settings`     | Toggle auto mode, edit time ratios, set voice commands, customize UI/sound. |
| `Stats`        | View productivity history, total session time, and mode usage. |

---

## 🎨 Font Choices

### Primary Font – **Sora**

Used for the main timer, large numeric displays, and headers. Clean, futuristic, and geometric.

### Secondary Font – **Manrope**

Used for mode labels (e.g., Pomodoro, Gym), hints, and settings labels. Smooth, rounded, and UI-friendly.

### Flutter Integration Example

```dart
import 'package:google_fonts/google_fonts.dart';

Text(
  '25:00',
  style: GoogleFonts.sora(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
),

Text(
  'Pomodoro',
  style: GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white.withValues(alpha:0.8),
  ),
),
```

---

## 🛠️ Tech Stack

| Component           | Technology              |
|---------------------|--------------------------|
| Framework           | Flutter (Dart)           |
| State Management    | Riverpod                 |
| Local Storage       | Hive                     |
| Voice Recognition   | speech_to_text plugin    |
| Audio Playback      | audioplayers / just_audio |
| UI/Animations       | Custom theming, animated blob |
| Platform Target     | Android (initial)        |

---

## 📦 Installation

```bash
git clone https://github.com/rahim2306/hybrid_timer.git
cd hybrid_timer
flutter pub get
flutter run
```

---

## 🧪 Testing

Coming soon — unit tests for timer logic and settings state.

---

## ✨ Credits

Built by **Abderrahim Hadj Slimane**

---

## 🔮 Future Plans

- Firebase sync for cloud backup  
- Quick access widgets  
- Smartwatch (Wear OS) support  
- Background mode optimization  
- Smart reminders  
