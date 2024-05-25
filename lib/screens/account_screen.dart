// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:path/path.dart' as Path;
//
// import 'package:oryntapp/language/language_constants.dart';
// import 'package:oryntapp/language/language.dart';
//
// import '../main.dart';
//
// // Профильдік экран
// class AccountScreen extends StatefulWidget {
//   const AccountScreen({super.key});
//
//   @override
//   State<AccountScreen> createState() => _AccountScreenState();
// }
//
// class _AccountScreenState extends State<AccountScreen> {
//   // Ағымдағы пайдаланушы
//   final currentUser = FirebaseAuth.instance.currentUser;
//   // Пайдаланушылар тізімі
//   final userCollection = FirebaseFirestore.instance.collection("Users");
//
//   // Шығу функциясы
//   Future<void> signOut() async {
//     final navigator = Navigator.of(context);
//     await FirebaseAuth.instance.signOut();
//     navigator.pushNamedAndRemoveUntil(
//         '/login', (Route<dynamic> route) => false);
//   }
//   // Қолданушының атын өзгерту функциясы
//   Future<void> editField(String field) async {
//     String newValue = "";
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.grey[900],
//         title: Text(
//           translation(context).editUsername,
//           style: const TextStyle(color: Colors.white),
//         ),
//         content: TextField(
//           autofocus: true,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             hintText: 'Enter new $field',
//
//             hintStyle: const TextStyle(color: Colors.grey),
//           ),
//           onChanged: (value) {
//             newValue = value;
//           },
//         ),
//         actions: [
//           TextButton(
//               child: Text(translation(context).cancel, style: const TextStyle(color: Colors.white)),
//               onPressed: () => Navigator.pop(context)),
//           TextButton(
//               child: Text(translation(context).save, style: const TextStyle(color: Colors.white)),
//               onPressed: () {
//                 Navigator.of(context).pop(newValue);
//               }),
//         ],
//       ),
//     );
//
//     if (newValue.trim().length > 0) {
//       await userCollection.doc(currentUser?.email).update({field: newValue});
//     }
//   }
//
//   // Суретті таңдау функциясы
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       File file = File(pickedFile.path);
//       String fileName = Path.basename(file.path);
//       Reference firebaseStorageRef = FirebaseStorage.instance
//           .ref()
//           .child('user_profile_photos')
//           .child(fileName);
//       UploadTask uploadTask = firebaseStorageRef.putFile(file);
//       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
//       String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//
//       await userCollection.doc(currentUser?.email).update({
//         'profile_photo': downloadUrl,
//       });
//     }
//   }
//   // Суретті жою функциясы
//   Future<void> _deletePhoto() async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//
//     final userData = await userCollection.doc(currentUser?.email).get();
//     final profilePhotoUrl = userData.data()?['profile_photo'];
//
//     if (profilePhotoUrl != null) {
//       Reference photoRef = FirebaseStorage.instance.refFromURL(profilePhotoUrl);
//       await photoRef.delete();
//     }
//
//     await userCollection
//         .doc(currentUser?.email)
//         .update({'profile_photo': null});
//   }
//   // Суретті жою терезесі
//   Future<void> _deletePhotoDialog() async {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(translation(context).deletePhoto),
//         content: Text(translation(context).areYouSureYouWantToDeleteYourProfilePhoto),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(translation(context).cancel),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _deletePhoto();
//             },
//             child: Text(translation(context).delete),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Толық экранда суретті көрсету функциясы
//   void _showFullScreenImage(String imageUrl) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//             child: Hero(
//               tag: 'profile_photo',
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(imageUrl),
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//
//       appBar: AppBar(
//         title: Text(translation(context).profile),
//         actions: [
//           // Шығу түймесі
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => signOut(),
//           ),
//         ],
//       ),
//
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("Users")
//             .doc(currentUser?.email)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final userData = snapshot.data!.data() as Map<String, dynamic>;
//             // Профиль суреті
//             Widget profilePhoto = userData['profile_photo'] != null
//                 ? Hero(
//                     tag: 'profile_photo',
//                     child: CircleAvatar(
//                       radius: 64,
//                       backgroundImage: NetworkImage(userData['profile_photo']),
//                       child: InkWell(
//                         onTap: () {
//                           _showFullScreenImage(userData['profile_photo']);
//                         },
//                       ),
//                     ),
//                   )
//                 : const Hero(
//                     tag: 'profile_photo',
//                     child: CircleAvatar(
//                       radius: 64,
//                       backgroundImage:
//                           AssetImage('assets/images/default_photo.jpg'),
//                     ),
//                   );
//
//             return Column(
//               children: [
//                 const SizedBox(height: 20),
//                 // Профиль суреті
//                 Stack(
//                   children: [
//                     GestureDetector(
//                       onLongPress: _deletePhotoDialog,
//                       child: profilePhoto,
//                     ),
//                     // Суретті қосу түймесі
//                     Positioned(
//                       bottom: -10,
//                       left: 80,
//                       child: IconButton(
//                         onPressed: _pickImage,
//                         icon: const Icon(Icons.add_circle,
//                             color: Colors.blue, size: 30),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 24),
//                 // Пайдаланушының Email
//                 Text('${currentUser?.email}',
//                     style: const TextStyle(fontSize: 16)),
//
//                 const SizedBox(height: 24),
//                 // Пайдаланушының аты
//                 MyTextBox(
//                   text: userData['username'],
//                   sectionName: translation(context).username,
//                   onPressed: () => editField('username'),
//                 ),
//
//                 const SizedBox(height: 24),
//                 // Қосымшаның тілін ауыстыру
//                 Center(
//                     child: DropdownButton<Language>(
//                       iconSize: 30,
//                       hint: Text(translation(context).selectLanguage),
//                       onChanged: (Language? language) async {
//                         if (language != null) {
//                           Locale _locale = await setLocale(language.languageCode);
//                           MyApp.setLocale(context, _locale);
//                         }
//                       },
//                       items: Language.languageList()
//                           .map<DropdownMenuItem<Language>>(
//                             (e) => DropdownMenuItem<Language>(
//                           value: e,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: <Widget>[
//                               Text(
//                                 e.flag,
//                                 style: const TextStyle(fontSize: 30),
//                               ),
//                               Text(e.name)
//                             ],
//                           ),
//                         ),
//                       ).toList(),
//                     )
//                 ),
//
//               ],
//             );
//
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//
// class MyTextBox extends StatelessWidget {
//   final String text;
//   final String sectionName;
//   final void Function()? onPressed;
//
//   const MyTextBox({
//     super.key,
//     required this.text,
//     required this.sectionName,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       padding: const EdgeInsets.only(
//         bottom: 15,
//         left: 15,
//       ),
//       margin: const EdgeInsets.only(
//         left: 20,
//         right: 20,
//         top: 10,
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Text(
//             sectionName,
//             style: TextStyle(
//               color: Colors.grey[500],
//             ),
//           ),
//           IconButton(
//             onPressed: onPressed,
//             icon: Icon(
//               Icons.settings,
//               color: Colors.grey[400],
//             ),
//           ),
//         ]),
//         Text(text),
//       ]),
//     );
//   }
// }



import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;

import 'package:oryntapp/language/language_constants.dart';
import 'package:oryntapp/language/language.dart';

import '../main.dart';

// Профильдік экран
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // Ағымдағы пайдаланушы
  final currentUser = FirebaseAuth.instance.currentUser;
  // Пайдаланушылар тізімі
  final userCollection = FirebaseFirestore.instance.collection("Users");

  // Шығу функциясы
  Future<void> signOut() async {
    final navigator = Navigator.of(context);
    await FirebaseAuth.instance.signOut();
    navigator.pushNamedAndRemoveUntil(
        '/login', (Route<dynamic> route) => false);
  }

  // Пайдаланушының аккаунтын жою функциясы
  Future<void> deleteAccount() async {
    final navigator = Navigator.of(context);

    // Firestore-дан пайдаланушы деректерін жою
    await userCollection.doc(currentUser?.email).delete();

    // Пайдаланушының профиль фотосуреті бар болса, оны Firebase жадынан жою
    final userData = await userCollection.doc(currentUser?.email).get();
    final profilePhotoUrl = userData.data()?['profile_photo'];
    if (profilePhotoUrl != null) {
      Reference photoRef = FirebaseStorage.instance.refFromURL(profilePhotoUrl);
      await photoRef.delete();
    }

    // Пайдаланушыны Firebase Auth жүйесінен жою
    await currentUser?.delete();

    // Жүйеден шығып, кіру бетіне қайта бағыттау
    await FirebaseAuth.instance.signOut();
    navigator.pushNamedAndRemoveUntil(
        '/login', (Route<dynamic> route) => false);
  }
  // Қолданушының атын өзгерту функциясы
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          translation(context).editUsername,
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter new $field',
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
              child: Text(translation(context).cancel,
                  style: const TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pop(context)),
          TextButton(
              child: Text(translation(context).save,
                  style: const TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(newValue);
              }),
        ],
      ),
    );

    if (newValue.trim().length > 0) {
      await userCollection.doc(currentUser?.email).update({field: newValue});
    }
  }
  // Суретті таңдау функциясы
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String fileName = Path.basename(file.path);
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('user_profile_photos')
          .child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await userCollection.doc(currentUser?.email).update({
        'profile_photo': downloadUrl,
      });
    }
  }
  // Суретті жою функциясы
  Future<void> _deletePhoto() async {
    final userData = await userCollection.doc(currentUser?.email).get();
    final profilePhotoUrl = userData.data()?['profile_photo'];

    if (profilePhotoUrl != null) {
      Reference photoRef = FirebaseStorage.instance.refFromURL(profilePhotoUrl);
      await photoRef.delete();
    }

    await userCollection
        .doc(currentUser?.email)
        .update({'profile_photo': null});
  }
  // Суретті жою терезесі
  Future<void> _deletePhotoDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translation(context).deletePhoto),
        content: Text(
            translation(context).areYouSureYouWantToDeleteYourProfilePhoto),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(translation(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePhoto();
            },
            child: Text(translation(context).delete),
          ),
        ],
      ),
    );
  }
  // Толық экранда суретті көрсету функциясы
  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Hero(
              tag: 'profile_photo',
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(translation(context).profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => signOut(),
          ),
        ],
      ),
      // Профильдік деректерді жүктеу
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          // Профиль суреті
          Widget profilePhoto = userData['profile_photo'] != null
              ? Hero(
                  tag: 'profile_photo',
                  child: CircleAvatar(
                    radius: 72,
                    backgroundImage: NetworkImage(userData['profile_photo']),
                    child: InkWell(
                      onTap: () {
                        _showFullScreenImage(userData['profile_photo']);
                      },
                    ),
                  ),
                )
              : const Hero(
                  tag: 'profile_photo',
                  child: CircleAvatar(
                    radius: 72,
                    backgroundImage:
                        AssetImage('assets/images/default_photo.jpg'),
                  ),
                );

          return Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  // Профиль суреті
                  GestureDetector(
                    onLongPress: _deletePhotoDialog,
                    child: profilePhoto,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 100,
                    child: IconButton(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.add_circle,
                          color: Colors.blue, size: 35),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Пайдаланушының Email
              Text(
                  '${currentUser?.email}',
                  style: const TextStyle(
                      fontSize: 18,
                  )
              ),
              const SizedBox(height: 24),
              // Пайдаланушының аты
              MyTextBox(
                text: userData['username'],
                sectionName: translation(context).username,
                onPressed: () => editField('username'),
              ),
              const SizedBox(height: 24),
              // Қосымшаның тілін ауыстыру
              Center(
                  child: DropdownButton<Language>(
                iconSize: 30,
                hint: Text(translation(context).selectLanguage, style: const TextStyle(fontSize: 18)),
                onChanged: (Language? language) async {
                  if (language != null) {
                    Locale _locale = await setLocale(language.languageCode);
                    MyApp.setLocale(context, _locale);
                  }
                },
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>(
                      (e) => DropdownMenuItem<Language>(
                        value: e,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              e.flag,
                              style: const TextStyle(fontSize: 30),
                            ),
                            Text(e.name)
                          ],
                        ),
                      ),
                    )
                    .toList(),
              )),
               const Spacer(),
              // Аккаунтын жою түймесі
              ElevatedButton.icon(
                icon: const Icon(Icons.delete_forever),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(translation(context).deleteAccount),
                      content: Text(translation(context)
                          .areYouSureYouWantToDeleteYourAccountPermanently),
                      actions: <Widget>[
                        TextButton(
                          child: Text(translation(context).cancel),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: Text(translation(context).delete),
                          onPressed: () {
                            Navigator.of(context).pop();
                            deleteAccount();
                          },
                        ),
                      ],
                    ),
                  );
                },
                label: Text(translation(context).deleteAccount),
              ),
              SizedBox(height: 9),
            ],
          );
        },
      ),
    );
  }
}

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(
        bottom: 15,
        left: 15,
      ),
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            sectionName,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.settings,
              color: Colors.grey[400],
            ),
          ),
        ]),
        Text(text, style: const TextStyle(fontSize: 18)),
      ]),
    );
  }
}
