import '../models/question.dart';

class QuestionsRepository {
  const QuestionsRepository();

  List<Question> loadStarterPack() {
    return const [
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
        statement:
            'Qual a função do cinto de segurança no banco de trás?',
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
        statement:
            'Você está de bike na rua. Onde deve andar?',
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
        statement:
            'Capacete de moto: quando é obrigatório?',
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
        statement:
            'Numa via molhada, o que muda na forma de dirigir?',
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
    ];
  }
}
