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
    drawHeader("ÚLTIMOS PEDIDOS", 20, 60);
    drawHeader("MESAS", 20, 200);
    
    // Desenha ultimos pedidos por mesa:
    res.drawPedidos(20, 110);
    
    // Desenha todas as mesas:
    res.drawMesas(20, 250);
    
  }
  
  void update() {
    // Atualizar mesas/mouse:
    for(int i = 0; i < res.mesas.size(); i++) {
      Mesa m = res.mesas.get(i); 
      m.hover();
      boolean clicou = m.clicked();
      if(clicou) {
        mesaSel = m;
        tela = 1;
        m.hovered = false;
      }
    }
    
    // Atualizar pedidos/mouse:
    for(int i = 0; i < res.pedidos.size(); i++) {
      Pedido p = res.pedidos.get(i); 
      p.hover();
      boolean clicou = p.clicked();
      if(clicou) {
        pedidoSel = p;
        mesaSel = p.mesa;
        tela = 2;
        p.hovered = false;
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
