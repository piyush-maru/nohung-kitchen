import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:kitchen/model/AddOffer.dart';
import 'package:kitchen/model/BeanAddLunch.dart';
import 'package:kitchen/model/BeanAddMenu.dart';
import 'package:kitchen/model/BeanAddPackage.dart';
import 'package:kitchen/model/BeanAddPackageMeal.dart';
import 'package:kitchen/model/BeanAddPackagePrice.dart';
import 'package:kitchen/model/BeanApplyOrderFilter.dart';
import 'package:kitchen/model/BeanDeletePackage.dart';
import 'package:kitchen/model/BeanDinnerAdd.dart';
import 'package:kitchen/model/BeanGetLiveOrders.dart';
import 'package:kitchen/model/BeanGetOrderDetails.dart';
import 'package:kitchen/model/BeanGetOrderRequest.dart';
import 'package:kitchen/model/BeanGetPackages.dart';
import 'package:kitchen/model/BeanOrderAccepted.dart';
import 'package:kitchen/model/BeanOrderCancel.dart';
import 'package:kitchen/model/BeanOrderRejected.dart';
import 'package:kitchen/model/BeanPackagePriceDetail.dart';
import 'package:kitchen/model/BeanSaveMenu.dart';
import 'package:kitchen/model/BeanSendMessage.dart';
import 'package:kitchen/model/BeanSignUp.dart';
import 'package:kitchen/model/BeanUpdateMenuStock.dart';
import 'package:kitchen/model/BeanUpdateSetting.dart';
import 'package:kitchen/model/Category/AddCategory.dart';
import 'package:kitchen/model/EditCategory.dart';
import 'package:kitchen/model/EditCategoryItem.dart';
import 'package:kitchen/model/EditOffer.dart';
import 'package:kitchen/model/GetActiveOrder.dart';
import 'package:kitchen/model/GetArchiveOffer.dart';
import 'package:kitchen/model/GetCategories.dart';
import 'package:kitchen/model/GetCategoryDetails.dart';
import 'package:kitchen/model/GetCategoryItemDetails.dart';
import 'package:kitchen/model/GetCategoryItems.dart';
import 'package:kitchen/model/GetChat.dart';
import 'package:kitchen/model/GetLiveOffer.dart';
import 'package:kitchen/model/GetOfferDetail.dart';
import 'package:kitchen/model/GetOrderHistory.dart';
import 'package:kitchen/model/GetOrderTrialRequest.dart';
import 'package:kitchen/model/GetUpComingOrder.dart';
import 'package:kitchen/model/ReadyToPickupOrder.dart';
import 'package:kitchen/model/UpdateMenuDetails.dart';
import 'package:kitchen/model/breakfastModel.dart';
import 'package:kitchen/model/getKitchenStatus.dart';
import 'package:kitchen/model/getMealScreenItems.dart';
import 'package:kitchen/model/live_order_model.dart';
import 'package:kitchen/model/updateItemStock.dart';
import 'package:kitchen/model/updatePackageAvailability.dart';
import 'package:kitchen/network/EndPoints.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:logger/logger.dart';

import '../model/Bank Account Data/BeanAddAccount.dart';
import '../model/Bank Account Data/BeanPayment.dart';
import '../model/Bank Account Data/GetPayment.dart';
import '../model/Bank Account Data/WithDrawAmountModel.dart';
import '../model/Bank Account Data/bankAccountsModel.dart';
import '../model/Category/AddCategoryItem.dart';
import '../model/GetTrackDeliveries.dart';
import '../model/KitchenData/BeanForgotPassword.dart';
import '../model/KitchenData/BeanGetDashboard.dart';
import '../model/KitchenData/BeanLogin.dart';
import '../model/KitchenData/GetAccountDetail.dart';
import '../model/Rearrange Category/rearrangeCategory.dart';
import '../model/Rearrange Category/rearrangeCategoryItems.dart';
import '../model/WalletModel.dart';
import '../utils/Utils.dart';

class ApiProvider {
  static const String TAG = "ApiProvider";
  Logger log = Logger();
  // Dio? _dio;
  // DioError? _dioError;

  // ApiProvider() {
  //   BaseOptions dioOptions = BaseOptions()..baseUrl = testingUrl;
  //   // _dio = Dio(dioOptions);
  //   _dio = Dio(BaseOptions(baseUrl: testingUrl));
  //   _dio!.interceptors
  //       .add(InterceptorsWrapper(onRequest: (options, handler) async {
  //     options.headers = {
  //       'Content-Type': 'multipart/form-data',
  //     };
  //     DioLogger.onSend(TAG, options);
  //     return handler.next(options);
  //   }, onResponse: (Response response, ResponseInterceptorHandler handler) {
  //     DioLogger.onSuccess(TAG, response);
  //     return handler.next(response);
  //   }, onError: (DioError err, ErrorInterceptorHandler handler) {
  //     DioLogger.onError(TAG, err);
  //     return handler.next(err);
  //   }));
  // }

  Future<BeanSignUp> registerUser(
    String kitchenName,
    String kitchenAddress,
    String pinCode,
    String contactPersonName,
    String contactPersonRole,
    String mobileNumber,
    String kitchenContactNumber,
    String licence,
    String expDate,
    String panCard,
    String gst,
    String email,
    String? stateId,
    String? cityId,
    String dateCtlController,
    File? _uploadImage,
    File? _uploadImage1,
    File? _uploadImage2,
    File? _uploadImage3,
    File? _uploadImage4,
  ) async {
    try {
      http.Response response =
          await http.post(Uri.parse("$testingUrl${EndPoints.register}"), body: {
        {
          "token": "123456789",
          "kitchenname": kitchenName,
          "address": kitchenAddress,
          "stateid": stateId.toString(),
          "cityid": cityId.toString(),
          "pincode": pinCode,
          "contactpersonname": contactPersonName,
          "contactpersonrole": contactPersonRole,
          "mobilenumber": mobileNumber,
          "kitchenscontactnumber": kitchenContactNumber,
          "email": email,
          "FSSAILicenceNo": licence,
          "expirydate": dateCtlController,
          "pancard": panCard,
          "gstnumber": gst,
          "menufile": _uploadImage4,
          "pan_card": _uploadImage,
          "fssai_certificate": _uploadImage2,
          "gst_certificate": _uploadImage1,
          "business_address_proof": _uploadImage3,
        }
      });
      if (response.statusCode == 200) {
        BeanSignUp signUp = BeanSignUp.fromJson(
          jsonDecode(response.body),
        );
        return signUp;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<BeanLogin> loginUser(String kitchenId, String password) async {
    try {
      http.Response response =
          await http.post(Uri.parse("$testingUrl${EndPoints.login}"), body: {
        "kitchen_id": kitchenId,
        "token": "123456789",
        "password": password,
      });
      if (response.statusCode == 200) {
        BeanLogin beanLogin = BeanLogin.fromJson(
          json.decode(response.body),
        );
        return beanLogin;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<BeanPayment> beanPayment(
      String amount, String fromDate, String _selectedDate ,String actualAmount) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.withdraw_payment}"), body: {
        "kitchen_id": userBean.data!.id,
        "token": "123456789",
        "withdraw_amount": amount,
        "actual_amount": actualAmount,
        "from_date": fromDate,
        "to_date": _selectedDate
      });
      if (response.statusCode == 200) {
        BeanPayment beanPayment = BeanPayment.fromJson(
          json.decode(response.body),
        );
        var log = Logger();
        log.f(json.decode(response.body));
        return beanPayment;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<WithdrawAmount> getWithdrawAmount(
      String fromDate, String _selectedDate) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse("$testingUrl${EndPoints.get_withdrawal_amount}"),
          body: {
            "kitchen_id": userBean.data!.id,
            "token": "123456789",
            "from_date": fromDate,
            "to_date": _selectedDate
          });
      if (response.statusCode == 200) {
        WithdrawAmount withdrawAmount = WithdrawAmount.fromJson(
          json.decode(response.body),
        );
        return withdrawAmount;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future delete_Menu_item(String menuId) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.delete_menu_item}"), body: {
        'token': '123456789',
        'kitchen_id': userBean.data!.id,
        'menu_id': menuId
      });
      return json.decode(response.body);
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future getState() async {
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_state}"),
        body: {'token': '123456789'});
    return json.decode(response.body);
  }

  Future deleteOffer(String resultId) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.delete_offer}"), body: {
        'token': '123456789',
        'user_id': userBean.data!.id,
        "offer_id": resultId,
      });
      return json.decode(response.body);
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future getCity(String stateId) async {
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_city}"),
        body: {'token': '123456789', "state_id": stateId});
    return json.decode(response.body);
  }

  Future<BeanAddMenu> getMenuPackageList(String packageId) async {
    try {
      BeanLogin userId = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.get_package_info}"), body: {
        "kitchen_id": userId.data!.id,
        "token": "123456789",
        "package_id": packageId,
      });
      if (response.statusCode == 200) {
        BeanAddMenu beanAddMenu = BeanAddMenu.fromJson(
          json.decode(response.body),
        );
        return beanAddMenu;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<BeanAddAccount> beanAddAccount(String accountName, String bank,
      String ifscCode, String accountNumber) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse("$testingUrl${EndPoints.add_account_details}"),
          body: {
            "kitchen_id": userBean.data!.id,
            "token": "123456789",
            "account_name": accountName,
            "bank_name": bank,
            "ifsc_code": ifscCode,
            "account_number": accountNumber,
          });
      if (response.statusCode == 200) {
        BeanAddAccount beanAddAccount = BeanAddAccount.fromJson(
          json.decode(response.body),
        );
        return beanAddAccount;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<BeanSaveMenu> beanSaveMenu(
      isSelectVeg,
      String cuisineType,
      String? nameValidation,
      String? priceValidation,
      MultipartFile? imageValidation) async {
    BeanLogin beanLogin = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.add_breakfast_menu}"), body: {
      "kitchen_id": beanLogin.data!.id,
      "token": "123456789",
      "category": isSelectVeg,
      "cuisinetype": cuisineType,
      "itemname[]": nameValidation!,
      "price[]": priceValidation!,
      "item_image1": imageValidation
    });
    if (response.statusCode == 200) {
      BeanSaveMenu beanSaveMenu = BeanSaveMenu.fromJson(
        json.decode(response.body),
      );
      return beanSaveMenu;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanSaveMenu> uploadProfileImage(MultipartFile mediaFile) async {
    BeanLogin beanLogin = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.update_profile_image}"), body: {
      "user_id": beanLogin.data!.id,
      "token": "123456789",
      "profile_image": mediaFile,
    });
    if (response.statusCode == 200) {
      BeanSaveMenu beanSaveMenu = BeanSaveMenu.fromJson(
        json.decode(response.body),
      );
      return beanSaveMenu;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanLunchAdd> beanLunchAdd(
      String category,
      String cuisineType,
      String itemName,
      String price,
      MultipartFile image,
      String menuType) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.add_lunch_dinner_menu}"),
        body: {
          "kitchen_id": userBean.data!.id,
          "token": "123456789",
          "category": category,
          "cuisinetype": cuisineType,
          "itemname[]": itemName,
          "price[]": price,
          "item_image1": image,
          "menutype[]": menuType
        });
    if (response.statusCode == 200) {
      BeanLunchAdd beanLunchAdd = BeanLunchAdd.fromJson(
        json.decode(response.body),
      );
      return beanLunchAdd;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanDinnerAdd> beanDinnerAdd(String category, String cuisineType,
      String name, String price, MultipartFile image) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.add_dinner_menu}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "category": category,
      "cuisinetype": cuisineType,
      "itemname[]": name,
      "price[]": price,
      "item_image1": image,
    });
    if (response.statusCode == 200) {
      return BeanDinnerAdd.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanForgotPassword> forgotPassword(String email) async {
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.forgot_password}"),
        body: {"email": email, "token": "123456789"});
    if (response.statusCode == 200) {
      BeanForgotPassword beanForgotPassword = BeanForgotPassword.fromJson(
        json.decode(response.body),
      );
      return beanForgotPassword;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BreakfastModel> beanGetLunch() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_lunch_dinner_menu}"),
        body: {
          "kitchen_id": userBean.data!.id,
          "token": "123456789",
        });
    if (response.statusCode == 200) {
      BreakfastModel breakfastModel = BreakfastModel.fromJson(
        json.decode(response.body),
      );
      return breakfastModel;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BreakfastModel> beanGetDinner() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.get_dinner_menu}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
    });
    if (response.statusCode == 200) {
      BreakfastModel breakfastModel = BreakfastModel.fromJson(
        json.decode(response.body),
      );
      return breakfastModel;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<GetArchieveOffer> getArchieveOffer() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.get_archive_offer}"), body: {
      "user_id": userBean.data!.id,
      "token": "123456789",
    });
    if (response.statusCode == 200) {
      GetArchieveOffer getArchiveOffer = GetArchieveOffer.fromJson(
        json.decode(response.body),
      );
      return getArchiveOffer;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<GetOfferDetail> getOfferDetail(String offerId) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.get_offer_detail}"), body: {
      "user_id": userBean.data!.id,
      'offer_id': offerId,
      "token": "123456789"
    });
    if (response.statusCode == 200) {
      return GetOfferDetail.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanGetDashboard> beanGetDashboard() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_dashboard_detail}"),
        body: {"kitchen_id": userBean.data!.id, "token": "123456789"});
    if (response.statusCode == 200) {
      return BeanGetDashboard.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BreakfastModel> getMenu() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_menu}"),
        body: {"token": "123456789", "kitchen_id": userBean.data!.id});
    if (response.statusCode == 200) {
      return BreakfastModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future getOrderRequest() async {
    BeanLogin userBean = await Utils.getUser();
    print("kitchen id");
    print(userBean.data!.id);
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.get_orders_requests}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
    });
    // log.e(json.decode(response.body));
    return BeanGetOrderRequest.fromJson(
      json.decode(response.body),
    );
  }

  Future liveOrdesr(/*String type*/) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http.post(Uri.parse("$testingUrl${EndPoints.get_live_order}"), body: {
      "token": "123456789",
      "kitchen_id": userBean.data!.id,
     //"page_no": "1",
     //"order_status": "all",
     //"order_type": type,
    });

    return LiveOrderModel1.fromJson(json.decode(response.body),);
  }

  Future<GetUpComingOrder> getUpComingOrder() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.get_upcoming_orders}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "filter_fromdate": '',
      "filter_todate": "",
      "filter_order_number": ""
    });
    if (response.statusCode == 200) {
      return GetUpComingOrder.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanGetLiveOrders> getLiveOrder(
      String page, String orderStatus) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.get_live_orders}"), body: {
      "kitchen_id": userBean.data!.id.toString(),
      "token": "123456789",
      "page_no": page,
      "order_status": orderStatus
      // "filter_fromdate": '2021-10-8',
      // "filter_todate": "",
      // "filter_order_number": ""
    });
    if (response.statusCode == 200) {
      return BeanGetLiveOrders.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<GetActiveOrder> getActiveOrder() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.get_active_orders}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "filter_fromdate": '2021-10-8',
      "filter_todate": "",
      "filter_order_number": ""
    });
    if (response.statusCode == 200) {
      return GetActiveOrder.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<ReadyToPickupOrder> readyToPickupOrder(String orderItemsId) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.ready_to_pick_order}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": '123456789',
      "orderitems_id": orderItemsId,
    });
    if (response.statusCode == 200) {
      return ReadyToPickupOrder.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<GetOrderHistory> getOrderHistory() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response =
        await http.post(Uri.parse(EndPoints.get_order_history), body: {
      "kitchen_id": userBean.data!.id.toString(),
      "token": "123456789",
    });
    if (response.statusCode == 200) {
      GetOrderHistory getOrderHistory = GetOrderHistory.fromJson(
        json.decode(response.body),
      );
      return getOrderHistory;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<GetOrderTrialRequest> geTrialRequest() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_orders_trial_requests}"),
        body: {
          "kitchen_id": userBean.data!.id,
          "token": "123456789",
          "filter_fromdate": '',
          "filter_todate": "",
          "filter_order_number": ""
        });
    if (response.statusCode == 200) {
      GetOrderTrialRequest getOrderTrialRequest = GetOrderTrialRequest.fromJson(
        json.decode(response.body),
      );
      return getOrderTrialRequest;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<GetTrackDeliveries> geTrackDeliveries() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.get_track_deliveries}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
    });
    if (response.statusCode == 200) {
      return GetTrackDeliveries.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanOrderAccepted> orderAccept(
      String orderId, String subscriptionType) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.accept_order}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "order_id": orderId,
      "subscription_type": subscriptionType
      //subscription new and trial comes under new else old
      //order_id for trial
      //orderItem id for subscription
    });
    print("======================>${subscriptionType}");
    if (response.statusCode == 200) {
      return BeanOrderAccepted.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanOrderRejected> orderReject(
      String orderId, String? subscriptionType) async {
    BeanLogin userBean = await Utils.getUser();

    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.reject_order}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "order_id": orderId,
      "subscription_type": subscriptionType
    });

    if (response.statusCode == 200) {
      BeanOrderRejected beanOrderRejected = BeanOrderRejected.fromJson(
        json.decode(response.body),
      );
      return beanOrderRejected;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<MealScreenItems> getMealScreenItems(String packageId) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.get_package_meal}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "package_id": packageId,
    });
    if (response.statusCode == 200) {
      MealScreenItems mealScreenItems = MealScreenItems.fromJson(
        json.decode(response.body),
      );
      return mealScreenItems;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<GetPayment> getPay(String page) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.get_transaction}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "page_no": page
    });
    if (response.statusCode == 200) {
      GetPayment getPayment = GetPayment.fromJson(
        json.decode(response.body),
      );
      Logger log = Logger();
      log.f(json.decode(response.body));
      return getPayment;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<WalletModel> getWallet() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response =
        await http.post(Uri.parse("$testingUrl${EndPoints.get_wallet}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
    });
    if (response.statusCode == 200) {
      return WalletModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanSendMessage> sendMessage(String messageInput) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.send_message}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "message": messageInput,
    });
    if (response.statusCode == 200) {
      return BeanSendMessage.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<GetChat> getChat() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_chat}"),
        body: {"kitchen_id": userBean.data!.id, "token": "123456789"});
    if (response.statusCode == 200) {
      return GetChat.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanUpdateSetting> updateSetting(String name, String address,
      String email, String password, String number, String description) async {
    BeanLogin userBean = await Utils.getUser();
    print("$testingUrl${EndPoints.update_settings}");
    print({
      "token": "123456789",
      "user_id": userBean.data!.id,
      "kitchen_name": name,
      "address": address,
      "email": email,
      "mobile_number": number,
      "password": password,
      "description": description,
    });

    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.update_settings}"), body: {
      "token": "123456789",
      "user_id": userBean.data!.id,
      "kitchen_name": name,
      "address": address,
      "email": email,
      "mobile_number": number,
      "password": password,
      "description": description,
    });
    if (response.statusCode == 200) {
      return BeanUpdateSetting.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<UpdateMenuDetail> updateMenuSetting(
      // String radiovalue,
      kitchens,
      String typesOfFood,
      String breakfastFromTime,
      String breakfastToTime,
      String lunchFromTime,
      String lunchToTime,
      String dinnerFromTime,
      String dinnerToTime,
      timings,
      String days,
      meals,
      foodTypes,
      String description) async {
    BeanLogin userBean = await Utils.getUser();
    print("$testingUrl${EndPoints.update_account_detail}");
    print(
        "++++++++++++++++++++++++++++++update menu++++++++++++++++++++++++++++++++");
    print({
      "token": "123456789",
      "user_id": userBean.data!.id,
      "type_of_food": typesOfFood,
      "shift_timing": json.encode(timings),
      "open_days": days,
      "type_of_meals": meals,
      'description': description,
      "breakfast_fromtime": breakfastFromTime,
      "breakfast_totime": breakfastToTime,
      "lunch_fromtime": lunchFromTime,
      "lunch_totime": lunchToTime,
      "dinner_fromtime": dinnerFromTime,
      "dinner_totime": dinnerToTime,
      "kitchentype": kitchens,
      "typeof_food1": foodTypes,
    }); /*print( {
      "token": "123456789",
      "user_id": userBean.data!.id,
      //"type_of_firm": radiovalue,
      "type_of_food": typesOfFood,
      "breakfast_fromtime": breakfastFromTime,
      "breakfast_totime": breakfastToTime,
      "lunch_fromtime": lunchFromTime,
      "lunch_totime": lunchToTime,
      "dinner_fromtime": dinnerFromTime,
      "dinner_totime": dinnerToTime,
      "shift_timing": jsonEncode(timings),
      "open_days": days,
      "type_of_meals": meals,
      'description': description,
    });*/
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.update_account_detail}"),
        body: {
          "token": "123456789",
          "user_id": userBean.data!.id,
          "type_of_food": typesOfFood,
          "shift_timing": json.encode(timings),
          "open_days": days,
          "type_of_meals": meals,
          'description': description,
          "breakfast_fromtime": breakfastFromTime,
          "breakfast_totime": breakfastToTime,
          "lunch_fromtime": lunchFromTime,
          "lunch_totime": lunchToTime,
          "dinner_fromtime": dinnerFromTime,
          "dinner_totime": dinnerToTime,
          "kitchentype": kitchens,
          "typeof_food": foodTypes,
        });
    if (response.statusCode == 200) {
      return UpdateMenuDetail.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<GetLiveOffer> getLiveOffers() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_live_offer}"),
        body: {"user_id": userBean.data!.id, "token": "123456789"});
    if (response.statusCode == 200) {
      return GetLiveOffer.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanGetPackages> getPackages() async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.get_package}"), body: {
      "token": "123456789",
      "user_id": userBean.data!.id,
    });
    // log.f(json.decode(response.body));
    if (response.statusCode == 200) {
      return BeanGetPackages.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanApplyOrderFilter> applyOrderFilter(
      String fromDate, String toDate, String orderId) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.apply_order_filter}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": '123456789',
      "fromdate": fromDate,
      "todate": toDate,
      "order_number": orderId,
    });
    if (response.statusCode == 200) {
      return BeanApplyOrderFilter.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanAddPackageMeals> addPackageMeal(String packageId, String day,
      String selectedList, String defaultList) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.add_package_meal}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": '123456789',
      "package_id": packageId,
      "day": int.parse(day),
      // "weekly_package_id": widget.weekly_package_id,
      "item_detail": selectedList,
      "defaultdishitem": defaultList,
    });
    if (response.statusCode == 200) {
      return BeanAddPackageMeals.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanPackagePriceDetail> getPackagePriceDetail(String packageId) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_package_price_detail}"),
        body: {
          "kitchen_id": userBean.data!.id,
          "token": "123456789",
          "package_id": packageId,
        });
    if (response.statusCode == 200) {
      return BeanPackagePriceDetail.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<MealScreenItems> getSelectedItem() async {
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.get_selected_item}"), body: {});
    if (response.statusCode == 200) {
      return MealScreenItems.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanAddPackagePrice> addPackagePrice(
      String packageId, String weekly, String monthly) async {
    BeanLogin userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.add_package_price}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": '123456789',
      "package_id": packageId,
      "weekly_price": weekly,
      "monthly_price": monthly
    });
    if (response.statusCode == 200) {
      return BeanAddPackagePrice.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BeanDeletePackage> deletePackage(String packageId) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.delete_package}"), body: {
        "kitchen_id": userBean.data!.id,
        "token": "123456789",
        "package_id": packageId,
      });
      if (response.statusCode == 200) {
        return BeanDeletePackage.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<KitchenStatus> updateKitchenAvailability(value) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse("$testingUrl${EndPoints.update_available_status}"),
          body: {
            "token": "123456789",
            "status": value,
            "kitchen_id": userBean.data!.id,
          });
      if (response.statusCode == 200) {
        KitchenStatus kitchenStatus = KitchenStatus.fromJson(
          json.decode(response.body),
        );
        return kitchenStatus;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<BeanUpdateMenuStock> updateMenuStock(
      String menuId, String inStock) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.update_menu_stock}"), body: {
        "kitchen_id": userBean.data!.id,
        "token": "123456789",
        "menu_id": menuId,
        "instock": inStock,
      });
      if (response.statusCode == 200) {
        BeanUpdateMenuStock beanUpdateMenuStock = BeanUpdateMenuStock.fromJson(
          json.decode(response.body),
        );
        return beanUpdateMenuStock;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<BeanAddPackage> addPackage(
      String packageName,
      String cuisineType,
      String mealType,
      String mealFor,
      String weeklyPlan,
      String monthlyPlan,
      String date,
      String includingSaturday,
      String includingSunday) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.add_package}"), body: {
        "user_id": userBean.data!.id,
        "token": "123456789",
        "package_name": packageName,
        "cuisine_type": cuisineType,
        "meal_type": mealType,
        "meal_for": mealFor,
        "weekly_plan_type": weeklyPlan,
        "monthly_plan_type": monthlyPlan,
        "start_date": date,
        "including_saturday": includingSaturday,
        "including_sunday": includingSunday
      });
      if (response.statusCode == 200) {
        BeanAddPackage beanAddPackage = BeanAddPackage.fromJson(
          json.decode(response.body),
        );
        return beanAddPackage;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<BeanAddPackage> updatePackage(
      String packageName,
      String packageId,
      String cuisineType,
      String mealType,
      String mealFor,
      String weeklyPlan,
      String monthlyPlan,
      String includingSaturday,
      String includingSunday,
      String startDate) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.update_package}"), body: {
        "user_id": userBean.data!.id,
        "token": "123456789",
        "package_name": packageName,
        "cuisine_type": cuisineType,
        "meal_type": mealType,
        "meal_for": mealFor,
        "weekly_plan_type": weeklyPlan,
        "monthly_plan_type": monthlyPlan,
        "start_date": startDate,
        "including_saturday": includingSaturday,
        "including_sunday": includingSunday,
        "package_id": packageId,
      });
      if (response.statusCode == 200) {
        BeanAddPackage beanAddPackage = BeanAddPackage.fromJson(
          json.decode(response.body),
        );
        return beanAddPackage;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<GetAccountDetails> getAccountDetails() async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse("$testingUrl${EndPoints.get_account_detail}"),
          body: {"user_id": userBean.data!.id, "token": "123456789"});
      if (response.statusCode == 200) {
        GetAccountDetails getAccountDetails = GetAccountDetails.fromJson(
          json.decode(response.body),
        );
        return getAccountDetails;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<BankAccountsModel> getBankAccounts() async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse("$testingUrl${EndPoints.get_bank_accounts}"),
          body: {"kitchen_id": userBean.data!.id, "token": "123456789"});
      if (response.statusCode == 200) {
        return BankAccountsModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future editBankAccount(String accountName, String bank, String ifscCode,
      String accountNumber) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.edit_bank_account}"), body: {
        "token": "123456789",
        "id": userBean.data!.id,
        "account_name": accountName,
        "bank_name": bank,
        "ifsc_code": ifscCode,
        "account_number": accountNumber
      });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future deleteBankAccount() async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse("$testingUrl${EndPoints.delete_bank_account}"),
          body: {
            {
              "token": "123456789",
              "id": userBean.data!.id,
            }
          });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<AddOffer> addOffer(
    String? title,
    String? type,
    String? value,
    String? sTime,
    String? eTime,
    String? minimumAmount,
    String? description,
    String? upToValue,
    String? discountCode,
    String? applyTo,
    String? minimumRequirement,
    String? limit,
    String? startDate,
    String? endDate,
  ) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.add_offer}"), body: {
        "user_id": userBean.data!.id,
        "offer_title": title,
        "offer_code": discountCode,
        "discount_type": type,
        "discount_value": value,
        "apply_to": applyTo,
        "minimum_requirement": minimumRequirement,
        "usage_limit": limit,
        "start_date": startDate,
        "end_date": endDate,
        "start_time": sTime,
        "end_time": eTime,
        "token": "123456789",
        "minimum_amount": minimumAmount,
        // "maximum_amount": maximumAmount,
        "description": description,
        "upto_amount": upToValue,
      });
      if (response.statusCode == 200) {
        AddOffer addOffer = AddOffer.fromJson(
          json.decode(response.body),
        );
        return addOffer;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<EditOffer> editOffer(
      String offerId,
      String title,
      String discountCode,
      String type,
      String value,
      String applyTo,
      String minimumRequirement,
      String limit,
      String startDate,
      String endDate,
      String startTime,
      String endTime,
      String minimumAmount,
      String uptoAmount,
      String description) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.update_offer}"), body: {
        "user_id": userBean.data!.id,
        "offer_id": offerId,
        "offer_title": title,
        "offer_code": discountCode,
        "discount_type": type,
        "discount_value": value,
        "apply_to": applyTo,
        "minimum_requirement": minimumRequirement,
        "usage_limit": limit,
        "start_date": startDate,
        "end_date": endDate,
        "start_time": startTime,
        "end_time": endTime,
        "token": "123456789",
        "minimum_amount": minimumAmount,
        // "maximum_amount":maximumAmount,
        "upto_amount": uptoAmount,
        "description": description,
      });
      print({
        "user_id": userBean.data!.id,
        "offer_id": offerId,
        "offer_title": title,
        "offer_code": discountCode,
        "discount_type": type,
        "discount_value": value,
        "apply_to": applyTo,
        "minimum_requirement": minimumRequirement,
        "usage_limit": limit,
        "start_date": startDate,
        "end_date": endDate,
        "start_time": startTime,
        "end_time": endTime,
        "token": "123456789",
        "minimum_amount": minimumAmount,
        // "maximum_amount":maximumAmount,
        "upto_amount": uptoAmount,
        "description": description,
      });
      if (response.statusCode == 200) {
        EditOffer editOffer = EditOffer.fromJson(
          json.decode(response.body),
        );

        return editOffer;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future getCategories() async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse("$testingUrl${EndPoints.all_category}"),
          body: {"kitchen_id": userBean.data!.id, "token": "123456789"});
      if (response.statusCode == 200) {
        GetCategories getCategories = GetCategories.fromJson(
          json.decode(response.body),
        );
        return getCategories;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<GetCategoryDetails> getCategoryDetail(String categoryId) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.category_details}"), body: {
        "kitchen_id": userBean.data!.id,
        'category_id': categoryId,
        "token": "123456789"
      });
      if (response.statusCode == 200) {
        GetCategoryDetails getCategoryDetails = GetCategoryDetails.fromJson(
          json.decode(response.body),
        );
        return getCategoryDetails;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<AddCategory> addCategory(String title, String description) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.add_category}"), body: {
        "kitchen_id": userBean.data!.id,
        "category_name": title,
        "description": description,
        "token": "123456789",
      });
      if (response.statusCode == 200) {
        AddCategory addCategory = AddCategory.fromJson(
          json.decode(response.body),
        );
        return addCategory;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<GetCategoryItemDetails> getCategoryItemDetail(
      String categoryId, String categoryItemId) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse("$testingUrl${EndPoints.category_item_details}"),
          body: {
            "kitchen_id": userBean.data!.id,
            'category_id': categoryId,
            "menu_id": categoryItemId,
            "token": "123456789"
          });
      if (response.statusCode == 200) {
        GetCategoryItemDetails getCategoryItemDetails =
            GetCategoryItemDetails.fromJson(
          json.decode(response.body),
        );
        return getCategoryItemDetails;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<EditCategory> editCategory(
      String categoryId, String title, String description) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.update_category}"), body: {
        "kitchen_id": userBean.data!.id,
        "category_id": categoryId,
        "category_name": title,
        "description": description,
        "token": "123456789",
      });
      if (response.statusCode == 200) {
        EditCategory editCategory = EditCategory.fromJson(
          json.decode(response.body),
        );
        return editCategory;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future deleteCategory(String categoryId) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.delete_category}"), body: {
        'token': '123456789',
        'kitchen_id': userBean.data!.id,
        'category_id': categoryId
      });
      return json.decode(response.body);
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<GetCategoryItems> getCategoryItems(String categoryId) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.category_items}"), body: {
        "kitchen_id": userBean.data!.id,
        "category_id": categoryId,
        "token": "123456789"
      });
      if (response.statusCode == 200) {
        GetCategoryItems getCategoryItems = GetCategoryItems.fromJson(
          json.decode(response.body),
        );
        return getCategoryItems;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<AddCategoryItem> addCategoryItem(
      String categoryId,
      String title,
      String itemPrice,
      String mealFor,
      String itemType,
      String cuisineType,
      String dishType,
      String description,
      MultipartFile image) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse("$testingUrl${EndPoints.add_item_to_category}"),
          body: {
            "kitchen_id": userBean.data!.id,
            "token": "123456789",
            "category_id": categoryId,
            "item_name": title,
            "item_price": itemPrice,
            "meal_for": mealFor,
            "item_type": itemType,
            "cuisine_type": cuisineType,
            "dish_type": dishType,
            "description": description,
            "image": image
          });
      if (response.statusCode == 200) {
        AddCategoryItem addCategoryItem = AddCategoryItem.fromJson(
          json.decode(response.body),
        );
        return addCategoryItem;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<EditCategoryItem> editCategoryItem(
      String categoryId,
      String categoryItemId,
      String title,
      String itemPrice,
      String mealFor,
      String itemType,
      String cuisineType,
      String dishType,
      String description,
      MultipartFile? image,
      String isRemoved) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse("$testingUrl${EndPoints.update_category_item}"),
          body: {
            "kitchen_id": userBean.data!.id,
            "token": "123456789",
            "category_id": categoryId,
            "menu_id": categoryItemId,
            "item_name": title,
            "item_price": itemPrice,
            "meal_for": mealFor,
            "item_type": itemType,
            "cuisine_type": cuisineType,
            "dish_type": dishType,
            "description": description,
            "image": image,
            "update_image": isRemoved,
          });
      if (response.statusCode == 200) {
        EditCategoryItem editCategoryItem = EditCategoryItem.fromJson(
          json.decode(response.body),
        );
        return editCategoryItem;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future addFirebaseToken(String token) async {
    try {
      BeanLogin login = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse(
            "$testingUrl${EndPoints.firebase_token}",
          ),
          body: {
            "token": "123456789",
            "user_id": login.data!.id,
            "device_token": token
          });
      if (response.statusCode == 200) {
        print(
            "<++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++error${response.body}");
        return json.decode(response.body);
      }
    } catch (error) {
      print(error);
      print(
          "<++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++error");
      throw Exception("Something went wrong");
    }
  }

  Future<UpdateItemStock> updateItemInStock(
      String value, String categoryId, String menuId) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse("$testingUrl${EndPoints.update_item_instock_status}"),
          body: {
            "token": "123456789",
            "instock": value,// ? "y" : "n"
            "kitchen_id": userBean.data!.id.toString(),
            "category_id": categoryId,
            "menu_id": menuId
          });


      if (response.statusCode == 200) {
        print("=======================INSTOCK====================>${response.statusCode}");
        UpdateItemStock updateItemStock = UpdateItemStock.fromJson(
          json.decode(response.body),
        );
        return updateItemStock;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }



  Future<UpdatePackageAvailability> updatePackageStatus(
      value, String packageId) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse("$testingUrl${EndPoints.change_package_status}"),
          body: {
            "token": "123456789",
            "kitchen_id": userBean.data!.id,
            "package_id": packageId,
            "status": value, //==true ? "y" : "n",
          });
      print("$testingUrl${EndPoints.change_package_status}");
      print({
        "token": "123456789",
        "status": value == "y" ? true : false, //"y" : "n",
        "kitchen_id": userBean.data!.id,
        "package_id": packageId
      });
      if (response.statusCode == 200) {
        UpdatePackageAvailability updatePackageAvailability =
            UpdatePackageAvailability.fromJson(
          json.decode(response.body),
        );
        print("++++++++++++++++++PACKAGE STATUS+++++++++++++${response.body}");
        return updatePackageAvailability;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<RearrangeCategory> reArrangeCategory(String items) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.rearrange_category}"), body: {
        "kitchen_id": userBean.data!.id,
        "category_ids": jsonEncode(items),
        "token": "123456789",
      });
      if (response.statusCode == 200) {
        RearrangeCategory rearrangeCategory = RearrangeCategory.fromJson(
          json.decode(response.body),
        );
        return rearrangeCategory;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<RearrangeCategoryItems> reArrangeCategoryItems(
      String categoryId, String items) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http.post(
          Uri.parse("$testingUrl${EndPoints.rearrange_category_items}"),
          body: {
            "kitchen_id": userBean.data!.id,
            "category_id": categoryId,
            "menu_ids": jsonEncode(items),
            "token": "123456789",
          });
      if (response.statusCode == 200) {
        RearrangeCategoryItems categoryItems = RearrangeCategoryItems.fromJson(
          json.decode(response.body),
        );
        return categoryItems;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  Future<GetOrderDetailsData> getOrderDetails(
      { required String orderId,   String? orderItemId}) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response;
      if (orderItemId != null) {
        print("===========================================================================1>${userBean.data!.id.toString()}");
        print("----------------------1>$orderId");
        print("----------------------2>$orderItemId");
        response = await http.post(
            Uri.parse("$testingUrl${EndPoints.get_order_details}"),
            body: {
              "kitchen_id": userBean.data!.id.toString(),
              "token": "123456789",
              "order_id": orderId,
              "order_item_id": orderItemId,
            });
      } else {
        print("----------------------else>$orderId");
        response = await http.post(Uri.parse("$testingUrl${EndPoints.get_order_details}"),
            body: {
              "kitchen_id": userBean.data!.id,
              "token": "123456789",
              "order_id": orderId,
              "order_item_id": orderItemId,
            });
      }

      if (response.statusCode == 200) {
        log.f(json.decode(response.body));

        GetOrderDetailsData orderDetails = GetOrderDetails.fromJson(json.decode(response.body),).data;
        print("=-=--=-=-=-=-=--=-=-=-=>${orderDetails}");
        return orderDetails;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }

  /*Future<GetOrderDetailsData> getOrderDetails(
      {required String? orderId, String? orderItemId}) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      print("nikhil xxx${userBean.data!.id}, orID$orderId, orItemID$orderItemId");

      http.Response response;

      // Create a Map to hold the request parameters
      final Map<String, String> requestBody = {
        "kitchen_id": userBean.data!.id.toString(),
        "token": "123456789",
        "order_id": orderId,
        "order_item_id": orderItemId,
      };

      if (orderItemId != null) {
        print("----------------------if>$orderId");
        requestBody["order_item_id"] = orderItemId; // Add order_item_id only if not null
      } else {
        print("----------------------else>$orderId");
      }

      response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_order_details}"),
        body: requestBody, // Use the requestBody map here
      );

      if (response.statusCode == 200) {
        GetOrderDetailsData orderDetails = GetOrderDetails.fromJson(json.decode(response.body)).data;
        log.f(json.decode(response.body));
        print("=-=--=-=-=-=-=--=-=-=-=>${orderDetails}");
        return orderDetails;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }*/


  Future<BeanOrderCancel> cancelOrder(String orderId, String orderType,
      String siteName, String description) async {
    try {
      BeanLogin userBean = await Utils.getUser();
      http.Response response = await http
          .post(Uri.parse("$testingUrl${EndPoints.cancel_order}"), body: {
        "kitchen_id": userBean.data!.id,
        "token": "123456789",
        "order_id": orderId,
        "ordertype": orderType,
        "cancellation_type": siteName,
        "reason_for_cancellation": description
      });
      if (response.statusCode == 200) {
        BeanOrderCancel cancel = BeanOrderCancel.fromJson(
          json.decode(response.body),
        );
        return cancel;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong");
    }
  }
}
