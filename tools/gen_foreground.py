from PIL import Image
import numpy as np

# Load original logo
src_path = 'assets/images/logo.png'
dst_path = 'assets/launcher_icons/logo_foreground.png'

img = Image.open(src_path).convert('RGBA')
w, h = img.size

# Find bounding box of non-transparent pixels
# The logo has a white background. So we want to remove white pixels.
# Let's convert to an array and find bounds where pixels are not white.
data = np.array(img)
# white is [255, 255, 255, 255]
is_not_white = ~((data[:, :, 0] == 255) & (data[:, :, 1] == 255) & (data[:, :, 2] == 255))
coords = np.argwhere(is_not_white)

if coords.size > 0:
    top, left = coords.min(axis=0)
    bottom, right = coords.max(axis=0)
    bbox = (left, top, right, bottom)
    cropped = img.crop(bbox)
else:
    cropped = img

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