/*
 * Sistemas Embarcados - 2o semestre/2018
 * Pedro Henrique Oliveira Veloso
 */

class Mesa {
  
  int x, y;
  int size;
  int tempoEspera;
  String nome;
  Cliente cliente;
  boolean hovered;
  boolean ativa;
  Pedido pedido;
  
  Mesa() {
  
  }
  
  Mesa(String nome, int size) {
    this.nome    = nome;
    this.size    = size;
    this.hovered = false;
    
    this.tempoEspera = 0;
    this.ativa = false;
  }
  
  void draw(int x, int y) {
    
    this.x = x;
    this.y = y;
    
    // Sombra:
    noStroke();
    fill(82, 114, 111);
    rect(x, y + 3, this.size, this.size, 5);
    
    // Desenha status pedido:
    if(pedido != null) {
      if(pedido.status == StatusPedido.PENDENTE) {
        fill(255, 234, 81);
      }
    } else if(ativa)
      fill(205, 255, 206);
    else
      fill(255, 255, 255);
      
    if(hovered) {
      fill(82, 114, 111);
    }
    
    // Retangulo:
    stroke(82, 114, 111);
    strokeWeight(1);
    rect(x, y, this.size, this.size, 5);
    
    // Nome:
    if(hovered)
      fill(255, 255, 255);
    else
      fill(82, 114, 111);
      
    drawTitleCENTER(this.nome, x + this.size / 2, y + this.size / 2);
    
    // Tempo do pedido:
    if(pedido != null) {
      if(pedido.status == StatusPedido.PENDENTE) {
        if(hovered)
          fill(255, 255, 255);
        else
          fill(82, 114, 111);
        drawTextSmall(this.pedido.horaPedido(), x + this.size / 2, y + this.size - 18);
      }
    }
  }
  
  void hover()  {
    if (mouseX >= x && mouseX <= x + this.size && 
        mouseY >= y && mouseY <= y + this.size) {
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
  
}
