import 'package:camera/camera.dart';
import 'package:connect_x_app/constants/components/snackbar_widget.dart';
import 'package:connect_x_app/constants/variables/shared.dart';
import 'package:connect_x_app/data/dio_helper.dart';
import 'package:connect_x_app/screens/attendance.dart';
import 'package:connect_x_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  List<Widget> screens = [];
  int currentIndex = 0;
  late CameraController _controller;

  @override
  void initState() {
    screens = [HomeScreen(), AttendanceScreen()];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 75,
        width: 75,
        child: FloatingActionButton(
          foregroundColor: Colors.transparent,
          backgroundColor: darkColor,
         onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    final image = await _controller.takePicture();
                    final capturedImagePath = image.path;
                    await GallerySaver.saveImage(image.path,
                        albumName: 'Flutter');
                    pickImage(context);
                    //uploadImage(capturedImagePath, context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBarWidget.create('Saved successfully', true, 20),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBarWidget.create(
                          'Failed to save, try again', false, 20),
                    );
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
          tooltip: 'Capture',
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: darkColor,
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            backgroundColor: darkColor,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.white,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items:  const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),label: 'Attendance'),
            ],
          )),
      body: IndexedStack(
        children: screens,
        index: currentIndex,
      ),
    );
  }
}