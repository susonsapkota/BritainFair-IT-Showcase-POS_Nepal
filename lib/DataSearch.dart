import 'package:flutter/material.dart';

String selStr;

class DataSearch extends SearchDelegate<String> {
  final spots = [
    "3 no.Cargo",
    "Babarmahal",
    "Balaju",
    "Balkhu",
    "Balkumari",
    "Baluwatar",
    "Banasthali",
    "Banepa",
    "Bansbari",
    "Basundhara",
    "Bhat-Bhateni",
    "Bouddha",
    "Budhanilkantha",
    "Chabahil",
    "Chappal Karkhana",
    "Dakshinkali",
    "Dhobighat",
    "Dhulikhel",
    "Dhumbarahi",
    "Dhungedhara",
    "Ekantakuna",
    "Gairi-Gaun",
    "Gaushala",
    "Gongabu",
    "Gopi Krishna",
    "Gopi Krishna Bridge",
    "Gwarko",
    "Halchowk",
    "Jai-Nepal",
    "Jamal",
    "Jorpati",
    "Kalanki",
    "Kalimati",
    "Kamalpokhari",
    "Khasi Bajar",
    "Koteswor",
    "Lagankhel",
    "Lazimpat",
    "Machapokhari",
    "Machhe Gaun",
    "Mahalaxmisthan",
    "MaharajGunj",
    "Maitighar",
    "Makalu Petrol Pump",
    "Mitrapark",
    "Narayangopal Chowk",
    "Narayanthan",
    "Naxal",
    "Naya Bato",
    "New  Buspark",
    "New Baneswor",
    "New Buspark",
    "New Buspark gate",
    "Old Baneswor",
    "Old Buspark",
    "Panipokhari",
    "Putalisadak",
    "RNAC",
    "Sahid Gate",
    "Samakhusi",
    "Sanepa Chowk",
    "Sano Bharyang",
    "Satdobato",
    "Sinamangal",
    "Sitapaila",
    "Soltimod",
    "Sukedhara",
    "Sundarijal",
    "Swayambhu",
    "Teaching",
    "Thulo Bharyang",
    "Tilganga",
    "Tinkune",
    "Tripureswor",
    "TU-Gate",
    "Yatayat office"
  ];

  final recentSpots = [
    "Get Current Location 📍",
    "Kamalpokhari",
    "Maharajgunj",
    "Sukedhara",
    "Kalanki"
  ];

  String getString() {
    return selStr;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query != null) {
      return Text(query);
    } else {
      return null;
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? recentSpots
        : spots
            .where((p) => p.toUpperCase().startsWith(query.toUpperCase()))
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          query = suggestionsList[index];
          showResults(context);
          selStr = query;
          Navigator.of(context).pop();
        },
        leading: Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
              text: suggestionsList[index].substring(0, query.length),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                    text: suggestionsList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ]),
        ),
      ),
      itemCount: suggestionsList.length,
    );
  }
}
