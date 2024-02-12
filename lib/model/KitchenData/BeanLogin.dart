class BeanLogin {
    bool? status;
    String? message;
    UserData? data;

    BeanLogin({ this.status, this.message, this.data});

   factory BeanLogin.fromJson(Map<String, dynamic> json) {
      return BeanLogin(
        status : json['status'],
        message : json['message'],
        data : json['data'] != null ?!(json['data'] is List)? new UserData.fromJson(json['data']):null : null);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['status'] = this.status;
        data['message'] = this.message;
          data['data'] = this.data?.toJson();
        return data;
    }
}

class UserData {
    String? id;
    String? userType;
    String? kitchenName;
    String? email;
    String? kitchenId;
    String? password;
    String? address;
    String? stateId;
    String? cityId;
    String? pincode;
    String? contactName;
    String? role;
    String? mobileNumber;
    String? kitchenContactNumber;
    String? fssaiLicenceNo;
    String? expiryDate;
    String? panNo;
    String? gstNo;
    String? menuFile;
    String? availableStatus;
    String? firmType;
    String? foodType;
    String? fromTime;
    String? toTime;
    String? openDays;
    String? mealType;
    String? otpCode;
    String? isVerifiedOtp;
    String? otpDate;
    String? isAgreeForPolicy;
    String? city;
    String? bikeType;
    String? youHaveLicense;
    String? licenceFile;
    String? rcBookFile;
    String? passportFile;
    String? idProofFile;
    String? userStatus;
    String? status;
    String? createdDate;
    String? modifiedDate;

    UserData(
        {this.id,
            this.userType,
            this.kitchenName,
            this.email,
            this.kitchenId,
            this.password,
            this.address,
            this.stateId,
            this.cityId,
            this.pincode,
            this.contactName,
            this.availableStatus,
            this.role,
            this.mobileNumber,
            this.kitchenContactNumber,
            this.fssaiLicenceNo,
            this.expiryDate,
            this.panNo,
            this.gstNo,
            this.menuFile,
            this.firmType,
            this.foodType,
            this.fromTime,
            this.toTime,
            this.openDays,
            this.mealType,
            this.otpCode,
            this.isVerifiedOtp,
            this.otpDate,
            this.isAgreeForPolicy,
            this.city,
            this.bikeType,
            this.youHaveLicense,
            this.licenceFile,
            this.rcBookFile,
            this.passportFile,
            this.idProofFile,
            this.userStatus,
            this.status,
            this.createdDate,
            this.modifiedDate});

    UserData.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        userType = json['usertype'];
        kitchenName = json['kitchenname'];
        availableStatus = json['available_status'];
        email = json['email'];
        kitchenId = json['kitchenid'];
        password = json['password'];
        address = json['address'];
        stateId = json['stateid'];
        cityId = json['cityid'];
        pincode = json['pincode'];
        contactName = json['contactname'];
        role = json['role'];
        mobileNumber = json['mobilenumber'];
        kitchenContactNumber = json['kitchencontactnumber'];
        fssaiLicenceNo = json['fssailicenceno'];
        expiryDate = json['expirydate'];
        panNo = json['panno'];
        gstNo = json['gstno'];
        menuFile = json['menufile'];
        firmType = json['firmtype'];
        foodType = json['foodtype'];
        fromTime = json['fromtime'];
        toTime = json['totime'];
        openDays = json['opendays'];
        mealType = json['mealtype'];
        otpCode = json['otpcode'];
        isVerifiedOtp = json['isverifiedotp'];
        otpDate = json['otpdate'];
        isAgreeForPolicy = json['isagreeforpolicy'];
        city = json['city'];
        bikeType = json['biketype'];
        youHaveLicense = json['youhavelicense'];
        licenceFile = json['licencefile'];
        rcBookFile = json['rcbookfile'];
        passportFile = json['passportfile'];
        idProofFile = json['idprooffile'];
        userStatus = json['userstatus'];
        status = json['status'];
        createdDate = json['createddate'];
        modifiedDate = json['modifieddate'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['usertype'] = this.userType;
        data['kitchenname'] = this.kitchenName;
        data['email'] = this.email;
        data['kitchenid'] = this.kitchenId;
        data['password'] = this.password;
        data['address'] = this.address;
        data['available_status'] = this.availableStatus;
        data['stateid'] = this.stateId;
        data['cityid'] = this.cityId;
        data['pincode'] = this.pincode;
        data['contactname'] = this.contactName;
        data['role'] = this.role;
        data['mobilenumber'] = this.mobileNumber;
        data['kitchencontactnumber'] = this.kitchenContactNumber;
        data['fssailicenceno'] = this.fssaiLicenceNo;
        data['expirydate'] = this.expiryDate;
        data['panno'] = this.panNo;
        data['gstno'] = this.gstNo;
        data['menufile'] = this.menuFile;
        data['firmtype'] = this.firmType;
        data['foodtype'] = this.foodType;
        data['fromtime'] = this.fromTime;
        data['totime'] = this.toTime;
        data['opendays'] = this.openDays;
        data['mealtype'] = this.mealType;
        data['otpcode'] = this.otpCode;
        data['isverifiedotp'] = this.isVerifiedOtp;
        data['otpdate'] = this.otpDate;
        data['isagreeforpolicy'] = this.isAgreeForPolicy;
        data['city'] = this.city;
        data['biketype'] = this.bikeType;
        data['youhavelicense'] = this.youHaveLicense;
        data['licencefile'] = this.licenceFile;
        data['rcbookfile'] = this.rcBookFile;
        data['passportfile'] = this.passportFile;
        data['idprooffile'] = this.idProofFile;
        data['userstatus'] = this.userStatus;
        data['status'] = this.status;
        data['createddate'] = this.createdDate;
        data['modifieddate'] = this.modifiedDate;
        return data;
    }
}