import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FormData extends ChangeNotifier {
  List<TextEditingController> loginFormControllers = [];
  List<String> loginCredentials = ['', ''];
  bool loginVerifier = true;
  int loginController = 0;

  List<TextEditingController> registrationFormControllers = [];
  List<String> registrationFormItems = [
    '',
    '',
    '',
    '',
    '',
  ];
  var loggedUserInfo = {};

  bool firstFormVerifier = true;
  int counter = 0;

  bool emailRegistrationVerifier = true;
  List<TextEditingController> registrationEmailFormControllers = [];
  List<String> registrationEmailCredentials = ['', ''];

  void addLoginFormController(TextEditingController controller) {
    if (loginController < 2) {
      print('added login controller');
      loginController++;
      loginFormControllers.add(controller);
    }
  }

  void verifyLogin() {
    loginVerifier = true;
    for (var x = 0; x < 2; x++) {
      var controller = loginFormControllers[x];
      if (controller.text == '') {
        loginVerifier = false;
      }
      loginCredentials[x] = controller.text;
    }
    print(loginCredentials);
  }

  void addFormController(TextEditingController controller) {
    if (counter <= 4) {
      registrationFormControllers.add(controller);
    }
    counter++;
  }

  void firstRegistrationFormVerify() {
    for (var x = 0; x < registrationFormControllers.length; x++) {
      var controller = registrationFormControllers[x];
      registrationFormItems[x] = controller.text;
    }
    for (var i = 0; i < registrationFormControllers.length; i++) {
      if (registrationFormItems[i] == '') {
        firstFormVerifier = false;
      }
    }
    if (firstFormVerifier) {
      for (var j = 0; j < registrationFormControllers.length; j++) {
        var controller = registrationFormControllers[j];
        controller.clear();
      }
    }
  }

  void addEmailFormController(TextEditingController controller) {
    print('add');
    registrationEmailFormControllers.add(controller);
  }

  void emailRegistration() {
    emailRegistrationVerifier = true;
    for (var x = 0; x < registrationEmailFormControllers.length; x++) {
      var controller = registrationEmailFormControllers[x];
      if (controller.text == '') {
        emailRegistrationVerifier = false;
      }
      registrationEmailCredentials[x] = controller.text;
    }
    print(registrationEmailFormControllers[1].text);
  }

  void addToList(String field) {
    registrationFormItems.add(field);
  }

  void updateMap(Map map) {
    loggedUserInfo = Map.of(map);
  }
}
