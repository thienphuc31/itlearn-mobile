class Itemmaster {
  Itemmaster({
    required this.id,
    required this.locationName,
    required this.quantity,
    required this.recieveNo,
    required this.dateImport,
    required this.note,
    required this.qcAcceptQuantity,
    required this.qcInjectQuantity,
    required this.qcBy,
    required this.idImport,
    required this.itemName,
    required this.codeItemdata,
    required this.supplierName,
    required this.image,
    required this.disable,
    required this.pass,});

  factory Itemmaster.fromJson(Map<String, dynamic> json) {
    return Itemmaster(
      id: json['id'],
      locationName : json['locationName'],
      quantity : json['quantity'],
      recieveNo : json['recieveNo'],
      dateImport : json['dateImport'],
      note : json['note'],
      qcAcceptQuantity : json['qcAcceptQuantity'],
      qcInjectQuantity : json['qcInjectQuantity'],
      qcBy : json['qcBy'],
      idImport : json['idImport'],
      itemName : json['itemName'],
      codeItemdata : json['codeItemdata'],
      supplierName : json['supplierName'],
      image : json['image'],
      disable : json['disable'],
      pass : json['pass'],
    );
  }

  int id;
  String locationName;
  double quantity;
  String recieveNo;
  String dateImport;
  String note;
  double qcAcceptQuantity;
  double qcInjectQuantity;
  String qcBy;
  int idImport;
  String itemName;
  String codeItemdata;
  String supplierName;
  String image;
  bool disable;
  bool pass;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['locationName'] = locationName;
    map['quantity'] = quantity;
    map['recieveNo'] = recieveNo;
    map['dateImport'] = dateImport;
    map['note'] = note;
    map['qcAcceptQuantity'] = qcAcceptQuantity;
    map['qcInjectQuantity'] = qcInjectQuantity;
    map['qcBy'] = qcBy;
    map['idImport'] = idImport;
    map['itemName'] = itemName;
    map['codeItemdata'] = codeItemdata;
    map['supplierName'] = supplierName;
    map['image'] = image;
    map['disable'] = disable;
    map['pass'] = pass;
    return map;
  }

}