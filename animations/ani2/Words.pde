void loadWords() {
  ArrayList<String> anagrams = new ArrayList<String>();
  anagrams.add("disor1e7t");
  anagrams.add("disorient");
  anagrams.add("teatro di sorient");
  anagrams.add("sedition");
  anagrams.add("dsrnt");
  anagrams.add("tneirosid");
  anagrams.add("rose noose");
  anagrams.add("sore door");
  anagrams.add("dentor seat");
  anagrams.add("sordid dose");

  // Load names from file
  String[] lines = loadStrings("./data/names.txt");

  for (int i = 0 ; i < lines.length; i++) {
    // Insert Disorient every x amounts of words
    if (i % 5 == 0) {
      words.add("disorient");
    }
    words.add(lines[i]);
  }
  words.add("ice $4.99");
}

String createLongString(ArrayList<String> stringList, String separator) {
  // I wrote this without Java documentation. Enjoy the jankyness.
  String temp[] = new String[stringList.size()];
  for (int i = 0; i < temp.length; i++) {
    temp[i] = stringList.get(i);
  }
  return join(temp, separator);
}
