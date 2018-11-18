String info;

void setup() {
  
  // Inicializa a serial do arduino:
  Serial.begin(9600);

  // Inicializa a serial do bluetooth (RX=19, TX=18):
  Serial1.begin(9600);

}

void loop() {
  
  if(Serial1.available()) {
    info = readInfo(1);
    Serial.println(info);
  }
  else if(Serial.available()) {
    info = readInfo(0);
    Serial1.println(info);
  }
  
  delay(100);
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
