import 'package:drift/drift.dart';
import '../../core/logging/app_logger.dart';
import '../../core/platform/platform_bridge.dart';
import '../database/app_database.dart';

class CatalogRepository {
  final AppDatabase _db;
  final PlatformBridge _bridge;

  CatalogRepository(this._db, this._bridge);

  Future<void> syncInstalledApps() async {
    try {
      final apps = await _bridge.getInstalledApplications();
      final allCategories = await _db.select(_db.appCategories).get();
      final categoryMap = {
        for (final c in allCategories) c.name.toLowerCase(): c.id,
      };

      await _db.transaction(() async {
        for (final app in apps) {
          final existing =
              await (_db.select(_db.appCatalog)
                    ..where((tbl) => tbl.packageName.equals(app.packageName)))
                  .getSingleOrNull();

          int? autoCategoryId;
          if (app.category != null && app.category != 'uncategorized') {
            autoCategoryId = categoryMap[app.category!.toLowerCase()];
          }

          if (existing == null) {
            await _db
                .into(_db.appCatalog)
                .insert(
                  AppCatalogCompanion.insert(
                    packageName: app.packageName,
                    appName: app.appName,
                    isSystemApp: Value(app.isSystemApp),
                    categoryId: Value(autoCategoryId),
                  ),
                );
          } else {
            await (_db.update(
              _db.appCatalog,
            )..where((tbl) => tbl.packageName.equals(app.packageName))).write(
              AppCatalogCompanion(
                appName: Value(app.appName),
                categoryId:
                    existing.categoryId == null && autoCategoryId != null
                        ? Value(autoCategoryId)
                        : const Value.absent(),
                updatedAt: Value(DateTime.now()),
              ),
            );
          }
        }
      });
    } catch (e, st) {
      AppLogger.error('Failed to sync installed apps into catalog', e, st);
    }
  }

  Stream<List<AppCatalogData>> watchAllApps() {
    return (_db.select(
      _db.appCatalog,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.appName)])).watch();
  }

  Future<List<AppCatalogData>> getAllApps() {
    return (_db.select(
      _db.appCatalog,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.appName)])).get();
  }

  Future<void> updateCategory(String packageName, int? categoryId) async {
    await (_db.update(
      _db.appCatalog,
    )..where((tbl) => tbl.packageName.equals(packageName))).write(
      AppCatalogCompanion(
        categoryId: Value(categoryId),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> setAppExcluded(String packageName, bool isExcluded) async {
    await (_db.update(
      _db.appCatalog,
    )..where((tbl) => tbl.packageName.equals(packageName))).write(
      AppCatalogCompanion(
        isExcluded: Value(isExcluded),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<AppCategory>> watchCategories() {
    return _db.select(_db.appCategories).watch();
  }
}
