class BookingModel {
  dynamic id;
  String? email;
  String? phone;
  String? chair;
  String? day;
  String? total;
  dynamic approve;
  String? image;
  String? time;
  String? salonname;
  String? username;
  String? status;
  SalonModel? salon; // Add salon property

  BookingModel({
    this.id,
    this.email,
    this.phone,
    this.chair,
    this.day,
    this.total,
    this.approve,
    this.image,
    this.time,
    this.salonname,
    this.username,
    this.status,
    this.salon,
  });

  BookingModel.fromJson(Map json) {
    id = json['id']?.toString();
    email = json['email']?.toString();
    phone = json['phone']?.toString();
    chair = json['chair']?.toString();
    day = json['day']?.toString();
    total = json['total']?.toString();
    approve = json['approve']?.toString();
    image = json['image']?.toString();
    time = json['start_time']?.toString();
    salonname = json['name']?.toString();
    username = json['username']?.toString();
    status = json['status']?.toString();

    // Parse salon data if available
    if (json['salon'] != null) {
      salon = SalonModel.fromJson(json['salon']);
    }
  }

  Map toJson() {
    final Map data = new Map();
    data['id'] = this.id;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['chair'] = this.chair;
    data['day'] = this.day;
    data['total'] = this.total;
    data['approve'] = this.approve;
    data['image'] = this.image;
    data['start_time'] = this.time;
    data['name'] = this.salonname;
    data['username'] = this.username;
    data['status'] = this.status;

    // Include salon data in JSON
    if (this.salon != null) {
      data['salon'] = this.salon!.toJson();
    }

    return data;
  }
}

// Add the SalonModel class
class SalonModel {
  String? id;
  String? name;
  String? phone;
  String? address;
  String? image;

  SalonModel({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.image,
  });

  SalonModel.fromJson(Map json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    phone = json['phone']?.toString();
    address = json['address']?.toString();
    image = json['image']?.toString();
  }

  Map toJson() {
    final Map data = new Map();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['image'] = this.image;
    return data;
  }
}