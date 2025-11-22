import '../../domain/entities/material_item.dart';

class MaterialDetailArgs {
  final MaterialItem item;
  MaterialDetailArgs({required this.item});
}

class ChatScreenArgs {
  final String otherUserId;
  final String materialId;
  ChatScreenArgs({required this.otherUserId, required this.materialId});
}

class PaymentScreenArgs {
  final MaterialItem material;
  PaymentScreenArgs({required this.material});
}

class MapScreenArgs {
  final MaterialItem item;
  MapScreenArgs({required this.item});
}
