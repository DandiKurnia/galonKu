// To parse this JSON data, do
//
//     final signInModel = signInModelFromJson(jsonString);

import 'dart:convert';

SignInModel signInModelFromJson(String str) =>
    SignInModel.fromJson(json.decode(str));

String signInModelToJson(SignInModel data) => json.encode(data.toJson());

class SignInModel {
  String accessToken;
  String refreshToken;
  User user;

  SignInModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory SignInModel.fromJson(Map<String, dynamic> json) => SignInModel(
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "user": user.toJson(),
  };
}

class User {
  int id;
  int roleId;
  String name;
  String email;
  String? avatar;
  String? phoneNumber;
  dynamic addressId;
  DateTime createdAt;
  DateTime updatedAt;
  Role role;

  User({
    required this.id,
    required this.roleId,
    required this.name,
    required this.email,
    required this.avatar,
    required this.phoneNumber,
    required this.addressId,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    roleId: json["role_id"],
    name: json["name"],
    email: json["email"],
    avatar: json["avatar"],
    phoneNumber: json["phone_number"],
    addressId: json["address_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    role: Role.fromJson(json["role"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_id": roleId,
    "name": name,
    "email": email,
    "avatar": avatar,
    "phone_number": phoneNumber,
    "address_id": addressId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "role": role.toJson(),
  };
}

class Role {
  int id;
  String name;
  String key;
  DateTime createdAt;
  DateTime updatedAt;
  List<RolePermission> rolePermissions;
  List<PermissionElement> permissions;

  Role({
    required this.id,
    required this.name,
    required this.key,
    required this.createdAt,
    required this.updatedAt,
    required this.rolePermissions,
    required this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"],
    name: json["name"],
    key: json["key"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    rolePermissions: List<RolePermission>.from(
      json["role_permissions"].map((x) => RolePermission.fromJson(x)),
    ),
    permissions: List<PermissionElement>.from(
      json["permissions"].map((x) => PermissionElement.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "key": key,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "role_permissions": List<dynamic>.from(
      rolePermissions.map((x) => x.toJson()),
    ),
    "permissions": List<dynamic>.from(permissions.map((x) => x.toJson())),
  };
}

class PermissionElement {
  int id;
  String name;
  String key;
  String resource;

  PermissionElement({
    required this.id,
    required this.name,
    required this.key,
    required this.resource,
  });

  factory PermissionElement.fromJson(Map<String, dynamic> json) =>
      PermissionElement(
        id: json["id"],
        name: json["name"],
        key: json["key"],
        resource: json["resource"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "key": key,
    "resource": resource,
  };
}

class RolePermission {
  int id;
  int roleId;
  int permissionId;
  DateTime createdAt;
  DateTime updatedAt;
  RolePermissionPermission permission;

  RolePermission({
    required this.id,
    required this.roleId,
    required this.permissionId,
    required this.createdAt,
    required this.updatedAt,
    required this.permission,
  });

  factory RolePermission.fromJson(Map<String, dynamic> json) => RolePermission(
    id: json["id"],
    roleId: json["role_id"],
    permissionId: json["permission_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    permission: RolePermissionPermission.fromJson(json["permission"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_id": roleId,
    "permission_id": permissionId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "permission": permission.toJson(),
  };
}

class RolePermissionPermission {
  int id;
  String name;
  String key;
  String resource;
  DateTime createdAt;
  DateTime updatedAt;

  RolePermissionPermission({
    required this.id,
    required this.name,
    required this.key,
    required this.resource,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RolePermissionPermission.fromJson(Map<String, dynamic> json) =>
      RolePermissionPermission(
        id: json["id"],
        name: json["name"],
        key: json["key"],
        resource: json["resource"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "key": key,
    "resource": resource,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
