/*
 * Sistemas Embarcados - 2o semestre/2018
 * Pedro Henrique Oliveira Veloso
 */
 
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
 
// Restaurante:
Restaurante res;

// Telas:
TelaPrincipal tPrincipal;
TelaMesa tMesas;
Pedido pedidoSel;
Mesa mesaSel; // Mesa selecionada.

// Mesas cadastradas:
Mesa[] mesas;
 
// Informa a tela a ser desenhada:
int tela = 0;

void setup() {
  size(800, 500);
  
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
  
  
  // Instanciar objetos:
  res = new Restaurante("Restaurante");
  tPrincipal = new TelaPrincipal();
  tMesas     = new TelaMesa();
}

void draw() {
  // Clear screen:
  background(248, 247, 244);
  
  // Desenhar telas:
  if(tela == 0) {
    tPrincipal.update();
    tPrincipal.draw();
  } else if(tela == 1) {
    tMesas.update();
    tMesas.draw(); 
  }
  
}
