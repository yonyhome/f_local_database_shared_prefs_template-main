import 'package:loggy/loggy.dart';
import '../../data/datasources/local/user_local_datasource_sqflite.dart';
import '../../data/datasources/local/user_local_shared_prefs.dart';
import '../entities/random_user.dart';

// here we call the corresponding local source
class UserRepository {
  late UserLocalDataSource localDataSource;
  late UserLocalSharedPrefs userLocalSharedPrefs;

  UserRepository() {
    logInfo("Starting UserRepository");
    localDataSource = UserLocalDataSource();
    userLocalSharedPrefs = UserLocalSharedPrefs();
  }

  Future<void> addUser(User user) async {
    await localDataSource.addUser(user);
    return Future.value();
  }

  Future<List<User>> getAllUsers() async => await localDataSource.getAllUsers();

  Future<void> storeUserInfo(User user) async {
    try {
      await userLocalSharedPrefs.storeUserInfo(user);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<User> getStoredUser() async {
    try {
      return await userLocalSharedPrefs.getUserInfo();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> clearStoredUser() async {
    await userLocalSharedPrefs.clearUserInfo();
    return Future.value();
  }

  init() async => await userLocalSharedPrefs.init();

  Future<bool> signup(User user) async {
    List<User> users = await localDataSource.getAllUsers();
    int i = 0;
    bool found = false;
    while(i<users.length && !found){
      if(users[i].email == user.email && users[i].password == user.password){
        found = true;
      }
      i++;
    }
    return Future.value(found);
  }

  logout() async {
    userLocalSharedPrefs.clearUserInfo();
  }

  clearAll() async {
    await localDataSource.deleteAll();
    await userLocalSharedPrefs.deleteAll();
  }

  Future<bool> isStoringUser() async {
    bool result = await userLocalSharedPrefs.isStoringUser();
    return Future.value(result);
  }
}
