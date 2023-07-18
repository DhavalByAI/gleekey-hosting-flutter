class PropertyAllDetails_model {
  var status;
  var message;
  Data? data;

  PropertyAllDetails_model({this.status, this.message, this.data});

  PropertyAllDetails_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  var propertySlug;
  Result? result;
  var propertyId;
  var bookingStatus;
  List<PropertyPhotos>? propertyPhotos;
  var amenities;
  var safetyAmenities;
  var checkin;
  var checkout;
  var guests;
  var title;
  var symbol;
  var shareLink;
  var dateFormat;
  List<HouseRules>? houseRules;
  List<CustomHouseRules>? customHouseRules;
  var reviewsFromGuests;

  Data(
      {this.propertySlug,
      this.result,
      this.propertyId,
      this.bookingStatus,
      this.propertyPhotos,
      this.amenities,
      this.safetyAmenities,
      this.checkin,
      this.checkout,
      this.guests,
      this.title,
      this.symbol,
      this.shareLink,
      this.dateFormat,
      this.houseRules,
      this.customHouseRules,
      this.reviewsFromGuests});

  Data.fromJson(Map<String, dynamic> json) {
    propertySlug = json['property_slug'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
    propertyId = json['property_id'];
    bookingStatus = json['booking_status'];
    if (json['property_photos'] != null) {
      propertyPhotos = <PropertyPhotos>[];
      json['property_photos'].forEach((v) {
        propertyPhotos!.add(new PropertyPhotos.fromJson(v));
      });
    }
    amenities = json['amenities'];
    safetyAmenities = json['safety_amenities'];

    checkin = json['checkin'];
    checkout = json['checkout'];
    guests = json['guests'];
    title = json['title'];
    symbol = json['symbol'];
    shareLink = json['shareLink'];
    dateFormat = json['date_format'];
    if (json['house_rules'] != null) {
      houseRules = <HouseRules>[];
      json['house_rules'].forEach((v) {
        houseRules!.add(new HouseRules.fromJson(v));
      });
    }
    if (json['custom_house_rules'] != null) {
      customHouseRules = <CustomHouseRules>[];
      json['custom_house_rules'].forEach((v) {
        customHouseRules!.add(new CustomHouseRules.fromJson(v));
      });
    }
    reviewsFromGuests = json['reviews_from_guests'];
  }
}

class Result {
  var id;
  var propertyName;
  var agentId;
  var name;
  var slug;
  var urlName;
  var hostId;
  var bedrooms;
  var beds;
  var bedType;
  var bathrooms;
  var guest;
  var extraMattress;
  var livingRooms;
  var kitchen;
  var amenities;
  var propertyType;
  var spaceType;
  var accommodates;
  var bookingType;
  var cancellation;
  var status;
  var recomended;
  var squareFeet;
  var constructedSquareFeet;
  var stayTiming;
  var verifiedProperty;
  var isAgree;
  var viewCount;
  var ownerNumber;
  var careTakerNumber;
  var emergencyNumber;
  var isOwnerNumber;
  var isCareTakerNumber;
  var isEmergencyNumber;
  var isFirstBooking;
  var isOtherWebsite;
  var otherWebsite;
  var otherWebsiteName;
  var nameOtherWebsite;
  var adminHouseRule;
  var deletedAt;
  var createdAt;
  var updatedAt;
  var isApprove;
  var propertyRejectNote;
  var stepsCompleted;
  var spaceTypeName;
  var propertyTypeName;
  var propertyPhoto;
  var hostName;
  var bookMark;
  var reviewsCount;
  var overallRating;
  var coverPhoto;
  var avgRating;
  Users? users;
  PropertyDescription? propertyDescription;
  PropertyPrice? propertyPrice;
  PropertyAddress? propertyAddress;

  Result(
      {this.id,
      this.propertyName,
      this.agentId,
      this.name,
      this.slug,
      this.urlName,
      this.hostId,
      this.bedrooms,
      this.beds,
      this.bedType,
      this.bathrooms,
      this.guest,
      this.extraMattress,
      this.livingRooms,
      this.kitchen,
      this.amenities,
      this.propertyType,
      this.spaceType,
      this.accommodates,
      this.bookingType,
      this.cancellation,
      this.status,
      this.recomended,
      this.squareFeet,
      this.constructedSquareFeet,
      this.stayTiming,
      this.verifiedProperty,
      this.isAgree,
      this.viewCount,
      this.ownerNumber,
      this.careTakerNumber,
      this.emergencyNumber,
      this.isOwnerNumber,
      this.isCareTakerNumber,
      this.isEmergencyNumber,
      this.isFirstBooking,
      this.isOtherWebsite,
      this.otherWebsite,
      this.otherWebsiteName,
      this.nameOtherWebsite,
      this.adminHouseRule,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.isApprove,
      this.propertyRejectNote,
      this.stepsCompleted,
      this.spaceTypeName,
      this.propertyTypeName,
      this.propertyPhoto,
      this.hostName,
      this.bookMark,
      this.reviewsCount,
      this.overallRating,
      this.coverPhoto,
      this.avgRating,
      this.users,
      this.propertyDescription,
      this.propertyPrice,
      this.propertyAddress});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyName = json['property_name'];
    agentId = json['agent_id'];
    name = json['name'];
    slug = json['slug'];
    urlName = json['url_name'];
    hostId = json['host_id'];
    bedrooms = json['bedrooms'];
    beds = json['beds'];
    bedType = json['bed_type'];
    bathrooms = json['bathrooms'];
    guest = json['guest'];
    extraMattress = json['extra_mattress'];
    livingRooms = json['living_rooms'];
    kitchen = json['kitchen'];
    amenities = json['amenities'];
    propertyType = json['property_type'];
    spaceType = json['space_type'];
    accommodates = json['accommodates'];
    bookingType = json['booking_type'];
    cancellation = json['cancellation'];
    status = json['status'];
    recomended = json['recomended'];
    squareFeet = json['square_feet'];
    constructedSquareFeet = json['constructed_square_feet'];
    stayTiming = json['stay_timing'];
    verifiedProperty = json['verified_property'];
    isAgree = json['is_agree'];
    viewCount = json['view_count'];
    ownerNumber = json['owner_number'];
    careTakerNumber = json['care_taker_number'];
    emergencyNumber = json['emergency_number'];
    isOwnerNumber = json['is_owner_number'];
    isCareTakerNumber = json['is_care_taker_number'];
    isEmergencyNumber = json['is_emergency_number'];
    isFirstBooking = json['is_first_booking'];
    isOtherWebsite = json['is_other_website'];
    otherWebsite = json['other_website'];
    otherWebsiteName = json['other_website_name'];
    nameOtherWebsite = json['name_other_website'];
    adminHouseRule = json['admin_house_rule'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isApprove = json['is_approve'];
    propertyRejectNote = json['property_reject_note'];
    stepsCompleted = json['steps_completed'];
    spaceTypeName = json['space_type_name'];
    propertyTypeName = json['property_type_name'];
    propertyPhoto = json['property_photo'];
    hostName = json['host_name'];
    bookMark = json['book_mark'];
    reviewsCount = json['reviews_count'];
    overallRating = json['overall_rating'];
    coverPhoto = json['cover_photo'];
    avgRating = json['avg_rating'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
    propertyDescription = json['property_description'] != null
        ? new PropertyDescription.fromJson(json['property_description'])
        : null;
    propertyPrice = json['property_price'] != null
        ? new PropertyPrice.fromJson(json['property_price'])
        : null;
    propertyAddress = json['property_address'] != null
        ? new PropertyAddress.fromJson(json['property_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_name'] = this.propertyName;
    data['agent_id'] = this.agentId;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['url_name'] = this.urlName;
    data['host_id'] = this.hostId;
    data['bedrooms'] = this.bedrooms;
    data['beds'] = this.beds;
    data['bed_type'] = this.bedType;
    data['bathrooms'] = this.bathrooms;
    data['guest'] = this.guest;
    data['extra_mattress'] = this.extraMattress;
    data['living_rooms'] = this.livingRooms;
    data['kitchen'] = this.kitchen;
    data['amenities'] = this.amenities;
    data['property_type'] = this.propertyType;
    data['space_type'] = this.spaceType;
    data['accommodates'] = this.accommodates;
    data['booking_type'] = this.bookingType;
    data['cancellation'] = this.cancellation;
    data['status'] = this.status;
    data['recomended'] = this.recomended;
    data['square_feet'] = this.squareFeet;
    data['constructed_square_feet'] = this.constructedSquareFeet;
    data['stay_timing'] = this.stayTiming;
    data['verified_property'] = this.verifiedProperty;
    data['is_agree'] = this.isAgree;
    data['view_count'] = this.viewCount;
    data['owner_number'] = this.ownerNumber;
    data['care_taker_number'] = this.careTakerNumber;
    data['emergency_number'] = this.emergencyNumber;
    data['is_owner_number'] = this.isOwnerNumber;
    data['is_care_taker_number'] = this.isCareTakerNumber;
    data['is_emergency_number'] = this.isEmergencyNumber;
    data['is_first_booking'] = this.isFirstBooking;
    data['is_other_website'] = this.isOtherWebsite;
    data['other_website'] = this.otherWebsite;
    data['other_website_name'] = this.otherWebsiteName;
    data['name_other_website'] = this.nameOtherWebsite;
    data['admin_house_rule'] = this.adminHouseRule;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_approve'] = this.isApprove;
    data['property_reject_note'] = this.propertyRejectNote;
    data['steps_completed'] = this.stepsCompleted;
    data['space_type_name'] = this.spaceTypeName;
    data['property_type_name'] = this.propertyTypeName;
    data['property_photo'] = this.propertyPhoto;
    data['host_name'] = this.hostName;
    data['book_mark'] = this.bookMark;
    data['reviews_count'] = this.reviewsCount;
    data['overall_rating'] = this.overallRating;
    data['cover_photo'] = this.coverPhoto;
    data['avg_rating'] = this.avgRating;
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    if (this.propertyDescription != null) {
      data['property_description'] = this.propertyDescription!.toJson();
    }
    if (this.propertyPrice != null) {
      data['property_price'] = this.propertyPrice!.toJson();
    }
    if (this.propertyAddress != null) {
      data['property_address'] = this.propertyAddress!.toJson();
    }
    return data;
  }
}

class Users {
  var id;
  var firstName;
  var lastName;
  var email;
  var phone;
  var formattedPhone;
  var carrierCode;
  var defaultCountry;
  var address;
  var address2;
  var countryId;
  var stateId;
  var cityId;
  var pincode;
  var profileImage;
  var balance;
  var status;
  var sponserCode;
  var referralCode;
  var userProMember;
  var userAgent;
  var userHost;
  var agentRequest;
  var hostRequest;
  var promemberRequest;
  var isAgent;
  var isGst;
  var createdAt;
  var updatedAt;
  var profileSrc;

  Users(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.formattedPhone,
      this.carrierCode,
      this.defaultCountry,
      this.address,
      this.address2,
      this.countryId,
      this.stateId,
      this.cityId,
      this.pincode,
      this.profileImage,
      this.balance,
      this.status,
      this.sponserCode,
      this.referralCode,
      this.userProMember,
      this.userAgent,
      this.userHost,
      this.agentRequest,
      this.hostRequest,
      this.promemberRequest,
      this.isAgent,
      this.isGst,
      this.createdAt,
      this.updatedAt,
      this.profileSrc});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    formattedPhone = json['formatted_phone'];
    carrierCode = json['carrier_code'];
    defaultCountry = json['default_country'];
    address = json['address'];
    address2 = json['address_2'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    pincode = json['pincode'];
    profileImage = json['profile_image'];
    balance = json['balance'];
    status = json['status'];
    sponserCode = json['sponser_code'];
    referralCode = json['referral_code'];
    userProMember = json['user_pro_member'];
    userAgent = json['user_agent'];
    userHost = json['user_host'];
    agentRequest = json['agent_request'];
    hostRequest = json['host_request'];
    promemberRequest = json['promember_request'];
    isAgent = json['is_agent'];
    isGst = json['is_gst'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileSrc = json['profile_src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['formatted_phone'] = this.formattedPhone;
    data['carrier_code'] = this.carrierCode;
    data['default_country'] = this.defaultCountry;
    data['address'] = this.address;
    data['address_2'] = this.address2;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['pincode'] = this.pincode;
    data['profile_image'] = this.profileImage;
    data['balance'] = this.balance;
    data['status'] = this.status;
    data['sponser_code'] = this.sponserCode;
    data['referral_code'] = this.referralCode;
    data['user_pro_member'] = this.userProMember;
    data['user_agent'] = this.userAgent;
    data['user_host'] = this.userHost;
    data['agent_request'] = this.agentRequest;
    data['host_request'] = this.hostRequest;
    data['promember_request'] = this.promemberRequest;
    data['is_agent'] = this.isAgent;
    data['is_gst'] = this.isGst;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_src'] = this.profileSrc;
    return data;
  }
}

class PropertyDescription {
  var id;
  var propertyId;
  var summary;
  var houseRulesPolicy;
  var placeIsGreatFor;
  var aboutPlace;
  var guestCanAccess;
  var interactionGuests;
  var other;
  var aboutNeighborhood;
  var getAround;

  PropertyDescription(
      {this.id,
      this.propertyId,
      this.summary,
      this.houseRulesPolicy,
      this.placeIsGreatFor,
      this.aboutPlace,
      this.guestCanAccess,
      this.interactionGuests,
      this.other,
      this.aboutNeighborhood,
      this.getAround});

  PropertyDescription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    summary = json['summary'];
    houseRulesPolicy = json['house_rules_policy'];
    placeIsGreatFor = json['place_is_great_for'];
    aboutPlace = json['about_place'];
    guestCanAccess = json['guest_can_access'];
    interactionGuests = json['interaction_guests'];
    other = json['other'];
    aboutNeighborhood = json['about_neighborhood'];
    getAround = json['get_around'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['summary'] = this.summary;
    data['house_rules_policy'] = this.houseRulesPolicy;
    data['place_is_great_for'] = this.placeIsGreatFor;
    data['about_place'] = this.aboutPlace;
    data['guest_can_access'] = this.guestCanAccess;
    data['interaction_guests'] = this.interactionGuests;
    data['other'] = this.other;
    data['about_neighborhood'] = this.aboutNeighborhood;
    data['get_around'] = this.getAround;
    return data;
  }
}

class PropertyPrice {
  var id;
  var propertyId;
  var cleaningFee;
  var guestAfter;
  var guestFee;
  var securityFee;
  var price;
  var weekendPrice;
  var weeklyDiscount;
  var monthlyDiscount;
  var currencyCode;
  var originalCleaningFee;
  var originalGuestFee;
  var originalPrice;
  var originalWeekendPrice;
  var originalSecurityFee;
  var defaultCode;
  var defaultSymbol;

  PropertyPrice(
      {this.id,
      this.propertyId,
      this.cleaningFee,
      this.guestAfter,
      this.guestFee,
      this.securityFee,
      this.price,
      this.weekendPrice,
      this.weeklyDiscount,
      this.monthlyDiscount,
      this.currencyCode,
      this.originalCleaningFee,
      this.originalGuestFee,
      this.originalPrice,
      this.originalWeekendPrice,
      this.originalSecurityFee,
      this.defaultCode,
      this.defaultSymbol});

  PropertyPrice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    cleaningFee = json['cleaning_fee'];
    guestAfter = json['guest_after'];
    guestFee = json['guest_fee'];
    securityFee = json['security_fee'];
    price = json['price'];
    weekendPrice = json['weekend_price'];
    weeklyDiscount = json['weekly_discount'];
    monthlyDiscount = json['monthly_discount'];
    currencyCode = json['currency_code'];
    originalCleaningFee = json['original_cleaning_fee'];
    originalGuestFee = json['original_guest_fee'];
    originalPrice = json['original_price'];
    originalWeekendPrice = json['original_weekend_price'];
    originalSecurityFee = json['original_security_fee'];
    defaultCode = json['default_code'];
    defaultSymbol = json['default_symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['cleaning_fee'] = this.cleaningFee;
    data['guest_after'] = this.guestAfter;
    data['guest_fee'] = this.guestFee;
    data['security_fee'] = this.securityFee;
    data['price'] = this.price;
    data['weekend_price'] = this.weekendPrice;
    data['weekly_discount'] = this.weeklyDiscount;
    data['monthly_discount'] = this.monthlyDiscount;
    data['currency_code'] = this.currencyCode;
    data['original_cleaning_fee'] = this.originalCleaningFee;
    data['original_guest_fee'] = this.originalGuestFee;
    data['original_price'] = this.originalPrice;
    data['original_weekend_price'] = this.originalWeekendPrice;
    data['original_security_fee'] = this.originalSecurityFee;
    data['default_code'] = this.defaultCode;
    data['default_symbol'] = this.defaultSymbol;
    return data;
  }
}

class PropertyAddress {
  var id;
  var propertyId;
  var addressLine1;
  var addressLine2;
  var latitude;
  var longitude;
  var city;
  var state;
  var country;
  var postalCode;

  PropertyAddress(
      {this.id,
      this.propertyId,
      this.addressLine1,
      this.addressLine2,
      this.latitude,
      this.longitude,
      this.city,
      this.state,
      this.country,
      this.postalCode});

  PropertyAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['postal_code'] = this.postalCode;
    return data;
  }
}

class PropertyPhotos {
  var id;
  var image;
  var message;

  PropertyPhotos({this.id, this.image, this.message});

  PropertyPhotos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['message'] = this.message;
    return data;
  }
}

class HouseRules {
  var id;
  var userId;
  var propertyId;
  var checkInTime;
  var checkOutTime;
  var guestAllowed;
  var petFriendly;
  var poolTime;
  var poolOpenTime;
  var poolCloseTime;
  var loudMusicTime;
  var loudMusicOpenTime;
  var loudMusicCloseTime;
  var foodAllowed;
  var isAlcoholAllowed;
  var alcoholAllowedSide;
  var isSmokingAllowed;
  var smokingAllowed;
  var title;
  var status;
  var isRole;
  var image;
  var createdAt;
  var updatedAt;

  HouseRules(
      {this.id,
      this.userId,
      this.propertyId,
      this.checkInTime,
      this.checkOutTime,
      this.guestAllowed,
      this.petFriendly,
      this.poolTime,
      this.poolOpenTime,
      this.poolCloseTime,
      this.loudMusicTime,
      this.loudMusicOpenTime,
      this.loudMusicCloseTime,
      this.foodAllowed,
      this.isAlcoholAllowed,
      this.alcoholAllowedSide,
      this.isSmokingAllowed,
      this.smokingAllowed,
      this.title,
      this.status,
      this.isRole,
      this.image,
      this.createdAt,
      this.updatedAt});

  HouseRules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    propertyId = json['property_id'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    guestAllowed = json['guest_allowed'];
    petFriendly = json['pet_friendly'];
    poolTime = json['pool_time'];
    poolOpenTime = json['pool_open_time'];
    poolCloseTime = json['pool_close_time'];
    loudMusicTime = json['loud_music_time'];
    loudMusicOpenTime = json['loud_music_open_time'];
    loudMusicCloseTime = json['loud_music_close_time'];
    foodAllowed = json['food_allowed'];
    isAlcoholAllowed = json['is_alcohol_allowed'];
    alcoholAllowedSide = json['alcohol_allowed_side'];
    isSmokingAllowed = json['is_smoking_allowed'];
    smokingAllowed = json['smoking_allowed'];
    title = json['title'];
    status = json['status'];
    isRole = json['is_role'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['property_id'] = this.propertyId;
    data['check_in_time'] = this.checkInTime;
    data['check_out_time'] = this.checkOutTime;
    data['guest_allowed'] = this.guestAllowed;
    data['pet_friendly'] = this.petFriendly;
    data['pool_time'] = this.poolTime;
    data['pool_open_time'] = this.poolOpenTime;
    data['pool_close_time'] = this.poolCloseTime;
    data['loud_music_time'] = this.loudMusicTime;
    data['loud_music_open_time'] = this.loudMusicOpenTime;
    data['loud_music_close_time'] = this.loudMusicCloseTime;
    data['food_allowed'] = this.foodAllowed;
    data['is_alcohol_allowed'] = this.isAlcoholAllowed;
    data['alcohol_allowed_side'] = this.alcoholAllowedSide;
    data['is_smoking_allowed'] = this.isSmokingAllowed;
    data['smoking_allowed'] = this.smokingAllowed;
    data['title'] = this.title;
    data['status'] = this.status;
    data['is_role'] = this.isRole;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class CustomHouseRules {
  var id;
  var userId;
  var propertyId;
  var title;
  var createdAt;
  var updatedAt;

  CustomHouseRules(
      {this.id,
      this.userId,
      this.propertyId,
      this.title,
      this.createdAt,
      this.updatedAt});

  CustomHouseRules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    propertyId = json['property_id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['property_id'] = this.propertyId;
    data['title'] = this.title;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
