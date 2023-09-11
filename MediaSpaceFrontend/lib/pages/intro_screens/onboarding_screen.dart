import 'package:flutter/material.dart';

import '../space_form/multi_step_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Stack(
        children: [

          PageView(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              buildPage(
                'Partager des informations sur ton endroit',
                'Decrit ton endroit avec des informations utils genre combien des gens il peut acceuilire adresse et l’espace est il grand ou pas',
                'assets/images/intro1.PNG',
              ),
              buildPage(
                'Lister les offres et enrichire l’endroit avec des images',
                'Dans deuxieme partie vous pouvez mentioner les equipements qui rendre votre endroit speciale et de quelle type d’evenement vous pouvez acceuillire',
                'assets/images/intro2.PNG',
              ),
              buildPage(
                'Finaliser et publier votre endroit',
                'C’est la derniere etape lister les evenements que vous souhaites acceuire avec les prix par heure du l’endroit',
                'assets/images/intro3.PNG',
              ),
            ],
          ),

          Positioned(
            bottom: 20,
            left: 20,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MultiStepForm(),
                ));
              },
              child: Text('Skip',style: TextStyle(color: Colors.white)),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: _currentIndex == 2  // Last page
                ? TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MultiStepForm(),
                ));
              },
              child: Text('Done',style: TextStyle(color: Colors.white)),
            )
                : TextButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: Text('Next',style: TextStyle(color: Colors.white),),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                3,
                    (int index) => buildDot(index == _currentIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(String title, String description, String assetPath) {
    return Stack(
      children: [
        // Your image here
        Image.asset(assetPath, height: 500, width: 500),

        // Blue background container
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 340,
            decoration: BoxDecoration(
              color: Color(0xFF5669FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(55),
                topRight: Radius.circular(55),
              ),
            ),
          ),
        ),

        // Your title and description here
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }




  Widget buildDot(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.grey,
      ),
    );
  }

}

class _ProgressPageState {
}
