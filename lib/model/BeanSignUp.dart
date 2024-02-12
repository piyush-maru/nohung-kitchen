class BeanSignUp {
  bool? status;
  String? message;
  Data? data;

  BeanSignUp({this.status, this.message, this.data});

  BeanSignUp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? json['data'] is List?null :new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? kitchenName;
  String? email;
  String? address;
  String? stateid;
  String? cityid;
  String? pincode;
  String? contactName;
  String? role;
  String? mobileNumber;
  String? kitchenContactNumber;
  String? fssaiLicenceNo;
  String? expiryDate;
  String? panNo;
  String? gstNo;
  dynamic userStatus;
  dynamic status;
  String? createdDate;
  String? modifiedDate;
  String? kitchenId;
  String? password;
  String? menuFile;
  String? panCardFile;
  String? fssaiFile;
  String? gstFile;
  String? userId;
  String? businessAddressProof;

  Data(
      {
        required this.kitchenName,
        required this.email,
        required this.address,
        required this.stateid,
        required this.cityid,
        required this.pincode,
        required this.contactName,
        required this.role,
        required this.mobileNumber,
        required this.kitchenContactNumber,
        required this.fssaiLicenceNo,
        required this.expiryDate,
        required this.panNo,
        required this.gstNo,
      this.userStatus,
      this.status,
        required this.createdDate,
        required this.modifiedDate,
        required this.kitchenId,
        required this.password,
        required this.menuFile,
        required this.panCardFile,
        required this.businessAddressProof,
        required this.fssaiFile,
        required this.gstFile,
        required this.userId});

  Data.fromJson(Map<String, dynamic> json) {
    kitchenName = json['kitchenname'];
    email = json['email'];
    address = json['address'];
    stateid = json['stateid'];
    cityid = json['cityid'];
    pincode = json['pincode'];
    contactName = json['contactname'];
    role = json['role'];
    mobileNumber = json['mobilenumber'];
    kitchenContactNumber = json['kitchencontactnumber'];
    fssaiLicenceNo = json['fssailicenceno'];
    expiryDate = json['expirydate'];
    panNo = json['panno'];
    gstNo = json['gstno'];
    userStatus = json['userstatus'];
    status = json['status'];
    createdDate = json['createddate'];
    modifiedDate = json['modifieddate'];
    kitchenId = json['kitchenid'];
    password = json['password'];
    menuFile = json['menu_file'];
    panCardFile = json['pan_card'];
    fssaiFile=json['fssai_certificate'];
    gstFile=json['gst_certificate'];
    businessAddressProof=json['business_address_proof'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kitchenname'] = this.kitchenName;
    data['email'] = this.email;
    data['address'] = this.address;
    data['stateid'] = this.stateid;
    data['cityid'] = this.cityid;
    data['pincode'] = this.pincode;
    data['contactname'] = this.contactName;
    data['role'] = this.role;
    data['mobilenumber'] = this.mobileNumber;
    data['kitchencontactnumber'] = this.kitchenContactNumber;
    data['fssailicenceno'] = this.fssaiLicenceNo;
    data['expirydate'] = this.expiryDate;
    data['panno'] = this.panNo;
    data['gstno'] = this.gstNo;
    data['userstatus'] = this.userStatus;
    data['status'] = this.status;
    data['createddate'] = this.createdDate;
    data['modifieddate'] = this.modifiedDate;
    data['kitchenid'] = this.kitchenId;
    data['password'] = this.password;
    data['menu_file'] = this.menuFile;
    data['pan_card'] = this.panCardFile;
    data['fssai_certificate']=this.fssaiFile;
    data['gst_certificate']=this.gstFile;
    data['business_address_proof']=this.businessAddressProof;
    data['user_id'] = this.userId;
    return data;
  }
}
