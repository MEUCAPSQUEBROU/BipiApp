import '../models/question.dart';

class QuestionsRepository {
  const QuestionsRepository();

  /// Banco completo de perguntas (usado pela trilha diária).
  List<Question> all() => _bank;

  /// Pacote curto para jogo avulso / fallback.
  List<Question> loadStarterPack() => _bank.take(10).toList();

  static const List<Question> _bank = [
    Question(
      id: 'q01',
      statement:
          'Você está atravessando a rua olhando o celular e ouve uma buzina. Qual a melhor atitude?',
      options: [
        'Continuar andando, motorista que se vire',
        'Parar imediatamente, guardar o celular e observar o trânsito antes de seguir',
        'Correr para o outro lado sem olhar',
        'Levantar a mão para o carro parar',
      ],
      correctIndex: 1,
      explanation:
          'Pedestre distraído é uma das maiores causas de atropelamento. Parar, guardar o celular e observar é a única forma segura de reagir.',
    ),
    Question(
      id: 'q02',
      statement:
          'A partir de qual idade alguém pode legalmente dirigir um carro no Brasil?',
      options: ['16 anos', '17 anos', '18 anos', '21 anos'],
      correctIndex: 2,
      explanation:
          'No Brasil, a CNH só pode ser emitida a partir dos 18 anos completos.',
    ),
    Question(
      id: 'q03',
      statement:
          'Seu amigo bebeu na festa e quer dar uma carona pra galera. O que fazer?',
      options: [
        'Aceitar — ele disse que está bem',
        'Pedir pra ele dirigir devagar',
        'Chamar um aplicativo de transporte ou táxi para todo mundo',
        'Ir só você no carona, os outros pegam outro',
      ],
      correctIndex: 2,
      explanation:
          'Álcool e direção não combinam — nunca. A Lei Seca é tolerância zero, e o risco é morte (sua ou de outros). Chamar transporte é a única saída.',
    ),
    Question(
      id: 'q04',
      statement:
          'No farol vermelho, à noite, sem ninguém por perto: pode avançar?',
      options: [
        'Sim, é só olhar antes',
        'Sim, se for rua pequena',
        'Não — avançar farol é infração gravíssima e principal causa de colisões em cruzamento',
        'Só se for moto',
      ],
      correctIndex: 2,
      explanation:
          'Avançar sinal vermelho é infração gravíssima (7 pontos na CNH) e responsável por uma parcela enorme das colisões em cruzamento — inclusive à noite, quando a visibilidade engana.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q05',
      statement: 'Qual a função do cinto de segurança no banco de trás?',
      options: [
        'Nenhuma, é só no banco da frente',
        'Evitar que o passageiro seja arremessado e vire um "projétil" contra quem está na frente em caso de colisão',
        'Só serve em estrada',
        'Apenas evitar multa',
      ],
      correctIndex: 1,
      explanation:
          'Em uma batida a 50 km/h, um passageiro sem cinto no banco de trás é arremessado com força equivalente a várias vezes seu peso — podendo matar quem está no banco da frente.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q06',
      statement: 'Você está de bike na rua. Onde deve andar?',
      options: [
        'Na calçada, mais seguro',
        'No meio da pista, junto com os carros',
        'Na ciclovia/ciclofaixa quando houver; senão, à direita da pista no mesmo sentido dos carros',
        'Contramão, pra ver os carros vindo',
      ],
      correctIndex: 2,
      explanation:
          'Calçada é do pedestre. Contramão é proibido e perigoso. O certo é ciclovia quando disponível, ou à direita da pista no mesmo sentido do tráfego.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q07',
      statement: 'Capacete de moto: quando é obrigatório?',
      options: [
        'Só em rodovia',
        'Sempre, para piloto e passageiro, mesmo em trajetos curtos',
        'Só se for moto grande',
        'Só de dia',
      ],
      correctIndex: 1,
      explanation:
          'Capacete afivelado é obrigatório sempre — para piloto e passageiro. A maioria das mortes de motociclistas envolve trauma craniano, muitas vezes em trajetos curtos perto de casa.',
    ),
    Question(
      id: 'q08',
      statement:
          'Mandar mensagem no celular ao dirigir aumenta o risco de acidente em quanto?',
      options: [
        'Quase nada, se for rapidinho',
        'Cerca de 2x',
        'Cerca de 4x — equivalente a dirigir embriagado',
        'Diminui o risco, te mantém acordado',
      ],
      correctIndex: 2,
      explanation:
          'Estudos mostram que digitar no celular ao volante aumenta o risco de colisão em até 4 vezes — comparável a dirigir com a taxa de álcool no limite legal em outros países.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q09',
      statement:
          'Você é pedestre e a faixa fica 50 metros adiante. Atravessar fora dela é?',
      options: [
        'Tranquilo, todo mundo faz',
        'Infração — pedestre deve usar a faixa quando ela está a até 50m. Além disso, atropelamento fora da faixa é a regra, não a exceção',
        'Permitido se não tiver carro vindo',
        'Só proibido em avenida',
      ],
      correctIndex: 1,
      explanation:
          'O CTB obriga o pedestre a usar a faixa quando ela está a até 50m. Mais importante: motorista não espera pedestre fora da faixa — por isso a maioria dos atropelamentos acontece ali.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q10',
      statement: 'Numa via molhada, o que muda na forma de dirigir?',
      options: [
        'Nada, pneu bom resolve',
        'Aumentar a distância do carro da frente e reduzir a velocidade — a distância de frenagem pode dobrar',
        'Acelerar pra não derrapar',
        'Pisar fundo no freio se precisar parar',
      ],
      correctIndex: 1,
      explanation:
          'Pista molhada pode dobrar a distância de frenagem e favorece aquaplanagem. A regra é simples: menos velocidade, mais distância, freadas suaves.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q11',
      statement: 'Até que idade a criança deve ser transportada no banco traseiro?',
      options: [
        'Até 7 anos',
        'Até 10 anos, com o dispositivo de retenção adequado à idade/altura',
        'Pode ir na frente a partir dos 5',
        'Não existe regra sobre isso',
      ],
      correctIndex: 1,
      explanation:
          'Crianças com até 10 anos devem ir no banco traseiro, usando bebê-conforto, cadeirinha ou assento de elevação conforme a faixa. O airbag e a posição da frente são perigosos para elas.',
    ),
    Question(
      id: 'q12',
      statement: 'O cinto de segurança é obrigatório para quem?',
      options: [
        'Só o motorista',
        'Motorista e passageiro da frente',
        'Todos os ocupantes do veículo, em qualquer banco',
        'Ninguém, é opcional',
      ],
      correctIndex: 2,
      explanation:
          'Todos os ocupantes devem usar cinto, em qualquer banco. É o equipamento que mais salva vidas no trânsito.',
    ),
    Question(
      id: 'q13',
      statement:
          'Como saber se você está a uma distância segura do carro da frente?',
      options: [
        'Se dá pra ler a placa dele',
        'Pela "regra dos 2 segundos": conte 2s entre o carro da frente passar por um ponto e você passar pelo mesmo ponto',
        'Um carro de distância sempre basta',
        'Não precisa, é só frear na hora',
      ],
      correctIndex: 1,
      explanation:
          'A regra dos 2 segundos se adapta à velocidade automaticamente. Em pista molhada ou à noite, aumente para 3 ou mais.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q14',
      statement: 'Antes de mudar de faixa ou virar, o que você deve fazer?',
      options: [
        'Só virar rápido',
        'Sinalizar com a seta com antecedência e checar os retrovisores e o ponto cego',
        'Buzinar',
        'Acender o pisca-alerta',
      ],
      correctIndex: 1,
      explanation:
          'A seta avisa os outros da sua intenção. Sinalizar com antecedência + olhar o ponto cego evita colisões laterais e fechadas.',
    ),
    Question(
      id: 'q15',
      statement: 'Numa rotatória (retorno), quem tem a preferência?',
      options: [
        'Quem vai entrar',
        'Quem já está circulando dentro da rotatória',
        'O carro maior',
        'Quem chegar primeiro buzinando',
      ],
      correctIndex: 1,
      explanation:
          'Quem já está na rotatória tem preferência. Quem vai entrar deve dar a vez e aguardar uma brecha segura.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q16',
      statement:
          'Um pedestre já começou a atravessar na faixa. O que o motorista deve fazer?',
      options: [
        'Buzinar pra ele apressar',
        'Parar e dar passagem — o pedestre na faixa tem prioridade',
        'Passar rápido antes dele',
        'Seguir, ele que espere',
      ],
      correctIndex: 1,
      explanation:
          'Pedestre na faixa (e quem já iniciou a travessia) tem prioridade. Não dar passagem é infração gravíssima — e pode matar.',
    ),
    Question(
      id: 'q17',
      statement:
          'Numa via urbana sem placa de velocidade, qual o limite numa via arterial (avenida)?',
      options: ['40 km/h', '60 km/h', '80 km/h', '100 km/h'],
      correctIndex: 1,
      explanation:
          'Sem sinalização, o CTB define: via local 30, coletora 40, arterial 60 e via de trânsito rápido 80 km/h. Avenida costuma ser arterial: 60.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q18',
      statement: 'Quanto de álcool é permitido para dirigir no Brasil?',
      options: [
        'Uma latinha de cerveja tá liberada',
        'Até duas dosezinhas',
        'Zero — qualquer quantidade já é infração (tolerância zero)',
        'Depende do peso da pessoa',
      ],
      correctIndex: 2,
      explanation:
          'A Lei Seca é tolerância zero: qualquer concentração de álcool já é infração gravíssima. Acima de certo nível, vira crime de trânsito.',
    ),
    Question(
      id: 'q19',
      statement:
          'A 60 km/h, quantos metros o carro percorre no 1 segundo de reação, antes mesmo de você frear?',
      options: [
        'Uns 2 metros',
        'Cerca de 17 metros',
        'Meio metro',
        'Nenhum, freia na hora',
      ],
      correctIndex: 1,
      explanation:
          'A 60 km/h você percorre ~16,7 m por segundo. Some o tempo de reação à distância de frenagem e entende por que velocidade mata.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q20',
      statement: 'A faixa central é contínua (amarela simples). Pode ultrapassar?',
      options: [
        'Pode, se o carro da frente estiver devagar',
        'Não — linha contínua proíbe a ultrapassagem e a transposição',
        'Só de dia',
        'Só se não vier ninguém',
      ],
      correctIndex: 1,
      explanation:
          'Linha contínua proíbe ultrapassar/transpor. Ela existe justamente em trechos onde ultrapassar é arriscado (curvas, lombadas, baixa visibilidade).',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q21',
      statement: 'Para que serve a buzina, segundo o CTB?',
      options: [
        'Pra xingar quem te irritou',
        'Apenas como advertência sonora breve, pra evitar acidentes',
        'Pra avisar que chegou em casa',
        'Pra apressar o pedestre',
      ],
      correctIndex: 1,
      explanation:
          'A buzina é toque breve, só para alertar e evitar acidentes. Usar de forma prolongada ou desnecessária é infração.',
    ),
    Question(
      id: 'q22',
      statement:
          'Motociclista costurando entre os carros parados/lentos (o "corredor"). Isso é?',
      options: [
        'Totalmente seguro, a moto é ágil',
        'Arriscadíssimo — é onde mais acontecem acidentes de moto; faça com muita cautela e baixa velocidade',
        'Obrigatório pra moto',
        'Proibido só na chuva',
      ],
      correctIndex: 1,
      explanation:
          'O corredor é o cenário clássico de acidente: portas abrindo, carros mudando de faixa. Se for passar, baixíssima velocidade e atenção redobrada.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q23',
      statement: 'Transportar criança pequena na garupa da moto é?',
      options: [
        'Liberado a qualquer idade',
        'Proibido para crianças que não tenham condições de se cuidar (em geral, menores de 10 anos)',
        'Permitido se segurar firme',
        'Permitido só na cidade',
      ],
      correctIndex: 1,
      explanation:
          'É proibido levar na moto criança sem condições de se segurar e cuidar — em geral menores de 10 anos. Capacete afivelado é sempre obrigatório.',
    ),
    Question(
      id: 'q24',
      statement: 'Pegou neblina forte na estrada. Qual farol usar?',
      options: [
        'Farol alto, pra enxergar mais longe',
        'Farol baixo (e de neblina, se tiver) — o alto reflete na neblina e ofusca',
        'Apagar tudo',
        'Pisca-alerta e seguir rápido',
      ],
      correctIndex: 1,
      explanation:
          'Na neblina, o farol alto reflete e piora a visão. Use farol baixo e o de neblina, reduza a velocidade e aumente a distância.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q25',
      statement:
          'Aquela vaga com símbolo de cadeira de rodas, sem você ter a credencial. Pode estacionar "rapidinho"?',
      options: [
        'Pode, se for rápido',
        'Não — é infração e tira o direito de quem realmente precisa',
        'Pode no fim de semana',
        'Só se não tiver outra vaga',
      ],
      correctIndex: 1,
      explanation:
          'Vagas reservadas (PCD e idoso) sem credencial = infração. Mais que multa, é uma questão de respeito a quem depende delas.',
    ),
    Question(
      id: 'q26',
      statement: 'Uma ambulância vem atrás com a sirene ligada. O que fazer?',
      options: [
        'Acelerar pra sair na frente',
        'Reduzir, sinalizar e encostar à direita pra liberar a passagem',
        'Parar no meio da pista',
        'Ignorar, ela se vira',
      ],
      correctIndex: 1,
      explanation:
          'Veículos de emergência têm prioridade. Encoste com segurança à direita e libere a via — pode ser uma vida dependendo daqueles segundos.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q27',
      statement: 'O carro começou a "boiar" numa poça (aquaplanagem). O que NÃO fazer?',
      options: [
        'Tirar o pé do acelerador',
        'Frear bruscamente e girar o volante com força',
        'Manter o volante firme e reto',
        'Reduzir a velocidade aos poucos',
      ],
      correctIndex: 1,
      explanation:
          'Na aquaplanagem os pneus perdem contato com o solo. Frear ou esterçar forte faz rodar. O certo: tirar o pé do acelerador, volante firme e esperar o pneu "agarrar" de novo.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q28',
      statement: 'Falar ao celular na mão enquanto dirige é qual tipo de infração?',
      options: [
        'Leve, quase ninguém é multado',
        'Gravíssima — tira muita atenção e pontos da CNH',
        'Não é infração se estiver parado no farol',
        'Só adverte na primeira vez',
      ],
      correctIndex: 1,
      explanation:
          'Usar o celular na mão dirigindo é infração gravíssima. A distração é comparável à de dirigir alcoolizado.',
    ),
    Question(
      id: 'q29',
      statement: 'Faixa exclusiva de ônibus (corredor): carro de passeio pode usar?',
      options: [
        'Pode sempre',
        'Não, exceto nas situações e horários sinalizados (ex.: conversão)',
        'Pode se estiver atrasado',
        'Pode no fim de semana sempre',
      ],
      correctIndex: 1,
      explanation:
          'A faixa exclusiva é do transporte coletivo. Carro só entra onde/quando a sinalização permite (geralmente para conversão). Fora disso, é infração.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q30',
      statement:
          'Um idoso atravessa devagar e o sinal vai fechar. Qual a atitude correta do motorista?',
      options: [
        'Buzinar e avançar',
        'Aguardar com paciência até ele concluir a travessia em segurança',
        'Desviar passando rente',
        'Acelerar antes que ele chegue',
      ],
      correctIndex: 1,
      explanation:
          'Idosos, crianças e pessoas com deficiência têm proteção especial no CTB. Esperar a travessia terminar é obrigação — e empatia.',
    ),
    Question(
      id: 'q31',
      statement: 'Por que pneu "careca" (liso) é tão perigoso?',
      options: [
        'Não é, só gasta mais rápido',
        'Sem os sulcos, ele não escoa a água e perde aderência — aumentando muito o risco de aquaplanagem e de não frear a tempo',
        'Só atrapalha o visual',
        'Só é problema em alta velocidade',
      ],
      correctIndex: 1,
      explanation:
          'Os sulcos do pneu escoam a água. Carecas, perdem aderência no molhado e a frenagem piora drasticamente. Profundidade mínima legal: 1,6 mm.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q32',
      statement: 'Em rodovias, durante o dia, o farol baixo deve estar:',
      options: [
        'Apagado pra economizar',
        'Aceso — é obrigatório o farol baixo em rodovias, mesmo de dia (ou luz de rodagem diurna)',
        'Só em túneis',
        'Só quando chove',
      ],
      correctIndex: 1,
      explanation:
          'A "lei do farol" exige farol baixo aceso em rodovias mesmo de dia (veículos com luz diurna de fábrica ficam dispensados). Ajuda os outros a te enxergarem.',
    ),
    Question(
      id: 'q33',
      statement:
          'Você está de moto/bike perto de um caminhão grande. Qual o maior perigo?',
      options: [
        'O barulho',
        'O ponto cego: se você não vê o espelho do motorista, ele não te vê',
        'A fumaça',
        'A altura do caminhão',
      ],
      correctIndex: 1,
      explanation:
          'Caminhões têm pontos cegos enormes (laterais, traseira e logo à frente). Regra de ouro: se você não enxerga o rosto do motorista no retrovisor, ele não te vê.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q34',
      statement: 'Passando em frente a uma escola no horário de entrada/saída, você deve:',
      options: [
        'Manter a velocidade normal',
        'Reduzir bastante e redobrar a atenção — crianças são imprevisíveis',
        'Buzinar pra abrirem caminho',
        'Acelerar pra passar logo',
      ],
      correctIndex: 1,
      explanation:
          'Perto de escolas a velocidade é reduzida e a atenção tem que ser máxima: criança pode atravessar correndo, sem olhar.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q35',
      statement: 'Jogar bituca de cigarro ou lixo pela janela do carro é?',
      options: [
        'Normal, some no chão',
        'Infração — e pode causar incêndio (no caso da bituca) e entupir bueiros',
        'Só feio, mas legal',
        'Permitido em estrada',
      ],
      correctIndex: 1,
      explanation:
          'Arremessar lixo pela janela é infração. Bituca acesa já causou incêndios em margens de rodovia; lixo entope bueiros e causa alagamentos.',
    ),
    Question(
      id: 'q36',
      statement:
          'O sinal fechou e você está chegando. Onde NÃO se deve parar?',
      options: [
        'Antes da faixa de pedestres',
        'Em cima da faixa de pedestres, bloqueando a travessia',
        'Atrás do carro da frente',
        'Na sua faixa',
      ],
      correctIndex: 1,
      explanation:
          'Parar sobre a faixa obriga o pedestre a desviar para o meio dos carros. Pare sempre antes da faixa de retenção.',
    ),
    Question(
      id: 'q37',
      statement: 'Andar de bike à noite exige o quê?',
      options: [
        'Nada, é só pedalar',
        'Sinalização: luz/refletivos (dianteiro, traseiro e laterais) e, de preferência, roupa clara',
        'Só andar rápido',
        'Buzina',
      ],
      correctIndex: 1,
      explanation:
          'À noite o ciclista quase some no trânsito. Luzes e refletivos (frente, trás e rodas) e roupa clara são o que tornam você visível — e vivo.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q38',
      statement: 'O que acontece se você acumular pontos demais na CNH?',
      options: [
        'Nada, os pontos não importam',
        'A CNH pode ser suspensa — a partir de 20, 30 ou 40 pontos, conforme você tenha infrações gravíssimas no período',
        'Você ganha pontos de volta dirigindo bem',
        'Só perde a CNH se bater',
      ],
      correctIndex: 1,
      explanation:
          'Pela regra atual, a suspensão ocorre com 20 pontos (com 2+ gravíssimas), 30 (com 1 gravíssima) ou 40 pontos (sem gravíssima) no período de 12 meses.',
      difficulty: QuestionDifficulty.dificil,
    ),
    Question(
      id: 'q39',
      statement: 'O que é "direção defensiva"?',
      options: [
        'Dirigir sempre devagar',
        'Antecipar riscos e agir pra evitar acidentes, mesmo que o erro seja do outro',
        'Andar só na defensiva, com medo',
        'Buzinar pra todo mundo',
      ],
      correctIndex: 1,
      explanation:
          'Direção defensiva é prever o erro alheio e se proteger: manter distância, sinalizar, não confiar que o outro vai fazer o certo.',
      difficulty: QuestionDifficulty.medio,
    ),
    Question(
      id: 'q40',
      statement: 'Bateu aquele sono dirigindo na estrada. A atitude certa é:',
      options: [
        'Tomar café e seguir, o sono passa',
        'Parar em local seguro e descansar/cochilar antes de continuar',
        'Abrir a janela e acelerar',
        'Ligar o som bem alto',
      ],
      correctIndex: 1,
      explanation:
          'Sono ao volante causa "microssonos" — você dorme por segundos sem perceber. Nenhum truque substitui parar e descansar.',
    ),
  ];
}
