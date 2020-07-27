import 'package:intl/intl.dart';

String numberToMoneyString(int price) {
  return NumberFormat("#,###", "vi_VN").format(price);
}
