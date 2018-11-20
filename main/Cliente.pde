class Cliente {
 
  String nome;
  int qtd_pedidos;
  float conta;
  int hora;
  int minuto;
  int segundo;
  
  Cliente(String nome) {
    this.nome = nome;
    this.qtd_pedidos = 0;
    this.conta = 0;
    this.hora = hour();
    this.minuto = minute();
    this.segundo = second();
  }
  
  String estadia() {
    int minAtual = minute();
    int hAtual = hour();
    
    int min = 0;
    
    if(hAtual > hora) {
      min = (hAtual - hora) * 60 + minAtual;
      min = min - minuto;
    } else {
      min = minAtual - minuto;
    }
    
    return min + " min"; 
  }
  
}
