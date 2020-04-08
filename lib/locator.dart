import 'package:get_it/get_it.dart';
import 'package:livechat/repository/user_respository.dart';
import 'package:livechat/services/fake_auth_service.dart';
import 'package:livechat/services/firebase_auth_service.dart';
import 'package:livechat/services/firebase_storage_service.dart';
import 'package:livechat/services/firestore_db_service.dart';


GetIt getIt = GetIt.instance;
void setupLocator(){
  getIt.registerLazySingleton(()=>FakeAuthenticationService());
  getIt.registerLazySingleton(()=>FirebaseAuthSevice());
  getIt.registerLazySingleton(()=>UserRepository());
  getIt.registerLazySingleton(()=>FirestoreDBService());
  getIt.registerLazySingleton(()=>FirebaseStorageService());
}