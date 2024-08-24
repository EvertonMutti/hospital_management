class BedModel {
  int? id;
  String? nome;
  BedStatus? status;

  BedModel({this.id, this.nome, this.status});

  // Construtor para criar o modelo a partir de um JSON
  BedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    status = BedStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['status'],
      orElse: () => BedStatus.LIVRE,
    );
  }

  // Método para converter o modelo em JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
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
}