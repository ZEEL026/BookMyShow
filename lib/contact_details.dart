import 'package:flutter/material.dart';
import 'final_booking.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ContactDetails extends StatefulWidget {
  final String movieName;
  final String movieImage;
  final String cinemaName;
  final String date;
  final String time;
  final List<String> selectedSeats;
  final int totalPrice;

  const ContactDetails({
    super.key,
    required this.movieName,
    required this.movieImage,
    required this.cinemaName,
    required this.date,
    required this.time,
    required this.selectedSeats,
    required this.totalPrice,
  });

  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  String _selectedCountryCode = '+91'; // Default country code

  // List of country codes
  final List<String> _countryCodes = ['+91', '+1', '+44', '+61'];

  // Email validation regex
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Mobile number validation (simple check for 10 digits)
  bool _isValidMobile(String mobile) {
    return RegExp(r'^\d{10}$').hasMatch(mobile);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueGrey.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced AppBar
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Colors.red.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      'Contact Details',
                      style: GoogleFonts.poppins(
                        fontSize: 24, // Increased
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ),
                const SizedBox(height: 20),

                // Enhanced Movie Details Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movieName,
                        style: GoogleFonts.poppins(
                          fontSize: 22, // Increased
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.cinemaName,
                        style: GoogleFonts.poppins(
                          fontSize: 18, // Increased
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${widget.date}',
                        style: GoogleFonts.poppins(
                          fontSize: 16, // Increased
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Time: ${widget.time}',
                        style: GoogleFonts.poppins(
                          fontSize: 16, // Increased
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Seats: ${widget.selectedSeats.join(', ')}',
                        style: GoogleFonts.poppins(
                          fontSize: 16, // Increased
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Price: ₹ ${widget.totalPrice}',
                        style: GoogleFonts.poppins(
                          fontSize: 18, // Increased
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Contact Details Form
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Name',
                          style: GoogleFonts.poppins(
                            fontSize: 18, // Increased
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 16, // Increased
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.green, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          style: GoogleFonts.poppins(fontSize: 16), // Increased text size
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        Text(
                          'Your Email',
                          style: GoogleFonts.poppins(
                            fontSize: 18, // Increased
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'eg. abc@gmail.com',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 16, // Increased
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.green, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.poppins(fontSize: 16), // Increased text size
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!_isValidEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'To access the ticket(s) on other devices, Login with this E-Mail',
                          style: GoogleFonts.poppins(
                            fontSize: 14, // Increased
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          'Mobile Number',
                          style: GoogleFonts.poppins(
                            fontSize: 18, // Increased
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[50],
                              ),
                              child: DropdownButton<String>(
                                value: _selectedCountryCode,
                                items: _countryCodes.map((String code) {
                                  return DropdownMenuItem<String>(
                                    value: code,
                                    child: Text(
                                      code,
                                      style: GoogleFonts.poppins(fontSize: 16), // Increased
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCountryCode = newValue!;
                                  });
                                },
                                underline: const SizedBox(),
                                dropdownColor: Colors.white,
                                icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _mobileController,
                                decoration: InputDecoration(
                                  hintText: 'eg. 91480XXXXX',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 16, // Increased
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.green, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.poppins(fontSize: 16), // Increased text size
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your mobile number';
                                  }
                                  if (!_isValidMobile(value)) {
                                    return 'Please enter a valid 10-digit mobile number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your Number will ONLY be used for sending ticket(s)',
                          style: GoogleFonts.poppins(
                            fontSize: 14, // Increased
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                              msg: 'Terms and Conditions clicked',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                            );
                          },
                          child: Text(
                            'Terms and Conditions',
                            style: GoogleFonts.poppins(
                              fontSize: 16, // Increased
                              color: Colors.red,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Enhanced Proceed Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FinalBooking(
                                      movieName: widget.movieName,
                                      cinemaName: widget.cinemaName,
                                      date: widget.date,
                                      time: widget.time,
                                      selectedSeats: widget.selectedSeats,
                                      totalPrice: widget.totalPrice,
                                      email: _emailController.text,
                                      mobile: '$_selectedCountryCode${_mobileController.text}',
                                      name: _nameController.text,
                                      movieImage :widget.movieImage
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.black26,
                            ).copyWith(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.grey;
                                  }
                                  return Colors.transparent;
                                },
                              ),
                              overlayColor: MaterialStateProperty.all(
                                Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.redAccent, Colors.red],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.redAccent.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              child: Text(
                                'Proceed',
                                style: GoogleFonts.poppins(
                                  fontSize: 18, // Increased
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}