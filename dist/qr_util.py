"""Helper compartilhado: gera o QR azul do Bipi com o ícone do app no centro.

Usado por make_qr.py (QR avulso) e make_banner.py (QR dentro do cartaz), pra
manter o mesmo visual nos dois. Correção de erro H (~30%) deixa o QR escaneável
mesmo com o logo cobrindo o centro.
"""
import os

import qrcode
from qrcode.constants import ERROR_CORRECT_H
from PIL import Image, ImageDraw

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
_DEFAULT_LOGO = os.path.join(_ROOT, "assets", "icon", "app_icon.png")
BRAND_BLUE = (13, 72, 114)  # #0D4872


def make_branded_qr(url, box_size=16, border=4, logo_frac=0.24, logo_path=None):
    """Retorna um QR (RGB) azul com o ícone do app arredondado no centro."""
    logo_path = logo_path or _DEFAULT_LOGO
    qr = qrcode.QRCode(
        error_correction=ERROR_CORRECT_H, box_size=box_size, border=border
    )
    qr.add_data(url)
    qr.make(fit=True)
    img = qr.make_image(fill_color=BRAND_BLUE, back_color="white").convert("RGBA")
    w, h = img.size

    # Logo (ícone do app) com cantos arredondados.
    logo_size = int(w * logo_frac)
    logo = Image.open(logo_path).convert("RGBA").resize(
        (logo_size, logo_size), Image.LANCZOS
    )
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
    return img.convert("RGB")
