import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './movie.dart';
import './seat_booking.dart';

class ViewDetailsMovie extends StatefulWidget {
  final Movie movie;

  const ViewDetailsMovie({super.key, required this.movie});

  @override
  _ViewDetailsMovieState createState() => _ViewDetailsMovieState();
}

class _ViewDetailsMovieState extends State<ViewDetailsMovie> {
  DateTime? _selectedDate;
  String? _selectedPriceRange;
  String? _selectedTime;
  String? _selectedCinema; // Selected cinema
  List<String> cinemas = ['Rajhans , Navsari', 'Amisha Miniplex', 'INOX Cinemas (Vr Surat)']; // Static list of cinemas
  List<String> timeSlots = []; // Initialize an empty list
  
  // Time slots for each cinema
  Map<String, List<String>> cinemaTimeSlots = {
    'Rajhans , Navsari': ['01:00 PM', '04:00 PM', '07:00 PM'],
    'Amisha Miniplex': ['02:00 PM', '05:00 PM', '08:00 PM'],
    'INOX Cinemas (Vr Surat)': ['03:00 PM', '06:00 PM', '09:00 PM'],
  };

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled =
        _selectedDate != null &&
        _selectedPriceRange != null &&
        _selectedTime != null &&
        _selectedCinema != null;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
               Container(
  height: 300,
  width: double.infinity,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
    border: Border.all(color: Colors.grey.shade300, width: 2),
    boxShadow: [
      BoxShadow(
        color: Colors.white,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
    child: Hero(
      tag: 'movieImage-${widget.movie.movieName}',
      child: Image.network(
        widget.movie.movieImage.isNotEmpty
            ? widget.movie.movieImage
            : 'https://via.placeholder.com/150',
        height: 300,
        width: double.infinity,
        fit: BoxFit.contain,
      ),
    ),
  ),
),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie.movieName,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Description',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            final date = DateTime.now().add(
                              Duration(days: index),
                            );
                            return _buildDateCard(date);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_selectedDate == null)
                        Center(
                          child: Text(
                            'Please select a date, time, and price slot',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      if (_selectedDate != null) ...[
                        const Divider(thickness: 1, color: Colors.grey),
                        const SizedBox(height: 16),
                        // Show cinema dropdown
                        _buildCinemaDropdown(),
                        const SizedBox(height: 16),
                        // Display selected cinema
                        if (_selectedCinema != null) ...[
                          Text(
                            'Selected Cinema: $_selectedCinema',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                        ],
                        // Display the price slots below the cinema dropdown
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
Divider(),
                               Text(
                          'Price Slots',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                          
                          ],
                        ),
                        SizedBox(
                          height: 80,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                                 _buildPriceCard("Normal Seat\n\n₹120"),
              SizedBox(width: 10),
              _buildPriceCard("Executive Seat\n\n₹170"),
              SizedBox(width: 10),
              _buildPriceCard("Royal Seat\n\n ₹210"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(thickness: 3, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'Time Slots',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildTimeSlotsForCinema(),
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        
        Positioned(
  bottom: 16,
  left: 16,
  right: 16,
  child: ElevatedButton(
    onPressed: isButtonEnabled
        ? () {
            int priceValue = 0; // Variable to hold the integer price
            if (_selectedPriceRange != null) {
              // Split the selected price range to get the integer value
              final parts = _selectedPriceRange!.split('\n').last.trim(); // Get the last part (the price)
              priceValue = int.parse(parts.replaceAll('₹', '').trim()); // Remove currency sign and convert to int
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SeatBooking(
                  date: '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  time: _selectedTime!,
                  price: priceValue, 
                  cinemaName: _selectedCinema!,
                  movieName: widget.movie.movieName,
                  movieImage: widget.movie.movieImage,
                ),
              ),
            );
          }
        : null,
    style: ElevatedButton.styleFrom(
      backgroundColor: isButtonEnabled ? Colors.redAccent : Colors.grey,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      minimumSize: const Size(double.infinity, 50),
    ),
    child: Text(
      'Book Now',
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ),
),
        ],
      ),
    );
  }

  Widget _buildDateCard(DateTime date) {
    final dayName =
        ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][date.weekday - 1];
    final monthName =
        [
          'JAN',
          'FEB',
          'MAR',
          'APR',
          'MAY',
          'JUN',
          'JUL',
          'AUG',
          'SEP',
          'OCT',
          'NOV',
          'DEC',
        ][date.month - 1];
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedSelectedDate =
        _selectedDate != null
            ? DateTime(
                _selectedDate!.year,
                _selectedDate!.month,
                _selectedDate!.day,
              )
            : null;
    final isSelected = normalizedSelectedDate == normalizedDate;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = DateTime(date.year, date.month, date.day);
          _selectedPriceRange = null; // Reset price when date changes
          _selectedTime = null; // Reset time when date changes
          _selectedCinema = null; // Reset cinema when date changes
          timeSlots.clear(); // Clear the time slots
        });
        Fluttertoast.showToast(
          msg: 'Selected Date: $dayName, ${date.day} $monthName',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.blueAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.blueAccent.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.blueAccent,
              ),
            ),
            Text(
              date.day.toString(),
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              monthName,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildCinemaDropdown() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButton<String>(
        hint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Select a Cinema",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
            ),
          ),
        ),
        value: _selectedCinema,
        onChanged: (String? cinema) {
          setState(() {
            _selectedCinema = cinema;
            // Populate time slots based on the selected cinema
            _populateTimeSlots();
          });
          if (cinema != null) {
            Fluttertoast.showToast(
              msg: 'Selected Cinema: $cinema',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          }
        },
        isExpanded: true,
        underline: SizedBox(),
        icon: Icon(
          Icons.arrow_drop_down_circle,
          color: Colors.blueAccent,
        ),
        items: cinemas.map((String cinema) {
          return DropdownMenuItem<String>(
            value: cinema,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                cinema,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}

  void _populateTimeSlots() {
    if (_selectedCinema != null) {
      setState(() {
        timeSlots = cinemaTimeSlots[_selectedCinema!] ?? [];
      });
    }
  }

  Widget _buildTimeSlotsForCinema() {
    if (_selectedCinema == null || timeSlots.isEmpty) {
      return Container(
        child: Text('No showtimes available.', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: timeSlots.map((time) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTime = time;
                });
                Fluttertoast.showToast(
                  msg: 'Selected Time: $time',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _selectedTime == time ? Colors.red : Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: _selectedTime == time ? Colors.white : Colors.blueAccent,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  Widget _buildPriceCard(String range) {
  final isSelected = _selectedPriceRange == range;

  return GestureDetector(
    onTap: () {
      setState(() {
        _selectedPriceRange = range;
      });
      Fluttertoast.showToast(
        msg: 'Selected Price Range: $range',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    },
    child: Container(
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Colors.redAccent : Colors.white,
      ),
      child: Center(
        child: Text(
          range,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.redAccent,
          ),
        ),
      ),
    ),
  );
}
}