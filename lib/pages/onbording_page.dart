import 'package:canbea_flutter/pages/home_page.dart';
import 'package:canbea_flutter/service/database_service.dart';
import 'package:canbea_flutter/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OnbordingPage extends StatefulWidget {
  const OnbordingPage({super.key});

  @override
  State<OnbordingPage> createState() => _OnbordingPageState();
}

class _OnbordingPageState extends State<OnbordingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin:
            const EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/logo.png"),
            Text(
              "Choose Your Avatar",
              style: TextStyle(
                color: Colors.yellow[700],
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateAvatar(
                            "https://1mphoto.com/wp-content/uploads/2023/09/kakashi-wallpaper-pc.jpg");
                    nextScreenRemoveBack(context, const HomePage());
                  },
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(
                        "https://1mphoto.com/wp-content/uploads/2023/09/kakashi-wallpaper-pc.jpg"),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateAvatar(
                            "https://wallpapercave.com/wp/wp13660875.jpg");
                    nextScreenRemoveBack(context, const HomePage());
                  },
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(
                        "https://wallpapercave.com/wp/wp13660875.jpg"),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateAvatar(
                            "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/8f674d57-69f2-4754-9dd5-152b5bcd77f1/dh05p2j-76b386ca-eb57-4aa8-8dfb-e0a51b042cf0.jpg/v1/fill/w_400,h_500,q_75,strp/levi_ackerman_wallpaper_by_otaku_zonee_dh05p2j-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzhmNjc0ZDU3LTY5ZjItNDc1NC05ZGQ1LTE1MmI1YmNkNzdmMVwvZGgwNXAyai03NmIzODZjYS1lYjU3LTRhYTgtOGRmYi1lMGE1MWIwNDJjZjAuanBnIiwiaGVpZ2h0IjoiPD01MDAiLCJ3aWR0aCI6Ijw9NDAwIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLndhdGVybWFyayJdLCJ3bWsiOnsicGF0aCI6Ilwvd21cLzhmNjc0ZDU3LTY5ZjItNDc1NC05ZGQ1LTE1MmI1YmNkNzdmMVwvb3Rha3Utem9uZWUtNC5wbmciLCJvcGFjaXR5Ijo5NSwicHJvcG9ydGlvbnMiOjAuNDUsImdyYXZpdHkiOiJjZW50ZXIifX0.X9lG71hVkIOO0Geo1wrtnglyJWs7BGBZHUfHDoUBCvI");
                    nextScreenRemoveBack(context, const HomePage());
                  },
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(
                        "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/8f674d57-69f2-4754-9dd5-152b5bcd77f1/dh05p2j-76b386ca-eb57-4aa8-8dfb-e0a51b042cf0.jpg/v1/fill/w_400,h_500,q_75,strp/levi_ackerman_wallpaper_by_otaku_zonee_dh05p2j-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzhmNjc0ZDU3LTY5ZjItNDc1NC05ZGQ1LTE1MmI1YmNkNzdmMVwvZGgwNXAyai03NmIzODZjYS1lYjU3LTRhYTgtOGRmYi1lMGE1MWIwNDJjZjAuanBnIiwiaGVpZ2h0IjoiPD01MDAiLCJ3aWR0aCI6Ijw9NDAwIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLndhdGVybWFyayJdLCJ3bWsiOnsicGF0aCI6Ilwvd21cLzhmNjc0ZDU3LTY5ZjItNDc1NC05ZGQ1LTE1MmI1YmNkNzdmMVwvb3Rha3Utem9uZWUtNC5wbmciLCJvcGFjaXR5Ijo5NSwicHJvcG9ydGlvbnMiOjAuNDUsImdyYXZpdHkiOiJjZW50ZXIifX0.X9lG71hVkIOO0Geo1wrtnglyJWs7BGBZHUfHDoUBCvI"),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateAvatar(
                            "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/0b56800e-c072-41cf-a37e-3106cc916c0b/dfvvd2f-0c4302d0-8c6e-4a22-8493-cdc3a9ae9917.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzBiNTY4MDBlLWMwNzItNDFjZi1hMzdlLTMxMDZjYzkxNmMwYlwvZGZ2dmQyZi0wYzQzMDJkMC04YzZlLTRhMjItODQ5My1jZGMzYTlhZTk5MTcucG5nIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.UmEQrzUpiN6whWqXb1bR0phaVYY9yoHJnwVCfegrVzw");
                    nextScreenRemoveBack(context, const HomePage());
                  },
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(
                        "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/0b56800e-c072-41cf-a37e-3106cc916c0b/dfvvd2f-0c4302d0-8c6e-4a22-8493-cdc3a9ae9917.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzBiNTY4MDBlLWMwNzItNDFjZi1hMzdlLTMxMDZjYzkxNmMwYlwvZGZ2dmQyZi0wYzQzMDJkMC04YzZlLTRhMjItODQ5My1jZGMzYTlhZTk5MTcucG5nIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.UmEQrzUpiN6whWqXb1bR0phaVYY9yoHJnwVCfegrVzw"),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateAvatar(
                            "https://i.pinimg.com/550x/36/65/8b/36658b9711dff21c933f432210ec65c3.jpg");
                    nextScreenRemoveBack(context, const HomePage());
                  },
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(
                        "https://i.pinimg.com/550x/36/65/8b/36658b9711dff21c933f432210ec65c3.jpg"),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateAvatar(
                            "https://cdn.donmai.us/original/20/06/2006d3eb461e71940063dbb0449a879e.jpg");
                    nextScreenRemoveBack(context, const HomePage());
                  },
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(
                        "https://cdn.donmai.us/original/20/06/2006d3eb461e71940063dbb0449a879e.jpg"),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50),
              child: const Text(
                "You will be redirected to homepage after choosing the Avatar",
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
