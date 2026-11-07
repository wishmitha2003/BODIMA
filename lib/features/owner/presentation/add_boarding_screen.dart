import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../home/data/boarding_listing.dart';
import '../../shared/data/mock_repository.dart';

class AddBoardingScreen extends StatefulWidget {
  const AddBoardingScreen({super.key});

  @override
  State<AddBoardingScreen> createState() => _AddBoardingScreenState();
}

class _AddBoardingScreenState extends State<AddBoardingScreen> {
  int _currentStep = 0;

  // Step 1: Basic Info
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _propertyType = 'Single Room Annex';

  // Step 2: Location
  final _addressController = TextEditingController();
  final _cityController = TextEditingController(text: 'Malabe');
  String _nearbyCampus = 'SLIIT (Malabe)';
  final _walkTimeController = TextEditingController(text: '6 min walk');

  // Step 3: Room Info
  String _roomType = 'Single Room';
  final _rentController = TextEditingController(text: '18,000');
  final _depositController = TextEditingController(text: '1 Month');
  String _gender = 'Any';

  // Step 4: Facilities
  final Set<String> _selectedFacilities = {
    'Wi-Fi',
    'Attached Bathroom',
    'Study Table',
    'Separate Entrance',
  };

  // Step 5: Photos (Mock count)
  int _uploadedPhotosCount = 3;

  // Step 6: Rules
  final _curfewController = TextEditingController(text: '10:30 PM');
  bool _smokingAllowed = false;
  bool _visitorsAllowed = true;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _walkTimeController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _curfewController.dispose();
    super.dispose();
  }

  void _submitListing() {
    final title = _nameController.text.trim().isEmpty
        ? 'University Scholar Haven'
        : _nameController.text.trim();
    final rent = _rentController.text.trim().isEmpty
        ? 'Rs. 18,000'
        : 'Rs. ${_rentController.text.trim()}';

    final newListing = BoardingListing(
      name: title,
      location: '${_cityController.text.trim()}, Sri Lanka',
      price: rent,
      rating: 5.0,
      reviewCount: 1,
      imageColor: 0xFF123B4A,
      gender: _gender,
      roomType: _roomType,
      isVerified: true,
      isAvailable: true,
      amenities: _selectedFacilities.toList(),
      campus: _nearbyCampus,
      walkTime: _walkTimeController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? 'Comfortable, safe student accommodation located conveniently near campus with study desk and high-speed Wi-Fi.'
          : _descController.text.trim(),
      ownerName: MockRepository.instance.userName,
      ownerPhone: MockRepository.instance.userPhone,
      ownerRating: 5.0,
    );

    MockRepository.instance.addListing(newListing);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 26),
            SizedBox(width: 8),
            Text('Listing Published!'),
          ],
        ),
        content: Text(
          '"$title" has been published successfully and is now visible to university students.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('View in Dashboard'),
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
        title: const Text('Add Boarding Place'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: isDark ? AppColors.darkSurface : Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step ${_currentStep + 1} of 6',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color:
                              isDark ? AppColors.darkPrimary : AppColors.teal,
                        ),
                      ),
                      Text(
                        _getStepTitle(_currentStep),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkPrimaryText
                              : AppColors.deepNavy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / 6,
                    backgroundColor: isDark
                        ? AppColors.darkElevatedSurface
                        : AppColors.softMint,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? AppColors.darkPrimary : AppColors.teal,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStep(isDark),
              ),
            ),

            // Bottom Navigation Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _currentStep--),
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: () {
                        if (_currentStep < 5) {
                          setState(() => _currentStep++);
                        } else {
                          _submitListing();
                        }
                      },
                      child: Text(
                        _currentStep == 5 ? 'Publish Listing 🚀' : 'Next Step',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Basic Details';
      case 1:
        return 'Location & Campus';
      case 2:
        return 'Room & Rental';
      case 3:
        return 'Facilities & Amenities';
      case 4:
        return 'Property Photos';
      case 5:
        return 'House Rules & Preview';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep(bool isDark) {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Property Name / Title',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'e.g. Green Haven Annex Malabe',
                prefixIcon: Icon(Icons.home_outlined),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Property Type',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _propertyType,
              items: const [
                DropdownMenuItem(
                  value: 'Single Room Annex',
                  child: Text('Single Room Annex'),
                ),
                DropdownMenuItem(
                  value: 'Shared Student Room',
                  child: Text('Shared Student Room'),
                ),
                DropdownMenuItem(
                  value: 'Entire Student House / Villa',
                  child: Text('Entire Student House / Villa'),
                ),
                DropdownMenuItem(
                  value: 'Hostel Bed',
                  child: Text('Hostel Bed'),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _propertyType = v);
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Detailed Description',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText:
                    'Describe the room environment, surroundings, study facilities, and water/electricity terms...',
                alignLabelWithHint: true,
              ),
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nearest Campus / University',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _nearbyCampus,
              items: const [
                DropdownMenuItem(
                  value: 'SLIIT (Malabe)',
                  child: Text('SLIIT (Malabe)'),
                ),
                DropdownMenuItem(
                  value: 'UoM (Moratuwa)',
                  child: Text('UoM (Moratuwa)'),
                ),
                DropdownMenuItem(
                  value: 'NSBM (Homagama)',
                  child: Text('NSBM (Homagama)'),
                ),
                DropdownMenuItem(
                  value: 'USJ (Nugegoda)',
                  child: Text('USJ (Nugegoda)'),
                ),
                DropdownMenuItem(
                  value: 'UOC (Colombo)',
                  child: Text('UOC (Colombo)'),
                ),
                DropdownMenuItem(
                  value: 'Kelaniya Uni',
                  child: Text('Kelaniya Uni'),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _nearbyCampus = v);
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Walking Distance / Time',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _walkTimeController,
              decoration: const InputDecoration(
                hintText: 'e.g. 5 min walk / 500m',
                prefixIcon: Icon(Icons.directions_walk_rounded),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Address / Town',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                hintText: 'e.g. Kaduwela Road, Malabe',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Room Category',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _roomType,
              items: const [
                DropdownMenuItem(
                  value: 'Single Room',
                  child: Text('Single Room'),
                ),
                DropdownMenuItem(
                  value: 'Shared Room (2 students)',
                  child: Text('Shared Room (2 students)'),
                ),
                DropdownMenuItem(
                  value: 'Shared Room (3-4 students)',
                  child: Text('Shared Room (3-4 students)'),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _roomType = v);
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Monthly Rental (LKR)',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _rentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 18,000',
                prefixIcon: Icon(Icons.attach_money_rounded),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Gender Preference',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _gender,
              items: const [
                DropdownMenuItem(
                    value: 'Any', child: Text('Any (Open to all)')),
                DropdownMenuItem(value: 'Boys', child: Text('Boys Only')),
                DropdownMenuItem(value: 'Girls', child: Text('Girls Only')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _gender = v);
              },
            ),
          ],
        );

      case 3:
        final allFacilities = [
          'Wi-Fi',
          'AC',
          'Attached Bathroom',
          'Hot Water',
          'Study Table',
          'Separate Entrance',
          'Car / Bike Parking',
          'Meals Available',
          'Washing Machine',
          'Generator / Power Backup',
          'CCTV Security',
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select all available facilities for students:',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allFacilities.map((fac) {
                final isSelected = _selectedFacilities.contains(fac);
                return FilterChip(
                  label: Text(fac),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedFacilities.add(fac);
                      } else {
                        _selectedFacilities.remove(fac);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );

      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Room & Property Photos',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Clear, well-lit photos increase student enquiries by 80%.',
              style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ...List.generate(
                  _uploadedPhotosCount,
                  (i) => Container(
                    width: 76,
                    height: 76,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppColors.softMint,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.teal),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            i == 0
                                ? Icons.bed_rounded
                                : (i == 1
                                    ? Icons.shower_rounded
                                    : Icons.kitchen_rounded),
                            color: AppColors.teal,
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () {
                              if (_uploadedPhotosCount > 1) {
                                setState(() => _uploadedPhotosCount--);
                              }
                            },
                            child: const Icon(
                              Icons.cancel_rounded,
                              size: 18,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _uploadedPhotosCount++),
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, size: 24),
                        SizedBox(height: 4),
                        Text(
                          'Add Photo',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );

      case 5:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'House Rules & Curfew',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _curfewController,
              decoration: const InputDecoration(
                labelText: 'Gate Curfew Time',
                prefixIcon: Icon(Icons.access_time_rounded),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Visitors Allowed'),
              subtitle: const Text('In common areas during daytime'),
              value: _visitorsAllowed,
              onChanged: (v) => setState(() => _visitorsAllowed = v),
            ),
            SwitchListTile(
              title: const Text('Smoking / Alcohol Permitted'),
              subtitle: const Text('Strictly prohibited by default'),
              value: _smokingAllowed,
              onChanged: (v) => setState(() => _smokingAllowed = v),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.verified_rounded,
                          color: AppColors.gold, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Listing Summary',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Title: ${_nameController.text.isEmpty ? 'New Student Boarding' : _nameController.text}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text('Campus: $_nearbyCampus (${_walkTimeController.text})'),
                  Text('Rent: Rs. ${_rentController.text} / month'),
                  Text('Facilities: ${_selectedFacilities.length} selected'),
                ],
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
