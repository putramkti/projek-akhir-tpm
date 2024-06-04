class DataDetailHP {
  bool? status;
  Data? data;

  DataDetailHP({this.status, this.data});

  DataDetailHP.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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
  String? brand;
  String? phoneName;
  String? thumbnail;
  List<String>? phoneImages;
  String? releaseDate;
  String? dimension;
  String? os;
  String? storage;
  List<Specification>? specifications;

  Data({
    this.brand,
    this.phoneName,
    this.thumbnail,
    this.phoneImages,
    this.releaseDate,
    this.dimension,
    this.os,
    this.storage,
    this.specifications,
  });

  Data.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    phoneName = json['phone_name'];
    thumbnail = json['thumbnail'];
    phoneImages = json['phone_images'] != null
        ? List<String>.from(json['phone_images'])
        : null;
    releaseDate = json['release_date'];
    dimension = json['dimension'];
    os = json['os'];
    storage = json['storage'];
    if (json['specifications'] != null) {
      specifications = <Specification>[];
      json['specifications'].forEach((v) {
        specifications!.add(Specification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand'] = this.brand;
    data['phone_name'] = this.phoneName;
    data['thumbnail'] = this.thumbnail;
    data['phone_images'] = this.phoneImages;
    data['release_date'] = this.releaseDate;
    data['dimension'] = this.dimension;
    data['os'] = this.os;
    data['storage'] = this.storage;
    if (this.specifications != null) {
      data['specifications'] =
          this.specifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Specification {
  String? title;
  List<Spec>? specs;

  Specification({this.title, this.specs});

  Specification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['specs'] != null) {
      specs = <Spec>[];
      json['specs'].forEach((v) {
        specs!.add(Spec.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.specs != null) {
      data['specs'] = this.specs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Spec {
  String? key;
  List<String>? val;

  Spec({this.key, this.val});

  Spec.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    val = json['val'] != null ? List<String>.from(json['val']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['val'] = this.val;
    return data;
  }
}
