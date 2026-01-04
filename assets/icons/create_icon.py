#!/usr/bin/env python3
"""
Simple script to create app icon from SVG description
Creates a PNG icon with TaskFlow AI branding
"""
from PIL import Image, ImageDraw, ImageFont
import os

# Create 1024x1024 icon
size = 1024
icon = Image.new('RGB', (size, size), color='#4A90E2')
draw = ImageDraw.Draw(icon)

# Draw checkmark (simplified path)
center_x, center_y = size // 2, size // 2
check_points = [
    (center_x - 192, center_y),
    (center_x - 64, center_y + 128),
    (center_x + 192, center_y - 128),
]

# Draw thick checkmark
for i in range(len(check_points) - 1):
    x1, y1 = check_points[i]
    x2, y2 = check_points[i + 1]
    # Draw multiple lines to make it thick
    for offset in range(-40, 41, 4):
        draw.line([x1 + offset, y1, x2 + offset, y2], fill='white', width=8)

# Draw task list lines above
y_start = center_y - 272
draw.line([center_x - 192, y_start, center_x + 192, y_start], fill='white', width=20)
draw.line([center_x - 192, y_start + 80, center_x, y_start + 80], fill='white', width=20)
draw.line([center_x - 192, y_start + 160, center_x + 64, y_start + 160], fill='white', width=20)

# Draw AI sparkles
sparkle_positions = [
    (center_x + 288, y_start - 128, 24),
    (center_x + 320, y_start - 96, 16),
    (center_x + 256, y_start - 96, 16),
]
for x, y, radius in sparkle_positions:
    draw.ellipse([x - radius, y - radius, x + radius, y + radius], fill='#FFD700')

# Save icon
output_path = os.path.join(os.path.dirname(__file__), 'app_icon.png')
icon.save(output_path, 'PNG')
print(f"Icon created: {output_path}")

# Also create foreground version (just the icon elements, no background)
foreground = Image.new('RGBA', (size, size), color=(0, 0, 0, 0))
fg_draw = ImageDraw.Draw(foreground)

# Redraw checkmark on transparent background
for i in range(len(check_points) - 1):
    x1, y1 = check_points[i]
    x2, y2 = check_points[i + 1]
    for offset in range(-40, 41, 4):
        fg_draw.line([x1 + offset, y1, x2 + offset, y2], fill='white', width=8)

# Draw task list lines
fg_draw.line([center_x - 192, y_start, center_x + 192, y_start], fill='white', width=20)
fg_draw.line([center_x - 192, y_start + 80, center_x, y_start + 80], fill='white', width=20)
fg_draw.line([center_x - 192, y_start + 160, center_x + 64, y_start + 160], fill='white', width=20)

# Draw sparkles
for x, y, radius in sparkle_positions:
    fg_draw.ellipse([x - radius, y - radius, x + radius, y + radius], fill='#FFD700')

foreground_path = os.path.join(os.path.dirname(__file__), 'app_icon_foreground.png')
foreground.save(foreground_path, 'PNG')
print(f"Foreground icon created: {foreground_path}")

