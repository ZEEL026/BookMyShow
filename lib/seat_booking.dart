import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'contact_details.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SeatBooking extends StatefulWidget {
  final String date;
  final String time;
  final int price;
  final String cinemaName;
  final String movieName;
  final String movieImage;

  const SeatBooking({
    super.key,
    required this.date,
    required this.time,
    required this.price,
    required this.cinemaName,
    required this.movieName,
    required this.movieImage,
  });

  @override
  _SeatBookingState createState() => _SeatBookingState();
}

class _SeatBookingState extends State<SeatBooking> {
  // List to track selected seats
  List<String> selectedSeats = [];
  // Number of tickets (default is 1)
  int ticketCount = 1;

  // Generate seat numbers (e.g., 01 to 50)
  List<String> get seatNumbers {
    return List.generate(50, (index) => (index + 1).toString().padLeft(2, '0'));
  }

  // Show pop-up menu for ticket selection
  void _showTicketSelectionMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem<int>(
          value: 1,
          child: Text('1 Ticket', style: GoogleFonts.poppins(fontSize: 14)),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Text('2 Tickets', style: GoogleFonts.poppins(fontSize: 14)),
        ),
        PopupMenuItem<int>(
          value: 3,
          child: Text('3 Tickets', style: GoogleFonts.poppins(fontSize: 14)),
        ),
        PopupMenuItem<int>(
          value: 4,
          child: Text('4 Tickets', style: GoogleFonts.poppins(fontSize: 14)),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          ticketCount = value;
          selectedSeats
              .clear(); // Clear selected seats when ticket count changes
        });
        Fluttertoast.showToast(
          msg: 'Selected $value Ticket${value == 1 ? '' : 's'}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = selectedSeats.length == ticketCount;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.movieName,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black12,
      ),
      body: Column(
        children: [
          // Display selected date, time, and price
          Container(
            margin: const EdgeInsets.all(12.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[400]!, Colors.blue[200]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Movie Name: ${widget.movieName}",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Cinema Name: ${widget.cinemaName}",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.date,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Text(
                      "₹ : ${widget.price}",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green[200]!,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.time,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.white,
                              ),
                              onPressed:
                                  () => _showTicketSelectionMenu(context),
                            ),
                            Text(
                              '$ticketCount Ticket${ticketCount == 1 ? '' : 's'}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // Optional Dark Overlay
                Container(color: Colors.black.withOpacity(0.3)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Seat categories and grid
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹340 Recliner',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSeatGrid(start: 0, end: 10), // First row of recliners
                    const SizedBox(height: 16),
                    _buildSeatGrid(start: 10, end: 50), // Remaining seats
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          // Legend
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendBox(Colors.white, Colors.grey, 'Available'),
                const SizedBox(width: 16),
                _buildLegendBox(Colors.green, Colors.white, 'Selected'),
                const SizedBox(width: 16),
                _buildLegendBox(Colors.grey[300]!, Colors.grey, 'Sold'),
              ],
            ),
          ),
          // Payment button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Seat ALLOCATION',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed:
                      isButtonEnabled
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ContactDetails(
                                      movieName: widget.movieName,
                                      movieImage: widget.movieImage,
                                      cinemaName: widget.cinemaName,
                                      date: widget.date,
                                      time: widget.time,
                                      selectedSeats: selectedSeats,
                                      totalPrice: selectedSeats.length * widget.price,
                                    ),
                              ),
                            );
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.black26,
                    foregroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.transparent;
                    }),
                    overlayColor: MaterialStateProperty.all(
                      Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            isButtonEnabled
                                ? [Colors.redAccent, Colors.red]
                                : [Colors.grey, Colors.grey],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      'Pay ₹ ${selectedSeats.length * widget.price}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build the seat grid
  Widget _buildSeatGrid({required int start, required int end}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10, // 10 columns
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1, // Square seats
      ),
      itemCount: end - start,
      itemBuilder: (context, index) {
        final seatNumber = seatNumbers[start + index];
        final isSelected = selectedSeats.contains(seatNumber);
        // For simplicity, assume no seats are sold (you can add logic for sold seats)
        final isSold = false;

        return GestureDetector(
          onTap:
              isSold
                  ? null
                  : () {
                    setState(() {
                      if (isSelected) {
                        selectedSeats.remove(seatNumber);
                        Fluttertoast.showToast(
                          msg: 'Seat $seatNumber deselected',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                        );
                      } else {
                        if (selectedSeats.length < ticketCount) {
                          selectedSeats.add(seatNumber);
                          Fluttertoast.showToast(
                            msg: 'Seat $seatNumber selected',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg:
                                'Please select exactly $ticketCount seat${ticketCount == 1 ? '' : 's'}',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                          );
                        }
                      }
                    });
                  },
          child: Container(
            decoration: BoxDecoration(
              color:
                  isSold
                      ? Colors.grey[300]
                      : isSelected
                      ? Colors.green
                      : Colors.white,
              border: Border.all(
                color:
                    isSold
                        ? Colors.grey
                        : isSelected
                        ? Colors.green
                        : Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                seatNumber,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      isSold
                          ? Colors.grey
                          : isSelected
                          ? Colors.white
                          : Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Build legend box
  Widget _buildLegendBox(Color bgColor, Color textColor, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: textColor, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
