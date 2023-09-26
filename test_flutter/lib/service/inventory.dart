import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test_flutter/service/Itemmaster.dart';


class Inventory {
  static String url = "http://192.168.1.11:9999/api/inventory/getdata";

  static Future<List<Itemmaster>> getInventory() async {
    final response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    List<Itemmaster> iList = [];
    for (var c in data) {
      Itemmaster item = Itemmaster(
          id: c['id'],
          locationName: c['locationName'],
          quantity: c['quantity'],
          recieveNo: c['recieveNo'],
          dateImport: c['dateImport'],
          note: c['note'],
          qcAcceptQuantity: c['qcAcceptQuantity'],
          qcInjectQuantity: c['qcInjectQuantity'],
          qcBy: c['qcBy'],
          idImport: c['idImport'],
          itemName: c['itemName'],
          codeItemdata: c['codeItemdata'],
          supplierName: c['supplierName'],
          image: c['image'],
          disable: c['disable'],
          pass: c['pass']);
      iList.add(item);
    }
    return iList;
  }
}