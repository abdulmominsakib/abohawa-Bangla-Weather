import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/search_provider.dart';
import 'components/no_city_available.dart';
import 'components/search_box.dart';
import 'components/search_button.dart';
import 'components/search_result_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController inputController = TextEditingController();
  String counterTextUpdator = '';
  Color inputBorder = Colors.white;
  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SearchBox(
              controller: inputController,
              counterTextUpdator: counterTextUpdator,
              inputBorder: inputBorder,
            ),
            SizedBox(height: 10),
            SearchButton(
              onTap: () {
                if (inputController.text.isNotEmpty) {
                  ref
                      .read(searchProvider.notifier)
                      .searchWeather(inputController.text);
                  setState(() {
                    counterTextUpdator = '';
                    inputBorder = Colors.white;
                  });
                } else {
                  setState(() {
                    inputBorder = Colors.redAccent;
                    counterTextUpdator = 'একটা শহরের নাম লিখুন';
                  });
                }
              },
            ),
            SizedBox(height: 30),
            if (searchState.isLoading)
              CircularProgressIndicator()
            else if (searchState.noCityAvailable)
              NoCityAvailable()
            else if (searchState.searchedCity != null)
              SearchResultCard(city: searchState.searchedCity!),
          ],
        ),
      ),
    );
  }
}
