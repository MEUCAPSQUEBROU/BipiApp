# Efeitos sonoros do Bipi

Estes `.wav` são **gerados sinteticamente** pelo script `tool/gen_sounds.py`
(só usa a stdlib do Python — sem dependência externa). Para regerar ou ajustar
os sons, edite o script e rode:

```
python tool/gen_sounds.py
```

| Arquivo               | Quando toca                              | Caráter do som            |
|-----------------------|------------------------------------------|---------------------------|
| `correct.wav`         | Resposta certa (junto do confete)        | dois toques ascendentes   |
| `wrong.wav`           | Resposta errada                          | glissando descendente     |
| `phase_complete.wav`  | Fase da trilha concluída                 | arpejo curto (C-E-G-C)    |
| `victory.wav`         | Trilha do dia inteira concluída          | arpejo + acorde final     |
| `tap.wav`             | Botões da Home, começar fase e CONTINUAR | blip curtíssimo           |

## Quer trocar por sons "de verdade" depois?

É só substituir os arquivos por outros com o mesmo nome (e extensão `.wav`).
Os nomes são mapeados no enum `Sfx` em `lib/core/audio/sound_service.dart` — se
mudar a extensão (ex.: voltar pra `.mp3`), ajuste lá também.

Bancos de som grátis (licença livre): Mixkit, Kenney, Freesound.
