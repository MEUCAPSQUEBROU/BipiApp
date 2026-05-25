import '../models/question.dart';

class QuestionsRepository {
  const QuestionsRepository();

  /// Banco completo de perguntas (usado pela trilha diária).
  List<Question> all() => _bank;

  /// Pacote curto para jogo avulso / fallback.
  List<Question> loadStarterPack() => _bank.take(10).toList();

  // Princípios do banco:
  // - As 4 alternativas têm tamanho/estilo parecidos (a correta NÃO é a maior).
  // - A posição da resposta certa varia entre as perguntas.
  // - A explicação (mostrada após responder) é que traz o detalhamento.
  static const List<Question> _bank = [
    // ───────────────────────── FÁCEIS ─────────────────────────
    Question(
      id: 'q01',
      statement: 'Como o pedestre deve atravessar a rua?',
      options: [
        'Pelo ponto mais curto, mesmo fora da faixa',
        'Pela faixa de pedestres sempre que houver',
        'Correndo, para passar o mais rápido possível',
        'Por entre os carros quando eles estão parados',
      ],
      correctIndex: 1,
      explanation:
          'A faixa é o ponto onde o motorista espera o pedestre. Fora dela, o risco de atropelamento é muito maior.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q02',
      statement: 'O cinto de segurança deve ser usado por quem?',
      options: [
        'Apenas por quem vai no banco da frente',
        'Somente pelo motorista do veículo',
        'Por todos os ocupantes, em qualquer banco',
        'Só em viagens longas por estrada',
      ],
      correctIndex: 2,
      explanation:
          'Todos os ocupantes devem usar cinto, em qualquer banco. É o equipamento que mais salva vidas no trânsito.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q03',
      statement:
          'Qual a idade mínima para tirar a habilitação de carro no Brasil?',
      options: ['16 anos', '17 anos', '18 anos', '21 anos'],
      correctIndex: 2,
      explanation: 'A CNH só pode ser emitida a partir dos 18 anos completos.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q04',
      statement: 'Depois de beber qualquer quantidade de álcool, o motorista:',
      options: [
        'Pode dirigir se tiver bebido pouco',
        'Não pode dirigir — é tolerância zero',
        'Pode dirigir depois de uma hora',
        'Pode dirigir, desde que devagar',
      ],
      correctIndex: 1,
      explanation:
          'A Lei Seca é tolerância zero: qualquer quantidade de álcool já é infração gravíssima.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q05',
      statement: 'Quando o capacete é obrigatório na motocicleta?',
      options: [
        'Somente para o piloto',
        'Apenas quando se anda em rodovia',
        'Só em trajetos longos',
        'Sempre, para piloto e passageiro',
      ],
      correctIndex: 3,
      explanation:
          'Capacete afivelado é obrigatório sempre, para os dois. A maioria das mortes de motociclistas envolve trauma na cabeça.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q06',
      statement: 'No sinal vermelho, o que o motorista deve fazer?',
      options: [
        'Parar e aguardar o sinal abrir',
        'Avançar se não vier ninguém',
        'Reduzir e passar com atenção',
        'Buzinar e seguir em frente',
      ],
      correctIndex: 0,
      explanation:
          'Avançar o vermelho é infração gravíssima e uma das maiores causas de colisão em cruzamento — inclusive de madrugada.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q07',
      statement: 'Para que serve a faixa de pedestres?',
      options: [
        'Marcar onde os carros podem estacionar',
        'Indicar o limite de velocidade da via',
        'Dar ao pedestre um ponto seguro de travessia',
        'Separar as faixas de rolamento dos carros',
      ],
      correctIndex: 2,
      explanation:
          'Na faixa, o pedestre tem prioridade e o motorista já espera a travessia ali.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q08',
      statement: 'De bicicleta na via, em que sentido o ciclista deve andar?',
      options: [
        'Na contramão, para ver os carros vindo',
        'No mesmo sentido do fluxo dos carros',
        'Sempre na calçada, junto aos pedestres',
        'Pelo meio da pista, bem ao centro',
      ],
      correctIndex: 1,
      explanation:
          'O ciclista segue no mesmo sentido do trânsito (de preferência em ciclovia). Contramão e calçada são perigosos e proibidos.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q09',
      statement: 'Qual é o uso correto da buzina?',
      options: [
        'Avisar e ajudar a evitar um acidente',
        'Apressar o carro que está na frente',
        'Demonstrar irritação com os outros',
        'Avisar a família que chegou em casa',
      ],
      correctIndex: 0,
      explanation:
          'A buzina é um toque breve, só para alertar. Usá-la de forma prolongada ou desnecessária é infração.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q10',
      statement: 'Antes de mudar de faixa ou virar, o motorista deve:',
      options: [
        'Acelerar para completar a manobra logo',
        'Buzinar para avisar quem está atrás',
        'Sinalizar com a seta com antecedência',
        'Acender o pisca-alerta do veículo',
      ],
      correctIndex: 2,
      explanation:
          'A seta comunica sua intenção a tempo. Junto com olhar os retrovisores, evita colisões laterais.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q11',
      statement: 'Onde uma criança pequena deve ser transportada no carro?',
      options: [
        'No colo de um adulto, com cinto',
        'No banco da frente, se for baixa',
        'No banco de trás, no dispositivo de retenção',
        'Em qualquer lugar, se o trajeto for curto',
      ],
      correctIndex: 2,
      explanation:
          'Até os 10 anos a criança vai no banco de trás, com cadeirinha/assento adequado à idade. O airbag da frente é perigoso para ela.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q12',
      statement: 'Ao ver uma ambulância com a sirene ligada, você deve:',
      options: [
        'Acelerar para sair logo da frente',
        'Parar onde estiver, no meio da via',
        'Dar passagem, encostando à direita',
        'Seguir normalmente, ela se vira',
      ],
      correctIndex: 2,
      explanation:
          'Veículos de emergência têm prioridade. Encoste à direita com segurança e libere a passagem — pode ser uma vida em jogo.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q13',
      statement: 'Jogar lixo ou bituca pela janela do carro é:',
      options: [
        'Normal, logo some no chão',
        'Permitido fora da cidade',
        'Aceitável, se for algo pequeno',
        'Infração — e risco de incêndio e enchente',
      ],
      correctIndex: 3,
      explanation:
          'Além de infração, bituca acesa causa incêndio em margem de via e lixo entope bueiros, provocando alagamentos.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q14',
      statement: 'Ao passar por uma via em frente a uma escola, o motorista deve:',
      options: [
        'Reduzir a velocidade e redobrar a atenção',
        'Buzinar para que as crianças se afastem',
        'Manter a mesma velocidade de sempre',
        'Acelerar para passar o quanto antes',
      ],
      correctIndex: 0,
      explanation:
          'Perto de escolas a velocidade é reduzida: crianças são imprevisíveis e podem atravessar correndo, sem olhar.',
      difficulty: QuestionDifficulty.facil,
    ),
    Question(
      id: 'q15',
      statement: 'Para andar de bicicleta à noite, o ciclista precisa de:',
      options: [
        'Nada além de pedalar com cuidado',
        'Luzes e refletivos para ser visto',
        'Uma buzina o mais alta possível',
        'Roupa escura para não chamar atenção',
      ],
      correctIndex: 1,
      explanation:
          'À noite o ciclista quase some no trânsito. Luzes (frente e trás), refletivos e roupa clara são o que o tornam visível.',
      difficulty: QuestionDifficulty.facil,
    ),

    // ───────────────────────── MÉDIAS ─────────────────────────
    Question(
      id: 'q16',
      statement: 'Numa rotatória, quem tem a preferência de passagem?',
      options: [
        'Quem está chegando para entrar nela',
        'O veículo de maior porte',
        'Quem já está circulando dentro dela',
        'Quem chegar primeiro e buzinar',
      ],
      correctIndex: 2,
      explanation:
          'Quem já está na rotatória tem preferência; quem vai entrar aguarda uma brecha segura.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q17',
      statement: 'A chamada "regra dos 2 segundos" serve para:',
      options: [
        'Cronometrar o tempo parado no farol',
        'Manter distância segura do carro da frente',
        'Saber a hora certa de trocar de marcha',
        'Calcular o consumo de combustível',
      ],
      correctIndex: 1,
      explanation:
          'Conte 2 segundos entre o carro da frente passar por um ponto e você passar pelo mesmo ponto. Na chuva, aumente para 3 ou mais.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q18',
      statement: 'A linha amarela contínua no centro da pista indica que:',
      options: [
        'Você pode ultrapassar com atenção',
        'Começa uma rua de mão dupla',
        'A ultrapassagem ali é proibida',
        'É permitido parar e estacionar',
      ],
      correctIndex: 2,
      explanation:
          'Linha contínua proíbe ultrapassar e transpor — ela existe em trechos de risco, como curvas e lombadas.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q19',
      statement:
          'Numa avenida urbana sem placa de velocidade, o limite costuma ser:',
      options: ['40 km/h', '60 km/h', '80 km/h', '100 km/h'],
      correctIndex: 1,
      explanation:
          'Sem sinalização, o CTB define: via local 30, coletora 40, arterial (avenida) 60 e via rápida 80 km/h.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q20',
      statement: 'Em neblina densa, qual iluminação o motorista deve usar?',
      options: [
        'Farol alto, para enxergar mais longe',
        'Pisca-alerta, mantendo a velocidade',
        'Apenas as luzes do painel',
        'Farol baixo e o de neblina',
      ],
      correctIndex: 3,
      explanation:
          'O farol alto reflete na neblina e ofusca. Use o baixo (e o de neblina), reduza a velocidade e aumente a distância.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q21',
      statement: 'Por que o "ponto cego" de um caminhão é perigoso?',
      options: [
        'Porque o motorista pode não te enxergar',
        'Porque o caminhão faz muito barulho',
        'Porque a fumaça atrapalha sua visão',
        'Porque o caminhão anda muito devagar',
      ],
      correctIndex: 0,
      explanation:
          'Regra de ouro: se você não vê o rosto do motorista no retrovisor dele, ele não está te vendo.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q22',
      statement: 'Numa colisão, o passageiro sem cinto no banco de trás:',
      options: [
        'Fica protegido pelo encosto do banco',
        'Corre risco apenas de arranhões',
        'É arremessado contra quem está na frente',
        'Não se machuca em baixa velocidade',
      ],
      correctIndex: 2,
      explanation:
          'A 50 km/h, o corpo é lançado com força de várias vezes o próprio peso — podendo matar quem está no banco da frente.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q23',
      statement: 'A faixa exclusiva de ônibus pode ser usada por um carro:',
      options: [
        'A qualquer hora, sem restrição',
        'Apenas onde e quando a placa permitir',
        'Quando o motorista está atrasado',
        'Sempre nos fins de semana',
      ],
      correctIndex: 1,
      explanation:
          'A faixa é do transporte coletivo. O carro só entra onde a sinalização libera, em geral para conversão. Fora disso, é infração.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q24',
      statement: 'Por que um pneu "careca" (liso) é tão perigoso?',
      options: [
        'Porque faz mais barulho ao rodar',
        'Porque gasta mais combustível',
        'Porque perde aderência e demora a frear',
        'Porque deixa o carro mais lento',
      ],
      correctIndex: 2,
      explanation:
          'Sem os sulcos, o pneu não escoa a água e perde aderência — aumentando muito o risco de aquaplanagem. O mínimo legal é 1,6 mm.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q25',
      statement: 'O que é "direção defensiva"?',
      options: [
        'Dirigir sempre o mais devagar possível',
        'Antecipar riscos e erros dos outros',
        'Revidar quem dirige mal com você',
        'Confiar que todos seguem as regras',
      ],
      correctIndex: 1,
      explanation:
          'É prever o erro alheio e se proteger: manter distância, sinalizar e nunca contar que o outro vai fazer o certo.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q26',
      statement: 'Usar o celular na mão enquanto dirige é infração:',
      options: [
        'Leve, que quase nunca é multada',
        'Média, com poucos pontos perdidos',
        'Gravíssima, com perda de pontos',
        'Inexistente, se estiver parado no farol',
      ],
      correctIndex: 2,
      explanation:
          'É infração gravíssima. A distração ao digitar é comparável à de dirigir alcoolizado.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q27',
      statement: 'Em uma pista molhada, qual é a atitude correta ao dirigir?',
      options: [
        'Acelerar um pouco para não derrapar',
        'Frear com força ao precisar parar',
        'Manter tudo igual, se o pneu for bom',
        'Reduzir a velocidade e aumentar a distância',
      ],
      correctIndex: 3,
      explanation:
          'Pista molhada pode dobrar a distância de frenagem. A regra: menos velocidade, mais distância e freadas suaves.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q28',
      statement:
          'Levar na moto uma criança que não consegue se cuidar sozinha é:',
      options: [
        'Permitido, desde que use capacete',
        'Permitido apenas dentro da cidade',
        'Permitido se um adulto a segurar',
        'Proibido pela legislação',
      ],
      correctIndex: 3,
      explanation:
          'É proibido transportar na moto criança sem condições de se segurar e cuidar da própria segurança.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q29',
      statement: 'Estacionar em vaga de idoso ou PCD sem ter a credencial é:',
      options: [
        'Permitido, se for por pouco tempo',
        'Permitido fora do horário comercial',
        'Infração de trânsito',
        'Aceitável quando não há outra vaga',
      ],
      correctIndex: 2,
      explanation:
          'Além da multa, é uma questão de respeito: essas vagas existem para quem realmente depende delas.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q30',
      statement: 'Ao se aproximar de uma faixa de pedestres, o motorista deve:',
      options: [
        'Acelerar para cruzar antes de alguém',
        'Reduzir e dar a vez a quem atravessa',
        'Buzinar para o pedestre esperar',
        'Seguir, pois o carro tem prioridade',
      ],
      correctIndex: 1,
      explanation:
          'O pedestre na faixa (e quem já começou a travessia) tem prioridade. Não dar passagem é infração gravíssima.',
      difficulty: QuestionDifficulty.medio,
    ),

    // ───────────────────────── DIFÍCEIS ─────────────────────────
    Question(
      id: 'q31',
      statement:
          'A 60 km/h, no 1 segundo de reação (antes de frear), o carro anda cerca de:',
      options: [
        'Menos de 1 metro',
        'Cerca de 5 metros',
        'Cerca de 17 metros',
        'Quase 50 metros',
      ],
      correctIndex: 2,
      explanation:
          'A 60 km/h você percorre ~16,7 m por segundo. Some o tempo de reação à distância de frenagem e entende por que velocidade mata.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q32',
      statement: 'O carro começou a "boiar" numa poça (aquaplanagem). O certo é:',
      options: [
        'Frear com firmeza para parar logo',
        'Girar rápido o volante para o acostamento',
        'Tirar o pé do acelerador e segurar o volante',
        'Acelerar com força para vencer a água',
      ],
      correctIndex: 2,
      explanation:
          'Os pneus perderam contato com o solo. Frear ou esterçar forte faz rodar — espere o pneu "agarrar" de novo com o volante firme.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q33',
      statement: 'A partir de quantos pontos a CNH pode ser suspensa?',
      options: [
        'Sempre ao atingir exatos 10 pontos',
        '20, 30 ou 40 pontos, conforme o caso',
        'Somente quando passa de 50 pontos',
        'Logo na primeira infração grave',
      ],
      correctIndex: 1,
      explanation:
          'Em 12 meses: 20 pontos (com 2+ gravíssimas), 30 (com 1 gravíssima) ou 40 (sem nenhuma gravíssima).',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q34',
      statement:
          'Ao estacionar numa ladeira voltado para baixo, as rodas dianteiras devem ficar:',
      options: [
        'Retas, alinhadas com a via',
        'Viradas para a guia (meio-fio)',
        'Viradas para o meio da rua',
        'Em qualquer posição, com o freio de mão',
      ],
      correctIndex: 1,
      explanation:
          'Na descida, vire as rodas para o meio-fio: se o carro escapar, ele "trava" na guia em vez de descer a ladeira sozinho.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q35',
      statement:
          'Ao ultrapassar um ciclista, qual a distância lateral mínima exigida?',
      options: [
        'Cerca de meio metro',
        '1,5 metro',
        'O suficiente para não encostar',
        'No mínimo 3 metros',
      ],
      correctIndex: 1,
      explanation:
          'O CTB exige 1,5 m de distância lateral ao ultrapassar bicicletas. Menos que isso é infração — e coloca o ciclista em risco.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q36',
      statement: 'Passar de moto entre os carros parados (o "corredor") é:',
      options: [
        'Totalmente seguro pela agilidade da moto',
        'Obrigatório para motos no trânsito',
        'Onde mais acontecem acidentes de moto',
        'Proibido somente quando está chovendo',
      ],
      correctIndex: 2,
      explanation:
          'Portas que abrem e carros que mudam de faixa fazem do corredor o cenário clássico de acidente. Se for passar: baixa velocidade e atenção máxima.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q37',
      statement: 'Quando a velocidade dobra, a distância para o carro parar fica:',
      options: [
        'Apenas o dobro maior',
        'Praticamente igual',
        'Cerca de quatro vezes maior',
        'Só um pouco maior',
      ],
      correctIndex: 2,
      explanation:
          'A distância de frenagem cresce com o quadrado da velocidade: dobrar a velocidade quadruplica o espaço necessário para parar.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q38',
      statement: 'Por que dirigir com sono é tão perigoso?',
      options: [
        'Porque cansa mais o motorista',
        'Por causa dos "microssonos" ao volante',
        'Porque aumenta o consumo do carro',
        'Porque deixa a direção mais lenta',
      ],
      correctIndex: 1,
      explanation:
          'No microssono você dorme por alguns segundos sem perceber. Nenhum truque substitui parar e descansar.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q39',
      statement: 'Em qual situação o pedestre tem prioridade sobre o veículo?',
      options: [
        'Sempre, em qualquer ponto da via',
        'Nunca, o veículo passa primeiro',
        'Na faixa e ao já ter iniciado a travessia',
        'Apenas quando o sinal está vermelho',
      ],
      correctIndex: 2,
      explanation:
          'A prioridade do pedestre é na faixa e quando ele já começou a atravessar — não é em qualquer lugar, mas ali o motorista deve parar.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q40',
      statement:
          'Num cruzamento sem sinalização (semáforo apagado), quem tem preferência?',
      options: [
        'Quem chegar e passar primeiro',
        'Quem vem pela direita do condutor',
        'Quem vem pela esquerda do condutor',
        'O veículo de maior porte',
      ],
      correctIndex: 1,
      explanation:
          'Regra do CTB para cruzamento não sinalizado: a preferência é de quem vem pela direita.',
      difficulty: QuestionDifficulty.dificil,
    ),
  ];
}
