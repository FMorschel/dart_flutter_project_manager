extension StringExt on String {
  String capitalize({
    bool allWords = false,
    Pattern splitter = ' ',
    String? replaceSplitter,
  }) {
    final index = indexOf(RegExp(r'[A-Z]', caseSensitive: false));
    final buffer = StringBuffer();
    if (index == -1) return this;
    final beforeFirstLetter = substring(0, index);
    final firstLetter = substring(index, index + 1).toUpperCase();
    final splittingString =
        beforeFirstLetter + firstLetter + substring(index + 1);
    if (allWords) {
      for (final word in splittingString.split(splitter)) {
        buffer.write(word.capitalize());
        buffer.write(replaceSplitter ?? splitter);
      }
    } else {
      buffer.write(beforeFirstLetter);
      buffer.write(firstLetter);
      buffer.write(substring(index + 1, length));
    }
    return buffer.toString();
  }

  String splitByPattern({
    required Pattern patternIdentifyer,
    String joiner = ' ',
  }) {
    final buffer = StringBuffer();
    final matches = [...patternIdentifyer.allMatches(this)];
    if (matches.isEmpty) return this;
    for (final mathc in matches) {
      buffer.write(mathc[0]!.capitalize());
      buffer.write(joiner);
    }
    return buffer.toString().trim();
  }

  String splitAndCapitalize({
    required Pattern wordIdentifyer,
    String joiner = ' ',
    bool allWords = false,
  }) {
    return splitByPattern(patternIdentifyer: wordIdentifyer, joiner: joiner)
        .capitalize(allWords: allWords, splitter: joiner);
  }
}
