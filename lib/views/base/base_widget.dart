import 'package:abohawa/views/home/components/home_loading.dart';

import '../../providers/connection_provider.dart';
import '../../components/no_internet_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../home/home_screen.dart';
import '../zillas/zilla_screen.dart';
import '../search/search_screen.dart';
import '../../constants/styling.dart';

class BanglaWeather extends HookConsumerWidget {
  const BanglaWeather({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);
    final connectiontStatus = ref.watch(connectionStatusProvider);
    // Use useMemoized to create screens only once
    final screens = useMemoized(() => [
          const HomeScreen(),
          const SearchScreen(),
          const SavedCity(),
        ]);

    // Use useCallback to memoize the onItemTapped function
    final onItemTapped = useCallback((int index) {
      if (index >= 0 && index < screens.length) {
        selectedIndex.value = index;
      } else {
        debugPrint('Invalid index: $index');
      }
    }, [screens]);

    // Use useFocusNode for managing focus
    final focusNode = useFocusNode();

    useEffect(() {
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      });
      return () => focusNode.dispose();
    }, [focusNode]);

    return GestureDetector(
      onTap: () => focusNode.requestFocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'হোম'),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded), label: 'সার্চ'),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_city_rounded), label: 'সব জেলা'),
          ],
          currentIndex: selectedIndex.value,
          onTap: onItemTapped,
        ),
        body: Stack(
          children: [
            if (connectiontStatus == AppConnectionStatus.loading) HomeLoading(),
            if (connectiontStatus == AppConnectionStatus.online)
              Container(
                decoration: homeBoxDecoration(),
                child: IndexedStack(
                  index: selectedIndex.value,
                  children: screens,
                ),
              ),
            if (connectiontStatus == AppConnectionStatus.offline)
              NoInternetWidget(),
          ],
        ),
      ),
    );
  }
}
