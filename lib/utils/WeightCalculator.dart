double calculateIdealWeight(
    String gender, double heightFeet, double heightInches) {
  double totalHeightInches = (heightFeet * 12) + heightInches;

  double inchesOver5Feet = totalHeightInches - 60;
  double idealWeight;
  if (gender.toLowerCase() == "male") {
    idealWeight = 52 + (1.9 * inchesOver5Feet);
  } else if (gender.toLowerCase() == "female") {
    idealWeight = 49 + (1.7 * inchesOver5Feet);
  } else {
    throw ArgumentError("Gender should be 'male' or 'female'");
  }

  return double.parse(idealWeight.toStringAsFixed(2));
}
