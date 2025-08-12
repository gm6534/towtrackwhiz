import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/View/Common/vehicle_card_widget.dart';

class VehicleScreen extends StatelessWidget {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                VehicleCard(
                  title: "Car",
                  subTitle: "4 Seater, Petrol",
                  imagePath: "assets/images/car.png",
                  bgColor: Colors.blue,
                  onTap: () {
                    print("Car Clicked");
                  },
                ),
                VehicleCard(
                  title: "Bike",
                  subTitle: "2 Seater, Petrol",
                  imagePath: "assets/images/bike.png",
                  bgColor: Colors.green,
                  onTap: () {
                    print("Bike Clicked");
                  },
                ),
                VehicleCard(
                  title: "Truck",
                  subTitle: "Heavy Duty",
                  imagePath: "assets/images/truck.png",
                  bgColor: Colors.orange,
                  onTap: () {
                    print("Truck Clicked");
                  },
                ),
                VehicleCard(
                  title: "Bus",
                  subTitle: "40 Seater",
                  imagePath: "assets/images/bus.png",
                  bgColor: Colors.red,
                  onTap: () {
                    print("Bus Clicked");
                  },
                ),
              ],
            ),
          ),
    
    );
  }
}
