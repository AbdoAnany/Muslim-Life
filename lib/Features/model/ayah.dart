import 'dart:convert';

import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class Ayah {
  @HiveField(0)
  final num? numberInSurah;
  @HiveField(1)
  final String? text;
  @HiveField(2)
  final num? juz;
  @HiveField(4)
  final num? page;
  @HiveField(5)
  final num? hizbQuarter;
  // @HiveField(6)
  // final num? number;

  // @HiveField(7)
  // final num? ruku;

  // @HiveField(8)
  // final bool? sajda;
 // @HiveField(9)
 // final num? manzil;
  Ayah({
   // this.number,
    this.text,
    this.numberInSurah,
    this.page,
    this.juz,
 //   this.ruku,
    this.hizbQuarter,
  //  this.sajda,
  //  this.manzil,
  });

  Ayah copyWith({
   // num? number,
    String? text,
    num? numberInSurah,
    num? hizbQuarter,
    num? page,
    num? juz,
  //  num? ruku,
  //  bool? sajda,
  //  num? manzil,
  }) {
    return Ayah(
    //  number: number ?? number,
      text: text ?? text,
      numberInSurah: numberInSurah ?? numberInSurah,
      hizbQuarter: hizbQuarter ?? hizbQuarter,
      page: page ?? page,
      juz: juz ?? juz,
    //  ruku: ruku ?? ruku,
    //  sajda: sajda ?? sajda,
   //   manzil: manzil ?? manzil,
    );
  }

  Ayah merge(Ayah model) {
    return Ayah(
   //   number: model.number ?? number,
      text: model.text ?? text,
      numberInSurah: model.numberInSurah ?? numberInSurah,
      hizbQuarter: model.hizbQuarter ?? hizbQuarter,
      page: model.page ?? page,
      juz: model.juz ?? juz,
    //  ruku: model.ruku ?? ruku,
    //  sajda: model.sajda ?? sajda,
   //   manzil: model.manzil ?? manzil,
    );
  }

  Map<String, dynamic> toMap() {
    return {
   //   'number': number,
      'text': text,
      "numberInSurah": numberInSurah,
      "juz": juz,
     // "manzil": manzil,
      "page": page,
    //  "ruku": ruku,
      "hizbQuarter": hizbQuarter,
   //   "sajda": sajda
    };
  }

  factory Ayah.fromMap(Map<String, dynamic> map) {

    return Ayah(
   //   number: map['number'],
      numberInSurah: map['numberInSurah'],
      hizbQuarter: map['hizbQuarter'],
      page: map['page'],
      juz: map['juz'],
 //    ruku: map['ruku'],
  //    sajda: map['sajda'],
   //   manzil: map['manzil'],
      text: map['text'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Ayah.fromJson(String source) => Ayah.fromMap(json.decode(source));

  @override
  String toString() =>
      'Ayah('
        //  'number: $number,'
          ' text: $text,'
         // 'manzil: $manzil,'
        //  ' sajda: $sajda,'
        //  'ruku: $ruku,'
          ' juz: $juz,'
          'page: $page,'
          ' hizbQuarter: $hizbQuarter,'
          ' numberInSurah: $numberInSurah)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ayah &&
        //other.number == number &&
        other.text == text &&
        other.numberInSurah == numberInSurah &&
        other.juz == juz &&
      //  other.manzil == manzil &&
        other.page == page &&
      //  other.ruku == ruku &&
      //  other.sajda == sajda &&
        other.hizbQuarter == hizbQuarter;
  }

  @override
  int get hashCode =>
    //  number.hashCode ^
      text.hashCode ^
      hizbQuarter.hashCode ^
   //   ruku.hashCode ^
      page.hashCode ^
  //    manzil.hashCode ^
      juz.hashCode ^
   //   sajda.hashCode ^
      numberInSurah.hashCode;
}
