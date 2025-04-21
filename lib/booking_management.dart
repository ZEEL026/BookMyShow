import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animations/animations.dart';
import 'booking_details.dart';
import 'package:transparent_image/transparent_image.dart';

class BookingManagement extends StatefulWidget {
  const BookingManagement({Key? key}) : super(key: key);

  @override
  BookingManagementState createState() => BookingManagementState();
}

class BookingManagementState extends State<BookingManagement> with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue[800]!, Colors.blue[900]!],
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Please log in to view bookings',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[800]!, Colors.blue[900]!],
          ),
        ),
        child: Column(
          children: [
            // Custom AppBar
            Container(
              padding: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AppBar(
                title: Text(
                  'My Bookings',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false, // Remove back icon
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(user!.uid)
                    .collection('Booking')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Colors.red[300]!, Colors.red[500]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            'Error loading bookings',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          'No bookings found',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    );
                  }

                  final bookings = snapshot.data!.docs;

                  return ListView.separated(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: bookings.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final booking = bookings[index].data() as Map<String, dynamic>;
                      return PageTransitionSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                            FadeScaleTransition(animation: primaryAnimation, child: child),
                        child: GestureDetector(
                          key: ValueKey(bookings[index].id),
                          onTapDown: (_) => _scaleController.forward(),
                          onTapUp: (_) {
                            _scaleController.reverse();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingDetails(
                                  movieName: booking['movieName'] ?? 'Unknown',
                                  cinemaName: booking['cinemaName'] ?? 'Unknown',
                                  date: booking['date'] ?? 'Unknown',
                                  time: booking['time'] ?? 'Unknown',
                                  selectedSeats: List<String>.from(booking['selectedSeats'] ?? []),
                                  totalPrice: (booking['totalPrice'] is int
                                      ? (booking['totalPrice'] as int).toDouble()
                                      : booking['totalPrice'] ?? 0.0),
                                  convenienceFees: (booking['convenienceFees'] is int
                                      ? (booking['convenienceFees'] as int).toDouble()
                                      : booking['convenienceFees'] ?? 0.0),
                                  bookASmileContribution: (booking['bookASmileContribution'] is int
                                      ? (booking['bookASmileContribution'] as int).toDouble()
                                      : booking['bookASmileContribution'] ?? 0.0),
                                  totalAmount: (booking['totalAmount'] is int
                                      ? (booking['totalAmount'] as int).toDouble()
                                      : booking['totalAmount'] ?? 0.0),
                                  email: booking['email'] ?? 'Unknown',
                                  mobile: booking['mobile'] ?? 'Unknown',
                                  name: booking['name'] ?? 'Unknown',
                                  paymentMethod: booking['paymentMethod'] ?? 'Unknown',
                                  movieImage: booking['movieImage'] ?? '',
                                ),
                              ),
                            );
                          },
                          onTapCancel: () => _scaleController.reverse(),
                          child: AnimatedBuilder(
                            animation: _scaleController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1.0 - _scaleController.value,
                                child: child,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(24.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Movie Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: booking['movieImage']?.isNotEmpty == true
                                          ? booking['movieImage']
                                          : 'https://via.placeholder.com/100',
                                      height: 120,
                                      width: 80,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder: (context, error, stackTrace) => Container(
                                        height: 120,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Colors.grey[700]!, Colors.grey[900]!],
                                          ),
                                        ),
                                        child: const Icon(Icons.error, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (booking['movieName'] ?? 'Unknown').split(' - ')[0],
                                          style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${booking['cinemaName'] ?? 'Unknown'} | ${booking['date'] ?? 'Unknown'} ${booking['time'] ?? 'Unknown'}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white70,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Seats: ${(booking['selectedSeats'] as List<dynamic>?)?.join(', ') ?? 'None'}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white70,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Total: ₹ ${(booking['totalAmount'] is int ? (booking['totalAmount'] as int).toDouble() : booking['totalAmount'] ?? 0.0).toStringAsFixed(2)}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }
}