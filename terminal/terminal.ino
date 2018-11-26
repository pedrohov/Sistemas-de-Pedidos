#include <LiquidCrystal.h>
#include <AFMotor.h>

// IO:
LiquidCrystal lcd(28, 29, 25, 24, 23, 22);
AF_DCMotor esteira(3);
const int buzzer = A0;

// Dados:
String info;

void setup() {

  // IO Setup:
  pinMode(buzzer, OUTPUT);
  lcd.begin(16, 2);

  // Mostra informacoes no LCD:
  lcd.print("Bem vindo!");
  delay(2000);
  lcd.setCursor(0, 0);
  lcd.print("Use o App para");
  lcd.setCursor(0, 1);
  lcd.print("fazer pedidos.");
  
  // Inicializa a serial do arduino:
  Serial.begin(9600);

  // Inicializa a serial do bluetooth (RX=19, TX=18):
  Serial1.begin(9600);

  // Inicia comunicacao com o processing:
  establishContact();
}

void loop() {

  // App -> Processing:
  if(Serial1.available()) {
    info = readInfo(1);
    Serial.println(info);
  }
  // Processing -> Arduino -> App:
  else if(Serial.available()) {
    info = readInfo(0);
    bool comInterno = handleMessage(info);
    Serial1.println(info);
  }
  
  delay(200);
}

bool handleMessage(String msg) {
    
  String comando = msg.substring(0, 11);

  // Novo cliente se conectou. Exibe o garcom:
  if(comando == "{{CLIENTE}}") {
    int indexFim = msg.indexOf(',', 12);
    String atendente = msg.substring(12, indexFim);
    clearDisplay();
    lcd.setCursor(0, 0);
    lcd.print("Atendente: ");
    lcd.setCursor(0, 1);
    lcd.print(atendente);
  }
  // Novo pedido recebido. Toca o buzzer:
  else if(comando == "{{0BUZZER}}") {
    //Serial1.println(msg);
    tone(buzzer, 2000, 150);
    delay(150);
    tone(buzzer, 3000, 200);
  }
  else if(comando == "{{RECEBID}}") {
    // Para o motor da esteira:
    esteira.run(RELEASE);
  }
  // Alteracao do status do pedido. Informa ao cliente:
  else if(comando == "{{ALTERAC}}") {
    //Serial1.println(msg);

    int indexFim = msg.indexOf(',', 12);
    String id = msg.substring(12, indexFim);
    int indexIni = indexFim + 1;
    indexFim = msg.indexOf(',', indexIni);
    String novoStatus = msg.substring(indexIni, indexFim);

    if(novoStatus == "DESPACHADO") {
      // Aciona o motor:
      esteira.setSpeed(255);
      esteira.run(FORWARD);
    }
  }
}

String readInfo(int serial) {
  String res = "";
  int caractere;
  if(serial == 0) {
    while(Serial.available()) {
      // Le um caractere da serial:
      caractere = Serial.read();

      // Checa se o caractere e '\n':
      if((caractere != 10) && (caractere != 13))
        // Concatena o caractere na string:
        res += (char)caractere;
    }
  } else if(serial == 1) {
    while(Serial1.available()) {
      caractere = Serial1.read();
      if((caractere != 10) && (caractere != 13))
        res += (char)caractere;
    }
  }
  return res;
}

void clearDisplay() {
  lcd.setCursor(0, 0);
  lcd.print("                ");
  lcd.setCursor(0, 1);
  lcd.print("                ");
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("{{CONTACT}}");
    delay(300);
  }
}
