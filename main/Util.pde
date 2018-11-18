void drawHeader(String str, int x, int y) {
  textFont(montserratR);
  textSize(22);
  fill(82, 114, 111);
  textAlign(LEFT, TOP);
  text(str, x, y);
}

void drawTitle(String str, int x, int y) {
  textFont(comfortaaB);
  textSize(26);
  fill(82, 114, 111);
  textAlign(LEFT, TOP);
  text(str, x, y);
}

void drawTextSmall(String str, int x, int y) {
  textFont(comfortaaB);
  textSize(12);
  textAlign(CENTER, TOP);
  text(str, x, y);
}

void drawTextSmallLeft(String str, int x, int y) {
  textFont(comfortaaB);
  textSize(12);
  textAlign(LEFT, TOP);
  text(str, x, y);
}

void drawTitleCENTER(String str, int x, int y) {
  textFont(comfortaaB);
  textSize(26);
  textAlign(CENTER, CENTER);
  text(str, x, y);
}

void time() {
  textFont(comfortaaB);
  textSize(18);
  fill(82, 114, 111);
  textAlign(RIGHT, TOP);
  
  String h = Integer.toString(hour());
  String m = Integer.toString(minute());
  String s = Integer.toString(second());
  
  if(h.length() == 1)
    h = "0" + h;
  if(m.length() == 1)
    m = "0" + m;
  if(s.length() == 1)
    s = "0" + s;
  
  text(h + ":" + m + ":" + s, 770, 20);
  image(iconClock, 680, 25);
}
