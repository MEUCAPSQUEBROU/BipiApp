"""Gera o GIF de carregamento do Bipi a partir dos quadros em assets/mascote/Frames.

Os quadros vêm com FUNDO PRETO OPACO (e marca d'água no canto). Aqui:
- cobre a marca d'água do canto inferior-direito;
- acha o urso de forma ROBUSTA (perfil de densidade por linha/coluna, ignorando
  ruído esparso — ex.: o pixel solto no canto do quadro 2) e CENTRALIZA o recorte;
- troca o fundo preto pelo azul da marca (#0D4872) via flood fill nas bordas;
- monta um loop ping-pong (1→2→3→4→3→2) lento, pra parecer que o urso flutua.

Rodar: python dist/make_loading_gif.py
"""
import os
from PIL import Image, ImageChops, ImageDraw

HERE = os.path.dirname(__file__)
ROOT = os.path.dirname(HERE)
FRAMES_DIR = os.path.join(ROOT, "assets", "mascote", "Frames")
OUT = os.path.join(ROOT, "assets", "mascote", "bipi_loading.gif")

BG = (13, 72, 114)        # #0D4872 (igual ao splash)
NAMES = ["1.png", "2.png", "3.png", "4.png"]
PINGPONG = [0, 1, 2, 3, 2, 1]   # vai-e-volta suave (sem corte brusco)
DURATION_MS = 280         # mais lento -> sensação de flutuar
TARGET_H = 440            # altura final do GIF (px)
PAD = 28                  # respiro ao redor do conteúdo
WATERMARK = (200, 160)    # canto inferior-direito a cobrir (largura, altura)
BG_THRESH = 42            # tolerância do flood fill do fundo preto
DENSITY_T = 6             # mín. de "branco" por linha/coluna p/ contar (ignora ruído)

frames = [Image.open(os.path.join(FRAMES_DIR, n)).convert("RGB") for n in NAMES]
w, h = frames[0].size

# 1) Cobre a marca d'água com preto (vira fundo, depois trocado por azul).
cw, ch = WATERMARK
for f in frames:
    ImageDraw.Draw(f).rectangle([w - cw, h - ch, w - 1, h - 1], fill=(0, 0, 0))

# 2) Máscara combinada (qualquer pixel não-preto em qualquer quadro).
combined = None
for f in frames:
    m = f.convert("L").point(lambda v: 255 if v > 28 else 0)
    combined = m if combined is None else ImageChops.lighter(combined, m)

# Perfis de densidade: média de "branco" por coluna e por linha (PIL faz rápido).
col = list(combined.resize((w, 1), Image.BOX).getdata())   # w valores
row = list(combined.resize((1, h), Image.BOX).getdata())   # h valores
xs = [x for x, v in enumerate(col) if v > DENSITY_T]
ys = [y for y, v in enumerate(row) if v > DENSITY_T]
x0, x1 = min(xs), max(xs)
y0, y1 = min(ys), max(ys)
print(f"bbox do urso (robusto): ({x0},{y0})-({x1},{y1}) center=({(x0+x1)//2},{(y0+y1)//2})")
x0, y0 = max(0, x0 - PAD), max(0, y0 - PAD)
x1, y1 = min(w, x1 + PAD), min(h, y1 + PAD)

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

# 4) Recorta (mesmo box p/ todos, centralizado no urso) e redimensiona.
crop_w, crop_h = x1 - x0, y1 - y0
new_h = TARGET_H
new_w = round(crop_w * (TARGET_H / crop_h))
rgb = [g.crop((x0, y0, x1, y1)).resize((new_w, new_h), Image.LANCZOS) for g in filled]

# 5) Paleta única (evita flicker) + ordem ping-pong + salva o GIF.
montage = Image.new("RGB", (new_w * len(rgb), new_h), BG)
for i, f in enumerate(rgb):
    montage.paste(f, (i * new_w, 0))
master = montage.quantize(colors=256, method=Image.MEDIANCUT)
seq = [rgb[i].quantize(palette=master, dither=Image.NONE) for i in PINGPONG]

seq[0].save(
    OUT,
    save_all=True,
    append_images=seq[1:],
    duration=DURATION_MS,
    loop=0,
    disposal=1,
)
size_kb = round(os.path.getsize(OUT) / 1024, 1)
print(f"GIF salvo: {OUT}")
print(f"{len(seq)} frames (ping-pong) | {new_w}x{new_h}px | {DURATION_MS}ms/frame | {size_kb} KB")
