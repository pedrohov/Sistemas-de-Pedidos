class Cliente {
 
  String nome;
  int qtd_pedidos;
  float conta;
  String estadia;
  
  Cliente(String nome) {
    this.nome = nome;
    this.qtd_pedidos = 0;
    this.conta = 0;
    this.estadia = hour() + ":" + minute() + ":" + second();
  }
  
}
