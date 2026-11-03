import os
import math
from PIL import Image, ImageDraw, ImageFilter, ImageFont

CANVAS_WIDTH = 1080
CANVAS_HEIGHT = 1920

# Color palette (Vocabik brand)
COLOR_BG_TOP = (11, 26, 38)        # #0B1A26 deep slate teal
COLOR_BG_BOTTOM = (4, 11, 16)      # #040B10 midnight black
COLOR_TEAL_ACCENT = (0, 229, 204)  # #00E5CC electric teal
COLOR_TEAL_DARK = (8, 145, 178)    # #0891B2 cyan
COLOR_TEXT_WHITE = (255, 255, 255)
COLOR_TEXT_SUB = (160, 175, 195)   # #A0AFC3 slate-300
COLOR_PHONE_BODY = (24, 24, 27)    # #18181B zinc-900
COLOR_PHONE_BORDER = (51, 65, 85)  # #334155 slate-700

# Fonts
FONT_BOLD_PATH = "C:\\Windows\\Fonts\\arialbd.ttf"
FONT_REG_PATH = "C:\\Windows\\Fonts\\arial.ttf"

def create_gradient_bg(width, height, top_rgb, bot_rgb):
    base = Image.new("RGBA", (width, height), top_rgb + (255,))
    draw = ImageDraw.Draw(base)
    for y in range(height):
        factor = y / float(height)
        r = int(top_rgb[0] * (1 - factor) + bot_rgb[0] * factor)
        g = int(top_rgb[1] * (1 - factor) + bot_rgb[1] * factor)
        b = int(top_rgb[2] * (1 - factor) + bot_rgb[2] * factor)
        draw.line([(0, y), (width, y)], fill=(r, g, b, 255))
    return base

def add_ambient_glow(image, center_x, center_y, radius, glow_color, alpha=65):
    glow_layer = Image.new("RGBA", image.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(glow_layer)
    draw.ellipse(
        [center_x - radius, center_y - radius, center_x + radius, center_y + radius],
        fill=glow_color + (alpha,)
    )
    blurred_glow = glow_layer.filter(ImageFilter.GaussianBlur(radius // 2))
    return Image.alpha_composite(image, blurred_glow)

def make_rounded_mask(size, radius):
    mask = Image.new("L", size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle([(0, 0), size], radius=radius, fill=255)
    return mask

def process_app_screenshot(source_path, target_w, crop_top=105, crop_bot=2800):
    src = Image.open(source_path).convert("RGBA")
    w, h = src.size
    cropped = src.crop((0, crop_top, w, min(h, crop_bot)))
    cw, ch = cropped.size
    target_h = int(ch * (target_w / float(cw)))
    resized = cropped.resize((target_w, target_h), Image.Resampling.LANCZOS)
    return resized

def build_phone_mockup(screen_img, screen_w=810, frame_radius=48, screen_radius=36, bezel=16):
    screen_h = screen_img.height
    phone_w = screen_w + bezel * 2
    phone_h = screen_h + bezel * 2

    # Screen with rounded corners
    screen_mask = make_rounded_mask((screen_w, screen_h), screen_radius)
    rounded_screen = Image.new("RGBA", (screen_w, screen_h), (0, 0, 0, 0))
    rounded_screen.paste(screen_img, (0, 0), screen_mask)

    # Phone chassis
    phone_img = Image.new("RGBA", (phone_w, phone_h), (0, 0, 0, 0))
    phone_draw = ImageDraw.Draw(phone_img)

    # Outer phone body with subtle sleek border
    phone_draw.rounded_rectangle(
        [(0, 0), (phone_w, phone_h)],
        radius=frame_radius,
        fill=COLOR_PHONE_BODY + (255,),
        outline=COLOR_PHONE_BORDER + (255,),
        width=3
    )

    # Paste screen inside chassis
    phone_img.paste(rounded_screen, (bezel, bezel), rounded_screen)

    # Punch-hole camera at top center
    cam_r = 7
    cam_x = phone_w // 2
    cam_y = bezel + 20
    phone_draw.ellipse(
        [cam_x - cam_r, cam_y - cam_r, cam_x + cam_r, cam_y + cam_r],
        fill=(10, 10, 15, 255),
        outline=(30, 41, 59, 255),
        width=1
    )

    # Drop shadow
    shadow_margin = 60
    shadow_w = phone_w + shadow_margin * 2
    shadow_h = phone_h + shadow_margin * 2
    shadow_layer = Image.new("RGBA", (shadow_w, shadow_h), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow_layer)
    shadow_draw.rounded_rectangle(
        [(shadow_margin, shadow_margin + 12), (shadow_margin + phone_w, shadow_margin + phone_h + 12)],
        radius=frame_radius,
        fill=(0, 0, 0, 150)
    )
    shadow_blurred = shadow_layer.filter(ImageFilter.GaussianBlur(32))

    # Composite phone on shadow
    final_mockup = Image.new("RGBA", (shadow_w, shadow_h), (0, 0, 0, 0))
    final_mockup = Image.alpha_composite(final_mockup, shadow_blurred)
    final_mockup.paste(phone_img, (shadow_margin, shadow_margin), phone_img)

    return final_mockup

def render_promo_screenshot(source_path, tag_text, title_text, subtitle_text, output_path, crop_top=105, crop_bot=2800):
    print(f"Creating: {output_path}...")
    canvas = create_gradient_bg(CANVAS_WIDTH, CANVAS_HEIGHT, COLOR_BG_TOP, COLOR_BG_BOTTOM)
    
    # Ambient glows for depth
    canvas = add_ambient_glow(canvas, CANVAS_WIDTH // 2, 700, 480, COLOR_TEAL_DARK, alpha=70)
    canvas = add_ambient_glow(canvas, CANVAS_WIDTH // 2, 1400, 400, (15, 23, 42), alpha=80)

    draw = ImageDraw.Draw(canvas)

    # Fonts
    font_tag = ImageFont.truetype(FONT_BOLD_PATH, 24)
    font_title = ImageFont.truetype(FONT_BOLD_PATH, 48)
    font_sub = ImageFont.truetype(FONT_REG_PATH, 26)

    # 1. Tag Pill
    tag_pad_x = 22
    tag_pad_y = 9
    tag_bbox = font_tag.getbbox(tag_text)
    tag_tw = tag_bbox[2] - tag_bbox[0]
    tag_th = tag_bbox[3] - tag_bbox[1]
    tag_w = tag_tw + tag_pad_x * 2
    tag_h = tag_th + tag_pad_y * 2
    tag_x = (CANVAS_WIDTH - tag_w) // 2
    tag_y = 85

    draw.rounded_rectangle(
        [(tag_x, tag_y), (tag_x + tag_w, tag_y + tag_h)],
        radius=tag_h // 2,
        fill=(15, 23, 42, 230),
        outline=COLOR_TEAL_ACCENT + (220,),
        width=2
    )
    draw.text((tag_x + tag_pad_x, tag_y + tag_pad_y - tag_bbox[1]), tag_text, font=font_tag, fill=COLOR_TEAL_ACCENT + (255,))

    # 2. Main Title (Centered)
    title_bbox = font_title.getbbox(title_text)
    title_tw = title_bbox[2] - title_bbox[0]
    title_x = (CANVAS_WIDTH - title_tw) // 2
    title_y = tag_y + tag_h + 28
    draw.text((title_x, title_y), title_text, font=font_title, fill=COLOR_TEXT_WHITE + (255,))

    # 3. Subtitle (Centered)
    sub_bbox = font_sub.getbbox(subtitle_text)
    sub_tw = sub_bbox[2] - sub_bbox[0]
    sub_x = (CANVAS_WIDTH - sub_tw) // 2
    sub_y = title_y + (title_bbox[3] - title_bbox[1]) + 20
    draw.text((sub_x, sub_y), subtitle_text, font=font_sub, fill=COLOR_TEXT_SUB + (255,))

    # 4. Phone Mockup
    screen_w = 810
    screen_img = process_app_screenshot(source_path, target_w=screen_w, crop_top=crop_top, crop_bot=crop_bot)
    mockup = build_phone_mockup(screen_img, screen_w=screen_w)

    phone_placement_x = (CANVAS_WIDTH - mockup.width) // 2
    phone_placement_y = sub_y + (sub_bbox[3] - sub_bbox[1]) + 38

    canvas.paste(mockup, (phone_placement_x, phone_placement_y), mockup)

    # Convert to RGB (standard 24-bit PNG without alpha channel, required by Google Play)
    final_rgb = canvas.convert("RGB")
    final_rgb.save(output_path, "PNG", optimize=True)
    size_mb = os.path.getsize(output_path) / (1024 * 1024)
    print(f"-> OK: {output_path} ({final_rgb.size[0]}x{final_rgb.size[1]}, {size_mb:.2f} MB)")

def main():
    os.makedirs("screenshots", exist_ok=True)

    items = [
        {
            "source": "emu_screen.png",
            "tag": "VOCABIK • HỌC QUA VIDEO",
            "title": "Học Tiếng Anh Qua Video",
            "sub": "Kho video thực tế phong phú, chia cấp độ chuẩn CEFR A1 - C1",
            "output": "screenshots/screenshot_1_home.png",
            "crop_top": 105,
            "crop_bot": 2800,
        },
        {
            "source": "emu_exercise.png",
            "tag": "BÀI TẬP TƯƠNG TÁC",
            "title": "Luyện Tập Điền Từ Tương Tác",
            "sub": "Vừa nghe video vừa chọn từ, phản xạ từ vựng tức thì",
            "output": "screenshots/screenshot_2_exercise.png",
            "crop_top": 110,
            "crop_bot": 2800,
        },
        {
            "source": "emu_exercise_answered.png",
            "tag": "PHẢN HỒI THÔNG MINH",
            "title": "Ghi Nhớ Sâu & Tích Lũy XP",
            "sub": "Chấm điểm chuẩn xác, nhận thưởng kinh nghiệm khi trả lời đúng",
            "output": "screenshots/screenshot_3_feedback.png",
            "crop_top": 110,
            "crop_bot": 2800,
        },
        {
            "source": "emu_tab2.png",
            "tag": "BỘ LỌC THÔNG MINH",
            "title": "Tìm Kiếm Theo Trình Độ CEFR",
            "sub": "Lọc nhanh theo chủ đề Vlog, Âm nhạc, Tin tức và thời lượng",
            "output": "screenshots/screenshot_4_discover.png",
            "crop_top": 105,
            "crop_bot": 2800,
        },
        {
            "source": "emu_tab3.png",
            "tag": "TIẾN ĐỘ HỌC TẬP",
            "title": "Theo Dõi Tiến Độ & Chuỗi Streak",
            "sub": "Xây dựng thói quen kiên trì mỗi ngày, thăng hạng cấp độ",
            "output": "screenshots/screenshot_5_progress.png",
            "crop_top": 105,
            "crop_bot": 2800,
        },
        {
            "source": "emu_lang.png",
            "tag": "THÀNH TÍCH & THỬ THÁCH",
            "title": "Chinh Phục Huy Hiệu Độc Quyền",
            "sub": "Mở khóa các danh hiệu vinh danh khi hoàn thành mục tiêu",
            "output": "screenshots/screenshot_6_achievements.png",
            "crop_top": 105,
            "crop_bot": 2800,
        },
    ]

    for item in items:
        render_promo_screenshot(
            source_path=item["source"],
            tag_text=item["tag"],
            title_text=item["title"],
            subtitle_text=item["sub"],
            output_path=item["output"],
            crop_top=item["crop_top"],
            crop_bot=item["crop_bot"],
        )

if __name__ == "__main__":
    main()
