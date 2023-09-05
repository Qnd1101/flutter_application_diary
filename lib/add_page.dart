import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  String filePath;
  AddPage({super.key, required this.filePath});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  // var controller1 = TextEditingController();
  // var controller2 = TextEditingController();
  String filePath = '';
  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filePath = widget.filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filePath),
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
                  label: Text('제목'),
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
                    label: Text('내용'),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  var title = controllers[0].text;
                  print(title);
                  Navigator.pop(context, 'ok');
                },
                child: const Text('저장'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
