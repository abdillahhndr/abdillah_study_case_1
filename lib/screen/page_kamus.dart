// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kamusapp/model/model_word.dart';
import 'package:kamusapp/screen/page_detail.dart';
import 'package:kamusapp/util/url.dart';

class PageKamus extends StatefulWidget {
  const PageKamus({super.key});

  @override
  State<PageKamus> createState() => _PageKamusState();
}

class _PageKamusState extends State<PageKamus> {
  bool isCari = false;
  bool isLoading = true;
  List<String> filterData = [];
  List<ModelWord> listKamus = [];
  TextEditingController txtcari = TextEditingController();

  _PageKamusState() {
    txtcari.addListener(() {
      if (txtcari.text.isEmpty) {
        setState(() {
          isCari = true;
          txtcari.text = '';
        });
      } else {
        setState(() {
          isCari = false;
          txtcari.text != "";
        });
      }
    });
  }
  Future getKamus() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.get(Uri.parse('$url/getlistkskt.php'));
      var data = jsonDecode(res.body);
      setState(() {
        for (Map<String, dynamic> i in data) {
          listKamus.add(ModelWord.fromJson(i));
        }
      });
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKamus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: Icon(Icons.person_2_rounded),
      // ),
      body: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 33, 72, 243),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  "lib/assets/tutwur.png",
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Kamus Besar Bahasa Indonesia",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: txtcari,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(Icons.search, size: 20),
                      ),
                      hintText: "Search",
                      hintStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.blue.shade100,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          isCari
              ? Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 33, 72, 243),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        child: ListView.builder(
                            itemCount: listKamus.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    ModelWord? data = listKamus[index];
                                    ;
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: Duration(
                                            seconds:
                                                0), // Set duration to 0 to disable animation
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return PageDetail(data);
                                        },
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: EdgeInsets.all(12),
                                    shape: Border(bottom: BorderSide(width: 1)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: ListTile(
                                        trailing: Icon(
                                          Icons.more,
                                          color: Colors.black26,
                                        ),
                                        title: Text(
                                          '${listKamus[index].word}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                            "${listKamus[index].arti}",
                                            style: TextStyle(fontSize: 14),
                                            maxLines: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                )
              : createFilterList()
        ],
      ),
    );
  }

  Widget createFilterList() {
    filterData = [];
    for (int i = 0; i < listKamus.length; i++) {
      var item = listKamus[i];
      if (item.word.toLowerCase().contains(txtcari.text.toLowerCase())) {
        filterData.add(item.word);
      }
    }
    return HasilSearch();
  }

  Widget HasilSearch() {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 33, 72, 243),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: ListView.builder(
              itemCount: filterData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: () {
                      ModelWord? data = listKamus.firstWhere(
                        (element) => element.word == filterData[index],
                      );
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(
                              seconds:
                                  0), // Set duration to 0 to disable animation
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return PageDetail(data);
                          },
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(0),
                      shape: Border(bottom: BorderSide(width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          trailing: Icon(
                            Icons.more,
                            color: Colors.black26,
                          ),
                          title: Text(
                            "${filterData[index]}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${listKamus[index].arti}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    ));
  }
}
