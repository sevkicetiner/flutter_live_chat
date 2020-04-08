
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:livechat/services/storage_base.dart';

class FirebaseStorageService extends StorageBase{

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
   StorageReference _storageReference;

  @override
  Future<String> uploadFile(String userID, String fileType, File file) async {
    _storageReference = _firebaseStorage.ref().child(userID).child(fileType);
    StorageUploadTask uploadTask = _storageReference.putFile(file);
    var url = await (await uploadTask.onComplete).ref.getDownloadURL();
    return url;
  }



}