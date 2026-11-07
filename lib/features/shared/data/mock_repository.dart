import 'package:flutter/material.dart';

import '../../home/data/boarding_listing.dart';

enum UserRole { student, owner }

class StudentEnquiry {
  StudentEnquiry({
    required this.id,
    required this.listingName,
    required this.studentName,
    required this.studentPhone,
    required this.studentUniversity,
    required this.moveInDate,
    required this.durationMonths,
    required this.message,
    required this.createdAt,
    this.status = 'Pending',
  });

  final String id;
  final String listingName;
  final String studentName;
  final String studentPhone;
  final String studentUniversity;
  final String moveInDate;
  final int durationMonths;
  final String message;
  final DateTime createdAt;
  String status; // 'Pending', 'Accepted', 'Declined'
}

class AppNotificationItem {
  AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final String type; // 'enquiry', 'listing', 'system'
  bool isRead;
}

/// Central mock repository providing unified business logic and mock persistence
/// for Students, Boarding Owners, Enquiries, and Notifications.
class MockRepository {
  MockRepository._();
  static final MockRepository instance = MockRepository._();

  // Authentication & Session
  UserRole currentRole = UserRole.student;
  bool isLoggedIn = true;
  String userName = 'Student User';
  String userEmail = 'student@example.com';
  String userPhone = '+94 77 123 4567';
  String userUniversity = 'SLIIT (Malabe)';

  // Saved / Favorites
  final ValueNotifier<Set<String>> savedListingsNotifier =
      ValueNotifier<Set<String>>({
    'Green Shadow Luxury Villa',
    'Scholars Haven Malabe',
  });

  // Listing Data (Shared between Student & Owner)
  late final ValueNotifier<List<BoardingListing>> listingsNotifier =
      ValueNotifier<List<BoardingListing>>(List.from(sampleBoardingListings));

  // Owner's Custom Added Listings
  final List<String> ownerListingNames = [
    'Green Shadow Luxury Villa',
    'Campus Crest Suites',
  ];

  // Enquiries
  final ValueNotifier<List<StudentEnquiry>> enquiriesNotifier =
      ValueNotifier<List<StudentEnquiry>>([
    StudentEnquiry(
      id: 'enq-1',
      listingName: 'Green Shadow Luxury Villa',
      studentName: 'Kasun Perera',
      studentPhone: '+94 71 890 1234',
      studentUniversity: 'SLIIT',
      moveInDate: '1st of Next Month',
      durationMonths: 6,
      message:
          'Hi, I am a 2nd year IT student. Is the single AC room still available for rent?',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      status: 'Pending',
    ),
    StudentEnquiry(
      id: 'enq-2',
      listingName: 'Campus Crest Suites',
      studentName: 'Nimesha Fernando',
      studentPhone: '+94 77 445 6677',
      studentUniversity: 'SLIIT',
      moveInDate: 'Immediate',
      durationMonths: 12,
      message:
          'Looking for a quiet room with study table and attached bathroom.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Accepted',
    ),
    StudentEnquiry(
      id: 'enq-3',
      listingName: 'Moratuwa Scholars Lodge',
      studentName: 'Dinuka Bandara',
      studentPhone: '+94 76 332 1199',
      studentUniversity: 'UoM',
      moveInDate: 'Next semester',
      durationMonths: 6,
      message: 'Can I arrange a physical visit this Saturday afternoon?',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Pending',
    ),
  ]);

  // Notifications
  final ValueNotifier<List<AppNotificationItem>> notificationsNotifier =
      ValueNotifier<List<AppNotificationItem>>([
    AppNotificationItem(
      id: 'notif-1',
      title: 'Enquiry Accepted 🎉',
      message:
          'Your enquiry for Campus Crest Suites has been accepted by owner Mr. Somapala. Check details to call.',
      timeAgo: '2h ago',
      type: 'enquiry',
    ),
    AppNotificationItem(
      id: 'notif-2',
      title: 'New Boarding near UoM',
      message:
          'Moratuwa Scholars Lodge added 2 new single AC rooms within 8 min walk to campus.',
      timeAgo: '1d ago',
      type: 'listing',
    ),
    AppNotificationItem(
      id: 'notif-3',
      title: 'Welcome to BODIMA!',
      message:
          'Complete your student profile to get verified badge and direct contact with verified landlords.',
      timeAgo: '3d ago',
      type: 'system',
      isRead: true,
    ),
  ]);

  // Methods
  bool isSaved(String name) => savedListingsNotifier.value.contains(name);

  void toggleSave(String name) {
    final next = Set<String>.from(savedListingsNotifier.value);
    if (!next.add(name)) {
      next.remove(name);
    }
    savedListingsNotifier.value = next;
  }

  void addEnquiry(StudentEnquiry enquiry) {
    enquiriesNotifier.value = [enquiry, ...enquiriesNotifier.value];
    // Add automated notification
    notificationsNotifier.value = [
      AppNotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Enquiry Sent Successfully',
        message:
            'Your enquiry for "${enquiry.listingName}" has been submitted to the landlord.',
        timeAgo: 'Just now',
        type: 'enquiry',
      ),
      ...notificationsNotifier.value,
    ];
  }

  void updateEnquiryStatus(String id, String newStatus) {
    final updated = enquiriesNotifier.value.map((e) {
      if (e.id == id) {
        e.status = newStatus;
      }
      return e;
    }).toList();
    enquiriesNotifier.value = updated;
  }

  void addListing(BoardingListing listing) {
    listingsNotifier.value = [listing, ...listingsNotifier.value];
    ownerListingNames.add(listing.name);
  }

  void deleteListing(String name) {
    listingsNotifier.value =
        listingsNotifier.value.where((l) => l.name != name).toList();
    ownerListingNames.remove(name);
    final nextSaved = Set<String>.from(savedListingsNotifier.value);
    nextSaved.remove(name);
    savedListingsNotifier.value = nextSaved;
  }

  void updateListingAvailability(String name, bool isAvailable) {
    final updated = listingsNotifier.value.map((l) {
      if (l.name == name) {
        return BoardingListing(
          name: l.name,
          location: l.location,
          price: l.price,
          rating: l.rating,
          reviewCount: l.reviewCount,
          imageColor: l.imageColor,
          gender: l.gender,
          roomType: l.roomType,
          isVerified: l.isVerified,
          isAvailable: isAvailable,
          amenities: l.amenities,
          campus: l.campus,
          walkTime: l.walkTime,
          description: l.description,
          ownerName: l.ownerName,
          ownerPhone: l.ownerPhone,
          ownerRating: l.ownerRating,
        );
      }
      return l;
    }).toList();
    listingsNotifier.value = updated;
  }
}
