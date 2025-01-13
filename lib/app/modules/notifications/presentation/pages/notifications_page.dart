import 'package:connect/app/core/custom/custom_icons.dart';
import 'package:connect/app/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/app/modules/navigation/presentation/components/custom_appbar.dart';
import 'package:connect/app/modules/notifications/presentation/cubits/noification_cubit.dart';
import 'package:connect/app/modules/notifications/presentation/cubits/notification_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationCubit cubit = Modular.get<NotificationCubit>();
  final String? userId = Modular.get<AuthCubit>().currentUser?.uid;

  @override
  void initState() {
    super.initState();

    cubit.getNotifications();
  }

  void readNotification(String notificationId) async {
    setState(() {
      final notificationIndex = cubit.state.notifications
          .indexWhere((notification) => notification.id == notificationId);

      if (notificationIndex != -1) {
        final updatedNotification =
            cubit.state.notifications[notificationIndex];

        updatedNotification.visualized.add(userId!);

        cubit.state.notifications[notificationIndex] = updatedNotification;
      }
    });

    await cubit.readNotification(notificationId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is NotificationLoading) {
          return const Scaffold(
            appBar: CustomAppBar(selectedIndex: 5, title: "Notificações"),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is NotificationsLoaded) {
          final notifications = state.notifications;

          return Scaffold(
            appBar: const CustomAppBar(selectedIndex: 5, title: "Notificações"),
            body: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: RefreshIndicator(
                onRefresh: () async {
                  await cubit.getNotifications();
                },
                child: ListView.builder(
                  itemCount: notifications.length,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final isVisualized =
                        notification.visualized.contains(userId);

                    return GestureDetector(
                      onTap: () => readNotification(notification.id),
                      child: Container(
                        width: double.infinity,
                        height: 95,
                        margin: const EdgeInsets.only(bottom: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isVisualized
                              ? Colors.transparent
                              : Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 50, // Ajuste o valor conforme necessário
                            alignment: Alignment.center,
                            child: _getNotificationIcon(notification.type),
                          ),
                          title: Text(
                            isVisualized ? "Notificação" : "Nova notificação",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            notification.text,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }

        return const Scaffold(
          appBar: CustomAppBar(selectedIndex: 5, title: "Notificações"),
          body: Center(
            child: Text("Nenhuma notiificação disponível"),
          ),
        );
      },
    );
  }

  Icon _getNotificationIcon(String type) {
    switch (type) {
      case "feed":
        return Icon(
          CustomIcons.feed,
          size: 25,
          color: Theme.of(context).colorScheme.primary,
        );
      case "birthday":
        return Icon(
          CustomIcons.cake,
          size: 30,
          color: Theme.of(context).colorScheme.primary,
        );
      case "contact":
        return Icon(
          CustomIcons.contacts,
          size: 30,
          color: Theme.of(context).colorScheme.primary,
        );
      case "mission":
        return Icon(
          CustomIcons.target,
          size: 30,
          color: Theme.of(context).colorScheme.primary,
        );
      default:
        return Icon(
          CustomIcons.feed,
          size: 25,
          color: Theme.of(context).colorScheme.primary,
        );
    }
  }
}
