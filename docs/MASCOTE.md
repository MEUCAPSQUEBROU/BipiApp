# 🐻 Bipi — Ficha do Mascote

> Identidade visual do app **Bipi** (Maio Amarelo). O mascote **é** o Bipi: o app
> leva o nome dele, igual a coruja Duo no Duolingo. Este documento é a fonte da
> verdade pra qualquer arte, prompt de IA ou briefing de ilustrador.

---

## 1. Identidade

Urso-guarda de trânsito, mascote e cara do app. **Bordão: "BIP!"** — o apito dele
é a origem do nome. É o "amigo que manja de trânsito": puxa o jogador pra cima e
corrige sem brigar.

- **Tema:** segurança no trânsito / campanha Maio Amarelo.
- **Público:** ensino médio — **não infantilizar**.

## 2. Personalidade & voz

- **Tom:** empolgado, confiável, direto. Gíria leve de ensino médio OK, sem forçar.
- **Firmeza só no que importa:** segurança ele leva a sério; o resto é leveza.
- **Falas (evoluindo o copy atual do quiz):**
  - Acerto → *"Boa! BIP de aprovação 👮"*
  - Erro → *"Opa, atenção! Bora rever isso."*
  - Streak → *"Tá voando! 🔥"*
- **Nunca:** humilhar no erro, dar bronca, tom professoral chato.

## 3. ⚠️ Guardrails anti-"bebê" (crítico)

A vibe escolhida é **cartoon moderno e estiloso** — expressivo, ótimo pra animação.
O risco é escorregar pro "fofo de criança". Estes detalhes seguram a vibe descolada:

- **Olhos médios com sobrancelha definida** (a sobrancelha dá atitude) — *nada* de
  olhão gigante brilhante de filhote.
- **Focinho e queixo definidos**, não bolinha fofa.
- **Postura dinâmica e confiante** — peso numa perna, gesto de mão, ombro virado.
  Nunca "paradinho de pelúcia".
- **Cores ricas e com contraste**, não pastel baby.
- **Leve sorriso de canto / sobrancelha erguida** = "gente boa e seguro de si".

## 4. Proporção

- ~**2 a 2,5 cabeças** de altura, cabeça levemente maior (cartoon), corpo dinâmico.
- Idade lida: jovem cheio de energia (não adulto sério, não bebê).

## 5. Cores (paleta do app)

| Elemento | Cor | Hex |
|---|---|---|
| Pelo | Caramelo/mel quente | `#B5835A` |
| Colete refletivo | Amarelo (primary) | `#FFB800` |
| Quepe + detalhes escuros | Azul-noite | `#2B2D42` |
| Apito + acentos de energia | Laranja (streak) | `#FF9600` |
| Luvas / faixas refletivas | Branco/creme | `#FFFFFF` |
| Nariz / contorno | Marrom escuro | `#3A2A1E` |

## 6. Uniforme & itens (estilo híbrido)

Credível como agente, mas com design atual:

- **Quepe** de linhas clean com faixa amarela.
- **Colete refletivo** estilizado (amarelo + faixas brancas refletivas).
- **Luvas brancas** — pros gestos clássicos de trânsito.
- **Apito** numa cordinha (o "BIP!") — item-assinatura.
- **Plaquinha PARE / SIGA** como prop opcional.

## 7. Sistema de expressões / folha de poses

| Estado no app | Expressão / pose |
|---|---|
| Login / boas-vindas | Saudação ou apitando 🫡 |
| Acerto | Gesto "SIGA" + apito feliz |
| Erro | Mão em "PARE" com plaquinha — atento, não bravo |
| Streak 🔥 | Soquinho no ar, empolgado |
| Resultado bom | Segurando troféu / medalha |
| Loading / vazio | Olhando prancheta, pensativo |

## 8. Estilo de ilustração

Flat / vetorial, cantos arredondados, **traço de peso variável**, sombras chapadas
(2 tons), **fundo transparente**. Combina com a fonte **Nunito** e os botões
arredondados do app.

---

## 9. Prompts de IA para gerar a arte

> Use o **Prompt mestre** primeiro pra fixar o design (gere algumas variações e
> escolha a melhor). Depois reuse o MESMO personagem (via imagem de referência /
> mesma seed) pras poses. **Sempre fundo transparente** ou branco liso pra recortar.

### 9.1 Prompt mestre (referência do personagem)

```
Mascot character design of "Bipi", a friendly modern cartoon brown bear who is a
Brazilian traffic guard. Caramel/honey colored fur (#B5835A), confident young and
energetic vibe — NOT a baby. Medium almond eyes with defined eyebrows, defined snout
and jaw, slight confident smirk.

Outfit: clean modern traffic-guard cap (night-blue #2B2D42 with a yellow band),
stylized reflective safety vest (yellow #FFB800 with white reflective stripes),
white gloves, an orange whistle (#FF9600) on a cord around the neck.

Style: flat vector illustration, rounded shapes, variable-weight clean outline,
flat 2-tone shading, bold and rich colors with strong contrast. Full body, dynamic
confident pose (weight on one leg, one hand gesturing). Centered, transparent
background.
```

**Negative prompt (o que EVITAR):**
```
huge sparkly baby eyes, oversized head, diaper-cute proportions, infantile, chibi
baby, photorealistic, 3D render, realistic fur, cluttered background, text, watermark,
extra limbs, deformed hands
```

**Parâmetros sugeridos**
- **Midjourney:** adicione ` --style raw --ar 1:1` (e use `--cref <url>` pra manter o personagem nas próximas poses).
- **DALL·E / ChatGPT / Gemini:** cole o prompt mestre; depois peça *"o MESMO personagem, mesma roupa e estilo, agora [pose]"*.
- **Leonardo / SD:** estilo "flat vector / sticker", seed fixa pra consistência.

### 9.2 Prompts das poses (reusar o mesmo personagem)

Prefixe cada um com: *"Same Bipi bear character, same outfit and flat vector style,
transparent background —"*

| Pose | Continuação do prompt |
|---|---|
| Boas-vindas | `...standing and waving hello with a friendly salute, whistle in mouth, cheerful.` |
| Acerto | `...happy, doing a "go ahead" traffic hand signal, thumbs up, blowing the whistle, sparkles of joy.` |
| Erro | `...alert but kind, one white-gloved palm forward in a "STOP" gesture, holding a small STOP paddle, encouraging look (not angry).` |
| Streak 🔥 | `...excited fist pump in the air, energetic, small flame motif nearby.` |
| Vitória | `...proud, holding up a gold trophy/medal, big confident smile.` |
| Loading | `...curious and thoughtful, looking at a clipboard, scratching head.` |

### 9.3 Folha de poses (tudo de uma vez)

```
Character model sheet of the Bipi bear mascot (same design as above), 6 poses in a
grid on a plain white background: waving hello, "go ahead" signal with thumbs up,
"STOP" gesture with paddle, excited fist pump, holding a gold trophy, and looking at
a clipboard. Consistent character, outfit, colors and flat vector style across all
poses.
```

### 9.4 Versão ícone / logo

```
Simple app-icon version of the Bipi bear: head-and-shoulders, front view, wearing the
cap and reflective vest collar, on a solid yellow (#FFB800) rounded-square background.
Flat vector, bold, readable at small sizes.
```

---

## 10. Entregáveis ideais

- **PNG** com fundo transparente, alta resolução (≥1024px) por pose.
- **SVG** se possível (escala sem perder qualidade — ideal pro Flutter com `flutter_svg`).
- Guardar em `assets/mascote/` e declarar em `pubspec.yaml`.
- Depois disso, o código liga o Bipi nas telas (login, home, feedback do quiz, etc.).
