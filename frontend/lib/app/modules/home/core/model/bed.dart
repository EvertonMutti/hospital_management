class BedModel {
  int? id;
  String? name;
  BedStatus? status;

  BedModel({this.id, this.name, this.status});

  // Construtor para criar o modelo a partir de um JSON
  BedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['nome'];
    status = BedStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['status'],
      orElse: () => BedStatus.LIVRE,
    );
  }

  // Método para converter o modelo em JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = name;
    data['status'] = status?.toString().split('.').last; // Converte enum para string
    return data;
  }

  void updateStatus(BedStatus newStatus) {
    if (status == BedStatus.LIVRE || newStatus == BedStatus.LIVRE) {
      status = newStatus;
    }
  }
  
}

enum BedStatus {
  LIVRE,
  OCUPADO,
  MANUTENCAO,
  EM_LIMPEZA,
  NECESSARIO_LIMPEZA
}