import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore/services/firebase_service.dart';
import 'package:firestore/user/user_data.dart';
import 'package:firestore/user/user_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  FirebaseService firebaseService = new FirebaseService();

  TextEditingController nama = TextEditingController();
  TextEditingController umur = TextEditingController();
  TextEditingController email = TextEditingController();

  List<UserData> daftarUser = [
    UserData("idris", 34, "idrez.mochamad@gmail.com"),
    UserData("adi", 24, "adi@gmail.com"),
    UserData("rizal", 33, "rizal.mochamad@gmail.com"),
  ];

  Color btnSimpanColorDefault = Colors.blue;
  Color btnSimpanColor = Colors.blue;
  Color btnUbahColor = Colors.blueGrey;

  String btnSimpanTextDefault = "Simpan";
  String btnSimpanText = "Simpan";
  String btnUbahText = "Ubah";

  bool isReadOnly = false;

  int selectedDaftarUserIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: TextField(
                  controller: nama,
                  readOnly: isReadOnly,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Nama", border: OutlineInputBorder()),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: TextField(
                  controller: umur,
                  readOnly: isReadOnly,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Umur", border: OutlineInputBorder()),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: TextField(
                  controller: email,
                  readOnly: isReadOnly,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Email", border: OutlineInputBorder()),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: ElevatedButton(
                        onPressed: () {
                          try {
                            if (nama.text.isEmpty ||
                                umur.text.isEmpty ||
                                email.text.isEmpty)
                              throw ("Data tidak boleh kosong");

                            if (btnSimpanText == btnSimpanTextDefault) {
                              //Ini menunjukkan Save
                              UserData userData = new UserData(
                                  nama.text, int.parse(umur.text), email.text);
                                  firebaseService.tambah(userData);
                            } else {
                              UserData userdata = daftarUser[selectedDaftarUserIndex];
                              userdata.nama = nama.text;
                              userdata.umur = int.parse(umur.text);
                              userdata.email = email.text;
                              daftarUser[selectedDaftarUserIndex] = userdata;

                              btnSimpanColor = btnSimpanColorDefault;
                              btnSimpanText = btnSimpanTextDefault;
                              setState(() {
                                btnSimpanColor;
                                btnSimpanText;
                              });
                            }

                            setState(() {
                              daftarUser;
                              isReadOnly = false;
                            });

                            nama.text = "";
                            umur.text = "";
                            email.text = "";
                          } catch (e) {
                            Fluttertoast.showToast(msg: '$e');
                          }
                        },
                        child: Text(btnSimpanText),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnSimpanColor,
                          minimumSize: Size(150, 75),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        nama.text = "";
                        umur.text = "";
                        email.text = "";
                        btnSimpanColor = btnSimpanColorDefault;
                        btnSimpanText = btnSimpanTextDefault;
                        isReadOnly = false;
                        setState(() {
                          btnSimpanColor;
                          btnSimpanText;
                          false;
                        });
                      },
                      child: Text("Clear"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          minimumSize: Size(150, 75)),
                    ),
                  )
                ],
              ),
              Divider(
                height: 20,
                thickness: 3,
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: firebaseService.ambilData(),
                builder: (context, snapshot) {
                  return ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        daftarUser;
                        DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        UserData userData = new UserData(
                            documentSnapshot['nama'],
                            documentSnapshot['umur'],
                            documentSnapshot['email']);
                        return Dismissible(
                          key: ValueKey(userData),
                          child: InkWell(
                            child: UserItem(userData),
                            onTap: () {
                              nama.text = userData.nama;
                              umur.text = userData.umur.toString();
                              email.text = userData.email;
                              btnSimpanColor = btnUbahColor;
                              btnSimpanText = btnUbahText;
                              isReadOnly = true;
                              setState(() {
                                btnSimpanColor;
                                btnSimpanText;
                                isReadOnly;
                              });
                              selectedDaftarUserIndex = index;
                            },
                          ),
                          background: Container(
                            padding: EdgeInsets.only(left: 25),
                            color: Colors.red,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          secondaryBackground: Container(
                            color: Colors.white,
                          ),
                          dismissThresholds: {DismissDirection.startToEnd: 0.2},
                          onDismissed: (direction) {
                            firebaseService.hapus(userData);
                          },
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm"),
                                    content: Text(
                                        "Are you sure you wish to delete this item?"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text("Delete")),
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text("Cancel"))
                                    ],
                                  );
                                },
                              );
                            } else {
                              return false;
                            }
                          },
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: snapshot.data!.docs.length);
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
