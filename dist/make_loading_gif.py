"""Gera o GIF de carregamento do Bipi a partir dos quadros em assets/mascote/Frames.

Os quadros vêm com FUNDO PRETO OPACO (e marca d'água no canto). Aqui:
- cobre a marca d'água do canto inferior-direito;
- recorta para o conteúdo (bear + balão);
- troca o fundo preto pelo azul da marca (#0D4872) via flood fill nas bordas,
  preservando os detalhes internos (chapéu, rosto, colete);
- salva animado em loop em assets/mascote/bipi_loading.gif.

Rodar: python dist/make_loading_gif.py
"""
import os
from PIL import Image, ImageDraw

HERE = os.path.dirname(__file__)
ROOT = os.path.dirname(HERE)
FRAMES_DIR = os.path.join(ROOT, "assets", "mascote", "Frames")
OUT = os.path.join(ROOT, "assets", "mascote", "bipi_loading.gif")

BG = (13, 72, 114)        # #0D4872 (igual ao splash)
ORDER = ["1.png", "2.png", "3.png", "4.png"]
DURATION_MS = 160         # tempo de cada quadro
TARGET_H = 440            # altura final do GIF (px)
PAD = 20                  # respiro ao redor do conteúdo
WATERMARK = (200, 160)    # canto inferior-direito a cobrir (largura, altura)
BG_THRESH = 42            # tolerância do flood fill do fundo preto

frames = [Image.open(os.path.join(FRAMES_DIR, n)).convert("RGB") for n in ORDER]
w, h = frames[0].size

# 1) Cobre a marca d'água com preto (vira fundo, depois é trocado por azul).
cw, ch = WATERMARK
for f in frames:
    ImageDraw.Draw(f).rectangle([w - cw, h - ch, w - 1, h - 1], fill=(0, 0, 0))


# 2) Bounding box do conteúdo (pixels não-pretos), união entre os quadros.
def content_bbox(img):
    mask = img.convert("L").point(lambda v: 255 if v > 24 else 0)
    return mask.getbbox()


bbox = None
for f in frames:
    b = content_bbox(f)
    if b is None:
        continue
    bbox = b if bbox is None else (
        min(bbox[0], b[0]), min(bbox[1], b[1]),
        max(bbox[2], b[2]), max(bbox[3], b[3]),
    )
x0, y0 = max(0, bbox[0] - PAD), max(0, bbox[1] - PAD)
x1, y1 = min(w, bbox[2] + PAD), min(h, bbox[3] + PAD)

# 3) Troca o fundo preto por azul (flood fill a partir das bordas).
seeds = [
    (1, 1), (w - 2, 1), (1, h - 2), (w - 2, h - 2),
    (w // 2, 1), (w // 2, h - 2), (1, h // 2), (w - 2, h // 2),
]
filled = []
for f in frames:
    g = f.copy()
    for s in seeds:
        ImageDraw.floodfill(g, s, BG, thresh=BG_THRESH)
    filled.append(g)

# 4) Recorta (mesmo box p/ todos) e redimensiona.
crop_w, crop_h = x1 - x0, y1 - y0
new_h = TARGET_H
new_w = round(crop_w * (TARGET_H / crop_h))
rgb_frames = [
    g.crop((x0, y0, x1, y1)).resize((new_w, new_h), Image.LANCZOS) for g in filled
]

# 5) Paleta única (evita flicker) + salva o GIF animado.
montage = Image.new("RGB", (new_w * len(rgb_frames), new_h), BG)
for i, f in enumerate(rgb_frames):
    montage.paste(f, (i * new_w, 0))
master = montage.quantize(colors=256, method=Image.MEDIANCUT)
pal = [f.quantize(palette=master, dither=Image.NONE) for f in rgb_frames]

pal[0].save(
    OUT,
    save_all=True,
    append_images=pal[1:],
    duration=DURATION_MS,
    loop=0,
    disposal=1,
)
size_kb = round(os.path.getsize(OUT) / 1024, 1)
print(f"GIF salvo: {OUT}")
print(f"Quadros: {len(pal)} | {new_w}x{new_h}px | {size_kb} KB | crop={x1-x0}x{y1-y0}")
