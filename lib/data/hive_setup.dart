import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

// Initialize Hive and open boxes
Future<void> initHive() async {
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(CompanyAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(HistoryItemAdapter());

  // Open Boxes
  await Hive.openBox<Company>('companies');
  await Hive.openBox<Product>('products');
  await Hive.openBox<HistoryItem>('history');
}

// --- HISTORY MODEL & ADAPTER ---

@HiveType(typeId: 2)
class HistoryItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String actionType;

  @HiveField(4)
  final int quantityChange;

  HistoryItem({
    String? id,
    required this.productName,
    required this.date,
    required this.actionType,
    required this.quantityChange,
  }) : id = id ?? const Uuid().v4();
}

class HistoryItemAdapter extends TypeAdapter<HistoryItem> {
  @override
  final int typeId = 2;

  @override
  HistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryItem(
      id: fields[0] as String?,
      productName: fields[1] as String,
      date: fields[2] as DateTime,
      actionType: fields[3] as String,
      quantityChange: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.actionType)
      ..writeByte(4)
      ..write(obj.quantityChange);
  }
}

// --- COMPANY MODEL & ADAPTER ---

@HiveType(typeId: 0)
class Company extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name; // Changed to non-final so you can edit it later

  @HiveField(3)
  int? colorValue; // Changed to non-final so you can edit it later

  Company({String? id, required this.name, this.colorValue})
    : id = id ?? const Uuid().v4();
}

class CompanyAdapter extends TypeAdapter<Company> {
  @override
  final int typeId = 0;

  @override
  Company read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Company(
      id: fields[0] as String?,
      name: fields[1] as String,
      colorValue: fields.containsKey(3) ? fields[3] as int? : null,
    );
  }

  @override
  void write(BinaryWriter writer, Company obj) {
    writer
      ..writeByte(3) // Changed from 4 to 3 because we removed visitDay
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      // Skipped byte 2 (visitDay) entirely to keep data clean
      ..writeByte(3)
      ..write(obj.colorValue);
  }
}

// --- PRODUCT MODEL & ADAPTER ---

@HiveType(typeId: 1)
class Product extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String companyId;

  @HiveField(2)
  String name; // Changed to non-final for editing

  @HiveField(3)
  int stock;

  @HiveField(4)
  int targetStock; // Changed to non-final for editing

  Product({
    String? id,
    required this.companyId,
    required this.name,
    this.stock = 0,
    this.targetStock = 10,
  }) : id = id ?? const Uuid().v4();
}

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 1;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as String?,
      companyId: fields[1] as String,
      name: fields[2] as String,
      stock: fields[3] as int,
      targetStock: fields[4] as int? ?? 10,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companyId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.stock)
      ..writeByte(4)
      ..write(obj.targetStock);
  }
}
