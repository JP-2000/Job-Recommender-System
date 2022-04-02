import 'package:job_recommender_system/model/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Network {
  static int? uid;
  static Future<List<User>> getRequest() async {
    //replace your restFull API here.
    Uri url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
    final response = await http.get(url);

    var responseData = json.decode(response.body);

    //Creating a list to store input data;
    List<User> users = [];
    for (var singleUser in responseData) {
      User user = User(
          id: singleUser["id"],
          name: singleUser["name"],
          pass: singleUser["pass"],
          fname: singleUser["fname"],
          email: singleUser["email"]);

      //Adding user to the list.
      users.add(user);
    }
    return users;
  }

  static Future<String> checkUser(Map userCred) async {
    Uri url = Uri.parse("http://192.168.0.106:5000/login");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(userCred));
    String val = response.body;
    if (val != "False") {
      Network.uid = int.parse(val);
    }
    return val;
  }


  static Future<bool> signUpUser(Map userCred) async {
    Uri url = Uri.parse("http://192.168.0.106:5000/signup");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(userCred));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List> getCustomRecommendations(String? jobId) async {
    List recommendations = [];
    Uri url = Uri.parse("http://192.168.0.106:5000/getCustomRecommendations");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user": {
            "Exp": "0",
            "Location": "Mumbai",
            "Skills": ",Python, Java, Linux, HTML, CSS"
          },
          "jobId": jobId
        }));

    String val = response.body;
    Map valueMap = json.decode(val);
    valueMap.forEach((k, v) => recommendations.add(v));
    return recommendations;
  }

  static Future<List> getRecommendations() async {
    List recommendations = [];
    Uri url = Uri.parse("http://192.168.0.106:5000/getrecommendations");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user": {
            "Exp": "0",
            "Location": "Mumbai",
            "Skills": ",Python, Java, Linux, HTML, CSS"
          },
          "userid": "1"
        }));

    String val = response.body;
    Map valueMap = json.decode(val);
    valueMap.forEach((k, v) => recommendations.add(v));
    return recommendations;
  }

  static Future<bool> checkProfile() async {
    Uri url = Uri.parse(
        "http://192.168.0.106:5000/chkprofile?uid=" + Network.uid.toString());
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      if (response.body == "True") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> createProfile(Map profile) async {
    Uri url = Uri.parse("http://192.168.0.106:5000/profile");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(profile));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
