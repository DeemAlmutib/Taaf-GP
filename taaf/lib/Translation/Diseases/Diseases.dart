class Diseases {
  String? name;
  String? nameAr;
  String? description;
  String? descriptionAr;
  String? advice1;
  String? advice1Ar;
  String? advice2;
  String? advice2Ar;
  String? advice3;
  String? advice3Ar;
  String? advice4;
  String? advice4Ar;

  Diseases(
      {this.name,
      this.nameAr,
      this.description,
      this.descriptionAr,
      this.advice1,
      this.advice1Ar,
      this.advice2,
      this.advice2Ar,
      this.advice3,
      this.advice3Ar,
      this.advice4,
      this.advice4Ar});

  Diseases.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    nameAr = json['NameAr'];
    description = json['Description'];
    descriptionAr = json['DescriptionAr'];
    advice1 = json['Advice1'];
    advice1Ar = json['Advice1Ar'];
    advice2 = json['Advice2'];
    advice2Ar = json['Advice2Ar'];
    advice3 = json['Advice3'];
    advice3Ar = json['Advice3Ar'];
    advice4 = json['Advice4'];
    advice4Ar = json['Advice4Ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['NameAr'] = this.nameAr;
    data['Description'] = this.description;
    data['DescriptionAr'] = this.descriptionAr;
    data['Advice1'] = this.advice1;
    data['Advice1Ar'] = this.advice1Ar;
    data['Advice2'] = this.advice2;
    data['Advice2Ar'] = this.advice2Ar;
    data['Advice3'] = this.advice3;
    data['Advice3Ar'] = this.advice3Ar;
    data['Advice4'] = this.advice4;
    data['Advice4Ar'] = this.advice4Ar;
    return data;
  }
}