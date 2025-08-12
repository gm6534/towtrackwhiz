import 'package:flutter/material.dart';
import 'package:flutter_util/flutter_util.dart';

class AddVehicles extends StatelessWidget {
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController makeController = TextEditingController();
  AddVehicles({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(body: SafeArea(
        child: Padding(
          padding: 16.p,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Vehicles',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              24.h, // vertical spacing
              Text(
                'License Plate',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              8.h,
              TextField(
                controller: licensePlateController,
                decoration: InputDecoration(
                  hintText: 'LUE6850',
                  border: OutlineInputBorder(
                    borderRadius: 8.br,
                  ),
                  contentPadding: 12.p,
                ),
              ),
              20.h,
              Text(
                'Make',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              8.h,
              TextField(
                controller: makeController,
                decoration: InputDecoration(
                  hintText: '---------',
                  border: OutlineInputBorder(
                    borderRadius: 8.br,
                  ),
                  contentPadding: 12.p,
                ),
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: 14.p,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.br),
                      ),
                    ),
                    onPressed: () {
                      // Handle save logic
                      print('Saved: ${licensePlateController.text}, ${makeController.text}');
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              16.h,
            ],
          ),
        ),
      ),);
  }
}