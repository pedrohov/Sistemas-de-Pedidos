/*
 * Sistemas Embarcados - 2o semestre/2018
 * Pedro Henrique Oliveira Veloso
 */

class Pedido {
 
  Produto produto;
  StatusPedido status;
  Mesa mesa;
  int qtd;
  int hora;
  int minuto;
  int segundo;
  
  Pedido(Produto produto, Mesa mesa, int qtd) {
    this.produto = produto;
    this.mesa = mesa;
    this.status = StatusPedido.PENDENTE;
    this.hora = hour();
    this.minuto = minute();
    this.segundo = second();
    this.qtd = qtd;
  }
  
  void draw() {
    
  }
  
  String horaPedido() {
    return hora + ":" + minuto + ":" + segundo; 
  }
  
}
