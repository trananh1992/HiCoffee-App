import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

import 'package:hicoffee/model/item_model.dart';

import 'package:hicoffee/sqlite/database_helper.dart';


class RequestsProvider extends ChangeNotifier{

  /// Avale app too main RequestsProvider() seda zade mishe , va
  /// in 2 ta function ejra mishan (faghat nmidonm chera 2 bar ejrash mikone :D)
  RequestsProvider() {
    // Use the local db
    selectAll();
    // Get data from server
    requestItems();
  }

  // Tarif avalie
  List<Item> _items = [];

  // Har vaght items ro khast _items ro behesh midam (getter)
  List get items => _items;

  // age chizi behem pas dad , mirizam to _items (setter)
  set items(List<Item> list){
    _items = list;
    notifyListeners();
  }

  // Select Token
  Future<String> selectToken()async{
    var result = await DatabaseHelper().selectToken();
    return result[0]['Token'];
  }

  // Select * kon va beriz too items
  void selectAll()async{
    var result = await DatabaseHelper().selectItems();
    print("* selectAll Result: $result");
    items = result.map((m) => Item.fromMap(m)).toList();
  }

  // Req bede va briz too items , Age req 200 bood --> insert kon too db
  void requestItems() async{
    try{
      Map<String, String> reqHeader = {"Authorization": "Token ${await selectToken()}"};
      Response response = await get("http://al1.best:86/api/show-all/", headers:reqHeader);
      print("response: ${response.statusCode}");
      List<dynamic> data = await jsonDecode(utf8.decode(response.bodyBytes));
      print("data: $data");
      // Serialize data
      items = data.map((m) => Item.fromJson(m)).toList();
      print("items: $items");
      // Add the items in local db
      if (response.statusCode == 200){
        var result = await DatabaseHelper().insertItems(items);
        print("*Insers db Result: $result");
      }
    }on Exception{
      print("** Try Again To Send Get Request");
      Future.delayed(const Duration(seconds: 5), () {
        requestItems();
      });
    }
  }


  // add items to server
  Future<int> reqAddItem(Item item) async{
    Map<String, dynamic> reqBody = item.toJson();
    String jsonBody = jsonEncode(reqBody);
    Map<String, String> reqHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Token ${await selectToken()}"
    };
    Response response = await post("http://al1.best:86/api/add/", body:jsonBody, headers:reqHeader);
    if(response.statusCode == 200){
      // Add to local db
      var result = await DatabaseHelper().insertItem(item);
      print("Insert db Result: $result");
      // Update the provider
      _items.add(item);
      notifyListeners();
    }else{
      print("Error In Add Item");
    }
    return response.statusCode;
  }

  // delete item from server
  Future<int> reqDeleteItem(Item item) async{
    Map<String, String> reqHeader = {"Authorization": "Token ${await selectToken()}"};
    Response response = await delete("http://al1.best:86/api/delete/${item.name}", headers:reqHeader);
    print(response.body);
    print(response.statusCode);
    if(response.statusCode == 200){
      // Delete from local db
      var result = await DatabaseHelper().deleteItem(item);
      print("Delete db Result: $result");
      // Update the provider
      _items.remove(item);
      notifyListeners();
    }
    return response.statusCode;
  }


  Future<int> reqSellItem(Item item, int sellValue) async{
    Item newItem = Item(item.name, sellValue);
    Map<String, dynamic> reqBody = newItem.toJson();
    String jsonBody = jsonEncode(reqBody);
    print(jsonBody);
    Map<String, String> reqHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Token ${await selectToken()}"
    };
    Response response = await post("http://al1.best:86/api/sell/", body:jsonBody, headers:reqHeader);
    if(response.statusCode == 200){
      // Update the local db
      var result = await DatabaseHelper().updateItem(item, sellValue);
      print("Sell db Result: $result");
      // Update the provider
      for(int i=0 ; i<_items.length ; i++){
        if (_items[i].name == item.name)
          _items[i].number = _items[i].number - sellValue;
      }
      notifyListeners();
    }
    return response.statusCode;
  }


  Future<int> reqEditItem(String oldName, String newName, int newNumber) async{
    var reqBody = Map<String, dynamic>();
    reqBody['old_name'] = oldName;
    reqBody['number'] = newNumber;
    if(newName != oldName)
      reqBody['name'] = newName;
    String jsonBody = jsonEncode(reqBody);
    print(jsonBody);
    Map<String, String> reqHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Token ${await selectToken()}"
    };
    Response response = await put("http://al1.best:86/api/edit/", body:jsonBody, headers: reqHeader);
    if(response.statusCode == 202){
      // Update the local db
      var result = await DatabaseHelper().editItem(oldName, newName, newNumber);
      print("Edit db Result: $result");
      // Update the provider
      for(int i=0 ; i<_items.length ; i++){
        if (_items[i].name == oldName){
          _items[i].name    = newName;
          _items[i].number  = newNumber;
        }
      }
      notifyListeners();
    }
    return response.statusCode;
  }
}