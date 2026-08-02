from PIL import Image

# Load transparent logo
src_path = 'assets/images/logostrasnparent.png'
dst_path = 'assets/launcher_icons/logo_foreground.png'

img = Image.open(src_path).convert('RGBA')

# Scale so logo occupies ~70% of 1024x1024 canvas.
# 70% (not 80%) because source fills canvas edge-to-edge with no padding;
# extra margin keeps it inside adaptive icon safe zone (~66% center).
canvas_size = 1024
logo_size = max(img.width, img.height)
scale = canvas_size * 0.70 / logo_size
new_w = int(img.width * scale)
new_h = int(img.height * scale)
logo_resized = img.resize((new_w, new_h), Image.LANCZOS)

# Center on transparent canvas
canvas = Image.new('RGBA', (canvas_size, canvas_size), (255, 255, 255, 0))
offset_x = (canvas_size - new_w) // 2
offset_y = (canvas_size - new_h) // 2
canvas.paste(logo_resized, (offset_x, offset_y), logo_resized)
canvas.save(dst_path)
print(f"Generated {dst_path} ({new_w}x{new_h} logo on {canvas_size}x{canvas_size})")
