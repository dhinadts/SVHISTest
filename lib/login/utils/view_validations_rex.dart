class ViewValidRex {
  static bool isName(String em) {
    return RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$").hasMatch(em);
  }

  static bool checkCardValidation(String em) {
    return RegExp(
            r"^((4\d{3})|(5[1-5]\d{2})|(6011))-?\d{4}-?\d{4}-?\d{4}|3[4,7]\d{13}$")
        .hasMatch(em);
  }
}
