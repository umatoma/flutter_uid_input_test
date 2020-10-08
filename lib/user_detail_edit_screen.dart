import 'package:flutter/material.dart';

class UserDetailEditParams {
  UserDetailEditParams(this.firstName, this.lastName);

  final firstName;
  final lastName;
}

class UserDetailEditScreen extends StatefulWidget {
  const UserDetailEditScreen({
    Key key,
    @required this.params,
  }) : super(key: key);

  final UserDetailEditParams params;

  @override
  _UserDetailEditScreenState createState() => _UserDetailEditScreenState();
}

class _UserDetailEditScreenState extends State<UserDetailEditScreen> {
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;

  @override
  void initState() {
    _firstNameController = TextEditingController(text: widget.params.firstName);
    _lastNameController = TextEditingController(text: widget.params.lastName);

    // NOTE: 値が入力されたら再描画する
    _firstNameController.addListener(() {
      setState(() => null);
    });
    _lastNameController.addListener(() {
      setState(() => null);
    });

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pinkAccent[100],
              Colors.redAccent[100],
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Text('名前変更'),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('お名前'),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '必須',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: NameTextFormField(
                              controller: _lastNameController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: NameTextFormField(
                              controller: _firstNameController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Container(
                        height: 40,
                        child: RaisedButton(
                          onPressed: _canSubmit() == true
                              ? () => _onSubmit(context)
                              : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.pinkAccent[100],
                                  Colors.redAccent[100],
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                '変更する',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canSubmit() {
    return _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty;
  }

  Future<void> _onSubmit(BuildContext context) async {
    final params = UserDetailEditParams(
      _firstNameController.text,
      _lastNameController.text,
    );
    Navigator.of(context).pop(params);
  }
}

class NameTextFormField extends StatelessWidget {
  const NameTextFormField({
    Key key,
    this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      controller: controller,
    );
  }
}
