# Assets Folder Structure

bmi_calculator/
│
├── assets/
│   ├── fonts/
│   │   ├── Poppins-Regular.ttf
│   │   ├── Poppins-Bold.ttf
│   │   └── Poppins-SemiBold.ttf
│   │
│   ├── icons/
│   │   ├── bmi_icon.png
│   │   ├── male_icon.png
│   │   └── female_icon.png
│   │
│   └── images/
│       └── splash_bg.png
│
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   └── result_screen.dart
│   └── widgets/
│       ├── gender_selector.dart
│       ├── height_slider.dart
│       └── number_input_card.dart
│
└── pubspec.yaml

---

## Fonts Used
- **Poppins** (Google Fonts) — downloaded via google_fonts package
  - Regular (400)
  - SemiBold (600)
  - Bold (700)

## Icons Used
- Flutter built-in Material Icons (no extra asset needed)
  - Icons.monitor_weight_outlined
  - Icons.arrow_back_ios
  - Icons.refresh
  - Icons.male
  - Icons.female

## Note
Fonts are loaded via the `google_fonts` package (internet connection required on first run).
No manual font file download needed if using the package approach.
