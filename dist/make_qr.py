"""Gera o QR code de download do APK do Bipi, com o ícone do app no centro.

Aponta para o link "latest" do GitHub Releases, que sempre serve o APK mais
recente (desde que o asset continue se chamando bipi.apk). A lógica do QR fica
em qr_util.py (compartilhada com o banner).
Rode novamente sempre que quiser regenerar: python dist/make_qr.py
"""
import os

from qr_util import make_branded_qr

URL = "https://github.com/MEUCAPSQUEBROU/BipiApp/releases/latest/download/bipi.apk"
OUT = os.path.join(os.path.dirname(__file__), "bipi-qr.png")

img = make_branded_qr(URL)
img.save(OUT)
print(f"QR salvo: {OUT}  ({img.size[0]}x{img.size[1]}px)")
print(f"URL: {URL}")
