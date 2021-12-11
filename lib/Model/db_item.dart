import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sApport/Model/Services/collections.dart';

abstract class DbItem {
  /// Get the data of the DBItem as a key-value map
  Map getData();

  /// Set the fields of the DBItem from the [doc]
  void setFromDocument(DocumentSnapshot doc);

  /// Collection of the DBItem
  Collection get collection;
}
