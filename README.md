# Bipi

> Aplicativo educacional gamificado sobre segurança no trânsito, criado em apoio à campanha **Maio Amarelo**.

> ⚠️ **Em desenvolvimento.** Funcionalidades, telas e mecânicas ainda estão sendo construídas — espere mudanças frequentes.

---

## Sobre

**Bipi** (referência ao som da buzina) é um app educacional voltado para estudantes do ensino médio. A proposta é aproximar regras de trânsito e decisões cotidianas do dia a dia do jovem através de um quiz rápido, com feedback imediato e mecânicas de progresso (streak, pontuação e dificuldade crescente).

A meta é distribuir o app em escolas como ferramenta de apoio à campanha **Maio Amarelo** — movimento brasileiro de conscientização sobre segurança viária.

---

## Princípios de design

- **Não infantilizar.** O público é ensino médio; o tom e o visual respeitam isso.
- **Decisão > memorização.** Perguntas são situações reais ("o que você faria se..."), não decoreba de artigo do CTB.
- **Feedback é o aprendizado.** Cada resposta vem com uma explicação curta sobre o porquê.
- **Engajamento curto.** Sessões rápidas de poucas perguntas, com gatilhos sensoriais (confete, flash, som e vibração) que dão peso a acerto e erro.

---

## Estado atual

Já implementado:

- Tema visual customizado (paleta Maio Amarelo) e mascote **Bipi** (ícone do app + expressões)
- **Autenticação** (Firebase Auth): login/cadastro por e-mail e **login com Google**
- **Onboarding** do Bipi após o primeiro login
- **Tela inicial** (Começar, Ranking, Sair)
- **Trilha diária** estilo Duolingo: caminho de fases que muda a cada dia, com desbloqueio progressivo e rampa de dificuldade
- Loop principal do quiz:
  - Pergunta + alternativas
  - Feedback colorido nas opções (acerto/erro)
  - Painel de explicação após responder
  - Contador de streak 🔥 no topo
  - Barra de progresso e contador X/Y
- **Feedback multissensorial:** confete + som no acerto, flash vermelho + som no erro, e vibração (háptico) nos dois
- **Efeitos sonoros** nos momentos-chave (acerto, erro, fase concluída, trilha completa, toques de botão), com **botão de mudo** que persiste a escolha
- Tela de resultado com pontuação e maior streak
- **Ranking** com pódio (top 3) e leaderboard, sincronizado via Firestore
- Banco inicial de perguntas sobre situações reais (celular ao volante, álcool, cinto, bike, capacete, faixa, pista molhada etc.)

Próximos passos planejados:

- [ ] Persistência do progresso da trilha (hoje é em memória — zera ao fechar o app)
- [ ] Animações de transição entre perguntas
- [ ] Banco de perguntas remoto (Firestore) com fallback local
- [ ] Tela de perfil e progresso histórico
- [ ] Curadoria pedagógica das perguntas

---

## Stack

- **Frontend:** [Flutter](https://flutter.dev/) (Android, iOS e Web do mesmo código-fonte)
- **Roteamento:** [`go_router`](https://pub.dev/packages/go_router)
- **Tipografia:** [`google_fonts`](https://pub.dev/packages/google_fonts) (Nunito)
- **Efeitos visuais:** [`confetti`](https://pub.dev/packages/confetti)
- **Áudio:** [`audioplayers`](https://pub.dev/packages/audioplayers) (efeitos sintetizados — ver `assets/sounds/`) + `HapticFeedback` nativo
- **Backend:** Firebase — [`firebase_auth`](https://pub.dev/packages/firebase_auth) (e-mail + Google) e [`cloud_firestore`](https://pub.dev/packages/cloud_firestore) (ranking); persistência local com [`shared_preferences`](https://pub.dev/packages/shared_preferences)

Requisitos mínimos:

- Flutter SDK estável (testado em **3.44.0**)
- Dart SDK `^3.12.0`

---

## Como rodar

Instale as dependências:

```bash
flutter pub get
```

### Web (Chrome / Chromium)

```bash
flutter run -d chrome
```

> Se estiver usando Chromium, exporte `CHROME_EXECUTABLE=/usr/bin/chromium` antes do comando. Em ambientes KDE, adicione `--web-browser-flag=--password-store=basic` para evitar o prompt do KDE Wallet.

### Android

```bash
flutter run -d <device-id>
```

(Liste os dispositivos disponíveis com `flutter devices`.)

---

## Estrutura do projeto

```
lib/
├── main.dart                     # Entry point
├── app.dart                      # Widget raiz (MaterialApp.router)
├── core/
│   ├── audio/                    # SoundService (efeitos sonoros + mudo)
│   ├── auth/                     # Firebase Auth
│   ├── onboarding/               # Estado do onboarding (shared_preferences)
│   ├── router/                   # go_router (rotas)
│   ├── theme/                    # Cores e ThemeData
│   └── widgets/                  # Mascote Bipi e compartilhados
└── features/
    ├── auth/                     # Login e cadastro
    ├── home/                     # Tela inicial
    ├── onboarding/               # Introdução do Bipi
    ├── quiz/                     # Loop do quiz (+ models, data)
    ├── ranking/                  # Pódio e leaderboard (Firestore)
    └── trilha/                   # Trilha diária de fases

assets/
├── icon/                         # Ícone do app
├── mascote/                      # Expressões do Bipi
└── sounds/                       # Efeitos sonoros (gerados por tool/gen_sounds.py)

tool/
└── gen_sounds.py                 # Gera os efeitos sonoros (.wav)
```

---

## Contribuindo

Por enquanto o projeto está em desenvolvimento ativo por um pequeno grupo. Sugestões pedagógicas (especialmente sobre **conteúdo das perguntas** e **abordagem para o ensino médio**) são muito bem-vindas — abra uma issue descrevendo a ideia.

---

## Sobre o Maio Amarelo

O **Maio Amarelo** é um movimento internacional adotado no Brasil para conscientização sobre o trânsito seguro. A cada ano, durante o mês de maio, instituições, escolas, empresas e governos promovem ações para reduzir mortes e ferimentos no trânsito — tema que é uma das principais causas de morte de jovens no país.

Este projeto é uma contribuição educacional para essa causa.
