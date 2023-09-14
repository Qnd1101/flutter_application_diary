import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';

class AddPage extends StatefulWidget {
  final Directory? directory; // 변경: directory 정보를 받도록 수정
  const AddPage({super.key, this.directory});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 작성'),
        centerTitle: true,
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextFormField(
                controller: controllers[0],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '제목', // label을 labelText로 수정
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: TextFormField(
                  controller: controllers[1],
                  maxLength: 500,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '내용', // label을 labelText로 수정
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var result = await fileSave(); // 저장이 잘 되었다면 T, 안되었다면 F
                  if (result == true) {
                    Navigator.pop(context, 'ok');
                  } else {
                    print('저장 실패입니다.');
                  }
                },
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> fileSave() async {
    try {
      File file = await getDiaryFile(); // 파일 이름을 생성하는 함수 호출
      List<dynamic> dataList = [];

      var data = {
        'date': DateFormat('yyyy-MM-dd')
            .format(DateTime.now()), // DateFormat을 사용하려면 import 필요
        'title': controllers[0].text,
        'contents': controllers[1].text,
      };

      if (file.existsSync()) {
        var fileContents = await file.readAsString();
        dataList = jsonDecode(fileContents) as List<dynamic>;
      }

      dataList.add(data);
      var jsondata = jsonEncode(dataList);
      await file.writeAsString(jsondata);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<File> getDiaryFile() async {
    if (widget.directory != null) {
      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String fileName = 'diary_$date.json';
      String filePath = '${widget.directory!.path}/$fileName';
      return File(filePath);
    } else {
      throw Exception('Directory is null');
    }
  }
}
