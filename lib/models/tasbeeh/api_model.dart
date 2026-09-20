enum AppModel {
  radioList,
  quran,
  zeker,
  hades,
  doaaInQuran,
  firstInIslam,
  azkarElyome,
  hisnMuslim,
  islamEvents,
  convertDate,
  about,
  prayer,
  qibla,
  sibha,
  quranReader,
  bookmarks,
  unDefined,
}

enum ApiType { unDefined, open }

enum ApiSubType {
  unDefined,
  open,
  Open_list,
  Open_view,
  Open_url,
  Open_about,
  Zeker,
  Open_list_db,
  Open_sound,
  Open_radio_list,
}

enum ApiReadFrom { api, database, unDefined }

class ApiModel {
  ApiModel();

  late String itemId;
  String title = '';
  late String photo;
  String? url;
  String html = '';
  String description = '';
  late ApiType type;
  late ApiSubType subtype;
  ApiReadFrom? readFrom;
  late AppModel appModel;

  static ApiModel home({
    required String itemId,
    required String title,
    required String photo,
    String? url,
    required ApiSubType subtype,
    required AppModel appModel,
    ApiReadFrom? readFrom,
  }) {
    final m = ApiModel();
    m.itemId = itemId;
    m.title = title;
    m.photo = photo;
    m.url = url;
    m.type = ApiType.open;
    m.subtype = subtype;
    m.appModel = appModel;
    m.readFrom = readFrom;
    return m;
  }

  factory ApiModel.fromPortableJson(Map<String, dynamic> map) {
    final m = ApiModel();
    m.itemId = map['itemId']?.toString() ?? '';
    m.title = map['title']?.toString() ?? '';
    m.html = map['html']?.toString() ?? '';
    m.description = map['description']?.toString() ?? '';
    m.type = ApiType.open;
    m.subtype = ApiSubType.Open_view;
    m.readFrom = ApiReadFrom.database;
    m.appModel = AppModel.unDefined;
    m.photo = '';
    return m;
  }
}
