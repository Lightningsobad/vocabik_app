import os
import base64
from io import BytesIO
from PIL import Image, ImageDraw
import numpy as np
import resvg_py

os.makedirs('play_store_assets', exist_ok=True)
os.makedirs('build/fonts', exist_ok=True)

# ----------------------------------------------------------------------
# 1. GENERATE APP ICON (512x512)
# ----------------------------------------------------------------------
def generate_app_icon():
    print("Generating App Icon (512x512)...")
    W, H = 512, 512
    
    # Load original master foreground
    fg = Image.open('assets/branding/app_icon_foreground.png')
    bbox = fg.getbbox()
    symbol = fg.crop(bbox)
    
    # Create radial background with subtle luxury glow
    bg_arr = np.zeros((H, W, 4), dtype=np.uint8)
    y, x = np.ogrid[:H, :W]
    cy, cx = H / 2.0, W / 2.0
    dist = np.sqrt((x - cx)**2 + (y - cy)**2)
    norm_dist = np.clip(dist / (W * 0.48), 0, 1)

    # Base background: #0D0D1A -> (13, 13, 26)
    # Center ambient aura: subtle cyan/dark indigo tint -> (18, 38, 56)
    r = (18 * (1 - norm_dist**1.6) + 13 * (norm_dist**1.6)).astype(np.uint8)
    g = (38 * (1 - norm_dist**1.6) + 13 * (norm_dist**1.6)).astype(np.uint8)
    b = (56 * (1 - norm_dist**1.6) + 26 * (norm_dist**1.6)).astype(np.uint8)

    bg_arr[:,:,0] = r
    bg_arr[:,:,1] = g
    bg_arr[:,:,2] = b
    bg_arr[:,:,3] = 255

    canvas = Image.fromarray(bg_arr, mode='RGBA')

    # Target height for symbol: 285px (within 384px keyline circle)
    target_h = 285
    scale = target_h / symbol.height
    target_w = int(symbol.width * scale)
    symbol_resized = symbol.resize((target_w, target_h), Image.Resampling.LANCZOS)

    # Paste centered
    pos_x = (W - target_w) // 2
    pos_y = (H - target_h) // 2
    canvas.paste(symbol_resized, (pos_x, pos_y), symbol_resized)

    out_path = 'play_store_assets/app_icon_512x512.png'
    canvas.save(out_path, format='PNG', optimize=True)
    size_bytes = os.path.getsize(out_path)
    print(f"App Icon saved to {out_path} ({W}x{H}, {size_bytes} bytes / {size_bytes/1024:.1f} KB)")
    
    # Self-check assertion
    assert canvas.size == (512, 512), "Icon dimensions must be 512x512"
    assert size_bytes <= 1024 * 1024, "Icon file size must be <= 1MB"

# ----------------------------------------------------------------------
# 2. GENERATE FEATURE GRAPHIC (1024x500)
# ----------------------------------------------------------------------
def generate_feature_graphic(lang='vi'):
    is_vi = (lang == 'vi')
    suffix = "" if is_vi else "_en"
    print(f"Generating Feature Graphic ({lang.upper()}) 1024x500...")
    
    # Load and encode emblem to base64 for embedding in SVG
    fg = Image.open('assets/branding/app_icon_foreground.png')
    bbox = fg.getbbox()
    symbol = fg.crop(bbox)
    buf = BytesIO()
    symbol.save(buf, format='PNG')
    symbol_b64 = base64.b64encode(buf.getvalue()).decode('utf-8')

    headline = "Học từ vựng qua Video &amp; Âm nhạc" if is_vi else "Learn Vocabulary with Music &amp; Videos"
    subhead = "Luyện nghe, điền từ &amp; mở rộng vốn từ vựng mỗi ngày" if is_vi else "Listen, fill the blanks &amp; master English naturally"
    pill1_text = "Hàng ngàn video YouTube &amp; bài hát" if is_vi else "YouTube Videos &amp; Hit Music"
    pill2_text = "Lộ trình chuẩn CEFR A1 — C1" if is_vi else "Standard CEFR A1 — C1 Levels"
    pill3_text = "Chuỗi Streak &amp; Tích lũy XP" if is_vi else "Gamified Daily Streak &amp; XP"

    card_label = "BÀI TẬP ĐIỀN TỪ" if is_vi else "FILL-IN-THE-BLANK"
    song_genre = "POP / R&amp;B • 03:20"
    song_title = "Blinding Lights — The Weeknd"
    task_prompt = "Nghe và điền từ còn thiếu vào câu:" if is_vi else "Listen and fill in the missing word:"
    lyric_pre = "I said, ooh, I'm blinded by the"
    lyric_blank = "lights"
    correct_badge = "✓ Chính xác" if is_vi else "✓ Correct"
    translation = "« Tôi đã nói, ôi, tôi bị choáng ngợp bởi ánh đèn »" if is_vi else "« I said, ooh, I'm blinded by the lights »"
    streak_tag = "🔥 7 Ngày liên tiếp" if is_vi else "🔥 7-Day Streak"
    xp_tag = "⚡ +20 XP"
    cefr_tag = "B2 Upper-Int"

    svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="500" viewBox="0 0 1024 500">
  <defs>
    <!-- Background Gradients -->
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#090912"/>
      <stop offset="40%" stop-color="#0D0D1A"/>
      <stop offset="100%" stop-color="#121224"/>
    </linearGradient>

    <!-- Ambient Glow Filters -->
    <filter id="glowTeal" x="-30%" y="-30%" width="160%" height="160%">
      <feGaussianBlur stdDeviation="70" result="blur"/>
    </filter>
    <filter id="glowPurple" x="-30%" y="-30%" width="160%" height="160%">
      <feGaussianBlur stdDeviation="60" result="blur"/>
    </filter>
    <filter id="cardShadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="16" stdDeviation="24" flood-color="#000000" flood-opacity="0.6"/>
    </filter>

    <!-- Card Gradients -->
    <linearGradient id="cardBg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#1A1A2E"/>
      <stop offset="100%" stop-color="#141424"/>
    </linearGradient>
    <linearGradient id="cardBorder" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#00E5CC" stop-opacity="0.6"/>
      <stop offset="40%" stop-color="#2A2A3D"/>
      <stop offset="100%" stop-color="#A854F7" stop-opacity="0.4"/>
    </linearGradient>
    
    <!-- Player Bar Gradient -->
    <linearGradient id="playerBg" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#0F172A"/>
      <stop offset="100%" stop-color="#1E1E38"/>
    </linearGradient>
    
    <!-- Waveform / Equalizer Gradient -->
    <linearGradient id="waveGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#00E5CC"/>
      <stop offset="100%" stop-color="#A854F7"/>
    </linearGradient>
  </defs>

  <!-- 1. Deep Canvas Background -->
  <rect width="1024" height="500" fill="url(#bgGrad)"/>

  <!-- Subtle grid texture -->
  <g opacity="0.04" stroke="#FFFFFF" stroke-width="1">
    <line x1="0" y1="100" x2="1024" y2="100"/>
    <line x1="0" y1="200" x2="1024" y2="200"/>
    <line x1="0" y1="300" x2="1024" y2="300"/>
    <line x1="0" y1="400" x2="1024" y2="400"/>
    <line x1="200" y1="0" x2="200" y2="500"/>
    <line x1="400" y1="0" x2="400" y2="500"/>
    <line x1="600" y1="0" x2="600" y2="500"/>
    <line x1="800" y1="0" x2="800" y2="500"/>
  </g>

  <!-- 2. Ambient Lighting / Glow Orbs -->
  <!-- Teal glow behind the interactive card -->
  <circle cx="760" cy="250" r="140" fill="#00E5CC" opacity="0.18" filter="url(#glowTeal)"/>
  <!-- Purple glow top left -->
  <circle cx="280" cy="140" r="130" fill="#8B5CF6" opacity="0.16" filter="url(#glowPurple)"/>
  <!-- Amber glow bottom right -->
  <circle cx="940" cy="420" r="90" fill="#F59E0B" opacity="0.10" filter="url(#glowTeal)"/>

  <!-- ========================================================= -->
  <!-- 3. LEFT COLUMN: BRANDING &amp; MESSAGING (Safe zone respected) -->
  <!-- ========================================================= -->
  <g transform="translate(68, 64)">
    <!-- Brand Header: Logo Badge + Vocabik Text -->
    <g>
      <!-- Small Logo Squircle Container -->
      <rect x="0" y="0" width="56" height="56" rx="16" fill="#141426" stroke="#00E5CC" stroke-width="1.5" stroke-opacity="0.8"/>
      <image href="data:image/png;base64,{symbol_b64}" x="10" y="8" width="36" height="40"/>
      
      <!-- Brand Name -->
      <text x="70" y="42" font-family="Nunito" font-size="44" font-weight="900" letter-spacing="-1">
        <tspan fill="#FFFFFF">Vocab</tspan><tspan fill="#00E5CC">ik</tspan>
      </text>
    </g>

    <!-- Main Headline -->
    <text x="0" y="128" font-family="Nunito" font-size="28" font-weight="900" fill="#F8FAFC" letter-spacing="-0.5">
      {headline}
    </text>

    <!-- Subtitle -->
    <text x="0" y="162" font-family="Nunito" font-size="15.5" font-weight="600" fill="#94A3B8">
      {subhead}
    </text>

    <!-- Feature Pills Stack -->
    <g transform="translate(0, 204)">
      <!-- Pill 1: Music & Videos -->
      <g>
        <rect x="0" y="0" width="390" height="42" rx="21" fill="#17172B" stroke="#252540" stroke-width="1.2"/>
        <circle cx="21" cy="21" r="12" fill="#00E5CC" fill-opacity="0.15"/>
        <polygon points="18,16 26,21 18,26" fill="#00E5CC"/>
        <text x="44" y="26" font-family="Nunito" font-size="14.5" font-weight="700" fill="#E2E8F0">
          {pill1_text}
        </text>
      </g>

      <!-- Pill 2: CEFR Standard -->
      <g transform="translate(0, 52)">
        <rect x="0" y="0" width="390" height="42" rx="21" fill="#17172B" stroke="#252540" stroke-width="1.2"/>
        <circle cx="21" cy="21" r="12" fill="#A854F7" fill-opacity="0.18"/>
        <!-- Target / Bullseye icon -->
        <circle cx="21" cy="21" r="7" stroke="#C084FC" stroke-width="1.8" fill="none"/>
        <circle cx="21" cy="21" r="2.5" fill="#C084FC"/>
        <text x="44" y="26" font-family="Nunito" font-size="14.5" font-weight="700" fill="#E2E8F0">
          {pill2_text}
        </text>
      </g>

      <!-- Pill 3: Gamified Streak & XP -->
      <g transform="translate(0, 104)">
        <rect x="0" y="0" width="390" height="42" rx="21" fill="#17172B" stroke="#252540" stroke-width="1.2"/>
        <circle cx="21" cy="21" r="12" fill="#F59E0B" fill-opacity="0.18"/>
        <!-- Flame icon representation -->
        <path d="M21 14 C22 17 25 18 25 21 C25 23.5 23 25.5 21 25.5 C19 25.5 17 23.5 17 21 C17 19 19 17.5 20 16 Z" fill="#FBBF24"/>
        <text x="44" y="26" font-family="Nunito" font-size="14.5" font-weight="700" fill="#E2E8F0">
          {pill3_text}
        </text>
      </g>
    </g>
  </g>

  <!-- ========================================================= -->
  <!-- 4. RIGHT COLUMN: INTERACTIVE APP CARD SHOWCASE -->
  <!-- ========================================================= -->
  <g transform="translate(530, 50)" filter="url(#cardShadow)">
    <!-- Floating Card Frame -->
    <rect x="0" y="0" width="435" height="400" rx="24" fill="url(#cardBg)" stroke="url(#cardBorder)" stroke-width="1.8"/>

    <!-- Inside Card Header: Mini Video Player Preview -->
    <g transform="translate(20, 20)">
      <rect x="0" y="0" width="395" height="110" rx="16" fill="url(#playerBg)" stroke="#262640" stroke-width="1"/>
      
      <!-- Video thumbnail background artwork -->
      <rect x="12" y="12" width="116" height="86" rx="12" fill="#161B2E"/>
      
      <!-- Waveform graphic inside thumbnail -->
      <g transform="translate(24, 38)">
        <rect x="0" y="10" width="4" height="20" rx="2" fill="url(#waveGrad)"/>
        <rect x="8" y="2" width="4" height="36" rx="2" fill="url(#waveGrad)"/>
        <rect x="16" y="16" width="4" height="12" rx="2" fill="url(#waveGrad)"/>
        <rect x="24" y="6" width="4" height="28" rx="2" fill="url(#waveGrad)"/>
        <rect x="32" y="0" width="4" height="40" rx="2" fill="url(#waveGrad)"/>
        <rect x="40" y="8" width="4" height="24" rx="2" fill="url(#waveGrad)"/>
        <rect x="48" y="14" width="4" height="16" rx="2" fill="url(#waveGrad)"/>
        <rect x="56" y="4" width="4" height="32" rx="2" fill="url(#waveGrad)"/>
        <rect x="64" y="12" width="4" height="18" rx="2" fill="url(#waveGrad)"/>
        <rect x="72" y="8" width="4" height="24" rx="2" fill="url(#waveGrad)"/>
        <rect x="80" y="18" width="4" height="10" rx="2" fill="url(#waveGrad)"/>
      </g>
      <!-- Circular play button over video thumbnail -->
      <circle cx="70" cy="55" r="18" fill="#00E5CC" opacity="0.95"/>
      <polygon points="67,48 76,55 67,62" fill="#0D0D1A"/>

      <!-- Song Metadata -->
      <text x="140" y="38" font-family="Nunito" font-size="11" font-weight="800" fill="#00E5CC" letter-spacing="1">
        {card_label}
      </text>
      <text x="140" y="60" font-family="Nunito" font-size="15" font-weight="800" fill="#F8FAFC">
        {song_title}
      </text>
      <text x="140" y="80" font-family="Nunito" font-size="12" font-weight="600" fill="#94A3B8">
        {song_genre}
      </text>
    </g>

    <!-- Inside Card Body: Fill-in-the-Blank Exercise -->
    <g transform="translate(20, 146)">
      <!-- Question instruction -->
      <text x="0" y="18" font-family="Nunito" font-size="13" font-weight="700" fill="#A0A0C0">
        {task_prompt}
      </text>

      <!-- Lyric Box -->
      <rect x="0" y="30" width="395" height="135" rx="16" fill="#101020" stroke="#232338" stroke-width="1.2"/>

      <!-- Lyric Sentence with glowing blank pill -->
      <g transform="translate(16, 52)">
        <text x="0" y="18" font-family="Nunito" font-size="15.5" font-weight="800" fill="#F1F5F9">
          {lyric_pre}
        </text>
        
        <!-- Highlighted Blank Pill -->
        <g transform="translate(230, -4)">
          <rect x="0" y="0" width="76" height="30" rx="8" fill="#00E5CC"/>
          <text x="38" y="20" font-family="Nunito" font-size="15" font-weight="900" fill="#0D0D1A" text-anchor="middle">
            {lyric_blank}
          </text>
        </g>
      </g>

      <!-- Correct Answer Validation Badge -->
      <g transform="translate(16, 96)">
        <rect x="0" y="0" width="94" height="24" rx="6" fill="#22D98C" fill-opacity="0.18"/>
        <text x="47" y="16" font-family="Nunito" font-size="11.5" font-weight="800" fill="#22D98C" text-anchor="middle">
          {correct_badge}
        </text>

        <!-- Translation line -->
        <text x="106" y="16" font-family="Nunito" font-size="12" font-style="italic" font-weight="600" fill="#8E8EA8">
          {translation}
        </text>
      </g>
    </g>

    <!-- Inside Card Footer: Gamification Badges Row -->
    <g transform="translate(20, 335)">
      <!-- Streak Tag -->
      <rect x="0" y="0" width="138" height="34" rx="10" fill="#2E2017" stroke="#735229" stroke-width="1"/>
      <text x="69" y="22" font-family="Nunito" font-size="12.5" font-weight="800" fill="#FFB13D" text-anchor="middle">
        {streak_tag}
      </text>

      <!-- XP Tag -->
      <rect x="148" y="0" width="105" height="34" rx="10" fill="#142B28" stroke="#166B60" stroke-width="1"/>
      <text x="200" y="22" font-family="Nunito" font-size="12.5" font-weight="800" fill="#00E5CC" text-anchor="middle">
        {xp_tag}
      </text>

      <!-- CEFR Level Tag -->
      <rect x="263" y="0" width="132" height="34" rx="10" fill="#241B38" stroke="#5B368C" stroke-width="1"/>
      <text x="329" y="22" font-family="Nunito" font-size="12.5" font-weight="800" fill="#C084FC" text-anchor="middle">
        {cefr_tag}
      </text>
    </g>
  </g>
</svg>'''

    # Save SVG source
    svg_path = f'play_store_assets/feature_graphic_{lang}_1024x500.svg'
    with open(svg_path, 'w', encoding='utf-8') as f:
        f.write(svg)

    # Render PNG with resvg-py
    png_bytes = resvg_py.svg_to_bytes(
        svg_string=svg,
        font_files=['build/fonts/Nunito.ttf'],
        font_family='Nunito',
        width=1024,
        height=500
    )
    
    out_png = f'play_store_assets/feature_graphic{suffix}_1024x500.png'
    with open(out_png, 'wb') as f:
        f.write(png_bytes)
        
    size_bytes = os.path.getsize(out_png)
    print(f"Feature Graphic saved to {out_png} (1024x500, {size_bytes} bytes / {size_bytes/1024:.1f} KB)")
    
    # Self-check assertion
    im = Image.open(out_png)
    assert im.size == (1024, 500), "Feature graphic dimensions must be 1024x500"
    assert size_bytes <= 15 * 1024 * 1024, "Feature graphic file size must be <= 15MB"

if __name__ == '__main__':
    generate_app_icon()
    generate_feature_graphic('vi')
    generate_feature_graphic('en')
    print("All Play Store graphic assets generated successfully!")

