import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<List<String>> {
  NotificationCubit() : super([]);

  void addNotification(dynamic notification) {
    print('Notificação recebida: $notification');
    
    if (notification is Map<String, dynamic>) {
      String notificationText = notification['text'] ?? 'Sem texto';
      print('Texto da notificação: $notificationText');
      
      final updatedNotifications = List<String>.from(state);
      updatedNotifications.add(notificationText);
      emit(updatedNotifications);
    } else {
      print('Formato de mensagem inesperado');
    }
  }
}
