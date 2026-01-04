#!/bin/bash
# Generate simple PNG icon using ImageMagick or fallback method
SIZE=1024
BG_COLOR="#4A90E2"

if command -v convert &> /dev/null; then
  # Create base icon with background
  convert -size ${SIZE}x${SIZE} xc:"$BG_COLOR" app_icon.png
  
  # Draw checkmark using imagemagick
  convert app_icon.png -stroke white -strokewidth 60 \
    -draw "path 'M 320,512 L 448,640 L 704,384'" \
    -stroke white -strokewidth 30 \
    -draw "line 320,240 704,240" \
    -draw "line 320,320 576,320" \
    -draw "line 320,400 640,400" \
    -fill "#FFD700" -draw "circle 800,224 800,248" \
    -draw "circle 832,256 832,272" \
    -draw "circle 768,256 768,272" \
    app_icon.png
  
  echo "Icon created with ImageMagick"
else
  echo "ImageMagick not found. Please install it or use the Python script with Pillow."
  exit 1
fi
