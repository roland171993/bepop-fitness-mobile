import '../../utils/shared_import.dart';
import 'package:mobx/mobx.dart';
part 'NotificationStore.g.dart';

class NotificationStore = NotificationStoreBase with _$NotificationStore;

abstract class NotificationStoreBase with Store {
  @observable
  List<ReminderModel> mRemindList = ObservableList<ReminderModel>();

  @action
  Future<void> addToReminder(ReminderModel data) async {
    if (mRemindList.any((element) => element.id == data.id)) {
      mRemindList.removeWhere((element) => element.id == data.id);
    } else {
      mRemindList.add(data);
    }
    storeNotificationData();
  }

  @action
  Future<void> storeNotificationData() async {
    if (mRemindList.isNotEmpty) {
      await setValue(NOTIFICATION_DETAIL, jsonEncode(mRemindList));
      log(getStringAsync(NOTIFICATION_DETAIL));
    } else {
      await setValue(NOTIFICATION_DETAIL, '');
    }
  }

  @action
  Future<void> clearReminder() async {
    mRemindList.clear();
    storeNotificationData();
  }

  @action
  void addAllReminderListItem(List<ReminderModel> reminderList) {
    mRemindList.addAll(reminderList);
  }

  @action
  Future<void> removeToReminder(ReminderModel data) async {
    mRemindList.removeWhere((element) => element.id == data.id);
    storeNotificationData();
  }
}
