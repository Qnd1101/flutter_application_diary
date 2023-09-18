import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  String filePath;
  AddPage({super.key, required this.filePath});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String filepath = '';

  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filepath = widget.filePath;
  }

  Future<bool> fileSave() async {
    try {
      File file = File(filepath);
      List<dynamic> dataList = [];
      var data = {
        'title': controllers[0].text,
        'contents': controllers[1].text
      };
      //기존에 파일이 있는 경우
      if (file.existsSync()) {
        var fileContents = await file.readAsString();
        //[{기존 작성했던 글},{},{}...]=>String err=[][]
        dataList = jsonDecode(fileContents) as List<dynamic>;
      }
      //내가 방금 쓴 글을 추가
      dataList.add(data);
      var jsonData = jsonEncode(dataList);
      var res = await file.writeAsString(jsonData, mode: FileMode.write);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filepath),
        centerTitle: true,
      ),
      body: Form(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: controllers[0],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('제목',
                    style: TextStyle(fontSize: 18, color: Colors.amber)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: TextFormField(
                controller: controllers[1],
                maxLines: 11,
                maxLength: 100,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('내용',
                      style: TextStyle(fontSize: 30, color: Colors.amber)),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var title = controllers[0].text;
                var result = await fileSave(); //T, F
                if (result == true) {
                  Navigator.pop(context, 'ok');
                } else {
                  print('저장실패');
                }
              },
              child: const Text('저장'),
            )
          ],
        ),
      )),
    );
  }
}
