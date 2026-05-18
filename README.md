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
- **Engajamento curto.** Sessões rápidas de 5-10 perguntas, com gatilhos visuais (confete, flash) que dão peso a acerto e erro.

---

## Estado atual

Já implementado:

- Tema visual customizado (paleta Maio Amarelo)
- Tela inicial
- Loop principal do quiz:
  - Pergunta + alternativas
  - Feedback colorido nas opções (acerto/erro)
  - Painel de explicação após responder
  - Contador de streak 🔥 no topo
  - Barra de progresso e contador X/Y
- **Confete no acerto** e **flash vermelho no erro**
- Tela de resultado com pontuação e maior streak
- 10 perguntas iniciais hardcoded sobre situações reais (celular ao volante, álcool, cinto, bike, capacete, faixa, pista molhada etc.)

Próximos passos planejados:

- [ ] Persistência local de progresso (streak entre sessões)
- [ ] Sons de feedback
- [ ] Animações de transição entre perguntas
- [ ] Curva de dificuldade real (sortear perguntas conforme streak)
- [ ] Onboarding / boas-vindas
- [ ] Autenticação (Firebase Auth — modo anônimo no início)
- [ ] Banco de perguntas remoto (Firestore) com fallback local
- [ ] Tela de perfil e progresso histórico
- [ ] Curadoria pedagógica das perguntas

---

## Stack

- **Frontend:** [Flutter](https://flutter.dev/) (Android, iOS e Web do mesmo código-fonte)
- **Roteamento:** [`go_router`](https://pub.dev/packages/go_router)
- **Tipografia:** [`google_fonts`](https://pub.dev/packages/google_fonts) (Nunito)
- **Efeitos visuais:** [`confetti`](https://pub.dev/packages/confetti)
- **Backend (planejado):** Firebase — Auth, Firestore, Cloud Functions, Analytics

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
│   ├── router/                   # go_router (rotas)
│   └── theme/                    # Cores e ThemeData
├── features/
│   ├── home/                     # Tela inicial
│   └── quiz/                     # Loop do quiz
│       ├── models/               # Question, dificuldade
│       ├── data/                 # Repositório local de perguntas
│       └── quiz_screen.dart      # Tela principal do quiz
└── shared/                       # Widgets/utilitários compartilhados
```

---

## Contribuindo

Por enquanto o projeto está em desenvolvimento ativo por um pequeno grupo. Sugestões pedagógicas (especialmente sobre **conteúdo das perguntas** e **abordagem para o ensino médio**) são muito bem-vindas — abra uma issue descrevendo a ideia.

---

## Sobre o Maio Amarelo

O **Maio Amarelo** é um movimento internacional adotado no Brasil para conscientização sobre o trânsito seguro. A cada ano, durante o mês de maio, instituições, escolas, empresas e governos promovem ações para reduzir mortes e ferimentos no trânsito — tema que é uma das principais causas de morte de jovens no país.

Este projeto é uma contribuição educacional para essa causa.
