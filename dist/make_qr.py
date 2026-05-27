"""Gera o QR code de download do APK do Bipi, com o ícone do app no centro.

Aponta para o link "latest" do GitHub Releases, que sempre serve o APK mais
recente (desde que o asset continue se chamando bipi.apk). Usa correção de erro
alta (H ~30%) para tolerar o logo central e seguir escaneável.
Rode novamente sempre que quiser regenerar: python dist/make_qr.py
"""
import os

import qrcode
from qrcode.constants import ERROR_CORRECT_H
from PIL import Image, ImageDraw

HERE = os.path.dirname(__file__)
ROOT = os.path.dirname(HERE)
URL = "https://github.com/MEUCAPSQUEBROU/BipiApp/releases/latest/download/bipi.apk"
OUT = os.path.join(HERE, "bipi-qr.png")
LOGO = os.path.join(ROOT, "assets", "icon", "app_icon.png")
BLUE = (13, 72, 114)  # #0D4872

# QR com alta correção de erro (H) para tolerar o logo no centro.
qr = qrcode.QRCode(error_correction=ERROR_CORRECT_H, box_size=16, border=4)
qr.add_data(URL)
qr.make(fit=True)
img = qr.make_image(fill_color=BLUE, back_color="white").convert("RGBA")
w, h = img.size

# Logo (ícone do app) com cantos arredondados.
logo_size = int(w * 0.24)
logo = Image.open(LOGO).convert("RGBA").resize((logo_size, logo_size), Image.LANCZOS)
logo_mask = Image.new("L", (logo_size, logo_size), 0)
ImageDraw.Draw(logo_mask).rounded_rectangle(
    [0, 0, logo_size - 1, logo_size - 1], radius=int(logo_size * 0.22), fill=255
)
logo.putalpha(logo_mask)

# Cartão branco arredondado atrás do logo (separa do QR e mantém escaneável).
pad = int(logo_size * 0.14)
card = logo_size + pad * 2
bg = Image.new("RGBA", (card, card), (0, 0, 0, 0))
ImageDraw.Draw(bg).rounded_rectangle(
    [0, 0, card - 1, card - 1], radius=int(card * 0.22), fill=(255, 255, 255, 255)
)

img.alpha_composite(bg, ((w - card) // 2, (h - card) // 2))
img.alpha_composite(logo, ((w - logo_size) // 2, (h - logo_size) // 2))
img.convert("RGB").save(OUT)

print(f"QR salvo: {OUT}")
print(f"{w}x{h}px | logo {logo_size}px | correcao de erro H | URL: {URL}")
