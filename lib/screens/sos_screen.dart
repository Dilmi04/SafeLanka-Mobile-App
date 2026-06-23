import 'dart:async';
import 'package:flutter/material.dart';
import 'package:safelanka/services/sos_service.dart';
import 'package:safelanka/models/emergency_contact_model.dart';
import 'package:safelanka/screens/emergency_contacts_screen.dart';
import 'package:safelanka/utils/constants.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen>
    with SingleTickerProviderStateMixin {
  final SosService _sosService = SosService();

  bool _isSending = false;
  bool _alertSent = false;
  String _locationText = 'Fetching location...';
  String _accuracy = '';
  List<EmergencyContact> _contacts = [];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.10).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadData();
  }

  Future<void> _loadData() async {
    await _fetchLocation();
    await _loadContacts();
  }

  Future<void> _fetchLocation() async {
    try {
      final pos = await _sosService.getCurrentPosition();
      if (mounted) {
        setState(() {
          _locationText =
          '${pos.latitude.toStringAsFixed(4)}° N, ${pos.longitude.toStringAsFixed(4)}° E';
          _accuracy = 'Accuracy: ${pos.accuracy.toStringAsFixed(0)} m';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationText = 'Location unavailable';
          _accuracy = '';
        });
      }
    }
  }

  Future<void> _loadContacts() async {
    try {
      final contacts = await _sosService.getEmergencyContacts();
      if (mounted) setState(() => _contacts = contacts);
    } catch (_) {}
  }

  Future<void> _sendSOS() async {
    if (_isSending || _alertSent) return;
    setState(() => _isSending = true);
    try {
      await _sosService.sendSosAlert();
      if (mounted) {
        setState(() {
          _alertSent = true;
          _isSending = false;
        });
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send SOS: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Alert Sent!'),
          ],
        ),
        content: const Text(
          'Your SOS alert with live location has been sent to your emergency contacts.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _alertSent = false);
            },
            child: const Text('OK',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── RED HEADER ──────────────────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.error,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'SOS ALERT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // balance back button
                  ],
                ),
              ),
            ),
          ),

          // ── WHITE BODY ──────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),

                  // ── SOS Pulsing Button (on white bg, red rings) ──
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outermost red ring (lightest)
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.error.withValues(alpha: 0.10),
                          ),
                        ),
                        // Middle red ring
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.error.withValues(alpha: 0.20),
                          ),
                        ),
                        // Inner red ring
                        Container(
                          width: 105,
                          height: 105,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.error.withValues(alpha: 0.35),
                          ),
                        ),
                        // Core button (red filled)
                        GestureDetector(
                          onTap: _sendSOS,
                          child: Container(
                            width: 78,
                            height: 78,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.error,
                            ),
                            child: _isSending
                                ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                                : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.warning_amber_rounded,
                                    color: Colors.white, size: 26),
                                SizedBox(height: 2),
                                Text(
                                  'SEND SOS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    'Sending your alert to\nemergency contacts',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Info card ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Your Location ──
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Your Location',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: AppColors.error, size: 16),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        _locationText,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textDark),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _fetchLocation,
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text(
                                        'Refresh',
                                        style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_accuracy.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 22),
                                    child: Text(
                                      _accuracy,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textGrey),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 14),
                              ],
                            ),
                          ),

                          const Divider(height: 1, color: Color(0xFFEEEEEE)),

                          // ── Alert will be sent to ──
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Alert will be sent to',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (_contacts.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      'No emergency contacts added yet.',
                                      style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                                    ),
                                  )
                                else
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _contacts.length,
                                    separatorBuilder: (context, index) =>
                                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                                    itemBuilder: (context, index) {
                                      final c = _contacts[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                                              child: Text(
                                                c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                                                style: const TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    c.name,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13,
                                                      color: AppColors.textDark,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    c.phone,
                                                    style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),

                          const Divider(height: 1, color: Color(0xFFEEEEEE)),

                          // ── Add More Contacts ──
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                  const EmergencyContactsScreen()),
                            ).then((_) => _loadContacts()),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                        AppColors.primary.withValues(alpha: 0.4),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                        Icons.person_add_outlined,
                                        color: AppColors.primary,
                                        size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Add More Contacts',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios,
                                      size: 13, color: AppColors.textGrey),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}