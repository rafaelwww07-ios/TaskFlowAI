# App Icon Generation

To generate the app icons, you need to create PNG files from the SVG or use the provided scripts.

## Option 1: Use Python with Pillow
```bash
pip install Pillow
python3 create_icon.py
```

## Option 2: Use ImageMagick
```bash
./generate_icon.sh
```

## Option 3: Manual creation
1. Open `app_icon.svg` in a graphics editor (Inkscape, Figma, etc.)
2. Export as PNG at 1024x1024 resolution
3. Save as `app_icon.png`
4. For adaptive icon, export foreground elements only as `app_icon_foreground.png`

## After creating icons, run:
```bash
flutter pub get
dart run flutter_launcher_icons
```

