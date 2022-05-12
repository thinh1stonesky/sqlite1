
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite1/page_home.dart';
import 'package:sqlite1/provider_data.dart';
import 'package:sqlite1/sqlite_data.dart';

class PageUserDetail extends StatefulWidget {
  PageUserDetail({Key? key, this.xem, this.user}) : super(key: key);
  bool? xem;
  User? user;
  @override
  State<PageUserDetail> createState() => _PageUserDetailState();
}

class _PageUserDetailState extends State<PageUserDetail> {
  bool? xem;
  User? user;
  String title = "Thông tin User";
  String buttonTitle = "Đóng";

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    xem = widget.xem;
    user = widget.user;
    if(user != null) {
      if (xem != true) {
        buttonTitle = "Câp nhật";
        title = "Chỉnh sửa thông tin";
      }
      nameCtrl.text = user!.name!;
      phoneCtrl.text = user!.phone!;
      emailCtrl.text = user!.email!;
    }
    else{
      title = "Thêm";
      buttonTitle = "Thêm User";
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("detail")
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                label: Text("Tên:"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(
                label: Text("SDT:"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                label: Text("Email:"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () => _capNhat(context),
                    child: Text(buttonTitle)),
                const SizedBox(
                  height: 10,
                ),

                xem == true
                    ? const SizedBox(width: 10,)
                    : ElevatedButton(onPressed: (){
                      Navigator.of(context).pop();},
                    child: const Text("Đóng"))
              ],
            )
          ],
        ),
      ),
    );
  }
  _capNhat(BuildContext context) async {
    DatabaseProvider provider = context.read<DatabaseProvider>();
    User nUser = User(name: nameCtrl.text, phone: phoneCtrl.text, email: emailCtrl.text );
    if(xem == true) {
      Navigator.of(context).pop();
    } else
      if(user == null)
      {
        int id = -1;
        id = await provider.insertUser(nUser);
        if(id >0){
          showSnackBar(context, "Đã thêm ${nUser.name}", 3);
        }
        else{
          showSnackBar(context, "Thêm ${nUser.name} không thành công", 3);
        }
      }
      else{
        int count = 0;
        count = await provider.updateUser(nUser, user!.id!);
        if(count > 0){
          showSnackBar(context, "Đã cập nhật ${user!.name}", 3);
        }
        else{
          showSnackBar(context, "Cập nhật ${user!.name} không thành công", 3);
        }
      }
  }
}


