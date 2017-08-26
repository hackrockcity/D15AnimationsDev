void loadWords() {
  // Load names from file
  String[] lines = loadStrings("./data/names.txt");

  for (int i = 0 ; i < lines.length; i++) {
    // TODO: Insert Disorient every x amounts of words
    if (i % 5 == 0) {
      words.add("disorient");
    }
    words.add(lines[i]);
  }
}
