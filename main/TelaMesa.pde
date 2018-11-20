/*
 * Sistemas Embarcados - 2o semestre/2018
 * Pedro Henrique Oliveira Veloso
 */

class TelaMesa {
 
  TelaMesa() {
    
  }
  
  void update() {
    this.clickVoltar();
    
    // Atualizar pedidos/mouse:
    for(int i = 0; i < mesaSel.pedidos.size(); i++) {
      Pedido p = mesaSel.pedidos.get(i); 
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
  
  void draw() {
    // Nome do restaurante:
    drawTitle(res.nome, 20, 20);
    time();
    drawHeader("DETALHES DA MESA " + mesaSel.nome, 20, 60);
    
    mesaSel.draw(100, 120);
    
    // Sombra:
    noStroke();
    fill(82, 114, 111);
    rect(190, 120, 503, 333, 2);
    
    // Retangulo:
    stroke(82, 114, 111);
    strokeWeight(1);
    fill(255, 255, 255);
    rect(190, 120, 500, 330, 2);
    
    // Icone de voltar
    image(iconBack, 100, 250);
    
    // Titulo mesa:
    fill(82, 114, 111);
    if(mesaSel.cliente != null)
      drawTitle(mesaSel.nome + " - " + mesaSel.cliente.nome, 220, 140);
    else
      drawTitle(str(mesaSel.nome), 220, 140);
      
    // Detalhes da mesa:
    image(iconSent , 220, 190);
    image(iconPrice, 220, 220);
    image(iconClock, 220, 250);
    
    int pedidos = 0;
    float gasto = 0;
    String estadia = "-";
    
    if(mesaSel.cliente != null) {
      pedidos = mesaSel.cliente.qtd_pedidos;
      gasto = mesaSel.cliente.conta;
      estadia = mesaSel.cliente.estadia();
    }
    
    drawTextSmallLeft("Qtd. Pedidos: " + pedidos, 250, 190);
    drawTextSmallLeft("Preço: " + gasto, 250, 220);
    drawTextSmallLeft("Estadia: " + estadia, 250, 250);
    
    fill(82, 114, 111);
    drawHeader("Último Pedido: ", 220, 300);
       
    if(mesaSel.ultimoPedido != null) {
      String item = mesaSel.ultimoPedido.produto.nome;
      int qtd = mesaSel.ultimoPedido.qtd;
      float preco = mesaSel.ultimoPedido.produto.preco;
    
      image(iconName , 220, 340);
      image(iconHash , 220, 370);
      image(iconPrice , 220, 400);
      
      drawTextSmallLeft("Item: " + item, 250, 340);
      drawTextSmallLeft("Quantidade: " + qtd, 250, 370);
      drawTextSmallLeft("Preço: " + preco, 250, 400);
      drawTextSmallLeft("TOTAL: R$ " + (preco * qtd), 250, 430);
    } else {
      textFont(montserratR);
      textSize(18);
      fill(82, 114, 111);
      textAlign(LEFT, TOP);
      text("Não há nenhum pedido registrado.", 220, 330);
    }
    
    // Exibir pedidos da mesa:
    drawTitle("Pedidos", 400, 140);
    res.drawPedidosMesa(400, 190, mesaSel);
  }
  
  void clickVoltar() {
    if (mousePressed && (mouseButton == LEFT) &&
       (mouseX >= 100 && mouseX <= 164 && 
        mouseY >= 250 && mouseY <= 314)) {
        delay(100);
        tela = 0;
    }
  }
  
}
