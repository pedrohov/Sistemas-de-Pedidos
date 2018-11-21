/*
 * Sistemas Embarcados - 2o semestre/2018
 * Pedro Henrique Oliveira Veloso
 */
 
import processing.serial.*;
 
// Utils:
PFont comfortaaB;
PFont montserratR;
PImage iconClock;
PImage iconSent;
PImage iconReceived;
PImage iconPrice;
PImage iconName;
PImage iconUser;
PImage iconBack;
PImage iconHash;
PImage coxinha;
PImage cigarrete;
PImage cafe;
 
// Restaurante:
Restaurante res;

// Telas:
TelaPrincipal tPrincipal;
TelaPedido tPedido;
TelaMesa tMesas;
Pedido pedidoSel;   // Pedido selecionado.
Mesa mesaSel;       // Mesa selecionada.

// Mesas cadastradas:
Mesa[] mesas;
 
// Informa a tela a ser desenhada:
int tela = 0;

// Arduino port:
Serial port;
boolean firstContact = false;

void setup() {
  size(800, 500);
  
  // Arduino/Processing setup:
  port = new Serial(this, "COM4", 9600);
  port.bufferUntil('\n');
  
  // Load assets:
  comfortaaB   = createFont("fonts/Comfortaa-Bold.tff", 30);
  montserratR  = createFont("fonts/Montserrat-Regular.ttf", 26);
  iconClock    = loadImage("icons/clock-o.png");
  iconSent     = loadImage("icons/send.png");
  iconReceived = loadImage("icons/inbox.png");
  iconPrice    = loadImage("icons/dollar.png");
  iconName     = loadImage("icons/tag.png");
  iconUser     = loadImage("icons/user.png");
  iconBack     = loadImage("icons/caret-left.png");
  iconHash     = loadImage("icons/hashtag.png");
  coxinha      = loadImage("images/coxinha.jpg");
  cigarrete    = loadImage("images/cigarrete.jpg");
  cafe         = loadImage("images/cafe.jpg"); 
  
  // Instanciar objetos:
  res = new Restaurante("Quick Menu - Restaurante");
  tPrincipal = new TelaPrincipal();
  tPedido    = new TelaPedido();
  tMesas     = new TelaMesa();
}

void draw() {
  // Limpar a tela:
  background(248, 247, 244);
  
  // Desenhar telas:
  if(tela == 0) {
    tPrincipal.draw();
    tPrincipal.update();
  } else if(tela == 1) {
    tMesas.draw();
    tMesas.update();
  } else if(tela == 2) {
    tPedido.draw();
    tPedido.update();
  }
  
}

void handleMessage(String[] msg) {
  
  // Incia conexao:
  if(msg[0].equals("{{CLIENTE}}")) {
    res.initMesa(int(msg[1]), new Cliente(msg[2]));
  }
  
  // Novo pedido requisitado:
  else if(msg[0].equals("{{PEDIDO}}")) {
    // Cria novo pedido:
    res.novoPedido(int(msg[1]), msg[2], int(msg[3]));
  }
  
  // Pedido recebido:
  else if(msg[0].equals("{{RECEBID}}")) {
    res.pedidoRecebido(int(msg[1]));
  }
  
}

void serialEvent(Serial myPort) {
  String msgRecebida = myPort.readStringUntil('\n');
  
  if (msgRecebida != null) {
    msgRecebida = trim(msgRecebida);
    
    // Primeiro contato com o arduino:
    if (firstContact == false) {
      if (msgRecebida.equals("{{CONTACT}}")) { 
        myPort.clear();
        firstContact = true;
        myPort.write("{{REQUEST}}");
        println("Conectado.");
      }
    } 
    else {
      // Split the string at the commas:
      String msg[] = split(msgRecebida, ',');
      println(msgRecebida);
      
      if (msg.length >= 3) {
        handleMessage(msg);
        
        // Envia novas requisicoes ao arduino:
        if(msg[0].equals("{{PEDIDO}}")) {
          // Envia um alerta (buzzer),
          // Atualiza o Id e o Status do pedido:
          myPort.write("{{0BUZZER}}," + str(res.pedidoIdSeed - 1) + ",PENDENTE");

        } else if(msg[0].equals("{{CLIENTE}}")) { 
          // Atualiza a informacao do display:
          myPort.write("{{CLIENTE}}," + res.mesas.get(int(msg[1]) - 1).garcom);
          
        } else if(msg[0].equals("{{RECEBID}}")) {
          myPort.write("{{RECEBID}},");
        }
      }
    }
  }
}

void notificaAlteracaoStatus(Pedido p) {
  port.write("{{ALTERAC}}," + p.id + "," + p.status);
}

void mouseReleased() {
  tPedido.clicou = false;
}
