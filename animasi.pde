// ===== BACKGROUND (per lokasi, bukan per scene) =====
PImage[] bgLocations = new PImage[5]; // 0=cafe/modern, 1=pameran, 2=batik display, 3=ukiran candi, 4=prambanan

int[] sceneBgIndex = {0, 0, 0, 0, 1, 2, 3, 4};

// ===== ASET KARAKTER (dimuat sekali) =====
PImage[] batikHp     = new PImage[4];
PImage[] batikIdle   = new PImage[4];
PImage[] batikNunjuk = new PImage[4]; // untuk scene 5, 6, 7
PImage[] friends     = new PImage[4];
PImage[] friendsHp2  = new PImage[4]; // untuk scene 1 & 4
PImage[] friendsBatik = new PImage[4]; // untuk scene 8

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
  "Teman-teman kembali ke dunianya.\nBima merasa terasing karena budaya mulai dilupakan.",
  "Bima mengajak teman-temannya ke pameran seni kontemporer.\n\nBima: \"Ayo ikut aku.\"",
  "Bima menunjukkan bahwa batik bisa dijadikan desain kontemporer tanpa kehilangan motifnya.\n\nBima: \"Batik juga bisa modern.\"",
  "Aris mulai memperhatikan ukiran dan filosofi budaya.\n\nAris: \"Ternyata keren juga...\"",
  "Teman-teman mulai menghargai budaya sendiri.\nMenjaga budaya bukan berarti menolak dunia.\n\n\"Kita hanya perlu ingat siapa diri kita.\""
};

String[] narasiLines;
String[] dialogLines;

void setup() {
  size(100, 100);
  surface.setSize(displayWidth, displayHeight);
  surface.setLocation(0, 0);
  noSmooth();

  bgLocations[0] = loadImage("bg1_modern_no_furniture.png");
  bgLocations[1] = loadImage("bg5_pameran_budaya.png");
  bgLocations[2] = loadImage("bg6_batik_modern.png");
  bgLocations[3] = loadImage("bg7_ukiran_candi.png");
  bgLocations[4] = loadImage("bg8_prambanan.png");

  for (int f = 0; f < 4; f++) {
    batikHp[f]      = loadImage("batik_hp_" + (f+1) + ".png");
    batikIdle[f]    = loadImage("batik_idle_" + (f+1) + ".png");
    batikNunjuk[f]  = loadImage("batik_nunjuk_frame" + (f+1) + ".png");
    friends[f]      = loadImage("friends_" + (f+1) + ".png");
    friendsHp2[f]   = loadImage("friends_hp2_frame" + (f+1) + ".png");
    friendsBatik[f] = loadImage("friends_batik_frame" + (f+1) + ".png");
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

  // Posisi friends tetap pakai anchor lama (supaya posisi mereka tidak berubah)
  float friendsX = 20 + bimaW - 20;

  // Bima digeser ke kanan agar lebih dekat ke teman, tapi tetap ada celah longgar
  float bimaXClose = 20 + 100;

  switch (currentScene) {
    case 0: // scene 1: Bima pegang HP + teman (friends_hp2)
      image(batikHp[currentFrame], bimaXClose, bimaY, bimaW, bimaH);
      image(friendsHp2[currentFrame], friendsX, friendsY, friendsW, friendsH);
      break;

    case 1: // scene 2: Bima idle + teman mengejek (friends)
      image(batikIdle[currentFrame], bimaXClose, bimaY, bimaW, bimaH);
      image(friends[currentFrame], friendsX, friendsY, friendsW, friendsH);
      break;

    case 2: // scene 3: Bima pegang HP, menjelaskan ke teman-teman (friends)
      image(batikHp[currentFrame], bimaXClose, bimaY, bimaW, bimaH);
      image(friends[currentFrame], friendsX, friendsY, friendsW, friendsH);
      break;

    case 3: // scene 4: Bima maju ke depan (idle), teman (friends_hp2)
      float bimaFloorLineY4 = height * 0.88;
      float bimaY4 = bimaFloorLineY4 - bimaH;
      image(batikIdle[currentFrame], 20, bimaY4, bimaW, bimaH);
      image(friendsHp2[currentFrame], friendsX, friendsY, friendsW, friendsH);
      break;

    case 4: // scene 5: Bima menunjuk + teman (friends), sejajar seperti scene 1-3
      image(batikNunjuk[currentFrame], bimaXClose, bimaY, bimaW, bimaH);
      image(friends[currentFrame], friendsX, friendsY, friendsW, friendsH);
      break;

    case 5: // scene 6: Bima menunjuk, sendirian, digeser sedikit ke kanan
      float bimaX6 = width * 0.14;
      image(batikNunjuk[currentFrame], bimaX6, bimaY, bimaW, bimaH);
      break;

    case 6: // scene 7: Bima menunjuk, sendirian (di depan ukiran candi)
      float bimaX7 = width * 0.08;
      image(batikNunjuk[currentFrame], bimaX7, bimaY, bimaW, bimaH);
      break;

    case 7: // scene 8: Bima idle + teman (friends_batik), diperkecil lagi & digeser ke kanan biar ke tengah
      float scaleBima8 = scaleBima * 0.75;
      float scaleFriends8 = scaleFriends * 0.75;
      float bimaW8 = 128 * scaleBima8;
      float bimaH8 = 128 * scaleBima8;
      float friendsW8 = 384 * scaleFriends8;
      float friendsH8 = 128 * scaleFriends8;
      float floorLineY8 = height * 0.82;
      float bimaY8 = floorLineY8 - bimaH8;
      float friendsY8 = floorLineY8 - friendsH8;
      float shiftRight8 = width * 0.12; // geser grup ke kanan biar lebih ke tengah
      float bimaXClose8 = 20 + 100 + shiftRight8;
      float friendsX8 = 20 + bimaW8 - 20 + shiftRight8;
      image(batikIdle[currentFrame], bimaXClose8, bimaY8, bimaW8, bimaH8);
      image(friendsBatik[currentFrame], friendsX8, friendsY8, friendsW8, friendsH8);
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
  float sectionGap = (narasiLines.length > 0 && dialogLines.length > 0) ? 20 : 0;
  float maxBoxW = width * 0.7; // batas maksimum lebar kolom

  // --- Hitung lebar teks terpanjang dari narasi & dialog ---
  float maxTextW = 0;

  textSize(narasiSize);
  for (String line : narasiLines) {
    maxTextW = max(maxTextW, textWidth(line));
  }

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

  // --- Pre-wrap semua baris jadi array baris manual (biar tinggi & posisi gambar selalu presisi sama) ---
  ArrayList<String> wrappedNarasi = new ArrayList<String>();
  textSize(narasiSize);
  for (String line : narasiLines) {
    String[] w = wrapTextLines(line, textW);
    for (String wl : w) wrappedNarasi.add(wl);
  }

  // Untuk dialog, simpan juga info speaker terpisah per baris asli
  ArrayList<String[]> dialogWrapped = new ArrayList<String[]>(); // {speaker, wrappedLine, isFirstLine("1"/"0")}
  textSize(dialogSize);
  for (String dLine : dialogLines) {
    int colonIndex = dLine.indexOf(":");
    if (colonIndex != -1) {
      String speaker = dLine.substring(0, colonIndex + 1);
      String speech = dLine.substring(colonIndex + 1).trim();
      float speakerW = textWidth(speaker + " ");
      String[] wrappedSpeech = wrapTextLines(speech, textW - speakerW);
      for (int i = 0; i < wrappedSpeech.length; i++) {
        dialogWrapped.add(new String[]{speaker, wrappedSpeech[i], i == 0 ? "1" : "0"});
      }
    } else {
      String[] wrapped = wrapTextLines(dLine, textW);
      for (String wl : wrapped) {
        dialogWrapped.add(new String[]{"", wl, "1"});
      }
    }
  }

  float narasiHeight = wrappedNarasi.size() * narasiLeading;
  float dialogHeight = dialogWrapped.size() * dialogLeading;

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

  // --- Gambar narasi ---
  textAlign(LEFT, TOP);
  textSize(narasiSize);
  fill(200, 200, 200);
  for (String line : wrappedNarasi) {
    // Baris kutipan (diawali & diakhiri tanda petik) ditengahkan dalam kotak,
    // supaya tidak menjorok mepet ke kiri seperti narasi biasa.
    if (line.startsWith("\"") && line.endsWith("\"")) {
      float lineW = textWidth(line);
      float centerOffset = (textW - lineW) / 2;
      if (centerOffset < 0) centerOffset = 0;
      text(line, textX + centerOffset, cursorY);
    } else {
      text(line, textX, cursorY);
    }
    cursorY += narasiLeading;
  }

  // --- Garis pemisah (sekarang presisi karena tinggi narasi dihitung dari baris hasil wrap yang sama persis) ---
  if (wrappedNarasi.size() > 0 && dialogWrapped.size() > 0) {
    float lineY = cursorY + sectionGap * 0.5;
    stroke(255, 100);
    strokeWeight(1);
    line(textX, lineY, textX + textW, lineY);
    noStroke();
    cursorY += sectionGap;
  }

  // --- Gambar dialog ---
  textSize(dialogSize);
  for (String[] d : dialogWrapped) {
    String speaker = d[0];
    String speechLine = d[1];
    boolean isFirstLine = d[2].equals("1");

    if (speaker.length() > 0) {
      float speakerW = textWidth(speaker + " ");
      if (isFirstLine) {
        fill(255, 220, 120);
        text(speaker, textX, cursorY);
      }
      fill(255);
      text(speechLine, textX + speakerW, cursorY);
    } else {
      fill(255);
      text(speechLine, textX, cursorY);
    }
    cursorY += dialogLeading;
  }
}

// Pecah teks jadi array baris sesuai lebar yang tersedia (word-wrap manual)
String[] wrapTextLines(String txt, float wrapWidth) {
  String[] words = split(txt, " ");
  ArrayList<String> lines = new ArrayList<String>();
  String currentLine = "";

  for (String w : words) {
    String testLine = currentLine.length() == 0 ? w : currentLine + " " + w;
    if (textWidth(testLine) > wrapWidth && currentLine.length() > 0) {
      lines.add(currentLine);
      currentLine = w;
    } else {
      currentLine = testLine;
    }
  }
  if (currentLine.length() > 0) lines.add(currentLine);

  return lines.toArray(new String[0]);
}
