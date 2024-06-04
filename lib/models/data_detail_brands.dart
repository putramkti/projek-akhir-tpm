class DataDetailBrand {
  bool? status;
  Data? data;

  DataDetailBrand({this.status, this.data});

  DataDetailBrand.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? title;
  int? currentPage;
  int? lastPage;
  List<Phone>? phones;

  Data({this.title, this.currentPage, this.lastPage, this.phones});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    if (json['phones'] != null) {
      phones = <Phone>[];
      json['phones'].forEach((v) {
        phones!.add(Phone.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = title;
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    if (phones != null) {
      data['phones'] = phones!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Phone {
  String? brand;
  String? phoneName;
  String? slug;
  String? image;
  String? detail;

  Phone({this.brand, this.phoneName, this.slug, this.image, this.detail});

  Phone.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    phoneName = json['phone_name'];
    slug = json['slug'];
    image = json['image'];
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['brand'] = brand;
    data['phone_name'] = phoneName;
    data['slug'] = slug;
    data['image'] = image;
    data['detail'] = detail;
    return data;
  }
}
