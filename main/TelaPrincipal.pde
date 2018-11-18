/*
 * Sistemas Embarcados - 2o semestre/2018
 * Pedro Henrique Oliveira Veloso
 */

class TelaPrincipal {
  
  TelaPrincipal() {
    
  }
  
  void draw() {
    // Nome do restaurante:
    drawTitle(res.nome, 20, 20);
    time();
    drawHeader("Últimos Pedidos", 20, 60);
    drawHeader("Mesas", 20, 200);
    
    // Desenha ultimos pedidos por mesa:
    
    // Desenha todas as mesas:
    res.drawMesas(20, 250);
    
  }
  
  void update() {
    for(int i = 0; i < res.mesas.size(); i++) {
      Mesa m = res.mesas.get(i); 
      m.hover();
      boolean clicou = m.clicked();
      if((clicou) /*&& (m.pedido != null)*/) {
        pedidoSel = m.pedido;
        mesaSel = m;
        tela = 1;
        m.hovered = false;
      }
    }
  }
  
  boolean overRect(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }
}
