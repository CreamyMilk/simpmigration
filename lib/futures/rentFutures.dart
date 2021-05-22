import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:simpmigration/constants.dart';
import 'package:simpmigration/model/payment_update.dart';

Future updateRent() async {
  PaymentUpdateModel data;
  final userHiveBox = Hive.box(Constants.HiveBoxName);
  var userID = userHiveBox.get(Constants.UserIDStore, defaultValue: "no");
  final response = await post(
    ("http://92.222.201.138:9003/" + "getnewtrans"),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    },
    body: jsonEncode(
      {
        'uid': userID, //mobile,
      },
    ),
  );
  var myjson = json.decode(response.body);
  data = PaymentUpdateModel.fromJson(myjson);
  var transactions = data.transaction.toJson();
  var rent = data.rent.toJson();
  userHiveBox.put(Constants.RentPayableStore, jsonEncode(rent));
  userHiveBox.put(Constants.TransactionStore, jsonEncode(transactions));
  print("Transactions Added by a push notification");
}
