String? validateEmail(String? value) {
  RegExp regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value!.isEmpty) {
    return "Your email is required";
  } else if (!regex.hasMatch(value)) {
    return "Please provide a valid emal address";
  }
  return null;
}

String? validatePassword(String? value) {
  if (value!.isEmpty) {
    return "Your password is required";
  }
  return null;
}

String? validateName(String? value) {
  if (value!.isEmpty) {
    return "Your name is required";
  }
  return null;
}

String? validateCourseCode(String? value) {
  if (value!.isEmpty) {
    return "Course Code is required";
  }
  return null;
}

String? validateCourseName(String? value) {
  if (value!.isEmpty) {
    return "Course Name is required";
  }
  return null;
}

String? validateCourseShortName(String? value) {
  if (value!.isEmpty) {
    return "Course Short Name is required";
  }
  return null;
}

String? validateCourseStartDate(String? value) {
  if (value!.isEmpty) {
    return "Course Start date is required";
  }
  return null;
}

String? validateCourseEndDate(String? value) {
  if (value!.isEmpty) {
    return "Course End date is required";
  }
  return null;
}
