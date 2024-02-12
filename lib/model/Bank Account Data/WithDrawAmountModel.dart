class WithdrawAmount {
  WithdrawAmount({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory WithdrawAmount.fromJson(Map<String, dynamic> json) => WithdrawAmount(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.withdrawalAmount,
    required this.actual_requested_amount,
  });

  String withdrawalAmount;
  String actual_requested_amount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        withdrawalAmount: json["withdrawal_amount"],
        actual_requested_amount: json["actual_requested_amount"],
      );

  Map<String, dynamic> toJson() => {
        "withdrawal_amount": withdrawalAmount,
        "actual_requested_amount": actual_requested_amount,
      };
}
