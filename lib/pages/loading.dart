import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flip_card/flip_card.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool loadStatus = true; //flipping logo animation on
  bool dataStatus = false; //if all data loaded
  bool connection = false; //if connected to the internet / database was established, then true

  void checkUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username= prefs.getString('username');
    final int? bestMoves= prefs.getInt('bestMoves');
    final int? totalPairs= prefs.getInt('totalPairs');
    final int? bestTime= prefs.getInt('bestsime');

    Offset o1 = Offset.zero;
    Offset o2 = const Offset(1.0,0.0);
    dataStatus = true; //local user loaded

    //animation loop
    while(loadStatus){
      await Future.delayed(const Duration(seconds: 1), (){
        cardKey.currentState?.toggleCard();
      });

      if(dataStatus){
        Future.delayed(const Duration(seconds: 1), (){
          loadStatus = false;
        });
      }
    }

    if(username != null){
      debugPrint('Detected: $username');
      o1 = const Offset(-1.0,0.0);
      o2 = Offset.zero;
    } else {
      debugPrint('No User:{ $username }');
    }

    if (!context.mounted) return;
    debugPrint("done loading");

    Navigator.pushReplacementNamed(context, './screen', 
      arguments: {
        'loginOffset': o1,
        'menuOffset': o2,
        'cardRow': 4,
        'cardCol': 4,
        'username': username,
        'bestMoves': bestMoves?? 0,
        'totalPairs': totalPairs?? 0,
        'bestTime': bestTime?? 0,
        'connection': connection,
        'reload': false,
    });
  }

  @override
  
  void initState(){
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20,20,20,0.5),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(50),
        child: FlipCard(
          key: cardKey,
          direction: FlipDirection.HORIZONTAL,
          side: CardSide.FRONT,
          front: const Image(
              image: AssetImage('assets/images/logo.png'),
              height: 70,
            ),
          back: const Image(
            image: AssetImage('assets/images/logo.png'),
            height: 70,
          ),
        ),
      ),
    );
  }
}