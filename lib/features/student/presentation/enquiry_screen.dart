import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../home/data/boarding_listing.dart';
import '../../shared/data/mock_repository.dart';

class EnquiryScreen extends StatefulWidget {
  const EnquiryScreen({
    required this.listing,
    super.key,
  });

  final BoardingListing listing;

  @override
  State<EnquiryScreen> createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _uniController;
  late final TextEditingController _messageController;
  String _moveInPeriod = '1st of Next Month';
  int _stayDuration = 6;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final repo = MockRepository.instance;
    _nameController = TextEditingController(text: repo.userName);
    _phoneController = TextEditingController(text: repo.userPhone);
    _uniController = TextEditingController(
      text: repo.userUniversity.isNotEmpty
          ? repo.userUniversity
          : widget.listing.campus,
    );
    _messageController = TextEditingController(
      text:
          'Hello Mr./Mrs. ${widget.listing.ownerName}, I am interested in renting this boarding place near ${widget.listing.campus}. Is it still available?',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _uniController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitEnquiry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final enquiry = StudentEnquiry(
      id: 'enq-${DateTime.now().millisecondsSinceEpoch}',
      listingName: widget.listing.name,
      studentName: _nameController.text.trim(),
      studentPhone: _phoneController.text.trim(),
      studentUniversity: _uniController.text.trim(),
      moveInDate: _moveInPeriod,
      durationMonths: _stayDuration,
      message: _messageController.text.trim(),
      createdAt: DateTime.now(),
      status: 'Pending',
    );

    MockRepository.instance.addEnquiry(enquiry);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 26),
            SizedBox(width: 10),
            Text('Enquiry Sent!'),
          ],
        ),
        content: Text(
          'Your enquiry for "${widget.listing.name}" has been forwarded to ${widget.listing.ownerName}. You can track this under My Enquiries in your Profile.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Great, Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('Send Boarding Enquiry'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property Target Summary Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Color(widget.listing.imageColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.home_work_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.listing.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.darkPrimaryText
                                    : AppColors.deepNavy,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${widget.listing.price} / month • Host: ${widget.listing.ownerName}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.teal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Your Student Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color:
                        isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 14),

                // Name
                TextFormField(
                  controller: _nameController,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Please enter your name'
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 14),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Please enter contact phone'
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Contact Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 14),

                // University
                TextFormField(
                  controller: _uniController,
                  decoration: const InputDecoration(
                    labelText: 'Campus / University / Degree',
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Rental Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color:
                        isDark ? AppColors.darkPrimaryText : AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 14),

                // Expected Move-in
                DropdownButtonFormField<String>(
                  initialValue: _moveInPeriod,
                  decoration: const InputDecoration(
                    labelText: 'Expected Move-in Date',
                    prefixIcon: Icon(Icons.calendar_today_rounded),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Immediate (Within this week)',
                      child: Text('Immediate (Within this week)'),
                    ),
                    DropdownMenuItem(
                      value: '1st of Next Month',
                      child: Text('1st of Next Month'),
                    ),
                    DropdownMenuItem(
                      value: 'Beginning of next semester',
                      child: Text('Beginning of next semester'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _moveInPeriod = val);
                  },
                ),
                const SizedBox(height: 14),

                // Stay Duration
                DropdownButtonFormField<int>(
                  initialValue: _stayDuration,
                  decoration: const InputDecoration(
                    labelText: 'Expected Stay Duration',
                    prefixIcon: Icon(Icons.timelapse_rounded),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 3,
                      child: Text('3 Months (Short term)'),
                    ),
                    DropdownMenuItem(
                      value: 6,
                      child: Text('6 Months (1 Semester)'),
                    ),
                    DropdownMenuItem(
                      value: 12,
                      child: Text('12 Months (Full Academic Year)'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _stayDuration = val);
                  },
                ),
                const SizedBox(height: 14),

                // Custom Message
                TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Please include a message for the host'
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Message to Landlord',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 28),

                // Submit CTA
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _isSubmitting ? null : _submitEnquiry,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded, size: 18),
                    label: Text(
                      _isSubmitting
                          ? 'Sending...'
                          : 'Submit Enquiry to Landlord',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
