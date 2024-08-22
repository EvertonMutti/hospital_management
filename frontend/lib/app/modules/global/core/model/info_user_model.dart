class InfoUser {
  Data? data;
  String? msg;
  bool? status;

  InfoUser({this.data, this.msg, this.status});

  InfoUser.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    msg = json['msg'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = msg;
    data['status'] = status;
    return data;
  }
}

class Data {
  bool? active;
  String? createOn;
  String? email;
  String? escope;
  bool? excluded;
  int? id;
  int? idUserCreated;
  int? idfAccessProfile;
  String? name;
  String? password;
  Profile? profile;
  String? timestampRefresh;
  String? username;

  Data(
      {this.active,
      this.createOn,
      this.email,
      this.escope,
      this.excluded,
      this.id,
      this.idUserCreated,
      this.idfAccessProfile,
      this.name,
      this.password,
      this.profile,
      this.timestampRefresh,
      this.username});

  Data.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    createOn = json['create_on'];
    email = json['email'];
    escope = json['escope'];
    excluded = json['excluded'];
    id = json['id'];
    idUserCreated = json['id_user_created'];
    idfAccessProfile = json['idf_access_profile'];
    name = json['name'];
    password = json['password'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    timestampRefresh = json['timestamp_refresh'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['create_on'] = createOn;
    data['email'] = email;
    data['escope'] = escope;
    data['excluded'] = excluded;
    data['id'] = id;
    data['id_user_created'] = idUserCreated;
    data['idf_access_profile'] = idfAccessProfile;
    data['name'] = name;
    data['password'] = password;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['timestamp_refresh'] = timestampRefresh;
    data['username'] = username;
    return data;
  }
}

class Profile {
  bool? active;
  String? createOn;
  String? escope;
  bool? excluded;
  int? id;
  int? idUserCreated;
  String? name;
  String? role;
  String? timestampRefresh;

  Profile(
      {this.active,
      this.createOn,
      this.escope,
      this.excluded,
      this.id,
      this.idUserCreated,
      this.name,
      this.role,
      this.timestampRefresh});

  Profile.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    createOn = json['create_on'];
    escope = json['escope'];
    excluded = json['excluded'];
    id = json['id'];
    idUserCreated = json['id_user_created'];
    name = json['name'];
    role = json['role'];
    timestampRefresh = json['timestamp_refresh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['create_on'] = createOn;
    data['escope'] = escope;
    data['excluded'] = excluded;
    data['id'] = id;
    data['id_user_created'] = idUserCreated;
    data['name'] = name;
    data['role'] = role;
    data['timestamp_refresh'] = timestampRefresh;
    return data;
  }
}
