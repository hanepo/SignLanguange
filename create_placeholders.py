#!/usr/bin/env python3
"""Create placeholder images for sign language gestures"""
from PIL import Image, ImageDraw, ImageFont
import os

# Create assets directory if it doesn't exist
os.makedirs('assets', exist_ok=True)

# Define gestures and their colors
gestures = [
    ('hello.png', 'HELLO', '#FF6B6B'),
    ('thankyou.png', 'THANK YOU', '#4ECDC4'),
    ('yes.png', 'YES', '#95E1D3'),
    ('no.png', 'NO', '#F38181'),
    ('ily.png', 'I LOVE YOU', '#AA96DA'),
    ('eat.png', 'EAT', '#FCBAD3')
]

# Image size
width, height = 200, 200

for filename, text, color in gestures:
    # Create new image with colored background
    img = Image.new('RGB', (width, height), color=color)
    draw = ImageDraw.Draw(img)

    # Add text
    try:
        # Try to use a default font
        font = ImageFont.truetype("arial.ttf", 24)
    except:
        # Fallback to default font
        font = ImageFont.load_default()

    # Calculate text position (centered)
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    x = (width - text_width) // 2
    y = (height - text_height) // 2

    # Draw text
    draw.text((x, y), text, fill='white', font=font)

    # Draw hand icon placeholder (simple rectangle representing a hand)
    hand_y = height - 60
    draw.rectangle([70, hand_y, 130, hand_y + 40], fill='white', outline='#333333', width=2)

    # Save image
    filepath = os.path.join('assets', filename)
    img.save(filepath)
    print(f'Created {filepath}')

print('\nAll placeholder images created successfully!')
