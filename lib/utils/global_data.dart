import '../models/donor.dart';
import '../models/blood_request.dart';
import '../models/user.dart';

/// Current logged-in user
User? currentUser;

/// Dummy donors
List<Donor> donors = [
  Donor(
    name: "Ali Khan",
    bloodGroup: "A+",
    city: "Lahore",
    contact: "0300-1234567",
    latitude: 31.5204,
    longitude: 74.3587,
  ),
  Donor(
    name: "Sara Ahmed",
    bloodGroup: "B+",
    city: "Karachi",
    contact: "0312-7654321",
    latitude: 24.8607,
    longitude: 67.0011,
  ),
  Donor(
    name: "Usman Malik",
    bloodGroup: "O-",
    city: "Islamabad",
    contact: "0321-9876543",
    latitude: 33.6844,
    longitude: 73.0479,
  ),
];

/// Blood requests
List<BloodRequest> requests = [];

/// Donation history (dummy data)
/// Admin -> sab dekh sakta hai
/// User -> sirf apni dekh sakta hai
List<Map<String, dynamic>> donationHistory = [
  {
    "userId": "u1",
    "name": "Ali Khan",
    "bloodGroup": "A+",
    "city": "Lahore",
    "status": "Donation Verified",
    "date": "2025-08-20"
  },
  {
    "userId": "u2",
    "name": "Sara Ahmed",
    "bloodGroup": "B+",
    "city": "Karachi",
    "status": "Donation Pending",
    "date": "2025-08-22"
  },
  {
    "userId": "u1",
    "name": "Ali Khan",
    "bloodGroup": "A+",
    "city": "Lahore",
    "status": "Donation Completed",
    "date": "2025-08-30"
  },
];
