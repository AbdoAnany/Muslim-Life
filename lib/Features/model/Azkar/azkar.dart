class AzkarModel {
  List<AzkarCategoryNew>? azkar;

  AzkarModel({this.azkar});

  AzkarModel.fromJson(Map<String, dynamic> json) {
    if (json['Azkar'] != null) {
      azkar = <AzkarCategoryNew>[];
      json['Azkar'].forEach((v) {
        azkar!.add(new AzkarCategoryNew.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.azkar != null) {
      data['Azkar'] = this.azkar!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AzkarCategoryNew {
  int? id;
  late int currentIndex;
  String? category;
  String? audio;
  String? filename;
  List<AzkarItemNew>? array;

  AzkarCategoryNew({this.id, this.category, this.currentIndex=0,this.audio, this.filename, this.array});

  AzkarCategoryNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    audio = json['audio'];
    currentIndex = json['currentIndex']??0;
    filename = json['filename'];
    if (json['array'] != null) {
      array = <AzkarItemNew>[];
      json['array'].forEach((v) {
        array!.add(new AzkarItemNew.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['audio'] = this.audio;
    data['currentIndex'] = this.currentIndex;
    data['filename'] = this.filename;
    if (this.array != null) {
      data['array'] = this.array!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AzkarItemNew {
  int? id;
  String? text;
  int? count;
 late int currentCount;
  String? audio;
  String? filename;

  AzkarItemNew({this.id, this.text, this.count, this.currentCount=0, this.audio, this.filename});

  AzkarItemNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    count = json['count'];
    currentCount = json['currentCount']??0;
    audio = json['audio'];
    filename = json['filename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['count'] = this.count;
    data['currentCount'] = this.currentCount;
    data['audio'] = this.audio;
    data['filename'] = this.filename;
    return data;
  }
}
