import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/random_user.dart';
import '../repositories/user_repository.dart';

// this file handles the business logic, calling the corresponding repository
class Authentication {
  UserRepository repository = Get.find();

  Future<bool> get init async => await repository.init();

  Future<void> addUser(email, password) async =>
      await repository.addUser(User(email: email, password: password));

  // if login is ok then data is stored on shared prefs
  Future<bool> login(bool storeUser, email, password) async {
    User user = User(email: email, password: password);
    bool result = await repository.signup(user);
    if(result && storeUser){
      await repository.storeUserInfo(user);
      User user2 = await repository.getStoredUser();
      print("Email: "+user2.email +" Pass: "+ user2.password);
    }

    return Future.value(result);
  }

  Future<bool> signup(user, password) async {
    bool result = await repository.signup(User(email: user, password: password));
    return Future.value(result);
  }

  Future<void> logout() async {
    //return await repository.logout();
  }

  Future<User> getStoredUser() async {
    try {
      return await repository.getStoredUser();
    } catch (e) {
      return User(email: "", password: "");
    }
  
  }

  Future<void> clearStoredUser() async {
    return await repository.clearStoredUser();
  }

  clearAll() async {
    await repository.clearAll();
  }

  Future<bool> isStoringUser() async {
    return repository.isStoringUser();
  }
}
