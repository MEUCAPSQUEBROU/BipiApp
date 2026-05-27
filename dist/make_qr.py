"""Gera o QR code de download do APK do Bipi.

Aponta para o link "latest" do GitHub Releases, que sempre serve o APK
mais recente (desde que o asset continue se chamando bipi.apk).
Rode novamente sempre que quiser regenerar: python dist/make_qr.py
"""
import os
import qrcode
from qrcode.constants import ERROR_CORRECT_Q

URL = "https://github.com/MEUCAPSQUEBROU/BipiApp/releases/latest/download/bipi.apk"
OUT = os.path.join(os.path.dirname(__file__), "bipi-qr.png")

qr = qrcode.QRCode(
    version=None,
    error_correction=ERROR_CORRECT_Q,  # tolera ~25% de dano (bom p/ impressão)
    box_size=16,
    border=4,
)
qr.add_data(URL)
qr.make(fit=True)

img = qr.make_image(fill_color="#0D4872", back_color="white")
img.save(OUT)
print(f"QR salvo em: {OUT}")
print(f"Tamanho: {img.size[0]}x{img.size[1]}px")
print(f"URL codificada: {URL}")
