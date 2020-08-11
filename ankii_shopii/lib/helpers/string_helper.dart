import 'package:intl/intl.dart';

String numberToMoneyString(int price, {String unit = 'đ'}) {
  return NumberFormat("#,###", "vi_VN").format(price) + unit;
}
