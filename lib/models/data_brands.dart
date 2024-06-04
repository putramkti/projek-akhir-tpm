class DataBrands {
  bool? status;
  List<Data>? data;

  DataBrands({this.status, this.data});

  DataBrands.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? brandId;
  String? brandName;
  String? brandSlug;
  int? deviceCount;
  String? detail;

  Data({this.brandId, this.brandName, this.brandSlug, this.deviceCount, this.detail});

  Data.fromJson(Map<String, dynamic> json) {
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    brandSlug = json['brand_slug'];
    deviceCount = json['device_count'];
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['brand_id'] = brandId;
    data['brand_name'] = brandName;
    data['brand_slug'] = brandSlug;
    data['device_count'] = deviceCount;
    data['detail'] = detail;
    return data;
  }
}
