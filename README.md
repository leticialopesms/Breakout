# Projeto final de MC613 - 2024s1

Grupo:

- 186087 - Gabriela Martins Jacob
- 184423 - Letícia Lopes Mendes da Silva
- 238001 - Luísa de Melo Barros Penze

## Descrição

Vamos implementar uma versão do Jogo Breakout, utilizando a placa DE1-SoC com suporte a VGA. Como representado na figura abaixo, o jogo consiste em um cenário composto por: blocos coloridos na parte superior da tela, uma bola que move-se com velocidade constante, e uma barra (na parte inferior da tela), a qual move-se de acordo com os botões pressionados pelo jogador na placa DE1-SoC.

A lógica de funcionamento dos movimentos da barra e da bola serão semelhantes àquelas utilizadas no Laboratório 6 da disciplina. Assim, aproveitaremos parte do código escrito na implementação de tal atividade. 

Além disso, utilizaremos o display de 7 segmentos da placa para indicar a situação do jogo para o usuário: do lado esquerdo, teremos a quantidade de vidas restantes (o jogo começa com 10 vidas), enquanto do lado direito teremos a quantidade de blocos que já foram eliminados pelo jogador. A ideia é que, quando a bola encontra um bloco, este último desaparece da tela e soma-se 1 à quantidade de blocos eliminados pelo jogador.

Como desafio para a implementação do projeto, tentaremos fazer com que os blocos desçam em uma velocidade constante, para que o jogo fique cada vez mais difícil de ser zerado pelo jogador.

Por fim, se o usuário conseguir eliminar todos os blocos (sem ter zerado sua quantidade de vidas restantes), uma mensagem de parabenização será mostrada no display de 7 segmentos da placa.

<img src="https://www.coolmathgames.com/sites/default/files/styles/blog_node_image/public/2022-11/Retro%20Game%20Atari%20Breakout%20Blog%20Thumbnail.png?itok=lmDmvPKx" width="500" />

