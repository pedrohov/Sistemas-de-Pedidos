/*
 * Sistemas Embarcados - 2o semestre/2018
 * Pedro Henrique Oliveira Veloso
 */

class TelaPedido {
 
  boolean clicou = false;
  
  TelaPedido() {
    
  }
  
  void update() {
    this.clickVoltar();
    this.clickPreparar();
    this.clickEnviar();
    this.clickRecusar();
  }
  
  void draw() {
    // Nome do restaurante:
    drawTitle(res.nome, 20, 20);
    time();
    drawHeader("DETALHES DO PEDIDO #" + pedidoSel.id, 20, 60);
    
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
    drawHeader("Pedido ", 220, 300);
       
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
    
    // Imagem:
    if(pedidoSel.produto.nome.equals("Coxinha")) {
      image(coxinha, 480, 300);
    } else if(pedidoSel.produto.nome.equals("Cigarrete")) {
      image(cigarrete, 480, 300);
    } else if(pedidoSel.produto.nome.equals("Café")) {
      image(cafe, 480, 300);
    }
    
    // Botoes:
      if((pedidoSel.status != StatusPedido.DESPACHADO)
      && (pedidoSel.status != StatusPedido.ENTREGUE)
      && (pedidoSel.status != StatusPedido.RECUSADO)) {
        
        if(pedidoSel.status != StatusPedido.ATENDIDO) {
          // PREPARAR:
          // Sombra:
          noStroke();
          fill(82, 114, 111);
          rect(550, 140 + 3, 100, 30);
          
          // Retangulo:
          stroke(82, 114, 111);
          fill(255, 255, 255);
          strokeWeight(1);
          rect(550, 140, 100, 30);
          
          // Texto:
          fill(82, 114, 111);
          text("PREPARAR", 570, 147);
        }
      
        if(pedidoSel.status != StatusPedido.DESPACHADO) {
          // ENVIAR:
          // Sombra:
          noStroke();
          fill(82, 114, 111);
          rect(550, 180 + 3, 100, 30);
          
          // Retangulo:
          stroke(82, 114, 111);
          fill(255, 255, 255);
          strokeWeight(1);
          rect(550, 180, 100, 30);
          
          // Texto:
          fill(82, 114, 111);
          text("ENVIAR", 575, 187);
        }
        
        // RECUSAR:
        // Sombra:
        noStroke();
        fill(82, 114, 111);
        rect(550, 210 + 3, 100, 30);
        
        // Retangulo:
        stroke(82, 114, 111);
        fill(255, 255, 255);
        strokeWeight(1);
        rect(550, 210, 100, 30);
        
        // Texto:
        fill(82, 114, 111);
        text("RECUSAR", 570, 217);
      }
    
  }
  
  boolean clickPreparar() {
    if (mousePressed && (mouseButton == LEFT) 
      && (mouseX >= 550 && mouseX <= 650)
      && (mouseY >= 140 && mouseY <= 170)
      && (clicou == false)) {
      clicou = true;
      pedidoSel.status = StatusPedido.ATENDIDO;
      notificaAlteracaoStatus(pedidoSel);
      return true;
    }
    return false;
  }
  
  boolean clickEnviar() {
    if (mousePressed && (mouseButton == LEFT) 
      && (mouseX >= 550 && mouseX <= 650)
      && (mouseY >= 180 && mouseY <= 210)
      && (clicou == false)) {
      clicou = true;
      pedidoSel.status = StatusPedido.DESPACHADO;
      notificaAlteracaoStatus(pedidoSel);
      return true;
    }
    return false;
  }
  
  boolean clickRecusar() {
    if (mousePressed && (mouseButton == LEFT) 
      && (mouseX >= 550 && mouseX <= 650)
      && (mouseY > 210 && mouseY <= 240)
       && (clicou == false)) {
      clicou = true;
      pedidoSel.status = StatusPedido.RECUSADO;
      notificaAlteracaoStatus(pedidoSel);
      return true;
    }
    return false;
  }
  
  void clickVoltar() {
    if (mousePressed && (mouseButton == LEFT) &&
       (mouseX >= 100 && mouseX <= 164 && 
        mouseY >= 250 && mouseY <= 314)
         && (clicou == false)) {
        delay(100);
        tela = 0;
    }
  }
  
}
