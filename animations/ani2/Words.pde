void loadWords() {
  // Load names from file
  String[] lines = loadStrings("./data/names.txt");

  for (int i = 0 ; i < lines.length; i++) {
    // Insert Disorient every x amounts of words
    if (i % 5 == 0) {
      words.add("disorient");
    }
    words.add(lines[i]);
  }
}

String createLongString(ArrayList<String> stringList, String separator) {
  // I wrote this without Java documentation. Enjoy the jankyness.
  String temp[] = new String[stringList.size()];
  for (int i = 0; i < temp.length; i++) {
    temp[i] = stringList.get(i);
  }
  return join(temp, separator);
}