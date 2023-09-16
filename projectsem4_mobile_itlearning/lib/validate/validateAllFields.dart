class validateAllFields {
  String? validateEmail(String email) {
    var emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$');
    if (email.isEmpty || email == '') {
      return "Email cannot be empty!";
    } else if (!emailRegex.hasMatch(email)) {
      return "Email is not in the correct format!";
    } else if (email.length > 100) {
      return "Email is too long!";
    } else {
      return null;
    }
  }

  String? validateUsername(String username) {
    if (username.isEmpty || username == '') {
      return "Username cannot be empty!";
    } else if (username.length > 100) {
      return 'Username is too long!';
    } else {
      return null;
    }
  }

  String? validateFullname(String fullname) {
    if (fullname.isEmpty || fullname == '') {
      return "Fullname cannot be empty!";
    } else if (fullname.length > 100) {
      return 'Fullname is too long!';
    } else {
      return null;
    }
  }

  String? validatePassword(String password) {
    var passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9])');
    if (password.isEmpty || password == '') {
      return "Password cannot be empty!";
    } else if (password.length < 8) {
      return  "Password must be at least 8 characters long!";
    } else if (!passwordRegex.hasMatch(password)) {
      return "Password must contain at least one uppercase letter and one lowercase letter!";
    } else if (password.length > 200) {
      return "Password is too long!";
    } else {
      return null;
    }
  }

  String? validatePhone(String phone) {
    var phoneRegex = RegExp(r'^0[0-9]{9,10}$');
    if (phone.isEmpty || phone == '') {
      return  "Phone number cannot be empty!";
    } else if (!phoneRegex.hasMatch(phone)) {
      return  "Phone number must start with 0 and must contain 10 digits.";
    } else if (phone.length > 30) {
      return "Phone is to long.";
    } else {
      return null;
    }
  }

  String? validatePasswordLogin(String password) {
    if (password.isEmpty || password == '') {
      return "Password cannot be empty!";
    } else if (password.length > 200) {
      return "Password is to long!";
    } else {
      return null;
    }
  }
}
