// ===== BACKGROUND (per lokasi, bukan per scene) =====
PImage[] bgLocations = new PImage[5]; // 0=cafe, 1=pameran, 2=batik display, 3=ukiran, 4=prambanan

int[] sceneBgIndex = {0, 0, 0, 0, 1, 2, 3, 4};

// ===== ASET KARAKTER (dimuat sekali) =====
PImage[] batikHp   = new PImage[4];
PImage[] batikIdle = new PImage[4];
PImage[] friends   = new PImage[4];

// ===== STATE ANIMASI =====
int currentFrame = 0;
int frameSwitchSpeed = 12;
float scaleBima = 3.0;
float scaleFriends = 3.0;

// ===== STATE SCENE =====
int currentScene = 0;

// ===== TEKS PER SCENE =====
String[] sceneDialogText = {
  "Bima melihat foto ukiran Candi Prambanan di ponselnya.\nTeman-temannya sibuk dengan tren luar negeri.\n\nAris: \"Bima, lihat terus candi?\"\nBima: \"Aku suka sejarah.\"",
  "Teman-temannya mengejek Bima karena lebih suka budaya sendiri.\n\nAris: \"Pakai batik terus, nggak bosan?\"\nTeman: \"Harusnya lebih kekinian!\"",
  "Bima menjelaskan bahwa budaya adalah narasi dan jati diri bangsa.\n\nBima: \"Ini bukan bangunan tua. Ini cerita nenek moyang kita.\"",
  "Teman-teman kembali ke dunianya.\nBima merasa terasing karena budaya mulai dilupakan."
};

String[] narasiLines;
String[] dialogLines;

void setup() {
  size(100, 100);
  surface.setSize(displayWidth, displayHeight);
  surface.setLocation(0, 0);
  noSmooth();

  bgLocations[0] = loadImage("bg1_modern_no_furniture.png");
  // bgLocations[1] = loadImage("bg_pameran.png");        // TODO scene 5
  // bgLocations[2] = loadImage("bg_batik_display.png");  // TODO scene 6
  // bgLocations[3] = loadImage("bg_ukiran.png");          // TODO scene 7
  // bgLocations[4] = loadImage("bg_prambanan.png");       // TODO scene 8

  for (int f = 0; f < 4; f++) {
    batikHp[f]   = loadImage("batik_hp_" + (f+1) + ".png");
    batikIdle[f] = loadImage("batik_idle_" + (f+1) + ".png");
    friends[f]   = loadImage("friends_" + (f+1) + ".png");
  }

  parseDialogText(sceneDialogText[currentScene]);
}

void draw() {
  background(0);

  PImage bg = bgLocations[sceneBgIndex[currentScene]];
  if (bg != null) {
    image(bg, 0, 0, width, height);
  } else {
    fill(80);
    rect(0, 0, width, height);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(24);
    text("Background scene " + (currentScene+1) + " belum dibuat", width/2, height/2);
  }

  if (frameCount % frameSwitchSpeed == 0) {
    currentFrame = (currentFrame + 1) % 4;
  }

  drawSceneContent();
  drawDialogBox();
}

void drawSceneContent() {
  float bimaW = 128 * scaleBima;
  float bimaH = 128 * scaleBima;
  float friendsW = 384 * scaleFriends;
  float friendsH = 128 * scaleFriends;
  float floorLineY = height * 0.76;
  float bimaY = floorLineY - bimaH;
  float friendsY = floorLineY - friendsH;

  switch (currentScene) {
    case 0: // scene 1: Bima pegang HP + teman
      image(batikHp[currentFrame], 20, bimaY, bimaW, bimaH);
      image(friends[currentFrame], 20 + bimaW - 20, friendsY, friendsW, friendsH);
      break;

    case 1: // scene 2: Bima idle + teman mengejek
      image(batikIdle[currentFrame], 20, bimaY, bimaW, bimaH);
      image(friends[currentFrame], 20 + bimaW - 20, friendsY, friendsW, friendsH);
      break;

    case 2: // scene 3: Bima pegang HP, menjelaskan ke teman-teman
      image(batikHp[currentFrame], 20, bimaY, bimaW, bimaH);
      image(friends[currentFrame], 20 + bimaW - 20, friendsY, friendsW, friendsH);
      break;

    case 3: // scene 4: Bima maju ke depan (idle), teman tetap di posisi biasa
      float bimaFloorLineY4 = height * 0.88;
      float bimaY4 = bimaFloorLineY4 - bimaH;
      image(batikIdle[currentFrame], 20, bimaY4, bimaW, bimaH);

      image(friends[currentFrame], 20 + bimaW - 20, friendsY, friendsW, friendsH);
      break;
  }
}

void keyPressed() {
  if (key == ' ') {
    currentScene = (currentScene + 1) % sceneDialogText.length;
    currentFrame = 0;
    parseDialogText(sceneDialogText[currentScene]);
  }
}

void parseDialogText(String dialogText) {
  String[] rawLines = split(dialogText, "\n");
  String[] narasiTemp = new String[rawLines.length];
  String[] dialogTemp = new String[rawLines.length];
  int nCount = 0, dCount = 0;

  for (String line : rawLines) {
    if (line.trim().length() == 0) continue;
    if (line.matches("^[A-Za-z ]{1,20}:\\s*.*")) {
      dialogTemp[dCount++] = line.trim();
    } else {
      narasiTemp[nCount++] = line.trim();
    }
  }
  narasiLines = subset(narasiTemp, 0, nCount);
  dialogLines = subset(dialogTemp, 0, dCount);
}

void drawDialogBox() {
  float padding = 25;
  float narasiSize = 14;
  float dialogSize = 17;
  float narasiLeading = narasiSize * 1.4;
  float dialogLeading = dialogSize * 1.5;
  float sectionGap = (narasiLines.length > 0 && dialogLines.length > 0) ? 14 : 0;
  float maxBoxW = width * 0.7;

  float maxTextW = 0;
  textSize(narasiSize);
  for (String line : narasiLines) maxTextW = max(maxTextW, textWidth(line));

  textSize(dialogSize);
  for (String dLine : dialogLines) {
    int colonIndex = dLine.indexOf(":");
    float lineW;
    if (colonIndex != -1) {
      String speaker = dLine.substring(0, colonIndex + 1) + " ";
      String speech = dLine.substring(colonIndex + 1).trim();
      lineW = textWidth(speaker) + textWidth(speech);
    } else {
      lineW = textWidth(dLine);
    }
    maxTextW = max(maxTextW, lineW);
  }

  float textW = min(maxTextW, maxBoxW - padding * 2);

  float narasiHeight = 0;
  textSize(narasiSize);
  for (String line : narasiLines) narasiHeight += calcWrappedHeight(line, textW, narasiLeading);

  float dialogHeight = 0;
  textSize(dialogSize);
  for (String dLine : dialogLines) dialogHeight += calcWrappedHeight(dLine, textW, dialogLeading);

  float boxW = textW + padding * 2;
  float boxH = padding * 2 + narasiHeight + sectionGap + dialogHeight;
  float bottomMargin = 40;
  float boxX = (width - boxW) / 2;
  float boxY = height - boxH - bottomMargin;

  noStroke();
  fill(20, 20, 20, 210);
  rect(boxX, boxY, boxW, boxH);
  stroke(255);
  strokeWeight(2);
  noFill();
  rect(boxX, boxY, boxW, boxH);

  float cursorY = boxY + padding;
  float textX = boxX + padding;

  textAlign(LEFT, TOP);
  textSize(narasiSize);
  fill(200, 200, 200);
  for (String line : narasiLines) {
    text(line, textX, cursorY, textW, 9999);
    cursorY += calcWrappedHeight(line, textW, narasiLeading);
  }

  if (narasiLines.length > 0 && dialogLines.length > 0) {
    cursorY += sectionGap * 0.4;
    stroke(255, 100);
    strokeWeight(1);
    line(textX, cursorY, textX + textW, cursorY);
    noStroke();
    cursorY += sectionGap * 0.6;
  }

  textSize(dialogSize);
  for (String dLine : dialogLines) {
    int colonIndex = dLine.indexOf(":");
    float lineH;
    if (colonIndex != -1) {
      String speaker = dLine.substring(0, colonIndex + 1);
      String speech = dLine.substring(colonIndex + 1).trim();
      fill(255, 220, 120);
      text(speaker, textX, cursorY);
      float speakerW = textWidth(speaker + " ");
      fill(255);
      text(speech, textX + speakerW, cursorY, textW - speakerW, 9999);
      lineH = calcWrappedHeight(speech, textW - speakerW, dialogLeading);
    } else {
      fill(255);
      text(dLine, textX, cursorY, textW, 9999);
      lineH = calcWrappedHeight(dLine, textW, dialogLeading);
    }
    cursorY += lineH;
  }
}

float calcWrappedHeight(String txt, float wrapWidth, float leading) {
  String[] words = split(txt, " ");
  String currentLine = "";
  int lineCount = 1;
  for (String w : words) {
    String testLine = currentLine.length() == 0 ? w : currentLine + " " + w;
    if (textWidth(testLine) > wrapWidth && currentLine.length() > 0) {
      lineCount++;
      currentLine = w;
    } else {
      currentLine = testLine;
    }
  }
  return lineCount * leading;
}
