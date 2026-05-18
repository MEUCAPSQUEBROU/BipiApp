# Histórico do Projeto Bipi (Maio Amarelo)

> Arquivo de continuidade para o Claude Code. Atualizar a cada sessão para que, se o ambiente reiniciar (PC fraco), seja possível retomar exatamente de onde paramos.

---

## 1. Visão geral do projeto

- **Nome:** Bipi (referência ao som de buzina; sigla BIPI no nome do diretório).
- **Tema:** Campanha Maio Amarelo — segurança no trânsito.
- **Formato:** "Duolingo do trânsito" — app educacional gamificado.
- **Público-alvo:** Estudantes do ensino médio (não infantilizar).
- **Modelo de usuário:** aluno individual (sem turma/professor por enquanto).

### Mecânicas principais
- Sequência/streak de respostas corretas (estilo Duolingo)
- Sistema de pontuação
- Perguntas criativas e cativantes
- Conteúdo: regras de trânsito + melhores decisões em situações cotidianas
- Dificuldade progressiva conforme a streak aumenta

---

## 2. Stack técnica (decidida em 2026-05-18)

- **Frontend:** Flutter (Android + iOS + Web a partir de um único código)
- **Backend:** Firebase
  - Auth (login dos alunos)
  - Firestore (perguntas, progresso, ranking)
  - Cloud Functions (lógica de pontuação/streak server-side)
  - Analytics
- **Motivo:** priorizar experiência gamificada (animações, gestos, feedback sonoro) sobre facilidade de PWA.

### Dependências atuais (`pubspec.yaml`)
- `flutter` (sdk)
- `cupertino_icons: ^1.0.8`
- `go_router: ^17.2.3`
- `google_fonts: ^8.1.0`
- `confetti: ^0.8.0` — efeitos de confete no acerto
- Dev: `flutter_test`, `flutter_lints: ^6.0.0`
- SDK Dart: `^3.12.0`

> Firebase ainda **NÃO** foi adicionado às dependências — está apenas planejado.

---

## 3. Estrutura atual do código

```
lib/
├── app.dart                      # Widget raiz (MaterialApp)
├── main.dart                     # Entry point
├── core/
│   ├── router/
│   │   └── app_router.dart       # go_router (rotas: /, /quiz)
│   └── theme/
│       ├── app_colors.dart       # Paleta (amarelo Maio Amarelo)
│       └── app_theme.dart        # ThemeData
├── features/
│   ├── home/
│   │   └── home_screen.dart      # Tela inicial (botão COMEÇAR → /quiz)
│   └── quiz/
│       ├── quiz_screen.dart      # Loop principal do quiz + tela de resultado
│       ├── models/
│       │   └── question.dart     # Question + QuestionDifficulty
│       └── data/
│           └── questions_repository.dart  # 10 perguntas locais hardcoded
└── shared/
    └── widgets/                  # (vazia por enquanto)
```

Pastas planejadas mas ainda inexistentes:
- `lib/features/auth/`
- `lib/features/profile/`

---

## 4. Estado atual do desenvolvimento

**O que já existe:**
- Esqueleto Flutter inicial (Android + estrutura padrão)
- Tema com cores do Maio Amarelo
- Roteamento `go_router` com rotas `/` e `/quiz`
- Tela Home (botão COMEÇAR navega para o quiz)
- **Loop completo do quiz local** ✅
  - Modelo `Question` com texto, alternativas, índice correto, explicação e dificuldade
  - Banco hardcoded com 10 perguntas (4 fáceis, 3 médias, 3 difíceis)
  - Tela com pergunta + alternativas
  - Feedback visual de acerto/erro (cores, ícones)
  - Painel de explicação após responder
  - Contador de streak no header (chip com chama 🔥)
  - Barra de progresso e contador X/Y
  - Tela de resultado com pontuação, % e maior streak
  - Botões "Jogar de novo" e "Voltar pro início"
- `flutter analyze` limpo (zero issues)

**O que falta (roadmap sugerido):**
1. Testar visualmente no emulador/dispositivo e ajustar UX
2. Animações (transição entre perguntas, "shake" no erro, confete no acerto)
3. Sons de feedback (acerto, erro, "bipi" da buzina)
4. Curva de dificuldade real (ordenar/sortear perguntas conforme streak)
5. Persistência local de progresso (shared_preferences) — manter streak entre sessões
6. Tela de onboarding / boas-vindas
7. Autenticação (Firebase Auth — anônimo no início)
8. Migrar perguntas para Firestore (com fallback local)
9. Tela de perfil / progresso
10. Curadoria pedagógica das perguntas (revisar com base no CTB)

---

## 5. Decisões e convenções já estabelecidas

- **Idioma:** Português (BR) — usuário e código de domínio.
- **Não infantilizar** a UI/conteúdo — público é ensino médio.
- **Arquitetura:** feature-first (`lib/features/<feature>/...`) com `core/` para infra compartilhada.

---

## 6. Ambiente do usuário

- **PC fraco** — evitar comandos pesados sem necessidade.
- **OS:** Linux (Arch — `7.0.3-arch1-2`).
- **Shell:** bash.
- **Diretório:** `/home/juanoliveira/Documentos/Pasta Pessoal/Projeto maio amarelo - BIPI`
- **Git:** ainda **não** é um repositório git (considerar `git init` quando o usuário desejar).

---

## 7. Log de sessões

### 2026-05-18 — Sessão inicial (este arquivo)
- Criado `HISTORICO.md` a pedido do usuário para servir de memória persistente entre sessões caso o PC reinicie.
- Confirmado estado atual do código: esqueleto Flutter mínimo, sem Firebase ainda.

### 2026-05-18 — Ambiente de execução (Web/Chromium)
- PC fraco + sem clang/cmake → optamos por rodar via **Flutter Web no Chromium**.
- Instalado `chromium` via pacman (~200MB).
- Adicionado scaffold web ao projeto (`flutter create --platforms=web .`).
- Comando padrão de execução: `CHROME_EXECUTABLE=/usr/bin/chromium flutter run -d chrome`
- Primeira build de debug demora ~50s. Tela preta/branca inicial pode ser Google Fonts baixando.
- WebGL não disponível → renderer CPU (warning normal, não afeta funcionalidade).

### 2026-05-18 — Confete e flash vermelho
- Feedback do usuário: "UI/UX legal mas faltando vida".
- Adicionados:
  - **Confete no acerto** — `ConfettiWidget` explosivo (24 partículas, cores da paleta + branco + azul) disparado por `ConfettiController.play()`.
  - **Flash vermelho no erro** — overlay vignette (RadialGradient transparente→vermelho 55%) com AnimatedOpacity, dura ~450ms e some.
- Stack envolve o body para sobrepor overlays sem afetar interações (IgnorePointer no flash).
- `flutter analyze` limpo.

### 2026-05-18 — Loop do quiz local implementado
- Decidido (juntos) começar pelo quiz local antes de tocar em Firebase — mais leve para o PC e valida UX antes de fixar schema.
- Criados:
  - `lib/features/quiz/models/question.dart` — modelo `Question` + enum `QuestionDifficulty`
  - `lib/features/quiz/data/questions_repository.dart` — 10 perguntas hardcoded sobre trânsito (foco em situações reais do dia a dia: celular, álcool, cinto, bike, capacete, faixa, pista molhada)
  - `lib/features/quiz/quiz_screen.dart` — tela completa: pergunta, alternativas, feedback colorido, explicação, streak chip, barra de progresso, tela de resultado
  - Rota `/quiz` registrada e botão COMEÇAR da Home agora navega para ela
- `flutter analyze` → **No issues found**
- **Próxima ação esperada:** usuário testar visualmente (rodar `flutter run`) e dar feedback de UX. Em paralelo, podemos avançar para persistência local de progresso (shared_preferences) ou para sons/animações.

---

## 8. Como o Claude deve usar este arquivo

1. **Sempre ler primeiro** ao iniciar uma nova sessão.
2. **Atualizar a seção "Log de sessões"** ao final de cada sessão produtiva — adicionar uma entrada datada com o que foi feito e o que ficou pendente.
3. **Atualizar a seção "Estado atual do desenvolvimento"** quando algo for concluído ou o roadmap mudar.
4. **Atualizar a "Stack técnica"** se houver mudança de dependência ou decisão arquitetural.
5. Manter o tom direto e em português.
