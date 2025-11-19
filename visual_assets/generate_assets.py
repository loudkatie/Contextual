#!/usr/bin/env python3
"""
Visual Asset Generator for Contextual Soul Seed
Generates complete pitch presentation assets
"""

from PIL import Image, ImageDraw, ImageFont, ImageFilter
import math
import random

# Design DNA - Color Palette
COLORS = {
    'pure_white': (255, 255, 255),
    'silver_shimmer': (232, 232, 240),
    'pale_lavender': (230, 230, 250),
    'powder_periwinkle': (224, 244, 255),
    'ghost_white': (248, 248, 255),
}

COLOR_NAMES = {
    'pure_white': ('Pure White', '#FFFFFF'),
    'silver_shimmer': ('Silver Shimmer', '#E8E8F0'),
    'pale_lavender': ('Pale Lavender', '#E6E6FA'),
    'powder_periwinkle': ('Powder Periwinkle', '#E0F4FF'),
    'ghost_white': ('Ghost White', '#F8F8FF'),
}


def add_soft_glow(draw, center, max_radius, color, intensity=0.3):
    """Add a soft radial glow effect"""
    for i in range(max_radius, 0, -2):
        alpha = int(255 * intensity * (1 - i/max_radius))
        glow_color = (*color[:3], alpha)
        draw.ellipse([
            center[0] - i, center[1] - i,
            center[0] + i, center[1] + i
        ], fill=glow_color)


def create_sparkle_particle(x, y, size, color):
    """Create a single sparkle particle"""
    sparkle = Image.new('RGBA', (size*4, size*4), (0, 0, 0, 0))
    draw = ImageDraw.Draw(sparkle)

    # Create diamond shape sparkle
    center = size * 2
    points = [
        (center, center - size),  # top
        (center + size//2, center),  # right
        (center, center + size),  # bottom
        (center - size//2, center),  # left
    ]
    draw.polygon(points, fill=(*color, 200))

    # Add horizontal and vertical lines
    draw.line([(center - size, center), (center + size, center)], fill=(*color, 150), width=1)
    draw.line([(center, center - size), (center, center + size)], fill=(*color, 150), width=1)

    return sparkle


def generate_soul_seed_main():
    """Generate main soul seed visual with ethereal glow"""
    img = Image.new('RGBA', (1200, 1200), COLORS['pure_white'])

    # Create a separate layer for the glow
    glow_layer = Image.new('RGBA', (1200, 1200), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow_layer)

    center = (600, 600)

    # Create multiple glow layers for depth
    # Outer glow - very subtle periwinkle
    for radius in range(400, 200, -10):
        alpha = int(15 * (1 - (radius - 200) / 200))
        color = (*COLORS['powder_periwinkle'], alpha)
        glow_draw.ellipse([
            center[0] - radius, center[1] - radius,
            center[0] + radius, center[1] + radius
        ], fill=color)

    # Middle glow - lavender
    for radius in range(200, 100, -5):
        alpha = int(30 * (1 - (radius - 100) / 100))
        color = (*COLORS['pale_lavender'], alpha)
        glow_draw.ellipse([
            center[0] - radius, center[1] - radius,
            center[0] + radius, center[1] + radius
        ], fill=color)

    # Inner glow - bright white to lavender gradient
    for radius in range(100, 30, -2):
        alpha = int(80 * (1 - (radius - 30) / 70))
        # Gradient from white to lavender
        ratio = (radius - 30) / 70
        r = int(255 * (1 - ratio) + COLORS['pale_lavender'][0] * ratio)
        g = int(255 * (1 - ratio) + COLORS['pale_lavender'][1] * ratio)
        b = int(255 * (1 - ratio) + COLORS['pale_lavender'][2] * ratio)
        color = (r, g, b, alpha)
        glow_draw.ellipse([
            center[0] - radius, center[1] - radius,
            center[0] + radius, center[1] + radius
        ], fill=color)

    # Core - bright white
    glow_draw.ellipse([
        center[0] - 30, center[1] - 30,
        center[0] + 30, center[1] + 30
    ], fill=(255, 255, 255, 255))

    # Apply subtle blur for matte luminosity
    glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(radius=3))

    # Composite the glow onto white background
    img = Image.alpha_composite(img.convert('RGBA'), glow_layer)

    # Add sparkle particles drifting upward
    random.seed(42)  # For consistency
    for i in range(40):
        x = center[0] + random.randint(-200, 200)
        y = center[1] + random.randint(-400, 100)
        size = random.randint(2, 6)

        sparkle = create_sparkle_particle(x, y, size, COLORS['silver_shimmer'])
        img.paste(sparkle, (x - size*2, y - size*2), sparkle)

    img = img.convert('RGB')
    img.save('/home/user/Contextual/visual_assets/soulseed_main.png', 'PNG', quality=95)
    print("✓ Generated soulseed_main.png")


def generate_color_palette():
    """Generate color palette board"""
    img = Image.new('RGB', (1920, 400), COLORS['pure_white'])
    draw = ImageDraw.Draw(img)

    # Try to load a font, fall back to default if not available
    try:
        title_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 36)
        label_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 28)
        hex_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf", 24)
    except:
        title_font = ImageFont.load_default()
        label_font = ImageFont.load_default()
        hex_font = ImageFont.load_default()

    # Title
    title = "Contextual Color Palette"
    draw.text((960, 30), title, fill=(100, 100, 120), font=title_font, anchor="mt")

    # Color swatches
    colors = ['pure_white', 'silver_shimmer', 'pale_lavender', 'powder_periwinkle', 'ghost_white']
    swatch_width = 250
    swatch_height = 200
    spacing = 50
    start_x = (1920 - (swatch_width * 5 + spacing * 4)) // 2
    start_y = 100

    for i, color_key in enumerate(colors):
        x = start_x + i * (swatch_width + spacing)
        y = start_y

        # Draw swatch with subtle border
        color = COLORS[color_key]
        draw.rectangle([x, y, x + swatch_width, y + swatch_height],
                      fill=color, outline=(200, 200, 210), width=2)

        # Add subtle inner shadow for depth
        if color_key != 'pure_white':
            for offset in range(1, 4):
                alpha = 20 - offset * 5
                shadow_color = tuple([max(0, c - alpha) for c in color])
                draw.rectangle([x + offset, y + offset,
                              x + swatch_width - offset, y + swatch_height - offset],
                             outline=shadow_color, width=1)

        # Labels
        name, hex_code = COLOR_NAMES[color_key]
        label_y = y + swatch_height + 20

        # Color name
        draw.text((x + swatch_width//2, label_y), name,
                 fill=(80, 80, 100), font=label_font, anchor="mt")

        # Hex code
        draw.text((x + swatch_width//2, label_y + 40), hex_code,
                 fill=(120, 120, 140), font=hex_font, anchor="mt")

    img.save('/home/user/Contextual/visual_assets/color_palette.png', 'PNG', quality=95)
    print("✓ Generated color_palette.png")


def generate_interaction_flow():
    """Generate three-part interaction flow diagram"""
    img = Image.new('RGB', (1920, 600), COLORS['pure_white'])
    draw = ImageDraw.Draw(img)

    try:
        title_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 32)
        label_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 24)
        desc_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 20)
    except:
        title_font = ImageFont.load_default()
        label_font = ImageFont.load_default()
        desc_font = ImageFont.load_default()

    # Title
    draw.text((960, 40), "Interaction Flow", fill=(100, 100, 120), font=title_font, anchor="mt")

    # Three stages
    stages = [
        ("Watch (Haptic)", "tap tap", 350),
        ("Watch (Glance)", "Katie, I found\nsomething. Now?", 960),
        ("AirPods (Whisper)", "Whispered response", 1570)
    ]

    y_center = 350

    for i, (stage_name, description, x) in enumerate(stages):
        # Draw circle for each stage
        radius = 80
        draw.ellipse([x - radius, y_center - radius, x + radius, y_center + radius],
                    fill=COLORS['pale_lavender'], outline=COLORS['silver_shimmer'], width=3)

        # Stage icons (simplified representations)
        if i == 0:  # Haptic - draw concentric circles
            for r in range(20, 50, 10):
                draw.ellipse([x - r, y_center - r, x + r, y_center + r],
                           outline=COLORS['powder_periwinkle'], width=2)
        elif i == 1:  # Glance - draw mini soul seed
            for r in range(40, 20, -5):
                alpha_val = int(150 * (1 - (r - 20) / 20))
                draw.ellipse([x - r, y_center - r, x + r, y_center + r],
                           fill=COLORS['powder_periwinkle'])
            draw.ellipse([x - 15, y_center - 15, x + 15, y_center + 15],
                       fill=COLORS['pure_white'])
        else:  # Whisper - draw sound waves
            for offset in [-30, 0, 30]:
                draw.arc([x - 50, y_center + offset - 15, x - 10, y_center + offset + 15],
                        start=270, end=90, fill=COLORS['powder_periwinkle'], width=3)

        # Labels
        draw.text((x, y_center + radius + 30), stage_name,
                 fill=(80, 80, 100), font=label_font, anchor="mt")

        # Description
        lines = description.split('\n')
        for j, line in enumerate(lines):
            draw.text((x, y_center + radius + 70 + j * 25), line,
                     fill=(120, 120, 140), font=desc_font, anchor="mt")

        # Draw arrow to next stage
        if i < len(stages) - 1:
            arrow_start_x = x + radius + 20
            arrow_end_x = stages[i + 1][2] - radius - 20
            arrow_y = y_center

            # Arrow line
            draw.line([(arrow_start_x, arrow_y), (arrow_end_x, arrow_y)],
                     fill=COLORS['pale_lavender'], width=3)

            # Arrow head
            draw.polygon([
                (arrow_end_x, arrow_y),
                (arrow_end_x - 20, arrow_y - 10),
                (arrow_end_x - 20, arrow_y + 10)
            ], fill=COLORS['pale_lavender'])

    img.save('/home/user/Contextual/visual_assets/interaction_flow.png', 'PNG', quality=95)
    print("✓ Generated interaction_flow.png")


def generate_watch_mockup():
    """Generate Apple Watch UI mockup"""
    img = Image.new('RGB', (800, 800), COLORS['pure_white'])
    draw = ImageDraw.Draw(img)

    try:
        text_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 24)
        button_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 28)
    except:
        text_font = ImageFont.load_default()
        button_font = ImageFont.load_default()

    # Watch frame (black border, rounded corners approximation)
    watch_outer = 100
    watch_inner = 120
    watch_size = 600

    # Black bezel
    draw.rounded_rectangle([watch_outer, watch_outer, watch_outer + watch_size, watch_outer + watch_size],
                          radius=80, fill=(20, 20, 20))

    # White screen
    draw.rounded_rectangle([watch_inner, watch_inner, watch_inner + watch_size - 40, watch_inner + watch_size - 40],
                          radius=70, fill=COLORS['pure_white'])

    # Mini soul seed at top center
    seed_center_x = 400
    seed_center_y = 250

    # Glow layers
    for radius in range(60, 20, -5):
        alpha = int(100 * (1 - (radius - 20) / 40))
        r = int(255 * (1 - (radius - 20) / 40 * 0.1) - 25)
        g = r
        b = int(255 - (radius - 20) / 40 * 5)
        draw.ellipse([seed_center_x - radius, seed_center_y - radius,
                     seed_center_x + radius, seed_center_y + radius],
                    fill=(r, g, b))

    # Core
    draw.ellipse([seed_center_x - 20, seed_center_y - 20,
                 seed_center_x + 20, seed_center_y + 20],
                fill=COLORS['pure_white'])

    # Message text
    message_lines = [
        "Katie, I found",
        "something for you.",
        "Now?"
    ]

    text_y = 400
    for line in message_lines:
        draw.text((400, text_y), line, fill=(80, 80, 100), font=text_font, anchor="mt")
        text_y += 35

    # Buttons at bottom
    button_y = 600
    button_width = 200
    button_height = 60

    # "Yes" button
    yes_x = 250
    draw.rounded_rectangle([yes_x, button_y, yes_x + button_width, button_y + button_height],
                          radius=30, fill=COLORS['pale_lavender'], outline=COLORS['silver_shimmer'], width=2)
    draw.text((yes_x + button_width//2, button_y + button_height//2), "Yes",
             fill=(80, 80, 100), font=button_font, anchor="mm")

    # "Later" button
    later_x = 450
    draw.rounded_rectangle([later_x, button_y, later_x + button_width, button_y + button_height],
                          radius=30, fill=COLORS['pale_lavender'], outline=COLORS['silver_shimmer'], width=2)
    draw.text((later_x + button_width//2, button_y + button_height//2), "Later",
             fill=(80, 80, 100), font=button_font, anchor="mm")

    img.save('/home/user/Contextual/visual_assets/watch_mockup.png', 'PNG', quality=95)
    print("✓ Generated watch_mockup.png")


def generate_iphone_mockup():
    """Generate iPhone passive state with breathing soul seed"""
    img = Image.new('RGB', (800, 1600), COLORS['pure_white'])
    draw = ImageDraw.Draw(img)

    # iPhone frame outline
    frame_width = 700
    frame_height = 1500
    frame_x = (800 - frame_width) // 2
    frame_y = (1600 - frame_height) // 2

    # Outer frame (black)
    draw.rounded_rectangle([frame_x, frame_y, frame_x + frame_width, frame_y + frame_height],
                          radius=60, fill=(20, 20, 20), width=8)

    # Screen (white)
    screen_inset = 10
    draw.rounded_rectangle([frame_x + screen_inset, frame_y + screen_inset,
                          frame_x + frame_width - screen_inset, frame_y + frame_height - screen_inset],
                          radius=50, fill=COLORS['pure_white'])

    # Large soul seed centered
    center_x = 400
    center_y = 800

    # Create breathing glow effect (multiple states implied by layered glow)
    # Outer breath
    for radius in range(300, 150, -10):
        alpha = int(20 * (1 - (radius - 150) / 150))
        draw.ellipse([center_x - radius, center_y - radius,
                     center_x + radius, center_y + radius],
                    fill=COLORS['powder_periwinkle'])

    # Middle breath
    for radius in range(150, 80, -5):
        alpha = int(40 * (1 - (radius - 80) / 70))
        draw.ellipse([center_x - radius, center_y - radius,
                     center_x + radius, center_y + radius],
                    fill=COLORS['pale_lavender'])

    # Inner glow
    for radius in range(80, 40, -3):
        ratio = (radius - 40) / 40
        r = int(255 - ratio * 25)
        g = int(255 - ratio * 25)
        b = 255
        draw.ellipse([center_x - radius, center_y - radius,
                     center_x + radius, center_y + radius],
                    fill=(r, g, b))

    # Core
    draw.ellipse([center_x - 40, center_y - 40,
                 center_x + 40, center_y + 40],
                fill=COLORS['pure_white'])

    # Add sparkles around it
    random.seed(42)
    for i in range(30):
        angle = random.uniform(0, 2 * math.pi)
        distance = random.randint(200, 350)
        x = int(center_x + math.cos(angle) * distance)
        y = int(center_y + math.sin(angle) * distance)
        size = random.randint(2, 5)

        sparkle = create_sparkle_particle(x, y, size, COLORS['silver_shimmer'])
        img.paste(sparkle, (x - size*2, y - size*2), sparkle)

    img.save('/home/user/Contextual/visual_assets/iphone_mockup.png', 'PNG', quality=95)
    print("✓ Generated iphone_mockup.png")


def generate_sparkle_comparison():
    """Generate three soul seed states with different sparkle patterns"""
    img = Image.new('RGB', (1920, 600), COLORS['pure_white'])
    draw = ImageDraw.Draw(img)

    try:
        title_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 32)
        label_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 28)
    except:
        title_font = ImageFont.load_default()
        label_font = ImageFont.load_default()

    # Title
    draw.text((960, 30), "Sparkle Trail States", fill=(100, 100, 120), font=title_font, anchor="mt")

    states = [
        ("Calm", 400, 12, 150, 0.3),  # name, x, sparkles, radius, speed
        ("Excited", 960, 24, 120, 0.5),
        ("Passionate", 1520, 36, 90, 0.8)
    ]

    random.seed(42)

    for state_name, center_x, num_sparkles, spark_radius, intensity in states:
        center_y = 300

        # Draw soul seed core
        for radius in range(80, 30, -5):
            alpha = int(50 * (1 - (radius - 30) / 50))
            draw.ellipse([center_x - radius, center_y - radius,
                         center_x + radius, center_y + radius],
                        fill=COLORS['pale_lavender'])

        draw.ellipse([center_x - 30, center_y - 30,
                     center_x + 30, center_y + 30],
                    fill=COLORS['pure_white'])

        # Draw sparkle pattern
        for i in range(num_sparkles):
            if state_name == "Calm":
                # Lazy upward spiral
                angle = (i / num_sparkles) * 2 * math.pi
                distance = spark_radius + (i / num_sparkles) * 50
                y_offset = -i * 8
            elif state_name == "Excited":
                # Faster swirling
                angle = (i / num_sparkles) * 4 * math.pi
                distance = spark_radius + math.sin(angle) * 30
                y_offset = -i * 4
            else:  # Passionate
                # Tight whirling
                angle = (i / num_sparkles) * 6 * math.pi
                distance = spark_radius + math.cos(angle * 2) * 20
                y_offset = -i * 2

            x = int(center_x + math.cos(angle) * distance)
            y = int(center_y + math.sin(angle) * distance * 0.5 + y_offset)
            size = max(2, int(6 * (1 - i / num_sparkles)))

            # Add slight lavender edge
            color = COLORS['silver_shimmer']
            if i % 3 == 0:
                color = COLORS['pale_lavender']

            draw.ellipse([x - size, y - size, x + size, y + size], fill=color)

        # Label
        draw.text((center_x, 520), state_name, fill=(80, 80, 100), font=label_font, anchor="mt")

    img.save('/home/user/Contextual/visual_assets/sparkle_comparison.png', 'PNG', quality=95)
    print("✓ Generated sparkle_comparison.png")


def generate_ftue_visual():
    """Generate FTUE journey timeline"""
    img = Image.new('RGB', (800, 1400), COLORS['pure_white'])
    draw = ImageDraw.Draw(img)

    try:
        title_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 36)
        stage_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 28)
        desc_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 22)
    except:
        title_font = ImageFont.load_default()
        stage_font = ImageFont.load_default()
        desc_font = ImageFont.load_default()

    # Title
    draw.text((400, 40), "First Time User Experience", fill=(100, 100, 120), font=title_font, anchor="mt")

    # Timeline stages
    stages = [
        ("Awakening", "A single bright point appears", 200, "point"),
        ("Breathing", "The seed begins to pulse gently", 500, "pulse"),
        ("Permissions", "Location, Motion, Calendar", 800, "checks"),
        ("Promise", "Your companion is ready", 1100, "ready")
    ]

    timeline_x = 400

    for i, (stage_name, description, y, icon_type) in enumerate(stages):
        # Draw connecting line to next stage
        if i < len(stages) - 1:
            next_y = stages[i + 1][2]
            draw.line([(timeline_x, y + 80), (timeline_x, next_y - 80)],
                     fill=COLORS['pale_lavender'], width=3)

        # Draw icon
        icon_radius = 60
        draw.ellipse([timeline_x - icon_radius, y - icon_radius,
                     timeline_x + icon_radius, y + icon_radius],
                    fill=COLORS['pale_lavender'], outline=COLORS['silver_shimmer'], width=3)

        if icon_type == "point":
            # Single bright point
            draw.ellipse([timeline_x - 15, y - 15, timeline_x + 15, y + 15],
                        fill=COLORS['pure_white'])
        elif icon_type == "pulse":
            # Pulsing orb
            for r in range(40, 15, -8):
                draw.ellipse([timeline_x - r, y - r, timeline_x + r, y + r],
                           fill=COLORS['powder_periwinkle'])
            draw.ellipse([timeline_x - 15, y - 15, timeline_x + 15, y + 15],
                        fill=COLORS['pure_white'])
        elif icon_type == "checks":
            # Three checkmarks (simplified)
            for offset_x in [-25, 0, 25]:
                draw.line([(timeline_x + offset_x - 10, y), (timeline_x + offset_x - 5, y + 10)],
                         fill=COLORS['powder_periwinkle'], width=3)
                draw.line([(timeline_x + offset_x - 5, y + 10), (timeline_x + offset_x + 10, y - 15)],
                         fill=COLORS['powder_periwinkle'], width=3)
        else:  # ready
            # Calm breathing orb
            for r in range(35, 15, -7):
                alpha = int(150 * (1 - (r - 15) / 20))
                draw.ellipse([timeline_x - r, y - r, timeline_x + r, y + r],
                           fill=COLORS['pale_lavender'])
            draw.ellipse([timeline_x - 15, y - 15, timeline_x + 15, y + 15],
                        fill=COLORS['pure_white'])

        # Labels
        draw.text((timeline_x + 100, y - 30), stage_name,
                 fill=(80, 80, 100), font=stage_font, anchor="lm")
        draw.text((timeline_x + 100, y + 10), description,
                 fill=(120, 120, 140), font=desc_font, anchor="lm")

    img.save('/home/user/Contextual/visual_assets/ftue_visual.png', 'PNG', quality=95)
    print("✓ Generated ftue_visual.png")


def generate_magic_types():
    """Generate three magic types diagram"""
    img = Image.new('RGB', (1920, 600), COLORS['pure_white'])
    draw = ImageDraw.Draw(img)

    try:
        title_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 36)
        type_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 32)
        desc_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 22)
    except:
        title_font = ImageFont.load_default()
        type_font = ImageFont.load_default()
        desc_font = ImageFont.load_default()

    # Title
    draw.text((960, 40), "Three Types of Magic", fill=(100, 100, 120), font=title_font, anchor="mt")

    types = [
        ("Memories", "Timely recalls of past moments", 400, "layers"),
        ("Perks", "Unexpected delights and discoveries", 960, "sparkle"),
        ("Time", "Perfect moment awareness", 1520, "clock")
    ]

    for type_name, description, center_x, icon_type in types:
        center_y = 300

        # Icon background circle
        icon_radius = 100

        # Gradient circle
        for r in range(icon_radius, 50, -5):
            ratio = (r - 50) / (icon_radius - 50)
            # Gradient from lavender to periwinkle
            color_r = int(COLORS['pale_lavender'][0] * ratio + COLORS['powder_periwinkle'][0] * (1 - ratio))
            color_g = int(COLORS['pale_lavender'][1] * ratio + COLORS['powder_periwinkle'][1] * (1 - ratio))
            color_b = int(COLORS['pale_lavender'][2] * ratio + COLORS['powder_periwinkle'][2] * (1 - ratio))
            draw.ellipse([center_x - r, center_y - r, center_x + r, center_y + r],
                        fill=(color_r, color_g, color_b))

        # Draw icon
        if icon_type == "layers":
            # Layered ghost images
            for offset in [20, 10, 0]:
                alpha_offset = offset
                draw.ellipse([center_x - 40 + offset, center_y - 40 + offset,
                            center_x + 40 + offset, center_y + 40 + offset],
                           outline=COLORS['silver_shimmer'], width=3)
        elif icon_type == "sparkle":
            # Star/sparkle
            # Draw multi-point star
            points = []
            for i in range(8):
                angle = i * math.pi / 4
                if i % 2 == 0:
                    r = 45
                else:
                    r = 20
                x = center_x + int(math.cos(angle) * r)
                y = center_y + int(math.sin(angle) * r)
                points.append((x, y))
            draw.polygon(points, fill=COLORS['silver_shimmer'])
        else:  # clock
            # Clock face
            draw.ellipse([center_x - 45, center_y - 45, center_x + 45, center_y + 45],
                        outline=COLORS['silver_shimmer'], width=4)
            # Hour hand
            draw.line([(center_x, center_y), (center_x + 15, center_y - 25)],
                     fill=COLORS['silver_shimmer'], width=4)
            # Minute hand
            draw.line([(center_x, center_y), (center_x + 30, center_y - 10)],
                     fill=COLORS['silver_shimmer'], width=3)

        # Labels
        draw.text((center_x, center_y + icon_radius + 40), type_name,
                 fill=(80, 80, 100), font=type_font, anchor="mt")
        draw.text((center_x, center_y + icon_radius + 85), description,
                 fill=(120, 120, 140), font=desc_font, anchor="mt")

    img.save('/home/user/Contextual/visual_assets/magic_types.png', 'PNG', quality=95)
    print("✓ Generated magic_types.png")


def generate_architecture():
    """Generate architecture diagram"""
    img = Image.new('RGB', (1920, 1080), COLORS['pure_white'])
    draw = ImageDraw.Draw(img)

    try:
        title_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 36)
        layer_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 28)
        item_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 22)
    except:
        title_font = ImageFont.load_default()
        layer_font = ImageFont.load_default()
        item_font = ImageFont.load_default()

    # Title
    draw.text((960, 40), "Contextual Architecture", fill=(100, 100, 120), font=title_font, anchor="mt")

    # Architecture layers
    layers = [
        {
            "name": "iOS App",
            "items": ["iPhone", "Apple Watch"],
            "y": 150,
            "color": COLORS['powder_periwinkle']
        },
        {
            "name": "Core Services",
            "items": ["Location", "Motion", "Calendar", "Health", "Contacts"],
            "y": 350,
            "color": COLORS['pale_lavender']
        },
        {
            "name": "AI Soul Layer",
            "items": ["Context Engine", "ChatGPT API", "Memory Store"],
            "y": 550,
            "color": COLORS['silver_shimmer']
        },
        {
            "name": "Backend",
            "items": ["Database", "APIs", "Cloud Sync"],
            "y": 750,
            "color": COLORS['ghost_white']
        }
    ]

    box_width = 1400
    box_height = 140
    box_x = (1920 - box_width) // 2

    for i, layer in enumerate(layers):
        y = layer["y"]

        # Draw layer box
        draw.rounded_rectangle([box_x, y, box_x + box_width, y + box_height],
                              radius=15, fill=layer["color"], outline=COLORS['silver_shimmer'], width=2)

        # Layer name
        draw.text((box_x + 50, y + 30), layer["name"],
                 fill=(80, 80, 100), font=layer_font, anchor="lm")

        # Items
        items_y = y + 75
        item_spacing = box_width // (len(layer["items"]) + 1)
        for j, item in enumerate(layer["items"]):
            item_x = box_x + item_spacing * (j + 1)

            # Item box
            item_width = 150
            item_height = 40
            draw.rounded_rectangle([item_x - item_width//2, items_y - item_height//2,
                                   item_x + item_width//2, items_y + item_height//2],
                                  radius=8, fill=COLORS['pure_white'], outline=COLORS['silver_shimmer'], width=1)

            draw.text((item_x, items_y), item, fill=(100, 100, 120), font=item_font, anchor="mm")

        # Draw arrows to next layer
        if i < len(layers) - 1:
            next_y = layers[i + 1]["y"]
            arrow_start_y = y + box_height
            arrow_end_y = next_y

            # Draw three arrows
            for arrow_x in [box_x + box_width//4, box_x + box_width//2, box_x + 3*box_width//4]:
                draw.line([(arrow_x, arrow_start_y + 10), (arrow_x, arrow_end_y - 10)],
                         fill=COLORS['pale_lavender'], width=2)

                # Arrow head
                draw.polygon([
                    (arrow_x, arrow_end_y - 10),
                    (arrow_x - 8, arrow_end_y - 25),
                    (arrow_x + 8, arrow_end_y - 25)
                ], fill=COLORS['pale_lavender'])

    img.save('/home/user/Contextual/visual_assets/architecture.png', 'PNG', quality=95)
    print("✓ Generated architecture.png")


def generate_mood_board():
    """Generate mood board layout guide"""
    img = Image.new('RGB', (1920, 1080), COLORS['pure_white'])
    draw = ImageDraw.Draw(img)

    try:
        title_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 36)
        label_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 20)
    except:
        title_font = ImageFont.load_default()
        label_font = ImageFont.load_default()

    # Title
    draw.text((960, 30), "Mood Board - Visual References", fill=(100, 100, 120), font=title_font, anchor="mt")

    # 3x3 grid
    references = [
        "Fairy wings\n(translucent, delicate)",
        "Dragonfly wing\niridescence",
        "Silver shimmer\neffects",
        "Soft white\nclouds",
        "Moonlight\nthrough silk",
        "Butterfly wing\nscales",
        "Dandelion seed\nwith backlight",
        "Vellum/rice paper\ntexture",
        "Northern lights\n(purple/blue)"
    ]

    cell_width = 600
    cell_height = 320
    margin = 60
    border = 3
    start_x = (1920 - (cell_width * 3 + margin * 2)) // 2
    start_y = 100

    for i, reference in enumerate(references):
        row = i // 3
        col = i % 3

        x = start_x + col * (cell_width + margin)
        y = start_y + row * (cell_height + margin)

        # Draw cell with gradient background
        for offset in range(0, cell_height, 20):
            ratio = offset / cell_height
            color_r = int(COLORS['pure_white'][0] * (1 - ratio) + COLORS['pale_lavender'][0] * ratio)
            color_g = int(COLORS['pure_white'][1] * (1 - ratio) + COLORS['pale_lavender'][1] * ratio)
            color_b = int(COLORS['pure_white'][2] * (1 - ratio) + COLORS['pale_lavender'][2] * ratio)

            draw.rectangle([x, y + offset, x + cell_width, y + offset + 20],
                          fill=(color_r, color_g, color_b))

        # Border
        draw.rectangle([x, y, x + cell_width, y + cell_height],
                      outline=COLORS['silver_shimmer'], width=border)

        # Reference label
        lines = reference.split('\n')
        label_y = y + cell_height // 2 - len(lines) * 15
        for line in lines:
            draw.text((x + cell_width // 2, label_y), line,
                     fill=(100, 100, 120), font=label_font, anchor="mt")
            label_y += 30

    img.save('/home/user/Contextual/visual_assets/mood_board.png', 'PNG', quality=95)
    print("✓ Generated mood_board.png")


def main():
    """Generate all visual assets"""
    print("\n🎨 Generating Contextual Visual Assets...")
    print("=" * 60)

    generate_soul_seed_main()
    generate_color_palette()
    generate_interaction_flow()
    generate_watch_mockup()
    generate_iphone_mockup()
    generate_sparkle_comparison()
    generate_ftue_visual()
    generate_magic_types()
    generate_architecture()
    generate_mood_board()

    print("=" * 60)
    print("✅ All visual assets generated successfully!")
    print("\nFiles saved to: /home/user/Contextual/visual_assets/")
    print("\nGenerated files:")
    print("  • soulseed_main.png (1200x1200)")
    print("  • color_palette.png (1920x400)")
    print("  • interaction_flow.png (1920x600)")
    print("  • watch_mockup.png (800x800)")
    print("  • iphone_mockup.png (800x1600)")
    print("  • sparkle_comparison.png (1920x600)")
    print("  • ftue_visual.png (800x1400)")
    print("  • magic_types.png (1920x600)")
    print("  • architecture.png (1920x1080)")
    print("  • mood_board.png (1920x1080)")


if __name__ == "__main__":
    main()
