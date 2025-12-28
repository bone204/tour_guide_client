String removeVietnameseAccents(String str) {
  var result = str;
  result = result.replaceAll(RegExp(r'[àáảãạăằắẳẵặâầấẩẫậ]'), 'a');
  result = result.replaceAll(RegExp(r'[ÀÁẢÃẠĂẰẮẲẴẶÂẦẤẨẪẬ]'), 'A');
  result = result.replaceAll(RegExp(r'[èéẻẽẹêềếểễệ]'), 'e');
  result = result.replaceAll(RegExp(r'[ÈÉẺẼẸÊỀẾỂỄỆ]'), 'E');
  result = result.replaceAll(RegExp(r'[ìíỉĩị]'), 'i');
  result = result.replaceAll(RegExp(r'[ÌÍỈĨỊ]'), 'I');
  result = result.replaceAll(RegExp(r'[òóỏõọôồốổỗộơờớởỡợ]'), 'o');
  result = result.replaceAll(RegExp(r'[ÒÓỎÕỌÔỒỐỔỖỘƠỜỚỞỠỢ]'), 'O');
  result = result.replaceAll(RegExp(r'[ùúủũụưừứửữự]'), 'u');
  result = result.replaceAll(RegExp(r'[ÙÚỦŨỤƯỪỨỬỮỰ]'), 'U');
  result = result.replaceAll(RegExp(r'[ỳýỷỹỵ]'), 'y');
  result = result.replaceAll(RegExp(r'[ỲÝỶỸỴ]'), 'Y');
  result = result.replaceAll(RegExp(r'[đ]'), 'd');
  result = result.replaceAll(RegExp(r'[Đ]'), 'D');
  return result;
}
