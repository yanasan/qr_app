import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/model/history.dart';
import 'package:qr_app/model/history_page_model.dart';
import 'package:qr_app/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HistoryModel>(
      create: (_) => HistoryModel()..fetchHistory(),
      child: Scaffold(
        backgroundColor: Colors.yellow[100],
        appBar: AppBar(
          title: const Text('履歴'),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('QR').doc().delete();
              },
              icon: Icon(Icons.delete_outline),
            ),
          ],
        ),
        body: Consumer<HistoryModel>(
          builder: ((context, model, child) {
            final historys = model.historys;
            print(historys.length);

            return ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: 125,
                    margin: const EdgeInsets.only(right: 30, left: 30),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(5, 5))
                      ],
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _historyList(
                            'url',
                            historys[index].url,
                          ),
                          _QRPageButton(
                            'サイトを開く',
                            historys[index].url,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: historys.length,
            );
          }),
        ),
      ),
    );
  }

  _QRPageButton(String title, btntext) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(
          btntext,
        );
        if (await canLaunchUrl(url)) {
          launchUrl(url);
        } else {
          // ignore: avoid_print
          print("Can't launch $url");
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 50, left: 50),
        width: double.infinity,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.blue[400],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _historyList(String title, title2) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Container(
          //   decoration: const BoxDecoration(
          //     border: Border(
          //       bottom: BorderSide(
          //         color: Colors.white,
          //         width: 3,
          //       ),
          //     ),
          //   ),
          // child:
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          // ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 3,
                ),
              ),
            ),
            child: Text(
              title2,
              style: const TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
