import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage('lib/assets/images/taixuanbridge.jpg'),
              opacity: AlwaysStoppedAnimation(0.5),
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'GUIDES FOR',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white70,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: Image(
                    image: AssetImage('lib/assets/images/logo2.png'),
                  ),
                ),
                Text(
                  'Powered by Nguyen Nhan and Anh Khoa Dang',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
