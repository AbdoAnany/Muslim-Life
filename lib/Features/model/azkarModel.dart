
class Azkar {
  List<AzkarCategory> azkarCategoryList = [];

  Azkar.fromJson(Map<String, dynamic> json) {
    if (json['Azkar'] != null) {
      azkarCategoryList = [];
      json['Azkar'].forEach((v) {
        azkarCategoryList.add(AzkarCategory.fromJson(v));
      });
    }
  }
}
class AzkarCategory {
  String? category='';
  int? count=0;
  List<AzkarData>? azkarList = [];

  AzkarCategory(
      {this.category, this.count,this.azkarList});

  AzkarCategory.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    count = azkarList!.length;
    json['AzkarList'].forEach((element) {
      azkarList!.add(AzkarData.fromJson(element));
    });



  }
}

class AzkarData {
  String? category;
  String? count;
  String? description;
  String? reference;
  String? zekr;

  AzkarData(
      {this.category, this.count, this.description, this.reference, this.zekr});

  AzkarData.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    count = json['count'];
    description = json['description'];
    reference = json['reference'];
    zekr = json['zekr'];
  }
}
