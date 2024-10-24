class BedModel {
  int? id;
  String? bedNumber;
  int? sectorId;
  BedStatus? status;

  BedModel({this.id, this.bedNumber, this.sectorId, this.status});

  BedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bedNumber = json['bed_number'];
    sectorId = json['sector_id'];
    status = BedStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['status'],
      orElse: () => BedStatus.FREE,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bed_number'] = bedNumber;
    data['sector_id'] = sectorId;
    data['status'] = status?.toString().split('.').last;
    return data;
  }

  void updateStatus(BedStatus newStatus) {
    if (status == BedStatus.FREE || newStatus == BedStatus.FREE) {
      status = newStatus;
    }
  }

  static String _translateStatus(BedStatus status) {
    switch (status) {
      case BedStatus.OCCUPIED:
        return "OCUPADO";
      case BedStatus.FREE:
        return "LIVRE";
      case BedStatus.MAINTENANCE:
        return "MANUNTENÇÃO";
      case BedStatus.CLEANING:
        return "EM LIMPEZA";
      case BedStatus.CLEANING_REQUIRED:
        return "NECESSÁRIO LIMPEZA";
      default:
        return "LIVRE";
    }
  }
}

class SectorModel {
  String? sectorName;
  List<BedModel>? beds;
  

  SectorModel({this.sectorName, this.beds});

  SectorModel.fromJson(Map<String, dynamic> json) {
    sectorName = json['sector_name'];
    if (json['beds'] != null) {
      beds = <BedModel>[];
      json['beds'].forEach((v) {
        beds!.add(BedModel.fromJson(v));
      });
    }
  }
}


class ListSectorModel {
  List<SectorModel>? data;
  bool? status;
  String? detail;

  ListSectorModel({this.data, this.status, this.detail});

  ListSectorModel.fromJson(List<dynamic> json) {
    data = <SectorModel>[];
    for (var item in json) {
      data!.add(SectorModel.fromJson(item));
    }
    status = true;
  }
}

enum BedStatus {
  FREE,
  OCCUPIED,
  MAINTENANCE,
  CLEANING,
  CLEANING_REQUIRED
}



class CountBed {
  int? free;
  int? occupied;
  int? maintenance;
  int? cleaning;
  int? cleaningRequired;
  bool? status;

  CountBed(
      {this.free,
      this.occupied,
      this.maintenance,
      this.cleaning,
      this.cleaningRequired,
      this.status,
      });

  CountBed.fromJson(Map<String, dynamic> json) {
    free = json['FREE'];
    occupied = json['OCCUPIED'];
    maintenance = json['MAINTENANCE'];
    cleaning = json['CLEANING'];
    cleaningRequired = json['CLEANING_REQUIRED'];
    status = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FREE'] = free;
    data['OCCUPIED'] = occupied;
    data['MAINTENANCE'] = maintenance;
    data['CLEANING'] = cleaning;
    data['CLEANING_REQUIRED'] = cleaningRequired;
    return data;
  }
}