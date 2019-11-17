class Venue {
  String id;
  String name;
  String description;
  List<String> photos = new List();
  List<String> comments = new List();
  String commentsBis;
  String latitude;
  String longitude;
  String city;
  String region;
  String country;
  String cat;

  Venue(String id, String name){
    this.id= id;
    this.name= name;
  }

  Venue.toString(){
    print("id : "+this.id + ", name : "+this.name);
  }

  setDescription(String desc){
    this.description = desc;
  }
  setComments(List<String> comm){
    this.comments = comm;
  }
  setPhotos(List<String> ph){
    this.photos = ph;
  }
  setLatitude(String lat){
    this.latitude = lat;
  }
  setLongitude(String long){
    this.longitude = long;
  }

}

class Reponses {
  final List<Venue> venues;

  Reponses({this.venues});

  factory Reponses.fromJson(Map<String, dynamic> json) {
    List<Venue> tes = new List<Venue>();
    for (var items in json["response"]["venues"]) {
      Venue venue = new Venue(items["id"], items["name"]);
      tes.add(venue);

    }
    return Reponses(venues: tes);
  }
}

class VenueDetails {
  Venue venue;

  VenueDetails({this.venue});

  factory VenueDetails.fromJson(Map<String, dynamic> json) {
    Venue itemR = new Venue(json["response"]["venue"]["id"], json["response"]["venue"]["name"]);
    itemR.setLatitude(json["response"]["venue"]["location"]["lat"].toString());
    itemR.setLongitude(json["response"]["venue"]["location"]["lng"].toString());
    if(json["response"]["venue"]["description"] != null){
      itemR.setDescription(json["response"]["venue"]["description"]);
    }else{
      itemR.description = null;
    }
    if(json["response"]["venue"]["tips"]["groups"][0]["items"].toString().length > 2){
      itemR.commentsBis = (json["response"]["venue"]["tips"]["groups"][0]["items"][0]["text"]);
    } else {
      itemR.commentsBis = null;
    }
    if(json["response"]["venue"]["bestPhoto"] != null){
      itemR.photos.add(
          json["response"]["venue"]["bestPhoto"]["prefix"]+
              json["response"]["venue"]["bestPhoto"]["width"].toString()+
              "x"+
              json["response"]["venue"]["bestPhoto"]["height"].toString()+
              json["response"]["venue"]["bestPhoto"]["suffix"]

      );
    }else{
      itemR.photos.add(
          "https://www.prendsmaplace.fr/wp-content/themes/prendsmaplace/images/defaut_image.gif"
      );
    }
    if(json["response"]["venue"]["categories"].toString().length > 2) {
      itemR.cat = json["response"]["venue"]["categories"][0]["name"];
    }else{
      itemR.cat = null;
    }

    return VenueDetails(venue: itemR);
  }
}