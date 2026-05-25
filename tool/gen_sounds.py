"""Gera os efeitos sonoros do Bipi sinteticamente (só stdlib).

Saída: assets/sounds/*.wav (16-bit PCM mono, 44.1 kHz).
Rodar: python tool/gen_sounds.py
Os sons têm envelope (ataque + decaimento) e fade nas pontas para não estalar.
"""

import math
import os
import struct
import wave

SR = 44100
OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "assets", "sounds")

# Timbre tipo sininho: fundamental + harmônicos mais fracos.
BELL = [(1, 1.0), (2, 0.45), (3, 0.18), (4, 0.08)]
# Timbre oco/buzzer (harmônicos ímpares), pro "errou" suave.
BUZZ = [(1, 1.0), (3, 0.35), (5, 0.18)]


def _add(buf, samples, start):
    """Soma `samples` em `buf` a partir do índice `start` (mistura/overlap)."""
    for i, s in enumerate(samples):
        j = start + i
        if 0 <= j < len(buf):
            buf[j] += s


def tone(freq, dur, harmonics=BELL, decay=6.0, attack=0.006, gain=1.0,
         glide_to=None):
    """Uma nota com envelope exponencial. `glide_to` faz glissando de pitch."""
    n = int(dur * SR)
    out = [0.0] * n
    for i in range(n):
        t = i / SR
        f = freq if glide_to is None else freq + (glide_to - freq) * (i / n)
        env = math.exp(-decay * t)
        if t < attack:                      # rampa de ataque (evita clique)
            env *= t / attack
        s = 0.0
        for mult, amp in harmonics:
            s += amp * math.sin(2 * math.pi * f * mult * t)
        out[i] = s * env * gain
    return out


def render(notes, tail=0.12):
    """notes: lista de (start_s, freq, dur, gain[, kwargs]). Retorna buffer."""
    total = max(s + d for s, _f, d, *_ in notes) + tail
    buf = [0.0] * int(total * SR)
    for start, freq, dur, gain, *rest in notes:
        kw = rest[0] if rest else {}
        _add(buf, tone(freq, dur, gain=gain, **kw), int(start * SR))
    return buf


def write_wav(name, buf, target_peak=0.89):
    # fade-in/out curtos nas pontas para não estalar.
    fade = int(0.008 * SR)
    for i in range(min(fade, len(buf))):
        buf[i] *= i / fade
        buf[-1 - i] *= i / fade
    # normaliza para o pico-alvo (sons de UI ficam mais baixos que feedback).
    peak = max((abs(x) for x in buf), default=1.0) or 1.0
    k = target_peak / peak
    frames = b"".join(
        struct.pack("<h", int(max(-1.0, min(1.0, x * k)) * 32767)) for x in buf
    )
    path = os.path.join(OUT_DIR, name)
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(frames)
    print(f"  {name:20s} {len(buf) / SR:0.2f}s")


# Notas (Hz)
C5, E5, G5 = 523.25, 659.25, 783.99
A5, C6, E6, G6 = 880.00, 1046.50, 1318.51, 1567.98

print("Gerando sons em assets/sounds/ ...")

# ✅ acerto: dois toques ascendentes, brilhante e curto.
write_wav("correct.wav", render([
    (0.00, G5, 0.18, 0.9),
    (0.07, C6, 0.32, 1.0),
]))

# ❌ erro: glissando descendente suave (não punitivo).
write_wav("wrong.wav", render([
    (0.00, 330.0, 0.34, 0.9, {"harmonics": BUZZ, "decay": 3.0,
                              "glide_to": 150.0}),
]))

# 🏁 fase concluída: arpejo ascendente curto (C-E-G-C).
write_wav("phase_complete.wav", render([
    (0.00, C5, 0.5, 0.8),
    (0.10, E5, 0.5, 0.8),
    (0.20, G5, 0.5, 0.85),
    (0.30, C6, 0.6, 0.95),
]))

# 🏆 vitória: arpejo + acorde final brilhante.
write_wav("victory.wav", render([
    (0.00, C5, 0.45, 0.75),
    (0.12, E5, 0.45, 0.75),
    (0.24, G5, 0.45, 0.8),
    (0.36, C6, 0.7, 0.9),
    (0.52, E6, 0.8, 0.7, {"decay": 4.0}),
    (0.52, G6, 0.9, 0.6, {"decay": 4.0}),
], tail=0.25))

# 👆 tap: tique curtíssimo, suave e BEM mais baixo que os sons de feedback.
write_wav("tap.wav", render([
    (0.00, E5, 0.035, 0.5, {"harmonics": [(1, 1.0), (2, 0.15)], "decay": 45.0}),
], tail=0.015), target_peak=0.30)

print("Pronto.")
