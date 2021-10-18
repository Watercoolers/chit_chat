extension StringExtension on String {
  String initials() {
    var words = this.replaceAll('@', '').split(' ');
    return words.first[0] + (words.length > 1 ? words.last[0] : '');
  }
}
