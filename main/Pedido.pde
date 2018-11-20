/*
 * Sistemas Embarcados - 2o semestre/2018
 * Pedro Henrique Oliveira Veloso
 */

class Pedido {
 
  Produto produto;
  StatusPedido status;
  Mesa mesa;
  int id;
  int qtd;
  int hora;
  int minuto;
  int segundo;
  int x, y;
  int pWidth = 120;
  int pHeight = 30;
  boolean hovered;
  
  Pedido(int id, Produto produto, Mesa mesa, int qtd) {
    this.id = id;
    this.produto = produto;
    this.mesa = mesa;
    this.status = StatusPedido.PENDENTE;
    this.hora = hour();
    this.minuto = minute();
    this.segundo = second();
    this.qtd = qtd;
    this.hovered = false;
  }
  
  void draw(int x, int y) {
    
    this.x = x;
    this.y = y;
    
    // Nao mostra pedidos entregues:
    if(status == StatusPedido.ENTREGUE)
      return;
      
    // Sombra:
    noStroke();
    fill(82, 114, 111);
    rect(x, y + 3, pWidth, pHeight, 5);
    
    if(status == StatusPedido.PENDENTE) {
      fill(255, 234, 81);
    } else if(status == StatusPedido.ATENDIDO) {
      fill(162, 255, 81); 
    } else if(status == StatusPedido.DESPACHADO) {
      fill(81, 208, 255); 
    } else if(status == StatusPedido.RECUSADO) {
      fill(156, 114, 255); 
    }
    
    if(hovered) {
      fill(82, 114, 111);
    } else if(tempoPassado() > produto.tempoPreparo) {
      fill(255, 81, 81);
    }
    
    // Retangulo:
    stroke(82, 114, 111);
    strokeWeight(1);
    rect(x, y, pWidth, pHeight, 5);
    
    // Info:
      // Mesa:
      if(hovered)
        fill(255, 255, 255);
      else
        fill(58, 81, 79);
        
      textFont(montserratR);
      textSize(12);
      textAlign(LEFT, TOP);
      text("Mesa " + mesa.nome, x + 10, y + 3);
      
      // Item:
      textSize(12);
      text(produto.nome.toUpperCase(), x + 10, y + 14);
      
      // Quantidade:
      textSize(13);
      text("x" + qtd, x + 95, y + 14);
      
      // Tempo:
      /*image(iconClock, x + 100, y);
      textSize(12);
      text(tempoPassado(), x + 103, y + 14);*/
      textSize(11);
      text(tempoPassado() + "min", x + 80, y + 3);
  }
  
  void hover()  {
    if (mouseX >= this.x && mouseX <= (this.x + this.pWidth) && 
        mouseY >= this.y && mouseY <= (this.y + this.pHeight)) {
        hovered = true;
    } else {
        hovered = false;
    }
  }
  
  boolean clicked() {
    if (mousePressed && (mouseButton == LEFT) && (this.hovered)) {
      return true;
    }
    return false;
  }
  
  int tempoPassado() {
    int minAtual = minute();
    int hAtual = hour();
    
    int min = 0;
    
    if(hAtual > hora) {
      min = (hAtual - hora) * 60 + minAtual;
      min = min - minuto;
    } else {
      min = minAtual - minuto;
    }
    
    return min;
  }
  
  String horaPedido() {
    return hora + ":" + minuto + ":" + segundo; 
  }
  
}
