Future<String> mockGeminiMatch(String foodType, String location) async {
  await Future.delayed(Duration(milliseconds: 500));
  return "NGO near $location accepts $foodType";
}

Future<String> mockExpiry(String foodName) async {
  await Future.delayed(Duration(milliseconds: 500));
  return "$foodName is fresh for approx 4 hours";
}
