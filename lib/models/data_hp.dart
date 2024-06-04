class DataHP {
  bool? status;
  Data? data;

  DataHP({this.status, this.data});

  DataHP.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? title;
  List<Phone>? phones;

  Data({this.title, this.phones});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['phones'] != null) {
      phones = <Phone>[];
      json['phones'].forEach((v) {
        phones!.add(new Phone.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.phones != null) {
      data['phones'] = this.phones!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Phone {
  String? phoneName;
  String? slug;
  String? image;
  String? detail;

  Phone({this.phoneName, this.slug, this.image, this.detail});

  Phone.fromJson(Map<String, dynamic> json) {
    phoneName = json['phone_name'];
    slug = json['slug'];
    image = json['image'];
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone_name'] = this.phoneName;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['detail'] = this.detail;
    return data;
  }
}
