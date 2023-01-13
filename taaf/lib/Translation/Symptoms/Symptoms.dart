class Symptoms {
  String? nameEn;
  String? nameAr;

  Symptoms({this.nameEn, this.nameAr});

  Symptoms.fromJson(Map<String, dynamic> json) {
    nameEn = json['NameEn'];
    nameAr = json['NameAr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NameEn'] = this.nameEn;
    data['NameAr'] = this.nameAr;
    return data;
  }
}