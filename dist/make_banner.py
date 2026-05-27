"""Gera o banner/cartaz do evento com o QR de download do APK do Bipi.

Formato A4 retrato (1240x1800), bom para imprimir e projetar.
Regerar: python dist/make_banner.py
"""
import os
import qrcode
from qrcode.constants import ERROR_CORRECT_Q
from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(__file__)
ROOT = os.path.dirname(HERE)
MASCOTE = os.path.join(ROOT, "assets", "mascote", "bipi_feliz.png")
OUT = os.path.join(HERE, "bipi-banner.png")
URL = "https://github.com/MEUCAPSQUEBROU/BipiApp/releases/latest/download/bipi.apk"

# --- Paleta do app ---
BLUE = (13, 72, 114)       # #0D4872
YELLOW = (245, 183, 0)     # amarelo Maio Amarelo
WHITE = (255, 255, 255)
INK = (38, 50, 62)
GRAY = (110, 122, 134)
CARD_BORDER = (220, 228, 236)

W, H = 1240, 1800
FONTS = r"C:\Windows\Fonts"


def font(names, size):
    for n in names:
        p = os.path.join(FONTS, n)
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()


f_black = lambda s: font(["seguibl.ttf", "arialbd.ttf"], s)   # Segoe UI Black
f_bold = lambda s: font(["segoeuib.ttf", "arialbd.ttf"], s)   # Segoe UI Bold
f_semi = lambda s: font(["seguisb.ttf", "segoeuib.ttf", "arialbd.ttf"], s)
f_reg = lambda s: font(["segoeui.ttf", "arial.ttf"], s)


def center(draw, text, y, fnt, fill):
    """Desenha texto centralizado horizontalmente. Retorna o y do fim."""
    box = draw.textbbox((0, 0), text, font=fnt)
    w, h = box[2] - box[0], box[3] - box[1]
    draw.text(((W - w) / 2 - box[0], y - box[1]), text, font=fnt, fill=fill)
    return y + h


def pill(draw, text, cy, fnt, fill_bg, fill_tx, pad_x=42, pad_y=20):
    box = draw.textbbox((0, 0), text, font=fnt)
    w, h = box[2] - box[0], box[3] - box[1]
    rw, rh = w + pad_x * 2, h + pad_y * 2
    x0, y0 = (W - rw) / 2, cy
    draw.rounded_rectangle((x0, y0, x0 + rw, y0 + rh), radius=rh / 2, fill=fill_bg)
    draw.text((x0 + pad_x - box[0], y0 + pad_y - box[1]), text, font=fnt, fill=fill_tx)
    return y0 + rh


img = Image.new("RGB", (W, H), WHITE)
d = ImageDraw.Draw(img)

# Moldura azul arredondada
d.rounded_rectangle((18, 18, W - 18, H - 18), radius=44, outline=BLUE, width=8)

y = 70

# --- Mascote ---
masc = Image.open(MASCOTE).convert("RGBA")
mh = 380
mw = int(masc.width * mh / masc.height)
masc = masc.resize((mw, mh), Image.LANCZOS)
img.paste(masc, (int((W - mw) / 2), y), masc)
y += mh + 18

# --- Título + accent amarelo ---
y = center(d, "Bipi", y, f_black(132), BLUE) + 10
d.rounded_rectangle((W / 2 - 150, y, W / 2 + 150, y + 12), radius=6, fill=YELLOW)
y += 12 + 30

# --- Tagline ---
y = pill(d, "MAIO AMARELO  ·  TRÂNSITO", y, f_bold(34), YELLOW, BLUE) + 44

# --- Chamada ---
y = center(d, "Baixe e teste no seu celular", y, f_bold(50), INK) + 46

# --- QR em card ---
qr = qrcode.QRCode(error_correction=ERROR_CORRECT_Q, box_size=10, border=2)
qr.add_data(URL)
qr.make(fit=True)
qr_img = qr.make_image(fill_color=BLUE, back_color=WHITE).convert("RGB")
qs = qr_img.size[0]
pad = 46
card = qs + pad * 2
cx0 = (W - card) / 2
d.rounded_rectangle((cx0, y, cx0 + card, y + card), radius=36,
                    fill=WHITE, outline=CARD_BORDER, width=4)
img.paste(qr_img, (int(cx0 + pad), int(y + pad)))
y += card + 28

# --- Instrução ---
y = center(d, "Aponte a câmera do celular para o QR Code", y, f_semi(36), GRAY) + 34

# --- Badge Android + ressalva ---
y = pill(d, "SOMENTE ANDROID", y, f_bold(36), BLUE, WHITE) + 12
y = center(d, "(iPhone não instala APK)", y, f_reg(28), GRAY) + 26

# --- Rodapé: link alternativo ---
center(d, "ou acesse: github.com/MEUCAPSQUEBROU/BipiApp  >  Releases",
       H - 86, f_reg(26), GRAY)

img.save(OUT)
print(f"Banner salvo em: {OUT}")
print(f"Tamanho: {img.size[0]}x{img.size[1]}px  |  QR ocupa {qs}px")
