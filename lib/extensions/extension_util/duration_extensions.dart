import '../../utils/shared_import.dart';

// Duration Extensions
extension GetDurationUtils on Duration {
  ///  await Duration(seconds: 1).delay();
  Future<void> get delay => Future.delayed(this);
}
