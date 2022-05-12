

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sqlite1/provider_data.dart';
import 'package:sqlite1/user_detail.dart';

import 'sqlite_data.dart';

class PageListUserSQLite extends StatefulWidget {
  const PageListUserSQLite({Key? key}) : super(key: key);

  @override
  State<PageListUserSQLite> createState() => _PageListUserSQLiteState();
}

class _PageListUserSQLiteState extends State<PageListUserSQLite> {

  BuildContext? _dialogContext;

  @override
  void dispose() {
    DatabaseProvider provider = context.read<DatabaseProvider>();
    provider.closeDatabase();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite App"),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PageUserDetail(xem: false,))
                );
              },
              icon: const Icon(Icons.add_circle_outline), color: Colors.white,)
        ],
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, databaseProvider, child) {
          if(databaseProvider.users == null){
            return const Center(child: Text("Chưa có dữ liệu!"));}
          else {
            return ListView.separated(
                separatorBuilder: (context, index) => const Divider(thickness: 1),
                itemCount: databaseProvider.users!.length,
                itemBuilder: (context, index){
                  _dialogContext = context;
                  User user = databaseProvider.users![index];
                  return Slidable(
                      child: ListTile(
                        leading: Text(user.id.toString()),
                        title: Text('${user.name}'),
                        subtitle: Column(
                          children: [
                            Text("Phone: ${user.phone}"),
                            Text("Email: ${user.email}")
                          ],
                        ),
                      ),
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        icon: Icons.details,
                        foregroundColor: Colors.green,
                        backgroundColor: Colors.green[50]!,
                        onPressed: (context){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => PageUserDetail(xem: true, user: user,),)
                          );
                        },
                        ),
                      SlidableAction(
                        icon: Icons.details,
                        foregroundColor: Colors.green,
                        backgroundColor: Colors.green[50]!,
                        onPressed: (context){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => PageUserDetail(xem: true, user: user,),)
                          );
                        },
                      ),
                      SlidableAction(
                        icon: Icons.edit,
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.blue[50]!,
                        onPressed: (context){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => PageUserDetail(xem: false, user: user,),)
                          );
                        },
                      ),
                      SlidableAction(
                        icon: Icons.delete_forever,
                        foregroundColor: Colors.red,
                        backgroundColor: Colors.red[50]!,
                        onPressed: (context){
                          _xoa(_dialogContext!, user);

                        },
                      )
                    ],
                  ),
                  );
                },
            );

          }
        },
      ),
    );
  }
}

_xoa(BuildContext dialogContext, User user) async {
  String? confirm = await showConfirmDialog(dialogContext, "Bạn có muốn xóa ${user.name}");
  if(confirm =="ok"){
    DatabaseProvider provider = dialogContext.read<DatabaseProvider>();
    provider.deleteUser(user.id!);
  }

}

Future<String?> showConfirmDialog(BuildContext context, String dispMessage) async {
  AlertDialog dialog = AlertDialog(
    title: const Text("Xác nhân!"),
    content: Text(dispMessage),
    actions: [
      ElevatedButton(
          onPressed: (){
            Navigator.of(context, rootNavigator: true).pop("cancel");
          },
          child: const Text("Hủy")),
      ElevatedButton(
          onPressed: (){
            Navigator.of(context, rootNavigator: true).pop("ok");
          },
          child: const Text("Xóa!")),
    ],
  );

  String? res = await showDialog<String?>(
    barrierDismissible: false, // bat buoc chon xoa hoac huy
    context: context,
    builder: (BuildContext context) => dialog,
  );
  return res;
}

void showSnackBar(BuildContext context, String message, int second){
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: Duration(seconds: second),)
  );
}
