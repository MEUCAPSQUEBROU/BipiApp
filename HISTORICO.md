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

> Firebase **ADICIONADO** em 2026-05-24: `firebase_core`, `firebase_auth`, `google_sign_in` — ver Seção 5 e o log de 2026-05-24. **Mudança de rumo:** o login passou a ser **e-mail/senha + Google** (não mais anônimo). `cloud_firestore` ainda **não** foi adicionado (persistência de progresso fica pra depois).

### Ferramentas de linha de comando já instaladas (2026-05-24)
- **Firebase CLI** `15.18.0` (via `npm install -g firebase-tools`).
- **FlutterFire CLI** `1.3.2` (via `dart pub global activate flutterfire_cli`). Executável em `C:\Users\silen\AppData\Local\Pub\Cache\bin` (já adicionado ao PATH do usuário).
- **node** v24.14.0 / **npm** 11.9.0.

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

> **Atualizado 2026-05-24:** adicionados `lib/core/auth/auth_service.dart` e `lib/features/auth/` (login_screen, register_screen, widgets/). O router agora tem `/login` e `/register` com proteção de rotas.

Pastas planejadas mas ainda inexistentes:
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
7. ~~Autenticação~~ ✅ **FEITO (2026-05-24): Firebase Auth e-mail/senha + Google** (mudou de anônimo p/ login real)
8. Migrar perguntas para Firestore (com fallback local)
9. Tela de perfil / progresso
10. Curadoria pedagógica das perguntas (revisar com base no CTB)

---

## 5. Decisões e convenções já estabelecidas

- **Idioma:** Português (BR) — usuário e código de domínio.
- **Não infantilizar** a UI/conteúdo — público é ensino médio.
- **Arquitetura:** feature-first (`lib/features/<feature>/...`) com `core/` para infra compartilhada.
- **Login/Autenticação (REVISADO em 2026-05-24 — implementado e testado):** **Firebase Auth com E-mail/senha + Google Sign-In.**
  - **Mudança consciente de rumo:** mais cedo no mesmo dia o plano era **Auth Anônimo + apelido** pra evitar coletar dado pessoal de menor (LGPD/ECA). O usuário **optou por login real** com e-mail/senha + Google.
  - ⚠️ **Atenção LGPD/ECA:** isso coleta nome/e-mail de público potencialmente menor de idade — tratar consentimento/aviso de privacidade **antes de produção**.
  - **Persistência de progresso:** ainda **não** implementada (sem Firestore por ora). `streak`/pontos seguem só na memória do `quiz_screen`. Quando fizer, manter atrás de abstração (`ProfileRepository`).
- **Conta/projeto Firebase:** projeto **`bipionfirebase`** (conta pessoal do usuário, plataforma **Android** apenas). **NÃO** usar `yoaibot25@gmail.com` (é só o login do Claude Code).
- **Arquivo sensível:** `android/app/google-services.json` está no **`.gitignore`** — re-baixar do console ao trocar de máquina.

---

## 6. Ambiente do usuário

> ⚠️ **O projeto MIGROU de máquina em 2026-05-24.** Antes era Linux/Arch; agora é Windows. As infos abaixo são as ATUAIS.

- **PC fraco** — evitar comandos pesados sem necessidade.
- **OS:** Windows 11 Pro for Workstations (25H2, build 10.0.26200).
- **Shell:** PowerShell (sintaxe PowerShell — `$env:VAR`, `$null`, backtick para continuação).
- **Diretório:** `C:\Users\silen\Documents\Uninassau\Bipi\Bipi`
- **Git:** ✅ **já é** repositório git. Branch `main`, commit inicial `16424c8 chore: initial commit do Bipi (Maio Amarelo)`.
- **Flutter SDK:** `C:\src\flutter` (canal **stable 3.44.0**), já no PATH do usuário (`C:\src\flutter\bin`).
- **Navegador web:** Chrome instalado via winget (148.x). Rodar com `flutter run -d chrome` (primeira build web ~47s). Edge também serve (`-d edge`).
- **flutter doctor:** ✅ Flutter, ✅ Chrome (web), ✅ devices. ✗ Android toolchain e ✗ Visual Studio (C++) — eram **esperados/ignoráveis** enquanto só rodávamos web. **A partir do Android Studio o Android toolchain deve ser resolvido.**
- **Histórico (Linux antigo):** OS Arch `7.0.3-arch1-2`, shell bash, dir `/home/juanoliveira/Documentos/Pasta Pessoal/Projeto maio amarelo - BIPI`.

### Pegadinha de PATH (importante)
A sessão de terminal da ferramenta do Claude e o processo `flutter run` foram abertos **antes** de o Flutter entrar no PATH, então não enxergavam `flutter`/`dart`/`flutterfire`. Solução: chamar pelo caminho completo (`C:\src\flutter\bin\flutter.bat`, `...\dart.bat`) ou prefixar `$env:Path = "C:\src\flutter\bin;C:\Users\silen\AppData\Local\Pub\Cache\bin;" + $env:Path`. **Terminais NOVOS** (inclusive o do Android Studio) já pegam o PATH correto.

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

### 2026-05-24 — Migração p/ Windows + setup Firebase (sessão interrompida p/ continuar no Android Studio)

**Contexto:** projeto migrado de Linux/Arch para **Windows 11**. Nesta máquina não havia Flutter.

**O que foi feito:**
1. **Ambiente montado do zero no Windows** (sem Android Studio, foco em web):
   - Flutter SDK clonado/instalado em `C:\src\flutter` (stable 3.44.0) e posto no PATH do usuário.
   - Chrome instalado via `winget install --id Google.Chrome -e`.
   - `flutter pub get` rodado com sucesso (8 pacotes com versões mais novas incompatíveis — normal, ignorado).
   - **App rodou OK** via `flutter run -d chrome` (primeira build ~47s). Usuário confirmou: "rodou perfeitamente".
2. **Decisão de produto:** login = **Firebase Auth Anônimo + Firestore** (ver Seção 5 para a justificativa completa). Conta do projeto: `juandantas27.02@gmail.com`.
3. **CLIs instalados:** Firebase CLI 15.18.0 (npm global) e FlutterFire CLI 1.3.2 (dart pub global; bin adicionado ao PATH).

**Estado do código relevante p/ o login:**
- `lib/features/home/home_screen.dart`: existe um botão **"JÁ TENHO UMA CONTA"** com `onPressed: () {}` **vazio** (stub). Plano: esconder/desabilitar por ora; **"COMEÇAR"** deve levar a um onboarding curto pedindo **apelido**.
- **Não há** auth, modelo de usuário nem persistência. O `streak`/pontuação vivem só na memória do `quiz_screen` e **zeram a cada sessão**.
- Estrutura ainda é a da Seção 3 (sem `lib/features/auth/` nem `lib/features/profile/`).

**⛔ BLOQUEIO (passos interativos pendentes — fazer no terminal do Android Studio):**
1. `firebase login` → escolher conta **`juandantas27.02@gmail.com`**.
   - ⚠️ Não roda pela caixa do Claude Code (deu `Error: Cannot run login in non-interactive mode`). Tem que ser num terminal interativo de verdade.
2. No [console Firebase](https://console.firebase.google.com): criar projeto (sugestão **bipi-maio-amarelo**).
3. Authentication → Sign-in method → **Anonymous** → Enable.
4. Firestore Database → Create database → região **`southamerica-east1` (São Paulo)** → production mode.
5. `flutterfire configure --project=<ID> --platforms=web,android` → gera `lib/firebase_options.dart` (precisa do passo 1 feito).
   - **Anotar aqui o ID do projeto quando criado:** `__________` (preencher!)

**📋 TODO de código (NÃO iniciado — fazer depois do bloqueio acima):**
- [ ] Add `firebase_core`, `firebase_auth`, `cloud_firestore` ao `pubspec.yaml` + `flutter pub get`.
- [ ] Inicializar Firebase no `lib/main.dart` (`Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`).
- [ ] `AuthService` com login anônimo (`signInAnonymously`) + stream de estado de auth.
- [ ] Tela de onboarding pedindo **apelido** (sem e-mail/senha).
- [ ] `ProfileRepository` abstrato + `FirebaseProfileRepository` (coleção `users/{uid}`).
- [ ] Persistir progresso real ao fim do quiz (pontos, maiorStreak, respostas).
- [ ] Redirect de rota no `go_router`: sem sessão → onboarding; com sessão → home.
- [ ] **Regras de segurança Firestore:** aluno lê/escreve só o próprio `users/{uid}`; ranking = leitura. (Fornecer p/ colar no console.)

**Modelo de dados Firestore combinado:**
```
users/{uid} {
  apelido: string,
  pontos: number,
  maiorStreak: number,
  respostas: number,
  criadoEm: timestamp,
  atualizadoEm: timestamp
}
```

**▶️ RETOMAR AQUI:** abrir o projeto no Android Studio, fazer os 5 passos do bloqueio (anotar o ID do projeto acima), e então tocar o TODO de código na ordem.

### 2026-05-24 (continuação) — Login com Firebase Auth implementado (e-mail/senha + Google)

**Mudança de rumo (consciente):** o plano anterior (entrada acima / Seção 5) era Auth Anônimo + apelido. O usuário optou por **login real com e-mail/senha + Google Sign-In**. ⚠️ Coleta nome/e-mail de público potencialmente menor → revisar LGPD/ECA antes de produção.

**Ambiente Android montado:**
- SDK Flutter em `C:\src\flutter` — **NÃO está no PATH** deste terminal; chamar via `C:\src\flutter\bin\flutter.bat` / `dart.bat`.
- Instalado **Android SDK Command-line Tools** (Android Studio → SDK Tools).
- Licenças do SDK aceitas via `sdkmanager --licenses` com `JAVA_HOME` = JBR do Android Studio (`C:\Program Files\Android\Android Studio\jbr`). (O `flutter doctor --android-licenses` não consumia o stdin pelo terminal do Claude.)
- `debug.keystore` gerada manualmente com keytool do JBR. **SHA-1:** `7C:5F:BF:2C:DC:09:0D:A1:B6:C0:D2:AF:F2:8C:86:B9:91:26:96:A9`.
- Android toolchain do `flutter doctor` ficou ✅. App rodado no **Motorola Edge 50 Fusion** (Android 16) via USB.

**Firebase (projeto `bipionfirebase`, só Android):**
- Providers habilitados no console: **E-mail/senha** + **Google** (SHA-1 acima registrado no app Android).
- `android/app/google-services.json` baixado e posto no lugar — ⚠️ **gitignored** (re-baixar do console ao trocar de máquina).
- Plugin Gradle `com.google.gms.google-services` 4.4.4 em `settings.gradle.kts` + `app/build.gradle.kts`.
- `main.dart`: `Firebase.initializeApp()` sem options (Android lê o google-services.json).

**Código adicionado:**
- `lib/core/auth/auth_service.dart` — `AuthService` (singleton `authService`): e-mail/senha, Google, reset de senha, logout, erros traduzidos PT. google_sign_in **7.x** (`GoogleSignIn.instance` + `initialize(serverClientId:)` + `authenticate()`); `serverClientId` = Client ID Web (client_type 3) do oauth_client.
- `lib/features/auth/{login_screen,register_screen}.dart` + `widgets/{auth_text_field,google_button}.dart`.
- `lib/core/router/app_router.dart` — `/login`, `/register` + redirect protegendo rotas via `GoRouterRefreshStream(authService.authStateChanges)`.
- `lib/features/home/home_screen.dart` — saúda o usuário logado + botão **SAIR**.
- `pubspec.yaml`: + `firebase_core` 4.9.0, `firebase_auth` 6.5.1, `google_sign_in` 7.2.0.

**Testado no dispositivo real:** criar conta, login, Google, logout e persistência de sessão — **tudo OK** ✅. `flutter analyze` limpo.

**Pendências / próximos:**
- Persistência de progresso por usuário (Firestore) — ainda não feito (streak/pontos zeram a cada sessão).
- Verificação de e-mail; tela de perfil (mostrar foto/e-mail do Google).
- LGPD/ECA: consentimento/aviso de privacidade antes de produção.
- Rodar em Web/iOS exigirá registrar essas plataformas (usar `flutterfire configure`, já instalado).

### 2026-05-24 (mascote + trilha) — Identidade visual e trilha diária

**Mascote Bipi:** 4 expressões (normal / feliz / dúvida / decepção) geradas por IA. Fundo recortado p/ transparente + auto-crop (flood-fill via `Add-Type` C#, sem ImageMagick). Em `assets/mascote/bipi_*.png`. Widget `BipiMascot(BipiMood.x)` em `lib/core/widgets/bipi_mascot.dart`. Usado no login, home e tela de resultado do quiz. Conceito completo em `docs/MASCOTE.md`. Originais (com fundo) em `assets/mascote/_originais/` (**gitignored**).

**Trilha diária (estilo Duolingo):** em `lib/features/trilha/`. 5 fases/dia × 3 perguntas; set **determinístico por data** (`DailyChallenge`, seed = data → mesmo conjunto pra todos, p/ ranking justo). Caminho sinuoso com fases bloqueada/atual/concluída (`TrilhaScreen`). Banco de perguntas expandido 10 → **40** (`QuestionsRepository.all()`). Home **COMEÇAR → `/trilha`**; o quiz recebe a `Phase` via `extra` e marca conclusão ao terminar.
- ⚠️ **Progresso em memória** (`TrilhaProgress` singleton) — zera ao fechar o app. Persistência entra junto com o ranking.

**Decisões:** mascote = o próprio Bipi (app leva o nome dele). Ranking será **online via Firestore** (próximo passo, em andamento). Conteúdo: ~40 perguntas (expansível).

### 2026-05-24 (ranking online) — Ranking top 10 via Firestore

Firestore ativado (região **southamerica-east1**, modo produção) + regras publicadas (`ranking/{uid}`: leitura p/ qualquer logado, escrita só do próprio uid). Dependência `cloud_firestore` ^6.4.1.
- `lib/features/ranking/data/score_repository.dart`: `ScoreRepository` (singleton `scoreRepository`). Coleção `ranking/{uid}` = { nome, pontos, atualizadoEm }. `addPoints` usa `FieldValue.increment` (best-effort, try/catch) e `top10()` faz `orderBy('pontos' desc).limit(10)`.
- `lib/features/ranking/ranking_screen.dart`: top 10 com pódio 🥇🥈🥉, destaque do próprio usuário, pull-to-refresh, estados de vazio/erro com o Bipi.
- Home: botão **RANKING** (rota `/ranking`). Quiz: **+10 pts por acerto** ao concluir uma fase (só na 1ª vez, checagem in-memory).
- **Testado no dispositivo real:** pontuou e apareceu no ranking ✅.
- ⚠️ Pendências: progresso da trilha ainda **em memória** (dá pra "farmar" pontos reabrindo o app, pois o `firstTime` é in-memory) → persistência é o próximo passo. **Onboarding do Bipi** (balões pós-login) ainda não feito.

---

## 8. Como o Claude deve usar este arquivo

1. **Sempre ler primeiro** ao iniciar uma nova sessão.
2. **Atualizar a seção "Log de sessões"** ao final de cada sessão produtiva — adicionar uma entrada datada com o que foi feito e o que ficou pendente.
3. **Atualizar a seção "Estado atual do desenvolvimento"** quando algo for concluído ou o roadmap mudar.
4. **Atualizar a "Stack técnica"** se houver mudança de dependência ou decisão arquitetural.
5. Manter o tom direto e em português.
