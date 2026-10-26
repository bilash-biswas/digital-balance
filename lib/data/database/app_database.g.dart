// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppCatalogTable extends AppCatalog
    with TableInfo<$AppCatalogTable, AppCatalogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppCatalogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _appNameMeta = const VerificationMeta(
    'appName',
  );
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
    'app_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSystemAppMeta = const VerificationMeta(
    'isSystemApp',
  );
  @override
  late final GeneratedColumn<bool> isSystemApp = GeneratedColumn<bool>(
    'is_system_app',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system_app" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _iconPathMeta = const VerificationMeta(
    'iconPath',
  );
  @override
  late final GeneratedColumn<String> iconPath = GeneratedColumn<String>(
    'icon_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isExcludedMeta = const VerificationMeta(
    'isExcluded',
  );
  @override
  late final GeneratedColumn<bool> isExcluded = GeneratedColumn<bool>(
    'is_excluded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_excluded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packageName,
    appName,
    isSystemApp,
    iconPath,
    categoryId,
    isExcluded,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_catalog';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppCatalogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('app_name')) {
      context.handle(
        _appNameMeta,
        appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta),
      );
    } else if (isInserting) {
      context.missing(_appNameMeta);
    }
    if (data.containsKey('is_system_app')) {
      context.handle(
        _isSystemAppMeta,
        isSystemApp.isAcceptableOrUnknown(
          data['is_system_app']!,
          _isSystemAppMeta,
        ),
      );
    }
    if (data.containsKey('icon_path')) {
      context.handle(
        _iconPathMeta,
        iconPath.isAcceptableOrUnknown(data['icon_path']!, _iconPathMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('is_excluded')) {
      context.handle(
        _isExcludedMeta,
        isExcluded.isAcceptableOrUnknown(data['is_excluded']!, _isExcludedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppCatalogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppCatalogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      appName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_name'],
      )!,
      isSystemApp: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system_app'],
      )!,
      iconPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_path'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      isExcluded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_excluded'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppCatalogTable createAlias(String alias) {
    return $AppCatalogTable(attachedDatabase, alias);
  }
}

class AppCatalogData extends DataClass implements Insertable<AppCatalogData> {
  final int id;
  final String packageName;
  final String appName;
  final bool isSystemApp;
  final String? iconPath;
  final int? categoryId;
  final bool isExcluded;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AppCatalogData({
    required this.id,
    required this.packageName,
    required this.appName,
    required this.isSystemApp,
    this.iconPath,
    this.categoryId,
    required this.isExcluded,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['package_name'] = Variable<String>(packageName);
    map['app_name'] = Variable<String>(appName);
    map['is_system_app'] = Variable<bool>(isSystemApp);
    if (!nullToAbsent || iconPath != null) {
      map['icon_path'] = Variable<String>(iconPath);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['is_excluded'] = Variable<bool>(isExcluded);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppCatalogCompanion toCompanion(bool nullToAbsent) {
    return AppCatalogCompanion(
      id: Value(id),
      packageName: Value(packageName),
      appName: Value(appName),
      isSystemApp: Value(isSystemApp),
      iconPath: iconPath == null && nullToAbsent
          ? const Value.absent()
          : Value(iconPath),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      isExcluded: Value(isExcluded),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppCatalogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppCatalogData(
      id: serializer.fromJson<int>(json['id']),
      packageName: serializer.fromJson<String>(json['packageName']),
      appName: serializer.fromJson<String>(json['appName']),
      isSystemApp: serializer.fromJson<bool>(json['isSystemApp']),
      iconPath: serializer.fromJson<String?>(json['iconPath']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      isExcluded: serializer.fromJson<bool>(json['isExcluded']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packageName': serializer.toJson<String>(packageName),
      'appName': serializer.toJson<String>(appName),
      'isSystemApp': serializer.toJson<bool>(isSystemApp),
      'iconPath': serializer.toJson<String?>(iconPath),
      'categoryId': serializer.toJson<int?>(categoryId),
      'isExcluded': serializer.toJson<bool>(isExcluded),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppCatalogData copyWith({
    int? id,
    String? packageName,
    String? appName,
    bool? isSystemApp,
    Value<String?> iconPath = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    bool? isExcluded,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AppCatalogData(
    id: id ?? this.id,
    packageName: packageName ?? this.packageName,
    appName: appName ?? this.appName,
    isSystemApp: isSystemApp ?? this.isSystemApp,
    iconPath: iconPath.present ? iconPath.value : this.iconPath,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    isExcluded: isExcluded ?? this.isExcluded,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppCatalogData copyWithCompanion(AppCatalogCompanion data) {
    return AppCatalogData(
      id: data.id.present ? data.id.value : this.id,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      appName: data.appName.present ? data.appName.value : this.appName,
      isSystemApp: data.isSystemApp.present
          ? data.isSystemApp.value
          : this.isSystemApp,
      iconPath: data.iconPath.present ? data.iconPath.value : this.iconPath,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      isExcluded: data.isExcluded.present
          ? data.isExcluded.value
          : this.isExcluded,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppCatalogData(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('appName: $appName, ')
          ..write('isSystemApp: $isSystemApp, ')
          ..write('iconPath: $iconPath, ')
          ..write('categoryId: $categoryId, ')
          ..write('isExcluded: $isExcluded, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packageName,
    appName,
    isSystemApp,
    iconPath,
    categoryId,
    isExcluded,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppCatalogData &&
          other.id == this.id &&
          other.packageName == this.packageName &&
          other.appName == this.appName &&
          other.isSystemApp == this.isSystemApp &&
          other.iconPath == this.iconPath &&
          other.categoryId == this.categoryId &&
          other.isExcluded == this.isExcluded &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppCatalogCompanion extends UpdateCompanion<AppCatalogData> {
  final Value<int> id;
  final Value<String> packageName;
  final Value<String> appName;
  final Value<bool> isSystemApp;
  final Value<String?> iconPath;
  final Value<int?> categoryId;
  final Value<bool> isExcluded;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AppCatalogCompanion({
    this.id = const Value.absent(),
    this.packageName = const Value.absent(),
    this.appName = const Value.absent(),
    this.isSystemApp = const Value.absent(),
    this.iconPath = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isExcluded = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppCatalogCompanion.insert({
    this.id = const Value.absent(),
    required String packageName,
    required String appName,
    this.isSystemApp = const Value.absent(),
    this.iconPath = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isExcluded = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : packageName = Value(packageName),
       appName = Value(appName);
  static Insertable<AppCatalogData> custom({
    Expression<int>? id,
    Expression<String>? packageName,
    Expression<String>? appName,
    Expression<bool>? isSystemApp,
    Expression<String>? iconPath,
    Expression<int>? categoryId,
    Expression<bool>? isExcluded,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packageName != null) 'package_name': packageName,
      if (appName != null) 'app_name': appName,
      if (isSystemApp != null) 'is_system_app': isSystemApp,
      if (iconPath != null) 'icon_path': iconPath,
      if (categoryId != null) 'category_id': categoryId,
      if (isExcluded != null) 'is_excluded': isExcluded,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppCatalogCompanion copyWith({
    Value<int>? id,
    Value<String>? packageName,
    Value<String>? appName,
    Value<bool>? isSystemApp,
    Value<String?>? iconPath,
    Value<int?>? categoryId,
    Value<bool>? isExcluded,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return AppCatalogCompanion(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      isSystemApp: isSystemApp ?? this.isSystemApp,
      iconPath: iconPath ?? this.iconPath,
      categoryId: categoryId ?? this.categoryId,
      isExcluded: isExcluded ?? this.isExcluded,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (isSystemApp.present) {
      map['is_system_app'] = Variable<bool>(isSystemApp.value);
    }
    if (iconPath.present) {
      map['icon_path'] = Variable<String>(iconPath.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (isExcluded.present) {
      map['is_excluded'] = Variable<bool>(isExcluded.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppCatalogCompanion(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('appName: $appName, ')
          ..write('isSystemApp: $isSystemApp, ')
          ..write('iconPath: $iconPath, ')
          ..write('categoryId: $categoryId, ')
          ..write('isExcluded: $isExcluded, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppCategoriesTable extends AppCategories
    with TableInfo<$AppCategoriesTable, AppCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#3F51B5'),
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('category'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, colorHex, iconName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      )!,
    );
  }

  @override
  $AppCategoriesTable createAlias(String alias) {
    return $AppCategoriesTable(attachedDatabase, alias);
  }
}

class AppCategory extends DataClass implements Insertable<AppCategory> {
  final int id;
  final String name;
  final String colorHex;
  final String iconName;
  const AppCategory({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.iconName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color_hex'] = Variable<String>(colorHex);
    map['icon_name'] = Variable<String>(iconName);
    return map;
  }

  AppCategoriesCompanion toCompanion(bool nullToAbsent) {
    return AppCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      colorHex: Value(colorHex),
      iconName: Value(iconName),
    );
  }

  factory AppCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      iconName: serializer.fromJson<String>(json['iconName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorHex': serializer.toJson<String>(colorHex),
      'iconName': serializer.toJson<String>(iconName),
    };
  }

  AppCategory copyWith({
    int? id,
    String? name,
    String? colorHex,
    String? iconName,
  }) => AppCategory(
    id: id ?? this.id,
    name: name ?? this.name,
    colorHex: colorHex ?? this.colorHex,
    iconName: iconName ?? this.iconName,
  );
  AppCategory copyWithCompanion(AppCategoriesCompanion data) {
    return AppCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('iconName: $iconName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorHex, iconName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorHex == this.colorHex &&
          other.iconName == this.iconName);
}

class AppCategoriesCompanion extends UpdateCompanion<AppCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> colorHex;
  final Value<String> iconName;
  const AppCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.iconName = const Value.absent(),
  });
  AppCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.colorHex = const Value.absent(),
    this.iconName = const Value.absent(),
  }) : name = Value(name);
  static Insertable<AppCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? colorHex,
    Expression<String>? iconName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorHex != null) 'color_hex': colorHex,
      if (iconName != null) 'icon_name': iconName,
    });
  }

  AppCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? colorHex,
    Value<String>? iconName,
  }) {
    return AppCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      iconName: iconName ?? this.iconName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('iconName: $iconName')
          ..write(')'))
        .toString();
  }
}

class $UsageDailyTable extends UsageDaily
    with TableInfo<$UsageDailyTable, UsageDailyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageDailyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foregroundTimeMsMeta = const VerificationMeta(
    'foregroundTimeMs',
  );
  @override
  late final GeneratedColumn<int> foregroundTimeMs = GeneratedColumn<int>(
    'foreground_time_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _launchCountMeta = const VerificationMeta(
    'launchCount',
  );
  @override
  late final GeneratedColumn<int> launchCount = GeneratedColumn<int>(
    'launch_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastUsedUtcMsMeta = const VerificationMeta(
    'lastUsedUtcMs',
  );
  @override
  late final GeneratedColumn<int> lastUsedUtcMs = GeneratedColumn<int>(
    'last_used_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    packageName,
    foregroundTimeMs,
    launchCount,
    lastUsedUtcMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_daily';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageDailyData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('foreground_time_ms')) {
      context.handle(
        _foregroundTimeMsMeta,
        foregroundTimeMs.isAcceptableOrUnknown(
          data['foreground_time_ms']!,
          _foregroundTimeMsMeta,
        ),
      );
    }
    if (data.containsKey('launch_count')) {
      context.handle(
        _launchCountMeta,
        launchCount.isAcceptableOrUnknown(
          data['launch_count']!,
          _launchCountMeta,
        ),
      );
    }
    if (data.containsKey('last_used_utc_ms')) {
      context.handle(
        _lastUsedUtcMsMeta,
        lastUsedUtcMs.isAcceptableOrUnknown(
          data['last_used_utc_ms']!,
          _lastUsedUtcMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date, packageName};
  @override
  UsageDailyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageDailyData(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      foregroundTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}foreground_time_ms'],
      )!,
      launchCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}launch_count'],
      )!,
      lastUsedUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_used_utc_ms'],
      )!,
    );
  }

  @override
  $UsageDailyTable createAlias(String alias) {
    return $UsageDailyTable(attachedDatabase, alias);
  }
}

class UsageDailyData extends DataClass implements Insertable<UsageDailyData> {
  final String date;
  final String packageName;
  final int foregroundTimeMs;
  final int launchCount;
  final int lastUsedUtcMs;
  const UsageDailyData({
    required this.date,
    required this.packageName,
    required this.foregroundTimeMs,
    required this.launchCount,
    required this.lastUsedUtcMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['package_name'] = Variable<String>(packageName);
    map['foreground_time_ms'] = Variable<int>(foregroundTimeMs);
    map['launch_count'] = Variable<int>(launchCount);
    map['last_used_utc_ms'] = Variable<int>(lastUsedUtcMs);
    return map;
  }

  UsageDailyCompanion toCompanion(bool nullToAbsent) {
    return UsageDailyCompanion(
      date: Value(date),
      packageName: Value(packageName),
      foregroundTimeMs: Value(foregroundTimeMs),
      launchCount: Value(launchCount),
      lastUsedUtcMs: Value(lastUsedUtcMs),
    );
  }

  factory UsageDailyData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageDailyData(
      date: serializer.fromJson<String>(json['date']),
      packageName: serializer.fromJson<String>(json['packageName']),
      foregroundTimeMs: serializer.fromJson<int>(json['foregroundTimeMs']),
      launchCount: serializer.fromJson<int>(json['launchCount']),
      lastUsedUtcMs: serializer.fromJson<int>(json['lastUsedUtcMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'packageName': serializer.toJson<String>(packageName),
      'foregroundTimeMs': serializer.toJson<int>(foregroundTimeMs),
      'launchCount': serializer.toJson<int>(launchCount),
      'lastUsedUtcMs': serializer.toJson<int>(lastUsedUtcMs),
    };
  }

  UsageDailyData copyWith({
    String? date,
    String? packageName,
    int? foregroundTimeMs,
    int? launchCount,
    int? lastUsedUtcMs,
  }) => UsageDailyData(
    date: date ?? this.date,
    packageName: packageName ?? this.packageName,
    foregroundTimeMs: foregroundTimeMs ?? this.foregroundTimeMs,
    launchCount: launchCount ?? this.launchCount,
    lastUsedUtcMs: lastUsedUtcMs ?? this.lastUsedUtcMs,
  );
  UsageDailyData copyWithCompanion(UsageDailyCompanion data) {
    return UsageDailyData(
      date: data.date.present ? data.date.value : this.date,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      foregroundTimeMs: data.foregroundTimeMs.present
          ? data.foregroundTimeMs.value
          : this.foregroundTimeMs,
      launchCount: data.launchCount.present
          ? data.launchCount.value
          : this.launchCount,
      lastUsedUtcMs: data.lastUsedUtcMs.present
          ? data.lastUsedUtcMs.value
          : this.lastUsedUtcMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageDailyData(')
          ..write('date: $date, ')
          ..write('packageName: $packageName, ')
          ..write('foregroundTimeMs: $foregroundTimeMs, ')
          ..write('launchCount: $launchCount, ')
          ..write('lastUsedUtcMs: $lastUsedUtcMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    packageName,
    foregroundTimeMs,
    launchCount,
    lastUsedUtcMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageDailyData &&
          other.date == this.date &&
          other.packageName == this.packageName &&
          other.foregroundTimeMs == this.foregroundTimeMs &&
          other.launchCount == this.launchCount &&
          other.lastUsedUtcMs == this.lastUsedUtcMs);
}

class UsageDailyCompanion extends UpdateCompanion<UsageDailyData> {
  final Value<String> date;
  final Value<String> packageName;
  final Value<int> foregroundTimeMs;
  final Value<int> launchCount;
  final Value<int> lastUsedUtcMs;
  final Value<int> rowid;
  const UsageDailyCompanion({
    this.date = const Value.absent(),
    this.packageName = const Value.absent(),
    this.foregroundTimeMs = const Value.absent(),
    this.launchCount = const Value.absent(),
    this.lastUsedUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsageDailyCompanion.insert({
    required String date,
    required String packageName,
    this.foregroundTimeMs = const Value.absent(),
    this.launchCount = const Value.absent(),
    this.lastUsedUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       packageName = Value(packageName);
  static Insertable<UsageDailyData> custom({
    Expression<String>? date,
    Expression<String>? packageName,
    Expression<int>? foregroundTimeMs,
    Expression<int>? launchCount,
    Expression<int>? lastUsedUtcMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (packageName != null) 'package_name': packageName,
      if (foregroundTimeMs != null) 'foreground_time_ms': foregroundTimeMs,
      if (launchCount != null) 'launch_count': launchCount,
      if (lastUsedUtcMs != null) 'last_used_utc_ms': lastUsedUtcMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsageDailyCompanion copyWith({
    Value<String>? date,
    Value<String>? packageName,
    Value<int>? foregroundTimeMs,
    Value<int>? launchCount,
    Value<int>? lastUsedUtcMs,
    Value<int>? rowid,
  }) {
    return UsageDailyCompanion(
      date: date ?? this.date,
      packageName: packageName ?? this.packageName,
      foregroundTimeMs: foregroundTimeMs ?? this.foregroundTimeMs,
      launchCount: launchCount ?? this.launchCount,
      lastUsedUtcMs: lastUsedUtcMs ?? this.lastUsedUtcMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (foregroundTimeMs.present) {
      map['foreground_time_ms'] = Variable<int>(foregroundTimeMs.value);
    }
    if (launchCount.present) {
      map['launch_count'] = Variable<int>(launchCount.value);
    }
    if (lastUsedUtcMs.present) {
      map['last_used_utc_ms'] = Variable<int>(lastUsedUtcMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageDailyCompanion(')
          ..write('date: $date, ')
          ..write('packageName: $packageName, ')
          ..write('foregroundTimeMs: $foregroundTimeMs, ')
          ..write('launchCount: $launchCount, ')
          ..write('lastUsedUtcMs: $lastUsedUtcMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsageHourlyTable extends UsageHourly
    with TableInfo<$UsageHourlyTable, UsageHourlyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageHourlyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hourOfDayMeta = const VerificationMeta(
    'hourOfDay',
  );
  @override
  late final GeneratedColumn<int> hourOfDay = GeneratedColumn<int>(
    'hour_of_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foregroundTimeMsMeta = const VerificationMeta(
    'foregroundTimeMs',
  );
  @override
  late final GeneratedColumn<int> foregroundTimeMs = GeneratedColumn<int>(
    'foreground_time_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deviceUnlocksMeta = const VerificationMeta(
    'deviceUnlocks',
  );
  @override
  late final GeneratedColumn<int> deviceUnlocks = GeneratedColumn<int>(
    'device_unlocks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    hourOfDay,
    foregroundTimeMs,
    deviceUnlocks,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_hourly';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageHourlyData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('hour_of_day')) {
      context.handle(
        _hourOfDayMeta,
        hourOfDay.isAcceptableOrUnknown(data['hour_of_day']!, _hourOfDayMeta),
      );
    } else if (isInserting) {
      context.missing(_hourOfDayMeta);
    }
    if (data.containsKey('foreground_time_ms')) {
      context.handle(
        _foregroundTimeMsMeta,
        foregroundTimeMs.isAcceptableOrUnknown(
          data['foreground_time_ms']!,
          _foregroundTimeMsMeta,
        ),
      );
    }
    if (data.containsKey('device_unlocks')) {
      context.handle(
        _deviceUnlocksMeta,
        deviceUnlocks.isAcceptableOrUnknown(
          data['device_unlocks']!,
          _deviceUnlocksMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date, hourOfDay};
  @override
  UsageHourlyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageHourlyData(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      hourOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour_of_day'],
      )!,
      foregroundTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}foreground_time_ms'],
      )!,
      deviceUnlocks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}device_unlocks'],
      )!,
    );
  }

  @override
  $UsageHourlyTable createAlias(String alias) {
    return $UsageHourlyTable(attachedDatabase, alias);
  }
}

class UsageHourlyData extends DataClass implements Insertable<UsageHourlyData> {
  final String date;
  final int hourOfDay;
  final int foregroundTimeMs;
  final int deviceUnlocks;
  const UsageHourlyData({
    required this.date,
    required this.hourOfDay,
    required this.foregroundTimeMs,
    required this.deviceUnlocks,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['hour_of_day'] = Variable<int>(hourOfDay);
    map['foreground_time_ms'] = Variable<int>(foregroundTimeMs);
    map['device_unlocks'] = Variable<int>(deviceUnlocks);
    return map;
  }

  UsageHourlyCompanion toCompanion(bool nullToAbsent) {
    return UsageHourlyCompanion(
      date: Value(date),
      hourOfDay: Value(hourOfDay),
      foregroundTimeMs: Value(foregroundTimeMs),
      deviceUnlocks: Value(deviceUnlocks),
    );
  }

  factory UsageHourlyData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageHourlyData(
      date: serializer.fromJson<String>(json['date']),
      hourOfDay: serializer.fromJson<int>(json['hourOfDay']),
      foregroundTimeMs: serializer.fromJson<int>(json['foregroundTimeMs']),
      deviceUnlocks: serializer.fromJson<int>(json['deviceUnlocks']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'hourOfDay': serializer.toJson<int>(hourOfDay),
      'foregroundTimeMs': serializer.toJson<int>(foregroundTimeMs),
      'deviceUnlocks': serializer.toJson<int>(deviceUnlocks),
    };
  }

  UsageHourlyData copyWith({
    String? date,
    int? hourOfDay,
    int? foregroundTimeMs,
    int? deviceUnlocks,
  }) => UsageHourlyData(
    date: date ?? this.date,
    hourOfDay: hourOfDay ?? this.hourOfDay,
    foregroundTimeMs: foregroundTimeMs ?? this.foregroundTimeMs,
    deviceUnlocks: deviceUnlocks ?? this.deviceUnlocks,
  );
  UsageHourlyData copyWithCompanion(UsageHourlyCompanion data) {
    return UsageHourlyData(
      date: data.date.present ? data.date.value : this.date,
      hourOfDay: data.hourOfDay.present ? data.hourOfDay.value : this.hourOfDay,
      foregroundTimeMs: data.foregroundTimeMs.present
          ? data.foregroundTimeMs.value
          : this.foregroundTimeMs,
      deviceUnlocks: data.deviceUnlocks.present
          ? data.deviceUnlocks.value
          : this.deviceUnlocks,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageHourlyData(')
          ..write('date: $date, ')
          ..write('hourOfDay: $hourOfDay, ')
          ..write('foregroundTimeMs: $foregroundTimeMs, ')
          ..write('deviceUnlocks: $deviceUnlocks')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(date, hourOfDay, foregroundTimeMs, deviceUnlocks);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageHourlyData &&
          other.date == this.date &&
          other.hourOfDay == this.hourOfDay &&
          other.foregroundTimeMs == this.foregroundTimeMs &&
          other.deviceUnlocks == this.deviceUnlocks);
}

class UsageHourlyCompanion extends UpdateCompanion<UsageHourlyData> {
  final Value<String> date;
  final Value<int> hourOfDay;
  final Value<int> foregroundTimeMs;
  final Value<int> deviceUnlocks;
  final Value<int> rowid;
  const UsageHourlyCompanion({
    this.date = const Value.absent(),
    this.hourOfDay = const Value.absent(),
    this.foregroundTimeMs = const Value.absent(),
    this.deviceUnlocks = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsageHourlyCompanion.insert({
    required String date,
    required int hourOfDay,
    this.foregroundTimeMs = const Value.absent(),
    this.deviceUnlocks = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       hourOfDay = Value(hourOfDay);
  static Insertable<UsageHourlyData> custom({
    Expression<String>? date,
    Expression<int>? hourOfDay,
    Expression<int>? foregroundTimeMs,
    Expression<int>? deviceUnlocks,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (hourOfDay != null) 'hour_of_day': hourOfDay,
      if (foregroundTimeMs != null) 'foreground_time_ms': foregroundTimeMs,
      if (deviceUnlocks != null) 'device_unlocks': deviceUnlocks,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsageHourlyCompanion copyWith({
    Value<String>? date,
    Value<int>? hourOfDay,
    Value<int>? foregroundTimeMs,
    Value<int>? deviceUnlocks,
    Value<int>? rowid,
  }) {
    return UsageHourlyCompanion(
      date: date ?? this.date,
      hourOfDay: hourOfDay ?? this.hourOfDay,
      foregroundTimeMs: foregroundTimeMs ?? this.foregroundTimeMs,
      deviceUnlocks: deviceUnlocks ?? this.deviceUnlocks,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (hourOfDay.present) {
      map['hour_of_day'] = Variable<int>(hourOfDay.value);
    }
    if (foregroundTimeMs.present) {
      map['foreground_time_ms'] = Variable<int>(foregroundTimeMs.value);
    }
    if (deviceUnlocks.present) {
      map['device_unlocks'] = Variable<int>(deviceUnlocks.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageHourlyCompanion(')
          ..write('date: $date, ')
          ..write('hourOfDay: $hourOfDay, ')
          ..write('foregroundTimeMs: $foregroundTimeMs, ')
          ..write('deviceUnlocks: $deviceUnlocks, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsageSyncStateTable extends UsageSyncState
    with TableInfo<$UsageSyncStateTable, UsageSyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageSyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _lastSyncUtcMsMeta = const VerificationMeta(
    'lastSyncUtcMs',
  );
  @override
  late final GeneratedColumn<int> lastSyncUtcMs = GeneratedColumn<int>(
    'last_sync_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lastSyncUtcMs,
    syncStatus,
    errorMessage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageSyncStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_sync_utc_ms')) {
      context.handle(
        _lastSyncUtcMsMeta,
        lastSyncUtcMs.isAcceptableOrUnknown(
          data['last_sync_utc_ms']!,
          _lastSyncUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSyncUtcMsMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsageSyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageSyncStateData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastSyncUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sync_utc_ms'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
    );
  }

  @override
  $UsageSyncStateTable createAlias(String alias) {
    return $UsageSyncStateTable(attachedDatabase, alias);
  }
}

class UsageSyncStateData extends DataClass
    implements Insertable<UsageSyncStateData> {
  final int id;
  final int lastSyncUtcMs;
  final String syncStatus;
  final String? errorMessage;
  const UsageSyncStateData({
    required this.id,
    required this.lastSyncUtcMs,
    required this.syncStatus,
    this.errorMessage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['last_sync_utc_ms'] = Variable<int>(lastSyncUtcMs);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  UsageSyncStateCompanion toCompanion(bool nullToAbsent) {
    return UsageSyncStateCompanion(
      id: Value(id),
      lastSyncUtcMs: Value(lastSyncUtcMs),
      syncStatus: Value(syncStatus),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory UsageSyncStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageSyncStateData(
      id: serializer.fromJson<int>(json['id']),
      lastSyncUtcMs: serializer.fromJson<int>(json['lastSyncUtcMs']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastSyncUtcMs': serializer.toJson<int>(lastSyncUtcMs),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  UsageSyncStateData copyWith({
    int? id,
    int? lastSyncUtcMs,
    String? syncStatus,
    Value<String?> errorMessage = const Value.absent(),
  }) => UsageSyncStateData(
    id: id ?? this.id,
    lastSyncUtcMs: lastSyncUtcMs ?? this.lastSyncUtcMs,
    syncStatus: syncStatus ?? this.syncStatus,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
  );
  UsageSyncStateData copyWithCompanion(UsageSyncStateCompanion data) {
    return UsageSyncStateData(
      id: data.id.present ? data.id.value : this.id,
      lastSyncUtcMs: data.lastSyncUtcMs.present
          ? data.lastSyncUtcMs.value
          : this.lastSyncUtcMs,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageSyncStateData(')
          ..write('id: $id, ')
          ..write('lastSyncUtcMs: $lastSyncUtcMs, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastSyncUtcMs, syncStatus, errorMessage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageSyncStateData &&
          other.id == this.id &&
          other.lastSyncUtcMs == this.lastSyncUtcMs &&
          other.syncStatus == this.syncStatus &&
          other.errorMessage == this.errorMessage);
}

class UsageSyncStateCompanion extends UpdateCompanion<UsageSyncStateData> {
  final Value<int> id;
  final Value<int> lastSyncUtcMs;
  final Value<String> syncStatus;
  final Value<String?> errorMessage;
  const UsageSyncStateCompanion({
    this.id = const Value.absent(),
    this.lastSyncUtcMs = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.errorMessage = const Value.absent(),
  });
  UsageSyncStateCompanion.insert({
    this.id = const Value.absent(),
    required int lastSyncUtcMs,
    required String syncStatus,
    this.errorMessage = const Value.absent(),
  }) : lastSyncUtcMs = Value(lastSyncUtcMs),
       syncStatus = Value(syncStatus);
  static Insertable<UsageSyncStateData> custom({
    Expression<int>? id,
    Expression<int>? lastSyncUtcMs,
    Expression<String>? syncStatus,
    Expression<String>? errorMessage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastSyncUtcMs != null) 'last_sync_utc_ms': lastSyncUtcMs,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (errorMessage != null) 'error_message': errorMessage,
    });
  }

  UsageSyncStateCompanion copyWith({
    Value<int>? id,
    Value<int>? lastSyncUtcMs,
    Value<String>? syncStatus,
    Value<String?>? errorMessage,
  }) {
    return UsageSyncStateCompanion(
      id: id ?? this.id,
      lastSyncUtcMs: lastSyncUtcMs ?? this.lastSyncUtcMs,
      syncStatus: syncStatus ?? this.syncStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastSyncUtcMs.present) {
      map['last_sync_utc_ms'] = Variable<int>(lastSyncUtcMs.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageSyncStateCompanion(')
          ..write('id: $id, ')
          ..write('lastSyncUtcMs: $lastSyncUtcMs, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }
}

class $RestrictionRulesTable extends RestrictionRules
    with TableInfo<$RestrictionRulesTable, RestrictionRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestrictionRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _limitMinutesPerDayMeta =
      const VerificationMeta('limitMinutesPerDay');
  @override
  late final GeneratedColumn<int> limitMinutesPerDay = GeneratedColumn<int>(
    'limit_minutes_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startMinuteOfDayMeta = const VerificationMeta(
    'startMinuteOfDay',
  );
  @override
  late final GeneratedColumn<int> startMinuteOfDay = GeneratedColumn<int>(
    'start_minute_of_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  static const VerificationMeta _endMinuteOfDayMeta = const VerificationMeta(
    'endMinuteOfDay',
  );
  @override
  late final GeneratedColumn<int> endMinuteOfDay = GeneratedColumn<int>(
    'end_minute_of_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  static const VerificationMeta _daysOfWeekMeta = const VerificationMeta(
    'daysOfWeek',
  );
  @override
  late final GeneratedColumn<String> daysOfWeek = GeneratedColumn<String>(
    'days_of_week',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1,2,3,4,5,6,7'),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isTemporaryBlockMeta = const VerificationMeta(
    'isTemporaryBlock',
  );
  @override
  late final GeneratedColumn<bool> isTemporaryBlock = GeneratedColumn<bool>(
    'is_temporary_block',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_temporary_block" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tempBlockUntilMsMeta = const VerificationMeta(
    'tempBlockUntilMs',
  );
  @override
  late final GeneratedColumn<int> tempBlockUntilMs = GeneratedColumn<int>(
    'temp_block_until_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    limitMinutesPerDay,
    startMinuteOfDay,
    endMinuteOfDay,
    daysOfWeek,
    isEnabled,
    isTemporaryBlock,
    tempBlockUntilMs,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'restriction_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<RestrictionRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('limit_minutes_per_day')) {
      context.handle(
        _limitMinutesPerDayMeta,
        limitMinutesPerDay.isAcceptableOrUnknown(
          data['limit_minutes_per_day']!,
          _limitMinutesPerDayMeta,
        ),
      );
    }
    if (data.containsKey('start_minute_of_day')) {
      context.handle(
        _startMinuteOfDayMeta,
        startMinuteOfDay.isAcceptableOrUnknown(
          data['start_minute_of_day']!,
          _startMinuteOfDayMeta,
        ),
      );
    }
    if (data.containsKey('end_minute_of_day')) {
      context.handle(
        _endMinuteOfDayMeta,
        endMinuteOfDay.isAcceptableOrUnknown(
          data['end_minute_of_day']!,
          _endMinuteOfDayMeta,
        ),
      );
    }
    if (data.containsKey('days_of_week')) {
      context.handle(
        _daysOfWeekMeta,
        daysOfWeek.isAcceptableOrUnknown(
          data['days_of_week']!,
          _daysOfWeekMeta,
        ),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('is_temporary_block')) {
      context.handle(
        _isTemporaryBlockMeta,
        isTemporaryBlock.isAcceptableOrUnknown(
          data['is_temporary_block']!,
          _isTemporaryBlockMeta,
        ),
      );
    }
    if (data.containsKey('temp_block_until_ms')) {
      context.handle(
        _tempBlockUntilMsMeta,
        tempBlockUntilMs.isAcceptableOrUnknown(
          data['temp_block_until_ms']!,
          _tempBlockUntilMsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestrictionRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestrictionRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      limitMinutesPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limit_minutes_per_day'],
      )!,
      startMinuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute_of_day'],
      )!,
      endMinuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minute_of_day'],
      )!,
      daysOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}days_of_week'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      isTemporaryBlock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_temporary_block'],
      )!,
      tempBlockUntilMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}temp_block_until_ms'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RestrictionRulesTable createAlias(String alias) {
    return $RestrictionRulesTable(attachedDatabase, alias);
  }
}

class RestrictionRule extends DataClass implements Insertable<RestrictionRule> {
  final String id;
  final String name;
  final int limitMinutesPerDay;
  final int startMinuteOfDay;
  final int endMinuteOfDay;
  final String daysOfWeek;
  final bool isEnabled;
  final bool isTemporaryBlock;
  final int tempBlockUntilMs;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RestrictionRule({
    required this.id,
    required this.name,
    required this.limitMinutesPerDay,
    required this.startMinuteOfDay,
    required this.endMinuteOfDay,
    required this.daysOfWeek,
    required this.isEnabled,
    required this.isTemporaryBlock,
    required this.tempBlockUntilMs,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['limit_minutes_per_day'] = Variable<int>(limitMinutesPerDay);
    map['start_minute_of_day'] = Variable<int>(startMinuteOfDay);
    map['end_minute_of_day'] = Variable<int>(endMinuteOfDay);
    map['days_of_week'] = Variable<String>(daysOfWeek);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['is_temporary_block'] = Variable<bool>(isTemporaryBlock);
    map['temp_block_until_ms'] = Variable<int>(tempBlockUntilMs);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RestrictionRulesCompanion toCompanion(bool nullToAbsent) {
    return RestrictionRulesCompanion(
      id: Value(id),
      name: Value(name),
      limitMinutesPerDay: Value(limitMinutesPerDay),
      startMinuteOfDay: Value(startMinuteOfDay),
      endMinuteOfDay: Value(endMinuteOfDay),
      daysOfWeek: Value(daysOfWeek),
      isEnabled: Value(isEnabled),
      isTemporaryBlock: Value(isTemporaryBlock),
      tempBlockUntilMs: Value(tempBlockUntilMs),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RestrictionRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestrictionRule(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      limitMinutesPerDay: serializer.fromJson<int>(json['limitMinutesPerDay']),
      startMinuteOfDay: serializer.fromJson<int>(json['startMinuteOfDay']),
      endMinuteOfDay: serializer.fromJson<int>(json['endMinuteOfDay']),
      daysOfWeek: serializer.fromJson<String>(json['daysOfWeek']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      isTemporaryBlock: serializer.fromJson<bool>(json['isTemporaryBlock']),
      tempBlockUntilMs: serializer.fromJson<int>(json['tempBlockUntilMs']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'limitMinutesPerDay': serializer.toJson<int>(limitMinutesPerDay),
      'startMinuteOfDay': serializer.toJson<int>(startMinuteOfDay),
      'endMinuteOfDay': serializer.toJson<int>(endMinuteOfDay),
      'daysOfWeek': serializer.toJson<String>(daysOfWeek),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'isTemporaryBlock': serializer.toJson<bool>(isTemporaryBlock),
      'tempBlockUntilMs': serializer.toJson<int>(tempBlockUntilMs),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RestrictionRule copyWith({
    String? id,
    String? name,
    int? limitMinutesPerDay,
    int? startMinuteOfDay,
    int? endMinuteOfDay,
    String? daysOfWeek,
    bool? isEnabled,
    bool? isTemporaryBlock,
    int? tempBlockUntilMs,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RestrictionRule(
    id: id ?? this.id,
    name: name ?? this.name,
    limitMinutesPerDay: limitMinutesPerDay ?? this.limitMinutesPerDay,
    startMinuteOfDay: startMinuteOfDay ?? this.startMinuteOfDay,
    endMinuteOfDay: endMinuteOfDay ?? this.endMinuteOfDay,
    daysOfWeek: daysOfWeek ?? this.daysOfWeek,
    isEnabled: isEnabled ?? this.isEnabled,
    isTemporaryBlock: isTemporaryBlock ?? this.isTemporaryBlock,
    tempBlockUntilMs: tempBlockUntilMs ?? this.tempBlockUntilMs,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RestrictionRule copyWithCompanion(RestrictionRulesCompanion data) {
    return RestrictionRule(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      limitMinutesPerDay: data.limitMinutesPerDay.present
          ? data.limitMinutesPerDay.value
          : this.limitMinutesPerDay,
      startMinuteOfDay: data.startMinuteOfDay.present
          ? data.startMinuteOfDay.value
          : this.startMinuteOfDay,
      endMinuteOfDay: data.endMinuteOfDay.present
          ? data.endMinuteOfDay.value
          : this.endMinuteOfDay,
      daysOfWeek: data.daysOfWeek.present
          ? data.daysOfWeek.value
          : this.daysOfWeek,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      isTemporaryBlock: data.isTemporaryBlock.present
          ? data.isTemporaryBlock.value
          : this.isTemporaryBlock,
      tempBlockUntilMs: data.tempBlockUntilMs.present
          ? data.tempBlockUntilMs.value
          : this.tempBlockUntilMs,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestrictionRule(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('limitMinutesPerDay: $limitMinutesPerDay, ')
          ..write('startMinuteOfDay: $startMinuteOfDay, ')
          ..write('endMinuteOfDay: $endMinuteOfDay, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isTemporaryBlock: $isTemporaryBlock, ')
          ..write('tempBlockUntilMs: $tempBlockUntilMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    limitMinutesPerDay,
    startMinuteOfDay,
    endMinuteOfDay,
    daysOfWeek,
    isEnabled,
    isTemporaryBlock,
    tempBlockUntilMs,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestrictionRule &&
          other.id == this.id &&
          other.name == this.name &&
          other.limitMinutesPerDay == this.limitMinutesPerDay &&
          other.startMinuteOfDay == this.startMinuteOfDay &&
          other.endMinuteOfDay == this.endMinuteOfDay &&
          other.daysOfWeek == this.daysOfWeek &&
          other.isEnabled == this.isEnabled &&
          other.isTemporaryBlock == this.isTemporaryBlock &&
          other.tempBlockUntilMs == this.tempBlockUntilMs &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RestrictionRulesCompanion extends UpdateCompanion<RestrictionRule> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> limitMinutesPerDay;
  final Value<int> startMinuteOfDay;
  final Value<int> endMinuteOfDay;
  final Value<String> daysOfWeek;
  final Value<bool> isEnabled;
  final Value<bool> isTemporaryBlock;
  final Value<int> tempBlockUntilMs;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RestrictionRulesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.limitMinutesPerDay = const Value.absent(),
    this.startMinuteOfDay = const Value.absent(),
    this.endMinuteOfDay = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isTemporaryBlock = const Value.absent(),
    this.tempBlockUntilMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RestrictionRulesCompanion.insert({
    required String id,
    required String name,
    this.limitMinutesPerDay = const Value.absent(),
    this.startMinuteOfDay = const Value.absent(),
    this.endMinuteOfDay = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isTemporaryBlock = const Value.absent(),
    this.tempBlockUntilMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<RestrictionRule> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? limitMinutesPerDay,
    Expression<int>? startMinuteOfDay,
    Expression<int>? endMinuteOfDay,
    Expression<String>? daysOfWeek,
    Expression<bool>? isEnabled,
    Expression<bool>? isTemporaryBlock,
    Expression<int>? tempBlockUntilMs,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (limitMinutesPerDay != null)
        'limit_minutes_per_day': limitMinutesPerDay,
      if (startMinuteOfDay != null) 'start_minute_of_day': startMinuteOfDay,
      if (endMinuteOfDay != null) 'end_minute_of_day': endMinuteOfDay,
      if (daysOfWeek != null) 'days_of_week': daysOfWeek,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (isTemporaryBlock != null) 'is_temporary_block': isTemporaryBlock,
      if (tempBlockUntilMs != null) 'temp_block_until_ms': tempBlockUntilMs,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RestrictionRulesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? limitMinutesPerDay,
    Value<int>? startMinuteOfDay,
    Value<int>? endMinuteOfDay,
    Value<String>? daysOfWeek,
    Value<bool>? isEnabled,
    Value<bool>? isTemporaryBlock,
    Value<int>? tempBlockUntilMs,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RestrictionRulesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      limitMinutesPerDay: limitMinutesPerDay ?? this.limitMinutesPerDay,
      startMinuteOfDay: startMinuteOfDay ?? this.startMinuteOfDay,
      endMinuteOfDay: endMinuteOfDay ?? this.endMinuteOfDay,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isEnabled: isEnabled ?? this.isEnabled,
      isTemporaryBlock: isTemporaryBlock ?? this.isTemporaryBlock,
      tempBlockUntilMs: tempBlockUntilMs ?? this.tempBlockUntilMs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (limitMinutesPerDay.present) {
      map['limit_minutes_per_day'] = Variable<int>(limitMinutesPerDay.value);
    }
    if (startMinuteOfDay.present) {
      map['start_minute_of_day'] = Variable<int>(startMinuteOfDay.value);
    }
    if (endMinuteOfDay.present) {
      map['end_minute_of_day'] = Variable<int>(endMinuteOfDay.value);
    }
    if (daysOfWeek.present) {
      map['days_of_week'] = Variable<String>(daysOfWeek.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (isTemporaryBlock.present) {
      map['is_temporary_block'] = Variable<bool>(isTemporaryBlock.value);
    }
    if (tempBlockUntilMs.present) {
      map['temp_block_until_ms'] = Variable<int>(tempBlockUntilMs.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestrictionRulesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('limitMinutesPerDay: $limitMinutesPerDay, ')
          ..write('startMinuteOfDay: $startMinuteOfDay, ')
          ..write('endMinuteOfDay: $endMinuteOfDay, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isTemporaryBlock: $isTemporaryBlock, ')
          ..write('tempBlockUntilMs: $tempBlockUntilMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RestrictionTargetsTable extends RestrictionTargets
    with TableInfo<$RestrictionTargetsTable, RestrictionTarget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestrictionTargetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<String> ruleId = GeneratedColumn<String>(
    'rule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, ruleId, packageName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'restriction_targets';
  @override
  VerificationContext validateIntegrity(
    Insertable<RestrictionTarget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rule_id')) {
      context.handle(
        _ruleIdMeta,
        ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ruleIdMeta);
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {ruleId, packageName},
  ];
  @override
  RestrictionTarget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestrictionTarget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ruleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_id'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
    );
  }

  @override
  $RestrictionTargetsTable createAlias(String alias) {
    return $RestrictionTargetsTable(attachedDatabase, alias);
  }
}

class RestrictionTarget extends DataClass
    implements Insertable<RestrictionTarget> {
  final int id;
  final String ruleId;
  final String packageName;
  const RestrictionTarget({
    required this.id,
    required this.ruleId,
    required this.packageName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['rule_id'] = Variable<String>(ruleId);
    map['package_name'] = Variable<String>(packageName);
    return map;
  }

  RestrictionTargetsCompanion toCompanion(bool nullToAbsent) {
    return RestrictionTargetsCompanion(
      id: Value(id),
      ruleId: Value(ruleId),
      packageName: Value(packageName),
    );
  }

  factory RestrictionTarget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestrictionTarget(
      id: serializer.fromJson<int>(json['id']),
      ruleId: serializer.fromJson<String>(json['ruleId']),
      packageName: serializer.fromJson<String>(json['packageName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ruleId': serializer.toJson<String>(ruleId),
      'packageName': serializer.toJson<String>(packageName),
    };
  }

  RestrictionTarget copyWith({int? id, String? ruleId, String? packageName}) =>
      RestrictionTarget(
        id: id ?? this.id,
        ruleId: ruleId ?? this.ruleId,
        packageName: packageName ?? this.packageName,
      );
  RestrictionTarget copyWithCompanion(RestrictionTargetsCompanion data) {
    return RestrictionTarget(
      id: data.id.present ? data.id.value : this.id,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestrictionTarget(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('packageName: $packageName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ruleId, packageName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestrictionTarget &&
          other.id == this.id &&
          other.ruleId == this.ruleId &&
          other.packageName == this.packageName);
}

class RestrictionTargetsCompanion extends UpdateCompanion<RestrictionTarget> {
  final Value<int> id;
  final Value<String> ruleId;
  final Value<String> packageName;
  const RestrictionTargetsCompanion({
    this.id = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.packageName = const Value.absent(),
  });
  RestrictionTargetsCompanion.insert({
    this.id = const Value.absent(),
    required String ruleId,
    required String packageName,
  }) : ruleId = Value(ruleId),
       packageName = Value(packageName);
  static Insertable<RestrictionTarget> custom({
    Expression<int>? id,
    Expression<String>? ruleId,
    Expression<String>? packageName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleId != null) 'rule_id': ruleId,
      if (packageName != null) 'package_name': packageName,
    });
  }

  RestrictionTargetsCompanion copyWith({
    Value<int>? id,
    Value<String>? ruleId,
    Value<String>? packageName,
  }) {
    return RestrictionTargetsCompanion(
      id: id ?? this.id,
      ruleId: ruleId ?? this.ruleId,
      packageName: packageName ?? this.packageName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<String>(ruleId.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestrictionTargetsCompanion(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('packageName: $packageName')
          ..write(')'))
        .toString();
  }
}

class $RestrictionOverridesTable extends RestrictionOverrides
    with TableInfo<$RestrictionOverridesTable, RestrictionOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestrictionOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<String> ruleId = GeneratedColumn<String>(
    'rule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _overrideUntilMsMeta = const VerificationMeta(
    'overrideUntilMs',
  );
  @override
  late final GeneratedColumn<int> overrideUntilMs = GeneratedColumn<int>(
    'override_until_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ruleId,
    packageName,
    overrideUntilMs,
    durationMinutes,
    reason,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'restriction_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<RestrictionOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rule_id')) {
      context.handle(
        _ruleIdMeta,
        ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ruleIdMeta);
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('override_until_ms')) {
      context.handle(
        _overrideUntilMsMeta,
        overrideUntilMs.isAcceptableOrUnknown(
          data['override_until_ms']!,
          _overrideUntilMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_overrideUntilMsMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestrictionOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestrictionOverride(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ruleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_id'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      overrideUntilMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}override_until_ms'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RestrictionOverridesTable createAlias(String alias) {
    return $RestrictionOverridesTable(attachedDatabase, alias);
  }
}

class RestrictionOverride extends DataClass
    implements Insertable<RestrictionOverride> {
  final int id;
  final String ruleId;
  final String packageName;
  final int overrideUntilMs;
  final int durationMinutes;
  final String? reason;
  final DateTime createdAt;
  const RestrictionOverride({
    required this.id,
    required this.ruleId,
    required this.packageName,
    required this.overrideUntilMs,
    required this.durationMinutes,
    this.reason,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['rule_id'] = Variable<String>(ruleId);
    map['package_name'] = Variable<String>(packageName);
    map['override_until_ms'] = Variable<int>(overrideUntilMs);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RestrictionOverridesCompanion toCompanion(bool nullToAbsent) {
    return RestrictionOverridesCompanion(
      id: Value(id),
      ruleId: Value(ruleId),
      packageName: Value(packageName),
      overrideUntilMs: Value(overrideUntilMs),
      durationMinutes: Value(durationMinutes),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      createdAt: Value(createdAt),
    );
  }

  factory RestrictionOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestrictionOverride(
      id: serializer.fromJson<int>(json['id']),
      ruleId: serializer.fromJson<String>(json['ruleId']),
      packageName: serializer.fromJson<String>(json['packageName']),
      overrideUntilMs: serializer.fromJson<int>(json['overrideUntilMs']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      reason: serializer.fromJson<String?>(json['reason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ruleId': serializer.toJson<String>(ruleId),
      'packageName': serializer.toJson<String>(packageName),
      'overrideUntilMs': serializer.toJson<int>(overrideUntilMs),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'reason': serializer.toJson<String?>(reason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RestrictionOverride copyWith({
    int? id,
    String? ruleId,
    String? packageName,
    int? overrideUntilMs,
    int? durationMinutes,
    Value<String?> reason = const Value.absent(),
    DateTime? createdAt,
  }) => RestrictionOverride(
    id: id ?? this.id,
    ruleId: ruleId ?? this.ruleId,
    packageName: packageName ?? this.packageName,
    overrideUntilMs: overrideUntilMs ?? this.overrideUntilMs,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    reason: reason.present ? reason.value : this.reason,
    createdAt: createdAt ?? this.createdAt,
  );
  RestrictionOverride copyWithCompanion(RestrictionOverridesCompanion data) {
    return RestrictionOverride(
      id: data.id.present ? data.id.value : this.id,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      overrideUntilMs: data.overrideUntilMs.present
          ? data.overrideUntilMs.value
          : this.overrideUntilMs,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestrictionOverride(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('packageName: $packageName, ')
          ..write('overrideUntilMs: $overrideUntilMs, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ruleId,
    packageName,
    overrideUntilMs,
    durationMinutes,
    reason,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestrictionOverride &&
          other.id == this.id &&
          other.ruleId == this.ruleId &&
          other.packageName == this.packageName &&
          other.overrideUntilMs == this.overrideUntilMs &&
          other.durationMinutes == this.durationMinutes &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt);
}

class RestrictionOverridesCompanion
    extends UpdateCompanion<RestrictionOverride> {
  final Value<int> id;
  final Value<String> ruleId;
  final Value<String> packageName;
  final Value<int> overrideUntilMs;
  final Value<int> durationMinutes;
  final Value<String?> reason;
  final Value<DateTime> createdAt;
  const RestrictionOverridesCompanion({
    this.id = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.packageName = const Value.absent(),
    this.overrideUntilMs = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RestrictionOverridesCompanion.insert({
    this.id = const Value.absent(),
    required String ruleId,
    required String packageName,
    required int overrideUntilMs,
    required int durationMinutes,
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : ruleId = Value(ruleId),
       packageName = Value(packageName),
       overrideUntilMs = Value(overrideUntilMs),
       durationMinutes = Value(durationMinutes);
  static Insertable<RestrictionOverride> custom({
    Expression<int>? id,
    Expression<String>? ruleId,
    Expression<String>? packageName,
    Expression<int>? overrideUntilMs,
    Expression<int>? durationMinutes,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleId != null) 'rule_id': ruleId,
      if (packageName != null) 'package_name': packageName,
      if (overrideUntilMs != null) 'override_until_ms': overrideUntilMs,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RestrictionOverridesCompanion copyWith({
    Value<int>? id,
    Value<String>? ruleId,
    Value<String>? packageName,
    Value<int>? overrideUntilMs,
    Value<int>? durationMinutes,
    Value<String?>? reason,
    Value<DateTime>? createdAt,
  }) {
    return RestrictionOverridesCompanion(
      id: id ?? this.id,
      ruleId: ruleId ?? this.ruleId,
      packageName: packageName ?? this.packageName,
      overrideUntilMs: overrideUntilMs ?? this.overrideUntilMs,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<String>(ruleId.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (overrideUntilMs.present) {
      map['override_until_ms'] = Variable<int>(overrideUntilMs.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestrictionOverridesCompanion(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('packageName: $packageName, ')
          ..write('overrideUntilMs: $overrideUntilMs, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FocusProfilesTable extends FocusProfiles
    with TableInfo<$FocusProfilesTable, FocusProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(25),
  );
  static const VerificationMeta _shortBreakMinutesMeta = const VerificationMeta(
    'shortBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> shortBreakMinutes = GeneratedColumn<int>(
    'short_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _longBreakMinutesMeta = const VerificationMeta(
    'longBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> longBreakMinutes = GeneratedColumn<int>(
    'long_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _cyclesMeta = const VerificationMeta('cycles');
  @override
  late final GeneratedColumn<int> cycles = GeneratedColumn<int>(
    'cycles',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _allowlistOnlyMeta = const VerificationMeta(
    'allowlistOnly',
  );
  @override
  late final GeneratedColumn<bool> allowlistOnly = GeneratedColumn<bool>(
    'allowlist_only',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("allowlist_only" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    durationMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    cycles,
    allowlistOnly,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('short_break_minutes')) {
      context.handle(
        _shortBreakMinutesMeta,
        shortBreakMinutes.isAcceptableOrUnknown(
          data['short_break_minutes']!,
          _shortBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('long_break_minutes')) {
      context.handle(
        _longBreakMinutesMeta,
        longBreakMinutes.isAcceptableOrUnknown(
          data['long_break_minutes']!,
          _longBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('cycles')) {
      context.handle(
        _cyclesMeta,
        cycles.isAcceptableOrUnknown(data['cycles']!, _cyclesMeta),
      );
    }
    if (data.containsKey('allowlist_only')) {
      context.handle(
        _allowlistOnlyMeta,
        allowlistOnly.isAcceptableOrUnknown(
          data['allowlist_only']!,
          _allowlistOnlyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      shortBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}short_break_minutes'],
      )!,
      longBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}long_break_minutes'],
      )!,
      cycles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycles'],
      )!,
      allowlistOnly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}allowlist_only'],
      )!,
    );
  }

  @override
  $FocusProfilesTable createAlias(String alias) {
    return $FocusProfilesTable(attachedDatabase, alias);
  }
}

class FocusProfile extends DataClass implements Insertable<FocusProfile> {
  final String id;
  final String name;
  final int durationMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int cycles;
  final bool allowlistOnly;
  const FocusProfile({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.cycles,
    required this.allowlistOnly,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['short_break_minutes'] = Variable<int>(shortBreakMinutes);
    map['long_break_minutes'] = Variable<int>(longBreakMinutes);
    map['cycles'] = Variable<int>(cycles);
    map['allowlist_only'] = Variable<bool>(allowlistOnly);
    return map;
  }

  FocusProfilesCompanion toCompanion(bool nullToAbsent) {
    return FocusProfilesCompanion(
      id: Value(id),
      name: Value(name),
      durationMinutes: Value(durationMinutes),
      shortBreakMinutes: Value(shortBreakMinutes),
      longBreakMinutes: Value(longBreakMinutes),
      cycles: Value(cycles),
      allowlistOnly: Value(allowlistOnly),
    );
  }

  factory FocusProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusProfile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      shortBreakMinutes: serializer.fromJson<int>(json['shortBreakMinutes']),
      longBreakMinutes: serializer.fromJson<int>(json['longBreakMinutes']),
      cycles: serializer.fromJson<int>(json['cycles']),
      allowlistOnly: serializer.fromJson<bool>(json['allowlistOnly']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'shortBreakMinutes': serializer.toJson<int>(shortBreakMinutes),
      'longBreakMinutes': serializer.toJson<int>(longBreakMinutes),
      'cycles': serializer.toJson<int>(cycles),
      'allowlistOnly': serializer.toJson<bool>(allowlistOnly),
    };
  }

  FocusProfile copyWith({
    String? id,
    String? name,
    int? durationMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? cycles,
    bool? allowlistOnly,
  }) => FocusProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
    longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
    cycles: cycles ?? this.cycles,
    allowlistOnly: allowlistOnly ?? this.allowlistOnly,
  );
  FocusProfile copyWithCompanion(FocusProfilesCompanion data) {
    return FocusProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      shortBreakMinutes: data.shortBreakMinutes.present
          ? data.shortBreakMinutes.value
          : this.shortBreakMinutes,
      longBreakMinutes: data.longBreakMinutes.present
          ? data.longBreakMinutes.value
          : this.longBreakMinutes,
      cycles: data.cycles.present ? data.cycles.value : this.cycles,
      allowlistOnly: data.allowlistOnly.present
          ? data.allowlistOnly.value
          : this.allowlistOnly,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('shortBreakMinutes: $shortBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('cycles: $cycles, ')
          ..write('allowlistOnly: $allowlistOnly')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    durationMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    cycles,
    allowlistOnly,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.durationMinutes == this.durationMinutes &&
          other.shortBreakMinutes == this.shortBreakMinutes &&
          other.longBreakMinutes == this.longBreakMinutes &&
          other.cycles == this.cycles &&
          other.allowlistOnly == this.allowlistOnly);
}

class FocusProfilesCompanion extends UpdateCompanion<FocusProfile> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> durationMinutes;
  final Value<int> shortBreakMinutes;
  final Value<int> longBreakMinutes;
  final Value<int> cycles;
  final Value<bool> allowlistOnly;
  final Value<int> rowid;
  const FocusProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.shortBreakMinutes = const Value.absent(),
    this.longBreakMinutes = const Value.absent(),
    this.cycles = const Value.absent(),
    this.allowlistOnly = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusProfilesCompanion.insert({
    required String id,
    required String name,
    this.durationMinutes = const Value.absent(),
    this.shortBreakMinutes = const Value.absent(),
    this.longBreakMinutes = const Value.absent(),
    this.cycles = const Value.absent(),
    this.allowlistOnly = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<FocusProfile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? durationMinutes,
    Expression<int>? shortBreakMinutes,
    Expression<int>? longBreakMinutes,
    Expression<int>? cycles,
    Expression<bool>? allowlistOnly,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (shortBreakMinutes != null) 'short_break_minutes': shortBreakMinutes,
      if (longBreakMinutes != null) 'long_break_minutes': longBreakMinutes,
      if (cycles != null) 'cycles': cycles,
      if (allowlistOnly != null) 'allowlist_only': allowlistOnly,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? durationMinutes,
    Value<int>? shortBreakMinutes,
    Value<int>? longBreakMinutes,
    Value<int>? cycles,
    Value<bool>? allowlistOnly,
    Value<int>? rowid,
  }) {
    return FocusProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      cycles: cycles ?? this.cycles,
      allowlistOnly: allowlistOnly ?? this.allowlistOnly,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (shortBreakMinutes.present) {
      map['short_break_minutes'] = Variable<int>(shortBreakMinutes.value);
    }
    if (longBreakMinutes.present) {
      map['long_break_minutes'] = Variable<int>(longBreakMinutes.value);
    }
    if (cycles.present) {
      map['cycles'] = Variable<int>(cycles.value);
    }
    if (allowlistOnly.present) {
      map['allowlist_only'] = Variable<bool>(allowlistOnly.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('shortBreakMinutes: $shortBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('cycles: $cycles, ')
          ..write('allowlistOnly: $allowlistOnly, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtUtcMsMeta = const VerificationMeta(
    'startedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> startedAtUtcMs = GeneratedColumn<int>(
    'started_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDurationMinutesMeta =
      const VerificationMeta('targetDurationMinutes');
  @override
  late final GeneratedColumn<int> targetDurationMinutes = GeneratedColumn<int>(
    'target_duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMinutesMeta = const VerificationMeta(
    'completedMinutes',
  );
  @override
  late final GeneratedColumn<int> completedMinutes = GeneratedColumn<int>(
    'completed_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pausedRemainingSecondsMeta =
      const VerificationMeta('pausedRemainingSeconds');
  @override
  late final GeneratedColumn<int> pausedRemainingSeconds = GeneratedColumn<int>(
    'paused_remaining_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _endedAtUtcMsMeta = const VerificationMeta(
    'endedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> endedAtUtcMs = GeneratedColumn<int>(
    'ended_at_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    startedAtUtcMs,
    targetDurationMinutes,
    completedMinutes,
    status,
    pausedRemainingSeconds,
    endedAtUtcMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    }
    if (data.containsKey('started_at_utc_ms')) {
      context.handle(
        _startedAtUtcMsMeta,
        startedAtUtcMs.isAcceptableOrUnknown(
          data['started_at_utc_ms']!,
          _startedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtUtcMsMeta);
    }
    if (data.containsKey('target_duration_minutes')) {
      context.handle(
        _targetDurationMinutesMeta,
        targetDurationMinutes.isAcceptableOrUnknown(
          data['target_duration_minutes']!,
          _targetDurationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetDurationMinutesMeta);
    }
    if (data.containsKey('completed_minutes')) {
      context.handle(
        _completedMinutesMeta,
        completedMinutes.isAcceptableOrUnknown(
          data['completed_minutes']!,
          _completedMinutesMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('paused_remaining_seconds')) {
      context.handle(
        _pausedRemainingSecondsMeta,
        pausedRemainingSeconds.isAcceptableOrUnknown(
          data['paused_remaining_seconds']!,
          _pausedRemainingSecondsMeta,
        ),
      );
    }
    if (data.containsKey('ended_at_utc_ms')) {
      context.handle(
        _endedAtUtcMsMeta,
        endedAtUtcMs.isAcceptableOrUnknown(
          data['ended_at_utc_ms']!,
          _endedAtUtcMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      ),
      startedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_utc_ms'],
      )!,
      targetDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_duration_minutes'],
      )!,
      completedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_minutes'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      pausedRemainingSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paused_remaining_seconds'],
      )!,
      endedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at_utc_ms'],
      ),
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }
}

class FocusSession extends DataClass implements Insertable<FocusSession> {
  final String id;
  final String? profileId;
  final int startedAtUtcMs;
  final int targetDurationMinutes;
  final int completedMinutes;
  final String status;
  final int pausedRemainingSeconds;
  final int? endedAtUtcMs;
  const FocusSession({
    required this.id,
    this.profileId,
    required this.startedAtUtcMs,
    required this.targetDurationMinutes,
    required this.completedMinutes,
    required this.status,
    required this.pausedRemainingSeconds,
    this.endedAtUtcMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || profileId != null) {
      map['profile_id'] = Variable<String>(profileId);
    }
    map['started_at_utc_ms'] = Variable<int>(startedAtUtcMs);
    map['target_duration_minutes'] = Variable<int>(targetDurationMinutes);
    map['completed_minutes'] = Variable<int>(completedMinutes);
    map['status'] = Variable<String>(status);
    map['paused_remaining_seconds'] = Variable<int>(pausedRemainingSeconds);
    if (!nullToAbsent || endedAtUtcMs != null) {
      map['ended_at_utc_ms'] = Variable<int>(endedAtUtcMs);
    }
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      profileId: profileId == null && nullToAbsent
          ? const Value.absent()
          : Value(profileId),
      startedAtUtcMs: Value(startedAtUtcMs),
      targetDurationMinutes: Value(targetDurationMinutes),
      completedMinutes: Value(completedMinutes),
      status: Value(status),
      pausedRemainingSeconds: Value(pausedRemainingSeconds),
      endedAtUtcMs: endedAtUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAtUtcMs),
    );
  }

  factory FocusSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSession(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String?>(json['profileId']),
      startedAtUtcMs: serializer.fromJson<int>(json['startedAtUtcMs']),
      targetDurationMinutes: serializer.fromJson<int>(
        json['targetDurationMinutes'],
      ),
      completedMinutes: serializer.fromJson<int>(json['completedMinutes']),
      status: serializer.fromJson<String>(json['status']),
      pausedRemainingSeconds: serializer.fromJson<int>(
        json['pausedRemainingSeconds'],
      ),
      endedAtUtcMs: serializer.fromJson<int?>(json['endedAtUtcMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String?>(profileId),
      'startedAtUtcMs': serializer.toJson<int>(startedAtUtcMs),
      'targetDurationMinutes': serializer.toJson<int>(targetDurationMinutes),
      'completedMinutes': serializer.toJson<int>(completedMinutes),
      'status': serializer.toJson<String>(status),
      'pausedRemainingSeconds': serializer.toJson<int>(pausedRemainingSeconds),
      'endedAtUtcMs': serializer.toJson<int?>(endedAtUtcMs),
    };
  }

  FocusSession copyWith({
    String? id,
    Value<String?> profileId = const Value.absent(),
    int? startedAtUtcMs,
    int? targetDurationMinutes,
    int? completedMinutes,
    String? status,
    int? pausedRemainingSeconds,
    Value<int?> endedAtUtcMs = const Value.absent(),
  }) => FocusSession(
    id: id ?? this.id,
    profileId: profileId.present ? profileId.value : this.profileId,
    startedAtUtcMs: startedAtUtcMs ?? this.startedAtUtcMs,
    targetDurationMinutes: targetDurationMinutes ?? this.targetDurationMinutes,
    completedMinutes: completedMinutes ?? this.completedMinutes,
    status: status ?? this.status,
    pausedRemainingSeconds:
        pausedRemainingSeconds ?? this.pausedRemainingSeconds,
    endedAtUtcMs: endedAtUtcMs.present ? endedAtUtcMs.value : this.endedAtUtcMs,
  );
  FocusSession copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSession(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      startedAtUtcMs: data.startedAtUtcMs.present
          ? data.startedAtUtcMs.value
          : this.startedAtUtcMs,
      targetDurationMinutes: data.targetDurationMinutes.present
          ? data.targetDurationMinutes.value
          : this.targetDurationMinutes,
      completedMinutes: data.completedMinutes.present
          ? data.completedMinutes.value
          : this.completedMinutes,
      status: data.status.present ? data.status.value : this.status,
      pausedRemainingSeconds: data.pausedRemainingSeconds.present
          ? data.pausedRemainingSeconds.value
          : this.pausedRemainingSeconds,
      endedAtUtcMs: data.endedAtUtcMs.present
          ? data.endedAtUtcMs.value
          : this.endedAtUtcMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSession(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('startedAtUtcMs: $startedAtUtcMs, ')
          ..write('targetDurationMinutes: $targetDurationMinutes, ')
          ..write('completedMinutes: $completedMinutes, ')
          ..write('status: $status, ')
          ..write('pausedRemainingSeconds: $pausedRemainingSeconds, ')
          ..write('endedAtUtcMs: $endedAtUtcMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    startedAtUtcMs,
    targetDurationMinutes,
    completedMinutes,
    status,
    pausedRemainingSeconds,
    endedAtUtcMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSession &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.startedAtUtcMs == this.startedAtUtcMs &&
          other.targetDurationMinutes == this.targetDurationMinutes &&
          other.completedMinutes == this.completedMinutes &&
          other.status == this.status &&
          other.pausedRemainingSeconds == this.pausedRemainingSeconds &&
          other.endedAtUtcMs == this.endedAtUtcMs);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSession> {
  final Value<String> id;
  final Value<String?> profileId;
  final Value<int> startedAtUtcMs;
  final Value<int> targetDurationMinutes;
  final Value<int> completedMinutes;
  final Value<String> status;
  final Value<int> pausedRemainingSeconds;
  final Value<int?> endedAtUtcMs;
  final Value<int> rowid;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.startedAtUtcMs = const Value.absent(),
    this.targetDurationMinutes = const Value.absent(),
    this.completedMinutes = const Value.absent(),
    this.status = const Value.absent(),
    this.pausedRemainingSeconds = const Value.absent(),
    this.endedAtUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    required String id,
    this.profileId = const Value.absent(),
    required int startedAtUtcMs,
    required int targetDurationMinutes,
    this.completedMinutes = const Value.absent(),
    required String status,
    this.pausedRemainingSeconds = const Value.absent(),
    this.endedAtUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAtUtcMs = Value(startedAtUtcMs),
       targetDurationMinutes = Value(targetDurationMinutes),
       status = Value(status);
  static Insertable<FocusSession> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<int>? startedAtUtcMs,
    Expression<int>? targetDurationMinutes,
    Expression<int>? completedMinutes,
    Expression<String>? status,
    Expression<int>? pausedRemainingSeconds,
    Expression<int>? endedAtUtcMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (startedAtUtcMs != null) 'started_at_utc_ms': startedAtUtcMs,
      if (targetDurationMinutes != null)
        'target_duration_minutes': targetDurationMinutes,
      if (completedMinutes != null) 'completed_minutes': completedMinutes,
      if (status != null) 'status': status,
      if (pausedRemainingSeconds != null)
        'paused_remaining_seconds': pausedRemainingSeconds,
      if (endedAtUtcMs != null) 'ended_at_utc_ms': endedAtUtcMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusSessionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? profileId,
    Value<int>? startedAtUtcMs,
    Value<int>? targetDurationMinutes,
    Value<int>? completedMinutes,
    Value<String>? status,
    Value<int>? pausedRemainingSeconds,
    Value<int?>? endedAtUtcMs,
    Value<int>? rowid,
  }) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      startedAtUtcMs: startedAtUtcMs ?? this.startedAtUtcMs,
      targetDurationMinutes:
          targetDurationMinutes ?? this.targetDurationMinutes,
      completedMinutes: completedMinutes ?? this.completedMinutes,
      status: status ?? this.status,
      pausedRemainingSeconds:
          pausedRemainingSeconds ?? this.pausedRemainingSeconds,
      endedAtUtcMs: endedAtUtcMs ?? this.endedAtUtcMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (startedAtUtcMs.present) {
      map['started_at_utc_ms'] = Variable<int>(startedAtUtcMs.value);
    }
    if (targetDurationMinutes.present) {
      map['target_duration_minutes'] = Variable<int>(
        targetDurationMinutes.value,
      );
    }
    if (completedMinutes.present) {
      map['completed_minutes'] = Variable<int>(completedMinutes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (pausedRemainingSeconds.present) {
      map['paused_remaining_seconds'] = Variable<int>(
        pausedRemainingSeconds.value,
      );
    }
    if (endedAtUtcMs.present) {
      map['ended_at_utc_ms'] = Variable<int>(endedAtUtcMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('startedAtUtcMs: $startedAtUtcMs, ')
          ..write('targetDurationMinutes: $targetDurationMinutes, ')
          ..write('completedMinutes: $completedMinutes, ')
          ..write('status: $status, ')
          ..write('pausedRemainingSeconds: $pausedRemainingSeconds, ')
          ..write('endedAtUtcMs: $endedAtUtcMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinuteOfDayMeta = const VerificationMeta(
    'startMinuteOfDay',
  );
  @override
  late final GeneratedColumn<int> startMinuteOfDay = GeneratedColumn<int>(
    'start_minute_of_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysOfWeekMeta = const VerificationMeta(
    'daysOfWeek',
  );
  @override
  late final GeneratedColumn<String> daysOfWeek = GeneratedColumn<String>(
    'days_of_week',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1,2,3,4,5,6,7'),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    startMinuteOfDay,
    daysOfWeek,
    isEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Routine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('start_minute_of_day')) {
      context.handle(
        _startMinuteOfDayMeta,
        startMinuteOfDay.isAcceptableOrUnknown(
          data['start_minute_of_day']!,
          _startMinuteOfDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinuteOfDayMeta);
    }
    if (data.containsKey('days_of_week')) {
      context.handle(
        _daysOfWeekMeta,
        daysOfWeek.isAcceptableOrUnknown(
          data['days_of_week']!,
          _daysOfWeekMeta,
        ),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      startMinuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute_of_day'],
      )!,
      daysOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}days_of_week'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class Routine extends DataClass implements Insertable<Routine> {
  final String id;
  final String name;
  final String type;
  final int startMinuteOfDay;
  final String daysOfWeek;
  final bool isEnabled;
  const Routine({
    required this.id,
    required this.name,
    required this.type,
    required this.startMinuteOfDay,
    required this.daysOfWeek,
    required this.isEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['start_minute_of_day'] = Variable<int>(startMinuteOfDay);
    map['days_of_week'] = Variable<String>(daysOfWeek);
    map['is_enabled'] = Variable<bool>(isEnabled);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      startMinuteOfDay: Value(startMinuteOfDay),
      daysOfWeek: Value(daysOfWeek),
      isEnabled: Value(isEnabled),
    );
  }

  factory Routine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      startMinuteOfDay: serializer.fromJson<int>(json['startMinuteOfDay']),
      daysOfWeek: serializer.fromJson<String>(json['daysOfWeek']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'startMinuteOfDay': serializer.toJson<int>(startMinuteOfDay),
      'daysOfWeek': serializer.toJson<String>(daysOfWeek),
      'isEnabled': serializer.toJson<bool>(isEnabled),
    };
  }

  Routine copyWith({
    String? id,
    String? name,
    String? type,
    int? startMinuteOfDay,
    String? daysOfWeek,
    bool? isEnabled,
  }) => Routine(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    startMinuteOfDay: startMinuteOfDay ?? this.startMinuteOfDay,
    daysOfWeek: daysOfWeek ?? this.daysOfWeek,
    isEnabled: isEnabled ?? this.isEnabled,
  );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      startMinuteOfDay: data.startMinuteOfDay.present
          ? data.startMinuteOfDay.value
          : this.startMinuteOfDay,
      daysOfWeek: data.daysOfWeek.present
          ? data.daysOfWeek.value
          : this.daysOfWeek,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('startMinuteOfDay: $startMinuteOfDay, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('isEnabled: $isEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, type, startMinuteOfDay, daysOfWeek, isEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.startMinuteOfDay == this.startMinuteOfDay &&
          other.daysOfWeek == this.daysOfWeek &&
          other.isEnabled == this.isEnabled);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<int> startMinuteOfDay;
  final Value<String> daysOfWeek;
  final Value<bool> isEnabled;
  final Value<int> rowid;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.startMinuteOfDay = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutinesCompanion.insert({
    required String id,
    required String name,
    required String type,
    required int startMinuteOfDay,
    this.daysOfWeek = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       startMinuteOfDay = Value(startMinuteOfDay);
  static Insertable<Routine> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? startMinuteOfDay,
    Expression<String>? daysOfWeek,
    Expression<bool>? isEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (startMinuteOfDay != null) 'start_minute_of_day': startMinuteOfDay,
      if (daysOfWeek != null) 'days_of_week': daysOfWeek,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutinesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<int>? startMinuteOfDay,
    Value<String>? daysOfWeek,
    Value<bool>? isEnabled,
    Value<int>? rowid,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      startMinuteOfDay: startMinuteOfDay ?? this.startMinuteOfDay,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isEnabled: isEnabled ?? this.isEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (startMinuteOfDay.present) {
      map['start_minute_of_day'] = Variable<int>(startMinuteOfDay.value);
    }
    if (daysOfWeek.present) {
      map['days_of_week'] = Variable<String>(daysOfWeek.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('startMinuteOfDay: $startMinuteOfDay, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineStepsTable extends RoutineSteps
    with TableInfo<$RoutineStepsTable, RoutineStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    routineId,
    title,
    orderIndex,
    isCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineStep> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineStep(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
    );
  }

  @override
  $RoutineStepsTable createAlias(String alias) {
    return $RoutineStepsTable(attachedDatabase, alias);
  }
}

class RoutineStep extends DataClass implements Insertable<RoutineStep> {
  final int id;
  final String routineId;
  final String title;
  final int orderIndex;
  final bool isCompleted;
  const RoutineStep({
    required this.id,
    required this.routineId,
    required this.title,
    required this.orderIndex,
    required this.isCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['routine_id'] = Variable<String>(routineId);
    map['title'] = Variable<String>(title);
    map['order_index'] = Variable<int>(orderIndex);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  RoutineStepsCompanion toCompanion(bool nullToAbsent) {
    return RoutineStepsCompanion(
      id: Value(id),
      routineId: Value(routineId),
      title: Value(title),
      orderIndex: Value(orderIndex),
      isCompleted: Value(isCompleted),
    );
  }

  factory RoutineStep.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineStep(
      id: serializer.fromJson<int>(json['id']),
      routineId: serializer.fromJson<String>(json['routineId']),
      title: serializer.fromJson<String>(json['title']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routineId': serializer.toJson<String>(routineId),
      'title': serializer.toJson<String>(title),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  RoutineStep copyWith({
    int? id,
    String? routineId,
    String? title,
    int? orderIndex,
    bool? isCompleted,
  }) => RoutineStep(
    id: id ?? this.id,
    routineId: routineId ?? this.routineId,
    title: title ?? this.title,
    orderIndex: orderIndex ?? this.orderIndex,
    isCompleted: isCompleted ?? this.isCompleted,
  );
  RoutineStep copyWithCompanion(RoutineStepsCompanion data) {
    return RoutineStep(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      title: data.title.present ? data.title.value : this.title,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineStep(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, routineId, title, orderIndex, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineStep &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.title == this.title &&
          other.orderIndex == this.orderIndex &&
          other.isCompleted == this.isCompleted);
}

class RoutineStepsCompanion extends UpdateCompanion<RoutineStep> {
  final Value<int> id;
  final Value<String> routineId;
  final Value<String> title;
  final Value<int> orderIndex;
  final Value<bool> isCompleted;
  const RoutineStepsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.title = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.isCompleted = const Value.absent(),
  });
  RoutineStepsCompanion.insert({
    this.id = const Value.absent(),
    required String routineId,
    required String title,
    this.orderIndex = const Value.absent(),
    this.isCompleted = const Value.absent(),
  }) : routineId = Value(routineId),
       title = Value(title);
  static Insertable<RoutineStep> custom({
    Expression<int>? id,
    Expression<String>? routineId,
    Expression<String>? title,
    Expression<int>? orderIndex,
    Expression<bool>? isCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (title != null) 'title': title,
      if (orderIndex != null) 'order_index': orderIndex,
      if (isCompleted != null) 'is_completed': isCompleted,
    });
  }

  RoutineStepsCompanion copyWith({
    Value<int>? id,
    Value<String>? routineId,
    Value<String>? title,
    Value<int>? orderIndex,
    Value<bool>? isCompleted,
  }) {
    return RoutineStepsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      title: title ?? this.title,
      orderIndex: orderIndex ?? this.orderIndex,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineStepsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('General'),
  );
  static const VerificationMeta _targetDaysPerWeekMeta = const VerificationMeta(
    'targetDaysPerWeek',
  );
  @override
  late final GeneratedColumn<int> targetDaysPerWeek = GeneratedColumn<int>(
    'target_days_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  static const VerificationMeta _targetMinutesMeta = const VerificationMeta(
    'targetMinutes',
  );
  @override
  late final GeneratedColumn<int> targetMinutes = GeneratedColumn<int>(
    'target_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAvoidanceMeta = const VerificationMeta(
    'isAvoidance',
  );
  @override
  late final GeneratedColumn<bool> isAvoidance = GeneratedColumn<bool>(
    'is_avoidance',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_avoidance" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    category,
    targetDaysPerWeek,
    targetMinutes,
    isAvoidance,
    isArchived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('target_days_per_week')) {
      context.handle(
        _targetDaysPerWeekMeta,
        targetDaysPerWeek.isAcceptableOrUnknown(
          data['target_days_per_week']!,
          _targetDaysPerWeekMeta,
        ),
      );
    }
    if (data.containsKey('target_minutes')) {
      context.handle(
        _targetMinutesMeta,
        targetMinutes.isAcceptableOrUnknown(
          data['target_minutes']!,
          _targetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('is_avoidance')) {
      context.handle(
        _isAvoidanceMeta,
        isAvoidance.isAcceptableOrUnknown(
          data['is_avoidance']!,
          _isAvoidanceMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      targetDaysPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_days_per_week'],
      )!,
      targetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_minutes'],
      ),
      isAvoidance: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_avoidance'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final String id;
  final String title;
  final String? description;
  final String category;
  final int targetDaysPerWeek;
  final int? targetMinutes;
  final bool isAvoidance;
  final bool isArchived;
  final DateTime createdAt;
  const Habit({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.targetDaysPerWeek,
    this.targetMinutes,
    required this.isAvoidance,
    required this.isArchived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['category'] = Variable<String>(category);
    map['target_days_per_week'] = Variable<int>(targetDaysPerWeek);
    if (!nullToAbsent || targetMinutes != null) {
      map['target_minutes'] = Variable<int>(targetMinutes);
    }
    map['is_avoidance'] = Variable<bool>(isAvoidance);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: Value(category),
      targetDaysPerWeek: Value(targetDaysPerWeek),
      targetMinutes: targetMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(targetMinutes),
      isAvoidance: Value(isAvoidance),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      targetDaysPerWeek: serializer.fromJson<int>(json['targetDaysPerWeek']),
      targetMinutes: serializer.fromJson<int?>(json['targetMinutes']),
      isAvoidance: serializer.fromJson<bool>(json['isAvoidance']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String>(category),
      'targetDaysPerWeek': serializer.toJson<int>(targetDaysPerWeek),
      'targetMinutes': serializer.toJson<int?>(targetMinutes),
      'isAvoidance': serializer.toJson<bool>(isAvoidance),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Habit copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    String? category,
    int? targetDaysPerWeek,
    Value<int?> targetMinutes = const Value.absent(),
    bool? isAvoidance,
    bool? isArchived,
    DateTime? createdAt,
  }) => Habit(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    category: category ?? this.category,
    targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
    targetMinutes: targetMinutes.present
        ? targetMinutes.value
        : this.targetMinutes,
    isAvoidance: isAvoidance ?? this.isAvoidance,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      targetDaysPerWeek: data.targetDaysPerWeek.present
          ? data.targetDaysPerWeek.value
          : this.targetDaysPerWeek,
      targetMinutes: data.targetMinutes.present
          ? data.targetMinutes.value
          : this.targetMinutes,
      isAvoidance: data.isAvoidance.present
          ? data.isAvoidance.value
          : this.isAvoidance,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('targetDaysPerWeek: $targetDaysPerWeek, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('isAvoidance: $isAvoidance, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    category,
    targetDaysPerWeek,
    targetMinutes,
    isAvoidance,
    isArchived,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.targetDaysPerWeek == this.targetDaysPerWeek &&
          other.targetMinutes == this.targetMinutes &&
          other.isAvoidance == this.isAvoidance &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> category;
  final Value<int> targetDaysPerWeek;
  final Value<int?> targetMinutes;
  final Value<bool> isAvoidance;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.targetDaysPerWeek = const Value.absent(),
    this.targetMinutes = const Value.absent(),
    this.isAvoidance = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.targetDaysPerWeek = const Value.absent(),
    this.targetMinutes = const Value.absent(),
    this.isAvoidance = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<Habit> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<int>? targetDaysPerWeek,
    Expression<int>? targetMinutes,
    Expression<bool>? isAvoidance,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (targetDaysPerWeek != null) 'target_days_per_week': targetDaysPerWeek,
      if (targetMinutes != null) 'target_minutes': targetMinutes,
      if (isAvoidance != null) 'is_avoidance': isAvoidance,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? category,
    Value<int>? targetDaysPerWeek,
    Value<int?>? targetMinutes,
    Value<bool>? isAvoidance,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      isAvoidance: isAvoidance ?? this.isAvoidance,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (targetDaysPerWeek.present) {
      map['target_days_per_week'] = Variable<int>(targetDaysPerWeek.value);
    }
    if (targetMinutes.present) {
      map['target_minutes'] = Variable<int>(targetMinutes.value);
    }
    if (isAvoidance.present) {
      map['is_avoidance'] = Variable<bool>(isAvoidance.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('targetDaysPerWeek: $targetDaysPerWeek, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('isAvoidance: $isAvoidance, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitEntriesTable extends HabitEntries
    with TableInfo<$HabitEntriesTable, HabitEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    date,
    completed,
    value,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {habitId, date},
  ];
  @override
  HabitEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $HabitEntriesTable createAlias(String alias) {
    return $HabitEntriesTable(attachedDatabase, alias);
  }
}

class HabitEntry extends DataClass implements Insertable<HabitEntry> {
  final int id;
  final String habitId;
  final String date;
  final bool completed;
  final int value;
  final String? notes;
  const HabitEntry({
    required this.id,
    required this.habitId,
    required this.date,
    required this.completed,
    required this.value,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['date'] = Variable<String>(date);
    map['completed'] = Variable<bool>(completed);
    map['value'] = Variable<int>(value);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  HabitEntriesCompanion toCompanion(bool nullToAbsent) {
    return HabitEntriesCompanion(
      id: Value(id),
      habitId: Value(habitId),
      date: Value(date),
      completed: Value(completed),
      value: Value(value),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory HabitEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitEntry(
      id: serializer.fromJson<int>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      date: serializer.fromJson<String>(json['date']),
      completed: serializer.fromJson<bool>(json['completed']),
      value: serializer.fromJson<int>(json['value']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'habitId': serializer.toJson<String>(habitId),
      'date': serializer.toJson<String>(date),
      'completed': serializer.toJson<bool>(completed),
      'value': serializer.toJson<int>(value),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  HabitEntry copyWith({
    int? id,
    String? habitId,
    String? date,
    bool? completed,
    int? value,
    Value<String?> notes = const Value.absent(),
  }) => HabitEntry(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    date: date ?? this.date,
    completed: completed ?? this.completed,
    value: value ?? this.value,
    notes: notes.present ? notes.value : this.notes,
  );
  HabitEntry copyWithCompanion(HabitEntriesCompanion data) {
    return HabitEntry(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      date: data.date.present ? data.date.value : this.date,
      completed: data.completed.present ? data.completed.value : this.completed,
      value: data.value.present ? data.value.value : this.value,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntry(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('value: $value, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, date, completed, value, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitEntry &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.date == this.date &&
          other.completed == this.completed &&
          other.value == this.value &&
          other.notes == this.notes);
}

class HabitEntriesCompanion extends UpdateCompanion<HabitEntry> {
  final Value<int> id;
  final Value<String> habitId;
  final Value<String> date;
  final Value<bool> completed;
  final Value<int> value;
  final Value<String?> notes;
  const HabitEntriesCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.date = const Value.absent(),
    this.completed = const Value.absent(),
    this.value = const Value.absent(),
    this.notes = const Value.absent(),
  });
  HabitEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String habitId,
    required String date,
    this.completed = const Value.absent(),
    this.value = const Value.absent(),
    this.notes = const Value.absent(),
  }) : habitId = Value(habitId),
       date = Value(date);
  static Insertable<HabitEntry> custom({
    Expression<int>? id,
    Expression<String>? habitId,
    Expression<String>? date,
    Expression<bool>? completed,
    Expression<int>? value,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (date != null) 'date': date,
      if (completed != null) 'completed': completed,
      if (value != null) 'value': value,
      if (notes != null) 'notes': notes,
    });
  }

  HabitEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? habitId,
    Value<String>? date,
    Value<bool>? completed,
    Value<int>? value,
    Value<String?>? notes,
  }) {
    return HabitEntriesCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      value: value ?? this.value,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntriesCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('value: $value, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $HabitStreaksTable extends HabitStreaks
    with TableInfo<$HabitStreaksTable, HabitStreak> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitStreaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _longestStreakMeta = const VerificationMeta(
    'longestStreak',
  );
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
    'longest_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastCompletedDateMeta = const VerificationMeta(
    'lastCompletedDate',
  );
  @override
  late final GeneratedColumn<String> lastCompletedDate =
      GeneratedColumn<String>(
        'last_completed_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    currentStreak,
    longestStreak,
    lastCompletedDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_streaks';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitStreak> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
        _longestStreakMeta,
        longestStreak.isAcceptableOrUnknown(
          data['longest_streak']!,
          _longestStreakMeta,
        ),
      );
    }
    if (data.containsKey('last_completed_date')) {
      context.handle(
        _lastCompletedDateMeta,
        lastCompletedDate.isAcceptableOrUnknown(
          data['last_completed_date']!,
          _lastCompletedDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitStreak map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitStreak(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      longestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest_streak'],
      )!,
      lastCompletedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_completed_date'],
      ),
    );
  }

  @override
  $HabitStreaksTable createAlias(String alias) {
    return $HabitStreaksTable(attachedDatabase, alias);
  }
}

class HabitStreak extends DataClass implements Insertable<HabitStreak> {
  final int id;
  final String habitId;
  final int currentStreak;
  final int longestStreak;
  final String? lastCompletedDate;
  const HabitStreak({
    required this.id,
    required this.habitId,
    required this.currentStreak,
    required this.longestStreak,
    this.lastCompletedDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    if (!nullToAbsent || lastCompletedDate != null) {
      map['last_completed_date'] = Variable<String>(lastCompletedDate);
    }
    return map;
  }

  HabitStreaksCompanion toCompanion(bool nullToAbsent) {
    return HabitStreaksCompanion(
      id: Value(id),
      habitId: Value(habitId),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      lastCompletedDate: lastCompletedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedDate),
    );
  }

  factory HabitStreak.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitStreak(
      id: serializer.fromJson<int>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      lastCompletedDate: serializer.fromJson<String?>(
        json['lastCompletedDate'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'habitId': serializer.toJson<String>(habitId),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'lastCompletedDate': serializer.toJson<String?>(lastCompletedDate),
    };
  }

  HabitStreak copyWith({
    int? id,
    String? habitId,
    int? currentStreak,
    int? longestStreak,
    Value<String?> lastCompletedDate = const Value.absent(),
  }) => HabitStreak(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    currentStreak: currentStreak ?? this.currentStreak,
    longestStreak: longestStreak ?? this.longestStreak,
    lastCompletedDate: lastCompletedDate.present
        ? lastCompletedDate.value
        : this.lastCompletedDate,
  );
  HabitStreak copyWithCompanion(HabitStreaksCompanion data) {
    return HabitStreak(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      lastCompletedDate: data.lastCompletedDate.present
          ? data.lastCompletedDate.value
          : this.lastCompletedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitStreak(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastCompletedDate: $lastCompletedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, habitId, currentStreak, longestStreak, lastCompletedDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitStreak &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.lastCompletedDate == this.lastCompletedDate);
}

class HabitStreaksCompanion extends UpdateCompanion<HabitStreak> {
  final Value<int> id;
  final Value<String> habitId;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<String?> lastCompletedDate;
  const HabitStreaksCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastCompletedDate = const Value.absent(),
  });
  HabitStreaksCompanion.insert({
    this.id = const Value.absent(),
    required String habitId,
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastCompletedDate = const Value.absent(),
  }) : habitId = Value(habitId);
  static Insertable<HabitStreak> custom({
    Expression<int>? id,
    Expression<String>? habitId,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<String>? lastCompletedDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (lastCompletedDate != null) 'last_completed_date': lastCompletedDate,
    });
  }

  HabitStreaksCompanion copyWith({
    Value<int>? id,
    Value<String>? habitId,
    Value<int>? currentStreak,
    Value<int>? longestStreak,
    Value<String?>? lastCompletedDate,
  }) {
    return HabitStreaksCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (lastCompletedDate.present) {
      map['last_completed_date'] = Variable<String>(lastCompletedDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitStreaksCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastCompletedDate: $lastCompletedDate')
          ..write(')'))
        .toString();
  }
}

class $InsightsTable extends Insights with TableInfo<$InsightsTable, Insight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InsightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _evidenceMeta = const VerificationMeta(
    'evidence',
  );
  @override
  late final GeneratedColumn<String> evidence = GeneratedColumn<String>(
    'evidence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDismissedMeta = const VerificationMeta(
    'isDismissed',
  );
  @override
  late final GeneratedColumn<bool> isDismissed = GeneratedColumn<bool>(
    'is_dismissed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dismissed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    message,
    type,
    evidence,
    isDismissed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'insights';
  @override
  VerificationContext validateIntegrity(
    Insertable<Insight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('evidence')) {
      context.handle(
        _evidenceMeta,
        evidence.isAcceptableOrUnknown(data['evidence']!, _evidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_evidenceMeta);
    }
    if (data.containsKey('is_dismissed')) {
      context.handle(
        _isDismissedMeta,
        isDismissed.isAcceptableOrUnknown(
          data['is_dismissed']!,
          _isDismissedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Insight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Insight(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      evidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence'],
      )!,
      isDismissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dismissed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InsightsTable createAlias(String alias) {
    return $InsightsTable(attachedDatabase, alias);
  }
}

class Insight extends DataClass implements Insertable<Insight> {
  final String id;
  final String title;
  final String message;
  final String type;
  final String evidence;
  final bool isDismissed;
  final DateTime createdAt;
  const Insight({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.evidence,
    required this.isDismissed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['message'] = Variable<String>(message);
    map['type'] = Variable<String>(type);
    map['evidence'] = Variable<String>(evidence);
    map['is_dismissed'] = Variable<bool>(isDismissed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InsightsCompanion toCompanion(bool nullToAbsent) {
    return InsightsCompanion(
      id: Value(id),
      title: Value(title),
      message: Value(message),
      type: Value(type),
      evidence: Value(evidence),
      isDismissed: Value(isDismissed),
      createdAt: Value(createdAt),
    );
  }

  factory Insight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Insight(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      message: serializer.fromJson<String>(json['message']),
      type: serializer.fromJson<String>(json['type']),
      evidence: serializer.fromJson<String>(json['evidence']),
      isDismissed: serializer.fromJson<bool>(json['isDismissed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'message': serializer.toJson<String>(message),
      'type': serializer.toJson<String>(type),
      'evidence': serializer.toJson<String>(evidence),
      'isDismissed': serializer.toJson<bool>(isDismissed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Insight copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    String? evidence,
    bool? isDismissed,
    DateTime? createdAt,
  }) => Insight(
    id: id ?? this.id,
    title: title ?? this.title,
    message: message ?? this.message,
    type: type ?? this.type,
    evidence: evidence ?? this.evidence,
    isDismissed: isDismissed ?? this.isDismissed,
    createdAt: createdAt ?? this.createdAt,
  );
  Insight copyWithCompanion(InsightsCompanion data) {
    return Insight(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      message: data.message.present ? data.message.value : this.message,
      type: data.type.present ? data.type.value : this.type,
      evidence: data.evidence.present ? data.evidence.value : this.evidence,
      isDismissed: data.isDismissed.present
          ? data.isDismissed.value
          : this.isDismissed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Insight(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('type: $type, ')
          ..write('evidence: $evidence, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, message, type, evidence, isDismissed, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Insight &&
          other.id == this.id &&
          other.title == this.title &&
          other.message == this.message &&
          other.type == this.type &&
          other.evidence == this.evidence &&
          other.isDismissed == this.isDismissed &&
          other.createdAt == this.createdAt);
}

class InsightsCompanion extends UpdateCompanion<Insight> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> message;
  final Value<String> type;
  final Value<String> evidence;
  final Value<bool> isDismissed;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const InsightsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.message = const Value.absent(),
    this.type = const Value.absent(),
    this.evidence = const Value.absent(),
    this.isDismissed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InsightsCompanion.insert({
    required String id,
    required String title,
    required String message,
    required String type,
    required String evidence,
    this.isDismissed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       message = Value(message),
       type = Value(type),
       evidence = Value(evidence);
  static Insertable<Insight> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? message,
    Expression<String>? type,
    Expression<String>? evidence,
    Expression<bool>? isDismissed,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (message != null) 'message': message,
      if (type != null) 'type': type,
      if (evidence != null) 'evidence': evidence,
      if (isDismissed != null) 'is_dismissed': isDismissed,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InsightsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? message,
    Value<String>? type,
    Value<String>? evidence,
    Value<bool>? isDismissed,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return InsightsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      evidence: evidence ?? this.evidence,
      isDismissed: isDismissed ?? this.isDismissed,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (evidence.present) {
      map['evidence'] = Variable<String>(evidence.value);
    }
    if (isDismissed.present) {
      map['is_dismissed'] = Variable<bool>(isDismissed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InsightsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('message: $message, ')
          ..write('type: $type, ')
          ..write('evidence: $evidence, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomGoalsTable extends CustomGoals
    with TableInfo<$CustomGoalsTable, CustomGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTypeMeta = const VerificationMeta(
    'targetType',
  );
  @override
  late final GeneratedColumn<String> targetType = GeneratedColumn<String>(
    'target_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetIdentifierMeta = const VerificationMeta(
    'targetIdentifier',
  );
  @override
  late final GeneratedColumn<String> targetIdentifier = GeneratedColumn<String>(
    'target_identifier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _limitMinutesMeta = const VerificationMeta(
    'limitMinutes',
  );
  @override
  late final GeneratedColumn<int> limitMinutes = GeneratedColumn<int>(
    'limit_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetType,
    targetIdentifier,
    limitMinutes,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('target_type')) {
      context.handle(
        _targetTypeMeta,
        targetType.isAcceptableOrUnknown(data['target_type']!, _targetTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_targetTypeMeta);
    }
    if (data.containsKey('target_identifier')) {
      context.handle(
        _targetIdentifierMeta,
        targetIdentifier.isAcceptableOrUnknown(
          data['target_identifier']!,
          _targetIdentifierMeta,
        ),
      );
    }
    if (data.containsKey('limit_minutes')) {
      context.handle(
        _limitMinutesMeta,
        limitMinutes.isAcceptableOrUnknown(
          data['limit_minutes']!,
          _limitMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_limitMinutesMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      targetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_type'],
      )!,
      targetIdentifier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_identifier'],
      ),
      limitMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limit_minutes'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $CustomGoalsTable createAlias(String alias) {
    return $CustomGoalsTable(attachedDatabase, alias);
  }
}

class CustomGoal extends DataClass implements Insertable<CustomGoal> {
  final String id;
  final String targetType;
  final String? targetIdentifier;
  final int limitMinutes;
  final bool isActive;
  const CustomGoal({
    required this.id,
    required this.targetType,
    this.targetIdentifier,
    required this.limitMinutes,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['target_type'] = Variable<String>(targetType);
    if (!nullToAbsent || targetIdentifier != null) {
      map['target_identifier'] = Variable<String>(targetIdentifier);
    }
    map['limit_minutes'] = Variable<int>(limitMinutes);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CustomGoalsCompanion toCompanion(bool nullToAbsent) {
    return CustomGoalsCompanion(
      id: Value(id),
      targetType: Value(targetType),
      targetIdentifier: targetIdentifier == null && nullToAbsent
          ? const Value.absent()
          : Value(targetIdentifier),
      limitMinutes: Value(limitMinutes),
      isActive: Value(isActive),
    );
  }

  factory CustomGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomGoal(
      id: serializer.fromJson<String>(json['id']),
      targetType: serializer.fromJson<String>(json['targetType']),
      targetIdentifier: serializer.fromJson<String?>(json['targetIdentifier']),
      limitMinutes: serializer.fromJson<int>(json['limitMinutes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'targetType': serializer.toJson<String>(targetType),
      'targetIdentifier': serializer.toJson<String?>(targetIdentifier),
      'limitMinutes': serializer.toJson<int>(limitMinutes),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  CustomGoal copyWith({
    String? id,
    String? targetType,
    Value<String?> targetIdentifier = const Value.absent(),
    int? limitMinutes,
    bool? isActive,
  }) => CustomGoal(
    id: id ?? this.id,
    targetType: targetType ?? this.targetType,
    targetIdentifier: targetIdentifier.present
        ? targetIdentifier.value
        : this.targetIdentifier,
    limitMinutes: limitMinutes ?? this.limitMinutes,
    isActive: isActive ?? this.isActive,
  );
  CustomGoal copyWithCompanion(CustomGoalsCompanion data) {
    return CustomGoal(
      id: data.id.present ? data.id.value : this.id,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      targetIdentifier: data.targetIdentifier.present
          ? data.targetIdentifier.value
          : this.targetIdentifier,
      limitMinutes: data.limitMinutes.present
          ? data.limitMinutes.value
          : this.limitMinutes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomGoal(')
          ..write('id: $id, ')
          ..write('targetType: $targetType, ')
          ..write('targetIdentifier: $targetIdentifier, ')
          ..write('limitMinutes: $limitMinutes, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, targetType, targetIdentifier, limitMinutes, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomGoal &&
          other.id == this.id &&
          other.targetType == this.targetType &&
          other.targetIdentifier == this.targetIdentifier &&
          other.limitMinutes == this.limitMinutes &&
          other.isActive == this.isActive);
}

class CustomGoalsCompanion extends UpdateCompanion<CustomGoal> {
  final Value<String> id;
  final Value<String> targetType;
  final Value<String?> targetIdentifier;
  final Value<int> limitMinutes;
  final Value<bool> isActive;
  final Value<int> rowid;
  const CustomGoalsCompanion({
    this.id = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetIdentifier = const Value.absent(),
    this.limitMinutes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomGoalsCompanion.insert({
    required String id,
    required String targetType,
    this.targetIdentifier = const Value.absent(),
    required int limitMinutes,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       targetType = Value(targetType),
       limitMinutes = Value(limitMinutes);
  static Insertable<CustomGoal> custom({
    Expression<String>? id,
    Expression<String>? targetType,
    Expression<String>? targetIdentifier,
    Expression<int>? limitMinutes,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetType != null) 'target_type': targetType,
      if (targetIdentifier != null) 'target_identifier': targetIdentifier,
      if (limitMinutes != null) 'limit_minutes': limitMinutes,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomGoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? targetType,
    Value<String?>? targetIdentifier,
    Value<int>? limitMinutes,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return CustomGoalsCompanion(
      id: id ?? this.id,
      targetType: targetType ?? this.targetType,
      targetIdentifier: targetIdentifier ?? this.targetIdentifier,
      limitMinutes: limitMinutes ?? this.limitMinutes,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(targetType.value);
    }
    if (targetIdentifier.present) {
      map['target_identifier'] = Variable<String>(targetIdentifier.value);
    }
    if (limitMinutes.present) {
      map['limit_minutes'] = Variable<int>(limitMinutes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomGoalsCompanion(')
          ..write('id: $id, ')
          ..write('targetType: $targetType, ')
          ..write('targetIdentifier: $targetIdentifier, ')
          ..write('limitMinutes: $limitMinutes, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  UserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSetting extends DataClass implements Insertable<UserSetting> {
  final String key;
  final String value;
  const UserSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory UserSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  UserSetting copyWith({String? key, String? value}) =>
      UserSetting(key: key ?? this.key, value: value ?? this.value);
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const UserSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<UserSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return UserSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppCatalogTable appCatalog = $AppCatalogTable(this);
  late final $AppCategoriesTable appCategories = $AppCategoriesTable(this);
  late final $UsageDailyTable usageDaily = $UsageDailyTable(this);
  late final $UsageHourlyTable usageHourly = $UsageHourlyTable(this);
  late final $UsageSyncStateTable usageSyncState = $UsageSyncStateTable(this);
  late final $RestrictionRulesTable restrictionRules = $RestrictionRulesTable(
    this,
  );
  late final $RestrictionTargetsTable restrictionTargets =
      $RestrictionTargetsTable(this);
  late final $RestrictionOverridesTable restrictionOverrides =
      $RestrictionOverridesTable(this);
  late final $FocusProfilesTable focusProfiles = $FocusProfilesTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $RoutineStepsTable routineSteps = $RoutineStepsTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitEntriesTable habitEntries = $HabitEntriesTable(this);
  late final $HabitStreaksTable habitStreaks = $HabitStreaksTable(this);
  late final $InsightsTable insights = $InsightsTable(this);
  late final $CustomGoalsTable customGoals = $CustomGoalsTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appCatalog,
    appCategories,
    usageDaily,
    usageHourly,
    usageSyncState,
    restrictionRules,
    restrictionTargets,
    restrictionOverrides,
    focusProfiles,
    focusSessions,
    routines,
    routineSteps,
    habits,
    habitEntries,
    habitStreaks,
    insights,
    customGoals,
    userSettings,
  ];
}

typedef $$AppCatalogTableCreateCompanionBuilder =
    AppCatalogCompanion Function({
      Value<int> id,
      required String packageName,
      required String appName,
      Value<bool> isSystemApp,
      Value<String?> iconPath,
      Value<int?> categoryId,
      Value<bool> isExcluded,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$AppCatalogTableUpdateCompanionBuilder =
    AppCatalogCompanion Function({
      Value<int> id,
      Value<String> packageName,
      Value<String> appName,
      Value<bool> isSystemApp,
      Value<String?> iconPath,
      Value<int?> categoryId,
      Value<bool> isExcluded,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$AppCatalogTableFilterComposer
    extends Composer<_$AppDatabase, $AppCatalogTable> {
  $$AppCatalogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystemApp => $composableBuilder(
    column: $table.isSystemApp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isExcluded => $composableBuilder(
    column: $table.isExcluded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppCatalogTableOrderingComposer
    extends Composer<_$AppDatabase, $AppCatalogTable> {
  $$AppCatalogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystemApp => $composableBuilder(
    column: $table.isSystemApp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isExcluded => $composableBuilder(
    column: $table.isExcluded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppCatalogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppCatalogTable> {
  $$AppCatalogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appName =>
      $composableBuilder(column: $table.appName, builder: (column) => column);

  GeneratedColumn<bool> get isSystemApp => $composableBuilder(
    column: $table.isSystemApp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconPath =>
      $composableBuilder(column: $table.iconPath, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isExcluded => $composableBuilder(
    column: $table.isExcluded,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppCatalogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppCatalogTable,
          AppCatalogData,
          $$AppCatalogTableFilterComposer,
          $$AppCatalogTableOrderingComposer,
          $$AppCatalogTableAnnotationComposer,
          $$AppCatalogTableCreateCompanionBuilder,
          $$AppCatalogTableUpdateCompanionBuilder,
          (
            AppCatalogData,
            BaseReferences<_$AppDatabase, $AppCatalogTable, AppCatalogData>,
          ),
          AppCatalogData,
          PrefetchHooks Function()
        > {
  $$AppCatalogTableTableManager(_$AppDatabase db, $AppCatalogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppCatalogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppCatalogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppCatalogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> packageName = const Value.absent(),
                Value<String> appName = const Value.absent(),
                Value<bool> isSystemApp = const Value.absent(),
                Value<String?> iconPath = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<bool> isExcluded = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AppCatalogCompanion(
                id: id,
                packageName: packageName,
                appName: appName,
                isSystemApp: isSystemApp,
                iconPath: iconPath,
                categoryId: categoryId,
                isExcluded: isExcluded,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String packageName,
                required String appName,
                Value<bool> isSystemApp = const Value.absent(),
                Value<String?> iconPath = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<bool> isExcluded = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AppCatalogCompanion.insert(
                id: id,
                packageName: packageName,
                appName: appName,
                isSystemApp: isSystemApp,
                iconPath: iconPath,
                categoryId: categoryId,
                isExcluded: isExcluded,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppCatalogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppCatalogTable,
      AppCatalogData,
      $$AppCatalogTableFilterComposer,
      $$AppCatalogTableOrderingComposer,
      $$AppCatalogTableAnnotationComposer,
      $$AppCatalogTableCreateCompanionBuilder,
      $$AppCatalogTableUpdateCompanionBuilder,
      (
        AppCatalogData,
        BaseReferences<_$AppDatabase, $AppCatalogTable, AppCatalogData>,
      ),
      AppCatalogData,
      PrefetchHooks Function()
    >;
typedef $$AppCategoriesTableCreateCompanionBuilder =
    AppCategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<String> colorHex,
      Value<String> iconName,
    });
typedef $$AppCategoriesTableUpdateCompanionBuilder =
    AppCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> colorHex,
      Value<String> iconName,
    });

class $$AppCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $AppCategoriesTable> {
  $$AppCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppCategoriesTable> {
  $$AppCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppCategoriesTable> {
  $$AppCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);
}

class $$AppCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppCategoriesTable,
          AppCategory,
          $$AppCategoriesTableFilterComposer,
          $$AppCategoriesTableOrderingComposer,
          $$AppCategoriesTableAnnotationComposer,
          $$AppCategoriesTableCreateCompanionBuilder,
          $$AppCategoriesTableUpdateCompanionBuilder,
          (
            AppCategory,
            BaseReferences<_$AppDatabase, $AppCategoriesTable, AppCategory>,
          ),
          AppCategory,
          PrefetchHooks Function()
        > {
  $$AppCategoriesTableTableManager(_$AppDatabase db, $AppCategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<String> iconName = const Value.absent(),
              }) => AppCategoriesCompanion(
                id: id,
                name: name,
                colorHex: colorHex,
                iconName: iconName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> colorHex = const Value.absent(),
                Value<String> iconName = const Value.absent(),
              }) => AppCategoriesCompanion.insert(
                id: id,
                name: name,
                colorHex: colorHex,
                iconName: iconName,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppCategoriesTable,
      AppCategory,
      $$AppCategoriesTableFilterComposer,
      $$AppCategoriesTableOrderingComposer,
      $$AppCategoriesTableAnnotationComposer,
      $$AppCategoriesTableCreateCompanionBuilder,
      $$AppCategoriesTableUpdateCompanionBuilder,
      (
        AppCategory,
        BaseReferences<_$AppDatabase, $AppCategoriesTable, AppCategory>,
      ),
      AppCategory,
      PrefetchHooks Function()
    >;
typedef $$UsageDailyTableCreateCompanionBuilder =
    UsageDailyCompanion Function({
      required String date,
      required String packageName,
      Value<int> foregroundTimeMs,
      Value<int> launchCount,
      Value<int> lastUsedUtcMs,
      Value<int> rowid,
    });
typedef $$UsageDailyTableUpdateCompanionBuilder =
    UsageDailyCompanion Function({
      Value<String> date,
      Value<String> packageName,
      Value<int> foregroundTimeMs,
      Value<int> launchCount,
      Value<int> lastUsedUtcMs,
      Value<int> rowid,
    });

class $$UsageDailyTableFilterComposer
    extends Composer<_$AppDatabase, $UsageDailyTable> {
  $$UsageDailyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get foregroundTimeMs => $composableBuilder(
    column: $table.foregroundTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get launchCount => $composableBuilder(
    column: $table.launchCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastUsedUtcMs => $composableBuilder(
    column: $table.lastUsedUtcMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsageDailyTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageDailyTable> {
  $$UsageDailyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get foregroundTimeMs => $composableBuilder(
    column: $table.foregroundTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get launchCount => $composableBuilder(
    column: $table.launchCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastUsedUtcMs => $composableBuilder(
    column: $table.lastUsedUtcMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsageDailyTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageDailyTable> {
  $$UsageDailyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get foregroundTimeMs => $composableBuilder(
    column: $table.foregroundTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get launchCount => $composableBuilder(
    column: $table.launchCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastUsedUtcMs => $composableBuilder(
    column: $table.lastUsedUtcMs,
    builder: (column) => column,
  );
}

class $$UsageDailyTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsageDailyTable,
          UsageDailyData,
          $$UsageDailyTableFilterComposer,
          $$UsageDailyTableOrderingComposer,
          $$UsageDailyTableAnnotationComposer,
          $$UsageDailyTableCreateCompanionBuilder,
          $$UsageDailyTableUpdateCompanionBuilder,
          (
            UsageDailyData,
            BaseReferences<_$AppDatabase, $UsageDailyTable, UsageDailyData>,
          ),
          UsageDailyData,
          PrefetchHooks Function()
        > {
  $$UsageDailyTableTableManager(_$AppDatabase db, $UsageDailyTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageDailyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageDailyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageDailyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> packageName = const Value.absent(),
                Value<int> foregroundTimeMs = const Value.absent(),
                Value<int> launchCount = const Value.absent(),
                Value<int> lastUsedUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageDailyCompanion(
                date: date,
                packageName: packageName,
                foregroundTimeMs: foregroundTimeMs,
                launchCount: launchCount,
                lastUsedUtcMs: lastUsedUtcMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String packageName,
                Value<int> foregroundTimeMs = const Value.absent(),
                Value<int> launchCount = const Value.absent(),
                Value<int> lastUsedUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageDailyCompanion.insert(
                date: date,
                packageName: packageName,
                foregroundTimeMs: foregroundTimeMs,
                launchCount: launchCount,
                lastUsedUtcMs: lastUsedUtcMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsageDailyTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsageDailyTable,
      UsageDailyData,
      $$UsageDailyTableFilterComposer,
      $$UsageDailyTableOrderingComposer,
      $$UsageDailyTableAnnotationComposer,
      $$UsageDailyTableCreateCompanionBuilder,
      $$UsageDailyTableUpdateCompanionBuilder,
      (
        UsageDailyData,
        BaseReferences<_$AppDatabase, $UsageDailyTable, UsageDailyData>,
      ),
      UsageDailyData,
      PrefetchHooks Function()
    >;
typedef $$UsageHourlyTableCreateCompanionBuilder =
    UsageHourlyCompanion Function({
      required String date,
      required int hourOfDay,
      Value<int> foregroundTimeMs,
      Value<int> deviceUnlocks,
      Value<int> rowid,
    });
typedef $$UsageHourlyTableUpdateCompanionBuilder =
    UsageHourlyCompanion Function({
      Value<String> date,
      Value<int> hourOfDay,
      Value<int> foregroundTimeMs,
      Value<int> deviceUnlocks,
      Value<int> rowid,
    });

class $$UsageHourlyTableFilterComposer
    extends Composer<_$AppDatabase, $UsageHourlyTable> {
  $$UsageHourlyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hourOfDay => $composableBuilder(
    column: $table.hourOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get foregroundTimeMs => $composableBuilder(
    column: $table.foregroundTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deviceUnlocks => $composableBuilder(
    column: $table.deviceUnlocks,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsageHourlyTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageHourlyTable> {
  $$UsageHourlyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hourOfDay => $composableBuilder(
    column: $table.hourOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get foregroundTimeMs => $composableBuilder(
    column: $table.foregroundTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deviceUnlocks => $composableBuilder(
    column: $table.deviceUnlocks,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsageHourlyTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageHourlyTable> {
  $$UsageHourlyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get hourOfDay =>
      $composableBuilder(column: $table.hourOfDay, builder: (column) => column);

  GeneratedColumn<int> get foregroundTimeMs => $composableBuilder(
    column: $table.foregroundTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deviceUnlocks => $composableBuilder(
    column: $table.deviceUnlocks,
    builder: (column) => column,
  );
}

class $$UsageHourlyTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsageHourlyTable,
          UsageHourlyData,
          $$UsageHourlyTableFilterComposer,
          $$UsageHourlyTableOrderingComposer,
          $$UsageHourlyTableAnnotationComposer,
          $$UsageHourlyTableCreateCompanionBuilder,
          $$UsageHourlyTableUpdateCompanionBuilder,
          (
            UsageHourlyData,
            BaseReferences<_$AppDatabase, $UsageHourlyTable, UsageHourlyData>,
          ),
          UsageHourlyData,
          PrefetchHooks Function()
        > {
  $$UsageHourlyTableTableManager(_$AppDatabase db, $UsageHourlyTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageHourlyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageHourlyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageHourlyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> hourOfDay = const Value.absent(),
                Value<int> foregroundTimeMs = const Value.absent(),
                Value<int> deviceUnlocks = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageHourlyCompanion(
                date: date,
                hourOfDay: hourOfDay,
                foregroundTimeMs: foregroundTimeMs,
                deviceUnlocks: deviceUnlocks,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required int hourOfDay,
                Value<int> foregroundTimeMs = const Value.absent(),
                Value<int> deviceUnlocks = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageHourlyCompanion.insert(
                date: date,
                hourOfDay: hourOfDay,
                foregroundTimeMs: foregroundTimeMs,
                deviceUnlocks: deviceUnlocks,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsageHourlyTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsageHourlyTable,
      UsageHourlyData,
      $$UsageHourlyTableFilterComposer,
      $$UsageHourlyTableOrderingComposer,
      $$UsageHourlyTableAnnotationComposer,
      $$UsageHourlyTableCreateCompanionBuilder,
      $$UsageHourlyTableUpdateCompanionBuilder,
      (
        UsageHourlyData,
        BaseReferences<_$AppDatabase, $UsageHourlyTable, UsageHourlyData>,
      ),
      UsageHourlyData,
      PrefetchHooks Function()
    >;
typedef $$UsageSyncStateTableCreateCompanionBuilder =
    UsageSyncStateCompanion Function({
      Value<int> id,
      required int lastSyncUtcMs,
      required String syncStatus,
      Value<String?> errorMessage,
    });
typedef $$UsageSyncStateTableUpdateCompanionBuilder =
    UsageSyncStateCompanion Function({
      Value<int> id,
      Value<int> lastSyncUtcMs,
      Value<String> syncStatus,
      Value<String?> errorMessage,
    });

class $$UsageSyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $UsageSyncStateTable> {
  $$UsageSyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncUtcMs => $composableBuilder(
    column: $table.lastSyncUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsageSyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageSyncStateTable> {
  $$UsageSyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncUtcMs => $composableBuilder(
    column: $table.lastSyncUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsageSyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageSyncStateTable> {
  $$UsageSyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get lastSyncUtcMs => $composableBuilder(
    column: $table.lastSyncUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );
}

class $$UsageSyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsageSyncStateTable,
          UsageSyncStateData,
          $$UsageSyncStateTableFilterComposer,
          $$UsageSyncStateTableOrderingComposer,
          $$UsageSyncStateTableAnnotationComposer,
          $$UsageSyncStateTableCreateCompanionBuilder,
          $$UsageSyncStateTableUpdateCompanionBuilder,
          (
            UsageSyncStateData,
            BaseReferences<
              _$AppDatabase,
              $UsageSyncStateTable,
              UsageSyncStateData
            >,
          ),
          UsageSyncStateData,
          PrefetchHooks Function()
        > {
  $$UsageSyncStateTableTableManager(
    _$AppDatabase db,
    $UsageSyncStateTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageSyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageSyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageSyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lastSyncUtcMs = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
              }) => UsageSyncStateCompanion(
                id: id,
                lastSyncUtcMs: lastSyncUtcMs,
                syncStatus: syncStatus,
                errorMessage: errorMessage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int lastSyncUtcMs,
                required String syncStatus,
                Value<String?> errorMessage = const Value.absent(),
              }) => UsageSyncStateCompanion.insert(
                id: id,
                lastSyncUtcMs: lastSyncUtcMs,
                syncStatus: syncStatus,
                errorMessage: errorMessage,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsageSyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsageSyncStateTable,
      UsageSyncStateData,
      $$UsageSyncStateTableFilterComposer,
      $$UsageSyncStateTableOrderingComposer,
      $$UsageSyncStateTableAnnotationComposer,
      $$UsageSyncStateTableCreateCompanionBuilder,
      $$UsageSyncStateTableUpdateCompanionBuilder,
      (
        UsageSyncStateData,
        BaseReferences<_$AppDatabase, $UsageSyncStateTable, UsageSyncStateData>,
      ),
      UsageSyncStateData,
      PrefetchHooks Function()
    >;
typedef $$RestrictionRulesTableCreateCompanionBuilder =
    RestrictionRulesCompanion Function({
      required String id,
      required String name,
      Value<int> limitMinutesPerDay,
      Value<int> startMinuteOfDay,
      Value<int> endMinuteOfDay,
      Value<String> daysOfWeek,
      Value<bool> isEnabled,
      Value<bool> isTemporaryBlock,
      Value<int> tempBlockUntilMs,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$RestrictionRulesTableUpdateCompanionBuilder =
    RestrictionRulesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> limitMinutesPerDay,
      Value<int> startMinuteOfDay,
      Value<int> endMinuteOfDay,
      Value<String> daysOfWeek,
      Value<bool> isEnabled,
      Value<bool> isTemporaryBlock,
      Value<int> tempBlockUntilMs,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$RestrictionRulesTableFilterComposer
    extends Composer<_$AppDatabase, $RestrictionRulesTable> {
  $$RestrictionRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get limitMinutesPerDay => $composableBuilder(
    column: $table.limitMinutesPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinuteOfDay => $composableBuilder(
    column: $table.startMinuteOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinuteOfDay => $composableBuilder(
    column: $table.endMinuteOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTemporaryBlock => $composableBuilder(
    column: $table.isTemporaryBlock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tempBlockUntilMs => $composableBuilder(
    column: $table.tempBlockUntilMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RestrictionRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $RestrictionRulesTable> {
  $$RestrictionRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get limitMinutesPerDay => $composableBuilder(
    column: $table.limitMinutesPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinuteOfDay => $composableBuilder(
    column: $table.startMinuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinuteOfDay => $composableBuilder(
    column: $table.endMinuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTemporaryBlock => $composableBuilder(
    column: $table.isTemporaryBlock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tempBlockUntilMs => $composableBuilder(
    column: $table.tempBlockUntilMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RestrictionRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestrictionRulesTable> {
  $$RestrictionRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get limitMinutesPerDay => $composableBuilder(
    column: $table.limitMinutesPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startMinuteOfDay => $composableBuilder(
    column: $table.startMinuteOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinuteOfDay => $composableBuilder(
    column: $table.endMinuteOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<bool> get isTemporaryBlock => $composableBuilder(
    column: $table.isTemporaryBlock,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tempBlockUntilMs => $composableBuilder(
    column: $table.tempBlockUntilMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RestrictionRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RestrictionRulesTable,
          RestrictionRule,
          $$RestrictionRulesTableFilterComposer,
          $$RestrictionRulesTableOrderingComposer,
          $$RestrictionRulesTableAnnotationComposer,
          $$RestrictionRulesTableCreateCompanionBuilder,
          $$RestrictionRulesTableUpdateCompanionBuilder,
          (
            RestrictionRule,
            BaseReferences<
              _$AppDatabase,
              $RestrictionRulesTable,
              RestrictionRule
            >,
          ),
          RestrictionRule,
          PrefetchHooks Function()
        > {
  $$RestrictionRulesTableTableManager(
    _$AppDatabase db,
    $RestrictionRulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestrictionRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestrictionRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RestrictionRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> limitMinutesPerDay = const Value.absent(),
                Value<int> startMinuteOfDay = const Value.absent(),
                Value<int> endMinuteOfDay = const Value.absent(),
                Value<String> daysOfWeek = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> isTemporaryBlock = const Value.absent(),
                Value<int> tempBlockUntilMs = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RestrictionRulesCompanion(
                id: id,
                name: name,
                limitMinutesPerDay: limitMinutesPerDay,
                startMinuteOfDay: startMinuteOfDay,
                endMinuteOfDay: endMinuteOfDay,
                daysOfWeek: daysOfWeek,
                isEnabled: isEnabled,
                isTemporaryBlock: isTemporaryBlock,
                tempBlockUntilMs: tempBlockUntilMs,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> limitMinutesPerDay = const Value.absent(),
                Value<int> startMinuteOfDay = const Value.absent(),
                Value<int> endMinuteOfDay = const Value.absent(),
                Value<String> daysOfWeek = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> isTemporaryBlock = const Value.absent(),
                Value<int> tempBlockUntilMs = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RestrictionRulesCompanion.insert(
                id: id,
                name: name,
                limitMinutesPerDay: limitMinutesPerDay,
                startMinuteOfDay: startMinuteOfDay,
                endMinuteOfDay: endMinuteOfDay,
                daysOfWeek: daysOfWeek,
                isEnabled: isEnabled,
                isTemporaryBlock: isTemporaryBlock,
                tempBlockUntilMs: tempBlockUntilMs,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RestrictionRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RestrictionRulesTable,
      RestrictionRule,
      $$RestrictionRulesTableFilterComposer,
      $$RestrictionRulesTableOrderingComposer,
      $$RestrictionRulesTableAnnotationComposer,
      $$RestrictionRulesTableCreateCompanionBuilder,
      $$RestrictionRulesTableUpdateCompanionBuilder,
      (
        RestrictionRule,
        BaseReferences<_$AppDatabase, $RestrictionRulesTable, RestrictionRule>,
      ),
      RestrictionRule,
      PrefetchHooks Function()
    >;
typedef $$RestrictionTargetsTableCreateCompanionBuilder =
    RestrictionTargetsCompanion Function({
      Value<int> id,
      required String ruleId,
      required String packageName,
    });
typedef $$RestrictionTargetsTableUpdateCompanionBuilder =
    RestrictionTargetsCompanion Function({
      Value<int> id,
      Value<String> ruleId,
      Value<String> packageName,
    });

class $$RestrictionTargetsTableFilterComposer
    extends Composer<_$AppDatabase, $RestrictionTargetsTable> {
  $$RestrictionTargetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RestrictionTargetsTableOrderingComposer
    extends Composer<_$AppDatabase, $RestrictionTargetsTable> {
  $$RestrictionTargetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RestrictionTargetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestrictionTargetsTable> {
  $$RestrictionTargetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ruleId =>
      $composableBuilder(column: $table.ruleId, builder: (column) => column);

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );
}

class $$RestrictionTargetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RestrictionTargetsTable,
          RestrictionTarget,
          $$RestrictionTargetsTableFilterComposer,
          $$RestrictionTargetsTableOrderingComposer,
          $$RestrictionTargetsTableAnnotationComposer,
          $$RestrictionTargetsTableCreateCompanionBuilder,
          $$RestrictionTargetsTableUpdateCompanionBuilder,
          (
            RestrictionTarget,
            BaseReferences<
              _$AppDatabase,
              $RestrictionTargetsTable,
              RestrictionTarget
            >,
          ),
          RestrictionTarget,
          PrefetchHooks Function()
        > {
  $$RestrictionTargetsTableTableManager(
    _$AppDatabase db,
    $RestrictionTargetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestrictionTargetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestrictionTargetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RestrictionTargetsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> ruleId = const Value.absent(),
                Value<String> packageName = const Value.absent(),
              }) => RestrictionTargetsCompanion(
                id: id,
                ruleId: ruleId,
                packageName: packageName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String ruleId,
                required String packageName,
              }) => RestrictionTargetsCompanion.insert(
                id: id,
                ruleId: ruleId,
                packageName: packageName,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RestrictionTargetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RestrictionTargetsTable,
      RestrictionTarget,
      $$RestrictionTargetsTableFilterComposer,
      $$RestrictionTargetsTableOrderingComposer,
      $$RestrictionTargetsTableAnnotationComposer,
      $$RestrictionTargetsTableCreateCompanionBuilder,
      $$RestrictionTargetsTableUpdateCompanionBuilder,
      (
        RestrictionTarget,
        BaseReferences<
          _$AppDatabase,
          $RestrictionTargetsTable,
          RestrictionTarget
        >,
      ),
      RestrictionTarget,
      PrefetchHooks Function()
    >;
typedef $$RestrictionOverridesTableCreateCompanionBuilder =
    RestrictionOverridesCompanion Function({
      Value<int> id,
      required String ruleId,
      required String packageName,
      required int overrideUntilMs,
      required int durationMinutes,
      Value<String?> reason,
      Value<DateTime> createdAt,
    });
typedef $$RestrictionOverridesTableUpdateCompanionBuilder =
    RestrictionOverridesCompanion Function({
      Value<int> id,
      Value<String> ruleId,
      Value<String> packageName,
      Value<int> overrideUntilMs,
      Value<int> durationMinutes,
      Value<String?> reason,
      Value<DateTime> createdAt,
    });

class $$RestrictionOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $RestrictionOverridesTable> {
  $$RestrictionOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overrideUntilMs => $composableBuilder(
    column: $table.overrideUntilMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RestrictionOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $RestrictionOverridesTable> {
  $$RestrictionOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overrideUntilMs => $composableBuilder(
    column: $table.overrideUntilMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RestrictionOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestrictionOverridesTable> {
  $$RestrictionOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ruleId =>
      $composableBuilder(column: $table.ruleId, builder: (column) => column);

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get overrideUntilMs => $composableBuilder(
    column: $table.overrideUntilMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RestrictionOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RestrictionOverridesTable,
          RestrictionOverride,
          $$RestrictionOverridesTableFilterComposer,
          $$RestrictionOverridesTableOrderingComposer,
          $$RestrictionOverridesTableAnnotationComposer,
          $$RestrictionOverridesTableCreateCompanionBuilder,
          $$RestrictionOverridesTableUpdateCompanionBuilder,
          (
            RestrictionOverride,
            BaseReferences<
              _$AppDatabase,
              $RestrictionOverridesTable,
              RestrictionOverride
            >,
          ),
          RestrictionOverride,
          PrefetchHooks Function()
        > {
  $$RestrictionOverridesTableTableManager(
    _$AppDatabase db,
    $RestrictionOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestrictionOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestrictionOverridesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RestrictionOverridesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> ruleId = const Value.absent(),
                Value<String> packageName = const Value.absent(),
                Value<int> overrideUntilMs = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RestrictionOverridesCompanion(
                id: id,
                ruleId: ruleId,
                packageName: packageName,
                overrideUntilMs: overrideUntilMs,
                durationMinutes: durationMinutes,
                reason: reason,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String ruleId,
                required String packageName,
                required int overrideUntilMs,
                required int durationMinutes,
                Value<String?> reason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RestrictionOverridesCompanion.insert(
                id: id,
                ruleId: ruleId,
                packageName: packageName,
                overrideUntilMs: overrideUntilMs,
                durationMinutes: durationMinutes,
                reason: reason,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RestrictionOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RestrictionOverridesTable,
      RestrictionOverride,
      $$RestrictionOverridesTableFilterComposer,
      $$RestrictionOverridesTableOrderingComposer,
      $$RestrictionOverridesTableAnnotationComposer,
      $$RestrictionOverridesTableCreateCompanionBuilder,
      $$RestrictionOverridesTableUpdateCompanionBuilder,
      (
        RestrictionOverride,
        BaseReferences<
          _$AppDatabase,
          $RestrictionOverridesTable,
          RestrictionOverride
        >,
      ),
      RestrictionOverride,
      PrefetchHooks Function()
    >;
typedef $$FocusProfilesTableCreateCompanionBuilder =
    FocusProfilesCompanion Function({
      required String id,
      required String name,
      Value<int> durationMinutes,
      Value<int> shortBreakMinutes,
      Value<int> longBreakMinutes,
      Value<int> cycles,
      Value<bool> allowlistOnly,
      Value<int> rowid,
    });
typedef $$FocusProfilesTableUpdateCompanionBuilder =
    FocusProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> durationMinutes,
      Value<int> shortBreakMinutes,
      Value<int> longBreakMinutes,
      Value<int> cycles,
      Value<bool> allowlistOnly,
      Value<int> rowid,
    });

class $$FocusProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $FocusProfilesTable> {
  $$FocusProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycles => $composableBuilder(
    column: $table.cycles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowlistOnly => $composableBuilder(
    column: $table.allowlistOnly,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FocusProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusProfilesTable> {
  $$FocusProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycles => $composableBuilder(
    column: $table.cycles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowlistOnly => $composableBuilder(
    column: $table.allowlistOnly,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FocusProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusProfilesTable> {
  $$FocusProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cycles =>
      $composableBuilder(column: $table.cycles, builder: (column) => column);

  GeneratedColumn<bool> get allowlistOnly => $composableBuilder(
    column: $table.allowlistOnly,
    builder: (column) => column,
  );
}

class $$FocusProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusProfilesTable,
          FocusProfile,
          $$FocusProfilesTableFilterComposer,
          $$FocusProfilesTableOrderingComposer,
          $$FocusProfilesTableAnnotationComposer,
          $$FocusProfilesTableCreateCompanionBuilder,
          $$FocusProfilesTableUpdateCompanionBuilder,
          (
            FocusProfile,
            BaseReferences<_$AppDatabase, $FocusProfilesTable, FocusProfile>,
          ),
          FocusProfile,
          PrefetchHooks Function()
        > {
  $$FocusProfilesTableTableManager(_$AppDatabase db, $FocusProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> shortBreakMinutes = const Value.absent(),
                Value<int> longBreakMinutes = const Value.absent(),
                Value<int> cycles = const Value.absent(),
                Value<bool> allowlistOnly = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusProfilesCompanion(
                id: id,
                name: name,
                durationMinutes: durationMinutes,
                shortBreakMinutes: shortBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                cycles: cycles,
                allowlistOnly: allowlistOnly,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> durationMinutes = const Value.absent(),
                Value<int> shortBreakMinutes = const Value.absent(),
                Value<int> longBreakMinutes = const Value.absent(),
                Value<int> cycles = const Value.absent(),
                Value<bool> allowlistOnly = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusProfilesCompanion.insert(
                id: id,
                name: name,
                durationMinutes: durationMinutes,
                shortBreakMinutes: shortBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                cycles: cycles,
                allowlistOnly: allowlistOnly,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FocusProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusProfilesTable,
      FocusProfile,
      $$FocusProfilesTableFilterComposer,
      $$FocusProfilesTableOrderingComposer,
      $$FocusProfilesTableAnnotationComposer,
      $$FocusProfilesTableCreateCompanionBuilder,
      $$FocusProfilesTableUpdateCompanionBuilder,
      (
        FocusProfile,
        BaseReferences<_$AppDatabase, $FocusProfilesTable, FocusProfile>,
      ),
      FocusProfile,
      PrefetchHooks Function()
    >;
typedef $$FocusSessionsTableCreateCompanionBuilder =
    FocusSessionsCompanion Function({
      required String id,
      Value<String?> profileId,
      required int startedAtUtcMs,
      required int targetDurationMinutes,
      Value<int> completedMinutes,
      required String status,
      Value<int> pausedRemainingSeconds,
      Value<int?> endedAtUtcMs,
      Value<int> rowid,
    });
typedef $$FocusSessionsTableUpdateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<String> id,
      Value<String?> profileId,
      Value<int> startedAtUtcMs,
      Value<int> targetDurationMinutes,
      Value<int> completedMinutes,
      Value<String> status,
      Value<int> pausedRemainingSeconds,
      Value<int?> endedAtUtcMs,
      Value<int> rowid,
    });

class $$FocusSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtUtcMs => $composableBuilder(
    column: $table.startedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDurationMinutes => $composableBuilder(
    column: $table.targetDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedMinutes => $composableBuilder(
    column: $table.completedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pausedRemainingSeconds => $composableBuilder(
    column: $table.pausedRemainingSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAtUtcMs => $composableBuilder(
    column: $table.endedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FocusSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtUtcMs => $composableBuilder(
    column: $table.startedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDurationMinutes => $composableBuilder(
    column: $table.targetDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedMinutes => $composableBuilder(
    column: $table.completedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pausedRemainingSeconds => $composableBuilder(
    column: $table.pausedRemainingSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAtUtcMs => $composableBuilder(
    column: $table.endedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FocusSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get startedAtUtcMs => $composableBuilder(
    column: $table.startedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetDurationMinutes => $composableBuilder(
    column: $table.targetDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedMinutes => $composableBuilder(
    column: $table.completedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get pausedRemainingSeconds => $composableBuilder(
    column: $table.pausedRemainingSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endedAtUtcMs => $composableBuilder(
    column: $table.endedAtUtcMs,
    builder: (column) => column,
  );
}

class $$FocusSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusSessionsTable,
          FocusSession,
          $$FocusSessionsTableFilterComposer,
          $$FocusSessionsTableOrderingComposer,
          $$FocusSessionsTableAnnotationComposer,
          $$FocusSessionsTableCreateCompanionBuilder,
          $$FocusSessionsTableUpdateCompanionBuilder,
          (
            FocusSession,
            BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSession>,
          ),
          FocusSession,
          PrefetchHooks Function()
        > {
  $$FocusSessionsTableTableManager(_$AppDatabase db, $FocusSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> profileId = const Value.absent(),
                Value<int> startedAtUtcMs = const Value.absent(),
                Value<int> targetDurationMinutes = const Value.absent(),
                Value<int> completedMinutes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> pausedRemainingSeconds = const Value.absent(),
                Value<int?> endedAtUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion(
                id: id,
                profileId: profileId,
                startedAtUtcMs: startedAtUtcMs,
                targetDurationMinutes: targetDurationMinutes,
                completedMinutes: completedMinutes,
                status: status,
                pausedRemainingSeconds: pausedRemainingSeconds,
                endedAtUtcMs: endedAtUtcMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> profileId = const Value.absent(),
                required int startedAtUtcMs,
                required int targetDurationMinutes,
                Value<int> completedMinutes = const Value.absent(),
                required String status,
                Value<int> pausedRemainingSeconds = const Value.absent(),
                Value<int?> endedAtUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion.insert(
                id: id,
                profileId: profileId,
                startedAtUtcMs: startedAtUtcMs,
                targetDurationMinutes: targetDurationMinutes,
                completedMinutes: completedMinutes,
                status: status,
                pausedRemainingSeconds: pausedRemainingSeconds,
                endedAtUtcMs: endedAtUtcMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FocusSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusSessionsTable,
      FocusSession,
      $$FocusSessionsTableFilterComposer,
      $$FocusSessionsTableOrderingComposer,
      $$FocusSessionsTableAnnotationComposer,
      $$FocusSessionsTableCreateCompanionBuilder,
      $$FocusSessionsTableUpdateCompanionBuilder,
      (
        FocusSession,
        BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSession>,
      ),
      FocusSession,
      PrefetchHooks Function()
    >;
typedef $$RoutinesTableCreateCompanionBuilder =
    RoutinesCompanion Function({
      required String id,
      required String name,
      required String type,
      required int startMinuteOfDay,
      Value<String> daysOfWeek,
      Value<bool> isEnabled,
      Value<int> rowid,
    });
typedef $$RoutinesTableUpdateCompanionBuilder =
    RoutinesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<int> startMinuteOfDay,
      Value<String> daysOfWeek,
      Value<bool> isEnabled,
      Value<int> rowid,
    });

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinuteOfDay => $composableBuilder(
    column: $table.startMinuteOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinuteOfDay => $composableBuilder(
    column: $table.startMinuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get startMinuteOfDay => $composableBuilder(
    column: $table.startMinuteOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          Routine,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (Routine, BaseReferences<_$AppDatabase, $RoutinesTable, Routine>),
          Routine,
          PrefetchHooks Function()
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> startMinuteOfDay = const Value.absent(),
                Value<String> daysOfWeek = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                name: name,
                type: type,
                startMinuteOfDay: startMinuteOfDay,
                daysOfWeek: daysOfWeek,
                isEnabled: isEnabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                required int startMinuteOfDay,
                Value<String> daysOfWeek = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                name: name,
                type: type,
                startMinuteOfDay: startMinuteOfDay,
                daysOfWeek: daysOfWeek,
                isEnabled: isEnabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      Routine,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (Routine, BaseReferences<_$AppDatabase, $RoutinesTable, Routine>),
      Routine,
      PrefetchHooks Function()
    >;
typedef $$RoutineStepsTableCreateCompanionBuilder =
    RoutineStepsCompanion Function({
      Value<int> id,
      required String routineId,
      required String title,
      Value<int> orderIndex,
      Value<bool> isCompleted,
    });
typedef $$RoutineStepsTableUpdateCompanionBuilder =
    RoutineStepsCompanion Function({
      Value<int> id,
      Value<String> routineId,
      Value<String> title,
      Value<int> orderIndex,
      Value<bool> isCompleted,
    });

class $$RoutineStepsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineStepsTable> {
  $$RoutineStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routineId => $composableBuilder(
    column: $table.routineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoutineStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineStepsTable> {
  $$RoutineStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routineId => $composableBuilder(
    column: $table.routineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutineStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineStepsTable> {
  $$RoutineStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get routineId =>
      $composableBuilder(column: $table.routineId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );
}

class $$RoutineStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineStepsTable,
          RoutineStep,
          $$RoutineStepsTableFilterComposer,
          $$RoutineStepsTableOrderingComposer,
          $$RoutineStepsTableAnnotationComposer,
          $$RoutineStepsTableCreateCompanionBuilder,
          $$RoutineStepsTableUpdateCompanionBuilder,
          (
            RoutineStep,
            BaseReferences<_$AppDatabase, $RoutineStepsTable, RoutineStep>,
          ),
          RoutineStep,
          PrefetchHooks Function()
        > {
  $$RoutineStepsTableTableManager(_$AppDatabase db, $RoutineStepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> routineId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
              }) => RoutineStepsCompanion(
                id: id,
                routineId: routineId,
                title: title,
                orderIndex: orderIndex,
                isCompleted: isCompleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String routineId,
                required String title,
                Value<int> orderIndex = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
              }) => RoutineStepsCompanion.insert(
                id: id,
                routineId: routineId,
                title: title,
                orderIndex: orderIndex,
                isCompleted: isCompleted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoutineStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineStepsTable,
      RoutineStep,
      $$RoutineStepsTableFilterComposer,
      $$RoutineStepsTableOrderingComposer,
      $$RoutineStepsTableAnnotationComposer,
      $$RoutineStepsTableCreateCompanionBuilder,
      $$RoutineStepsTableUpdateCompanionBuilder,
      (
        RoutineStep,
        BaseReferences<_$AppDatabase, $RoutineStepsTable, RoutineStep>,
      ),
      RoutineStep,
      PrefetchHooks Function()
    >;
typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      Value<String> category,
      Value<int> targetDaysPerWeek,
      Value<int?> targetMinutes,
      Value<bool> isAvoidance,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<String> category,
      Value<int> targetDaysPerWeek,
      Value<int?> targetMinutes,
      Value<bool> isAvoidance,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDaysPerWeek => $composableBuilder(
    column: $table.targetDaysPerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvoidance => $composableBuilder(
    column: $table.isAvoidance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDaysPerWeek => $composableBuilder(
    column: $table.targetDaysPerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvoidance => $composableBuilder(
    column: $table.isAvoidance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get targetDaysPerWeek => $composableBuilder(
    column: $table.targetDaysPerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAvoidance => $composableBuilder(
    column: $table.isAvoidance,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
          Habit,
          PrefetchHooks Function()
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> targetDaysPerWeek = const Value.absent(),
                Value<int?> targetMinutes = const Value.absent(),
                Value<bool> isAvoidance = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                title: title,
                description: description,
                category: category,
                targetDaysPerWeek: targetDaysPerWeek,
                targetMinutes: targetMinutes,
                isAvoidance: isAvoidance,
                isArchived: isArchived,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> targetDaysPerWeek = const Value.absent(),
                Value<int?> targetMinutes = const Value.absent(),
                Value<bool> isAvoidance = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                title: title,
                description: description,
                category: category,
                targetDaysPerWeek: targetDaysPerWeek,
                targetMinutes: targetMinutes,
                isAvoidance: isAvoidance,
                isArchived: isArchived,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
      Habit,
      PrefetchHooks Function()
    >;
typedef $$HabitEntriesTableCreateCompanionBuilder =
    HabitEntriesCompanion Function({
      Value<int> id,
      required String habitId,
      required String date,
      Value<bool> completed,
      Value<int> value,
      Value<String?> notes,
    });
typedef $$HabitEntriesTableUpdateCompanionBuilder =
    HabitEntriesCompanion Function({
      Value<int> id,
      Value<String> habitId,
      Value<String> date,
      Value<bool> completed,
      Value<int> value,
      Value<String?> notes,
    });

class $$HabitEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get habitId =>
      $composableBuilder(column: $table.habitId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$HabitEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitEntriesTable,
          HabitEntry,
          $$HabitEntriesTableFilterComposer,
          $$HabitEntriesTableOrderingComposer,
          $$HabitEntriesTableAnnotationComposer,
          $$HabitEntriesTableCreateCompanionBuilder,
          $$HabitEntriesTableUpdateCompanionBuilder,
          (
            HabitEntry,
            BaseReferences<_$AppDatabase, $HabitEntriesTable, HabitEntry>,
          ),
          HabitEntry,
          PrefetchHooks Function()
        > {
  $$HabitEntriesTableTableManager(_$AppDatabase db, $HabitEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => HabitEntriesCompanion(
                id: id,
                habitId: habitId,
                date: date,
                completed: completed,
                value: value,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String habitId,
                required String date,
                Value<bool> completed = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => HabitEntriesCompanion.insert(
                id: id,
                habitId: habitId,
                date: date,
                completed: completed,
                value: value,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitEntriesTable,
      HabitEntry,
      $$HabitEntriesTableFilterComposer,
      $$HabitEntriesTableOrderingComposer,
      $$HabitEntriesTableAnnotationComposer,
      $$HabitEntriesTableCreateCompanionBuilder,
      $$HabitEntriesTableUpdateCompanionBuilder,
      (
        HabitEntry,
        BaseReferences<_$AppDatabase, $HabitEntriesTable, HabitEntry>,
      ),
      HabitEntry,
      PrefetchHooks Function()
    >;
typedef $$HabitStreaksTableCreateCompanionBuilder =
    HabitStreaksCompanion Function({
      Value<int> id,
      required String habitId,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<String?> lastCompletedDate,
    });
typedef $$HabitStreaksTableUpdateCompanionBuilder =
    HabitStreaksCompanion Function({
      Value<int> id,
      Value<String> habitId,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<String?> lastCompletedDate,
    });

class $$HabitStreaksTableFilterComposer
    extends Composer<_$AppDatabase, $HabitStreaksTable> {
  $$HabitStreaksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastCompletedDate => $composableBuilder(
    column: $table.lastCompletedDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitStreaksTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitStreaksTable> {
  $$HabitStreaksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastCompletedDate => $composableBuilder(
    column: $table.lastCompletedDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitStreaksTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitStreaksTable> {
  $$HabitStreaksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get habitId =>
      $composableBuilder(column: $table.habitId, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastCompletedDate => $composableBuilder(
    column: $table.lastCompletedDate,
    builder: (column) => column,
  );
}

class $$HabitStreaksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitStreaksTable,
          HabitStreak,
          $$HabitStreaksTableFilterComposer,
          $$HabitStreaksTableOrderingComposer,
          $$HabitStreaksTableAnnotationComposer,
          $$HabitStreaksTableCreateCompanionBuilder,
          $$HabitStreaksTableUpdateCompanionBuilder,
          (
            HabitStreak,
            BaseReferences<_$AppDatabase, $HabitStreaksTable, HabitStreak>,
          ),
          HabitStreak,
          PrefetchHooks Function()
        > {
  $$HabitStreaksTableTableManager(_$AppDatabase db, $HabitStreaksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitStreaksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitStreaksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitStreaksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<String?> lastCompletedDate = const Value.absent(),
              }) => HabitStreaksCompanion(
                id: id,
                habitId: habitId,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                lastCompletedDate: lastCompletedDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String habitId,
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<String?> lastCompletedDate = const Value.absent(),
              }) => HabitStreaksCompanion.insert(
                id: id,
                habitId: habitId,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                lastCompletedDate: lastCompletedDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitStreaksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitStreaksTable,
      HabitStreak,
      $$HabitStreaksTableFilterComposer,
      $$HabitStreaksTableOrderingComposer,
      $$HabitStreaksTableAnnotationComposer,
      $$HabitStreaksTableCreateCompanionBuilder,
      $$HabitStreaksTableUpdateCompanionBuilder,
      (
        HabitStreak,
        BaseReferences<_$AppDatabase, $HabitStreaksTable, HabitStreak>,
      ),
      HabitStreak,
      PrefetchHooks Function()
    >;
typedef $$InsightsTableCreateCompanionBuilder =
    InsightsCompanion Function({
      required String id,
      required String title,
      required String message,
      required String type,
      required String evidence,
      Value<bool> isDismissed,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$InsightsTableUpdateCompanionBuilder =
    InsightsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> message,
      Value<String> type,
      Value<String> evidence,
      Value<bool> isDismissed,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$InsightsTableFilterComposer
    extends Composer<_$AppDatabase, $InsightsTable> {
  $$InsightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidence => $composableBuilder(
    column: $table.evidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InsightsTableOrderingComposer
    extends Composer<_$AppDatabase, $InsightsTable> {
  $$InsightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidence => $composableBuilder(
    column: $table.evidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InsightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InsightsTable> {
  $$InsightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get evidence =>
      $composableBuilder(column: $table.evidence, builder: (column) => column);

  GeneratedColumn<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$InsightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InsightsTable,
          Insight,
          $$InsightsTableFilterComposer,
          $$InsightsTableOrderingComposer,
          $$InsightsTableAnnotationComposer,
          $$InsightsTableCreateCompanionBuilder,
          $$InsightsTableUpdateCompanionBuilder,
          (Insight, BaseReferences<_$AppDatabase, $InsightsTable, Insight>),
          Insight,
          PrefetchHooks Function()
        > {
  $$InsightsTableTableManager(_$AppDatabase db, $InsightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InsightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InsightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InsightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> evidence = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InsightsCompanion(
                id: id,
                title: title,
                message: message,
                type: type,
                evidence: evidence,
                isDismissed: isDismissed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String message,
                required String type,
                required String evidence,
                Value<bool> isDismissed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InsightsCompanion.insert(
                id: id,
                title: title,
                message: message,
                type: type,
                evidence: evidence,
                isDismissed: isDismissed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InsightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InsightsTable,
      Insight,
      $$InsightsTableFilterComposer,
      $$InsightsTableOrderingComposer,
      $$InsightsTableAnnotationComposer,
      $$InsightsTableCreateCompanionBuilder,
      $$InsightsTableUpdateCompanionBuilder,
      (Insight, BaseReferences<_$AppDatabase, $InsightsTable, Insight>),
      Insight,
      PrefetchHooks Function()
    >;
typedef $$CustomGoalsTableCreateCompanionBuilder =
    CustomGoalsCompanion Function({
      required String id,
      required String targetType,
      Value<String?> targetIdentifier,
      required int limitMinutes,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$CustomGoalsTableUpdateCompanionBuilder =
    CustomGoalsCompanion Function({
      Value<String> id,
      Value<String> targetType,
      Value<String?> targetIdentifier,
      Value<int> limitMinutes,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$CustomGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomGoalsTable> {
  $$CustomGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetIdentifier => $composableBuilder(
    column: $table.targetIdentifier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get limitMinutes => $composableBuilder(
    column: $table.limitMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomGoalsTable> {
  $$CustomGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetIdentifier => $composableBuilder(
    column: $table.targetIdentifier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get limitMinutes => $composableBuilder(
    column: $table.limitMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomGoalsTable> {
  $$CustomGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetIdentifier => $composableBuilder(
    column: $table.targetIdentifier,
    builder: (column) => column,
  );

  GeneratedColumn<int> get limitMinutes => $composableBuilder(
    column: $table.limitMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$CustomGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomGoalsTable,
          CustomGoal,
          $$CustomGoalsTableFilterComposer,
          $$CustomGoalsTableOrderingComposer,
          $$CustomGoalsTableAnnotationComposer,
          $$CustomGoalsTableCreateCompanionBuilder,
          $$CustomGoalsTableUpdateCompanionBuilder,
          (
            CustomGoal,
            BaseReferences<_$AppDatabase, $CustomGoalsTable, CustomGoal>,
          ),
          CustomGoal,
          PrefetchHooks Function()
        > {
  $$CustomGoalsTableTableManager(_$AppDatabase db, $CustomGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> targetType = const Value.absent(),
                Value<String?> targetIdentifier = const Value.absent(),
                Value<int> limitMinutes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomGoalsCompanion(
                id: id,
                targetType: targetType,
                targetIdentifier: targetIdentifier,
                limitMinutes: limitMinutes,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String targetType,
                Value<String?> targetIdentifier = const Value.absent(),
                required int limitMinutes,
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomGoalsCompanion.insert(
                id: id,
                targetType: targetType,
                targetIdentifier: targetIdentifier,
                limitMinutes: limitMinutes,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomGoalsTable,
      CustomGoal,
      $$CustomGoalsTableFilterComposer,
      $$CustomGoalsTableOrderingComposer,
      $$CustomGoalsTableAnnotationComposer,
      $$CustomGoalsTableCreateCompanionBuilder,
      $$CustomGoalsTableUpdateCompanionBuilder,
      (
        CustomGoal,
        BaseReferences<_$AppDatabase, $CustomGoalsTable, CustomGoal>,
      ),
      CustomGoal,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsTableCreateCompanionBuilder =
    UserSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$UserSettingsTableUpdateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$UserSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTable,
          UserSetting,
          $$UserSettingsTableFilterComposer,
          $$UserSettingsTableOrderingComposer,
          $$UserSettingsTableAnnotationComposer,
          $$UserSettingsTableCreateCompanionBuilder,
          $$UserSettingsTableUpdateCompanionBuilder,
          (
            UserSetting,
            BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
          ),
          UserSetting,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTable,
      UserSetting,
      $$UserSettingsTableFilterComposer,
      $$UserSettingsTableOrderingComposer,
      $$UserSettingsTableAnnotationComposer,
      $$UserSettingsTableCreateCompanionBuilder,
      $$UserSettingsTableUpdateCompanionBuilder,
      (
        UserSetting,
        BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
      ),
      UserSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppCatalogTableTableManager get appCatalog =>
      $$AppCatalogTableTableManager(_db, _db.appCatalog);
  $$AppCategoriesTableTableManager get appCategories =>
      $$AppCategoriesTableTableManager(_db, _db.appCategories);
  $$UsageDailyTableTableManager get usageDaily =>
      $$UsageDailyTableTableManager(_db, _db.usageDaily);
  $$UsageHourlyTableTableManager get usageHourly =>
      $$UsageHourlyTableTableManager(_db, _db.usageHourly);
  $$UsageSyncStateTableTableManager get usageSyncState =>
      $$UsageSyncStateTableTableManager(_db, _db.usageSyncState);
  $$RestrictionRulesTableTableManager get restrictionRules =>
      $$RestrictionRulesTableTableManager(_db, _db.restrictionRules);
  $$RestrictionTargetsTableTableManager get restrictionTargets =>
      $$RestrictionTargetsTableTableManager(_db, _db.restrictionTargets);
  $$RestrictionOverridesTableTableManager get restrictionOverrides =>
      $$RestrictionOverridesTableTableManager(_db, _db.restrictionOverrides);
  $$FocusProfilesTableTableManager get focusProfiles =>
      $$FocusProfilesTableTableManager(_db, _db.focusProfiles);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$RoutineStepsTableTableManager get routineSteps =>
      $$RoutineStepsTableTableManager(_db, _db.routineSteps);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitEntriesTableTableManager get habitEntries =>
      $$HabitEntriesTableTableManager(_db, _db.habitEntries);
  $$HabitStreaksTableTableManager get habitStreaks =>
      $$HabitStreaksTableTableManager(_db, _db.habitStreaks);
  $$InsightsTableTableManager get insights =>
      $$InsightsTableTableManager(_db, _db.insights);
  $$CustomGoalsTableTableManager get customGoals =>
      $$CustomGoalsTableTableManager(_db, _db.customGoals);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
}
