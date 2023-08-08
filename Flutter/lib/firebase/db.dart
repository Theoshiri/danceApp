import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<Map> getVideoFiles(String collection) async {
  print(collection);
  Map files = {};

  try {
    final storageRef = FirebaseStorage.instance.ref(collection);
    ListResult listResult = await storageRef.listAll();

    for (var item in listResult.items) {
      print('name:${item.name}');
      item.getDownloadURL().then((url) {
        files[item.name] = url;
      });
    }
    return files;
  } on FirebaseException catch (e) {
    print('Error: $e');
    return files;
  }
}
