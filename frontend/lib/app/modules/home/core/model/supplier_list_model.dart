class Supplier {
  String? name;
  String? logo;
  String? state;
  double? costPerKwh;
  int? minimumKwhLimit;
  int? totalNumberOfCustomers;
  double? averageRating;

  Supplier({
     this.name,
     this.logo,
     this.state,
     this.costPerKwh,
     this.minimumKwhLimit,
     this.totalNumberOfCustomers,
     this.averageRating,
  });

  Supplier.fromJson(Map<String, dynamic> json){
        name = json['name'] ?? '';
        logo = json['logo'] ?? '';
        state = json['state'] ?? '';
        costPerKwh = (json['cost_per_kwh'] as num?)?.toDouble() ?? 0.0;
        minimumKwhLimit = json['minimum_kwh_limit'] ?? 0;
        totalNumberOfCustomers = json['total_number_of_customers'] ?? 0;
        averageRating = (json['average_rating'] as num?)?.toDouble() ?? 0.0; 
}

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logo,
      'state': state,
      'cost_per_kwh': costPerKwh,
      'minimum_kwh_limit': minimumKwhLimit,
      'total_number_of_customers': totalNumberOfCustomers,
      'average_rating': averageRating,
    };
  }
}

class BedList {
  String? detail;
  bool? status;
  List<Supplier>? data;

  BedList({this.detail, this.status, this.data});

  BedList.fromJson(List<dynamic> json) {
    data = <Supplier>[];
    for (var v in json) {
        data!.add(Supplier.fromJson(v));
      }
    status = true;

  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['msg'] = detail;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}