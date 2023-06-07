
import 'package:flutter/material.dart';
import 'package:infinite_scroll_example/get_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    GlobalKey<RefreshIndicatorState>();

  GetItems getItems = GetItems();
  ScrollController? scrollController;
  bool isMoreRequesting = false;        // 추가 데이터 가져올때 하단 인디케이터 표시용
  List<Widget> items = [];
  int serverItemLeng = 100;
  int nextPage = 0;                     // 다음 데이터 위치 파악.

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController!.addListener(onScroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController!.removeListener(onScroll);
    super.dispose();
  }

  onScroll() {
    // Reached the endpoint of the ListView
    if (scrollController!.offset >=
        scrollController!.position.maxScrollExtent && !scrollController!.position.outOfRange) {
      setState(() {
        isMoreRequesting = true;
      });
      // requestMore();
      requestMore().then((value) {
        setState(() {
          // 다 가져오면 하단 표시 서클 제거
          isMoreRequesting = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    requestMore();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Scroll ! '),
        centerTitle: true,
      ),

      body: Container(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: onFresh,
                child: ListView.builder(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return items[index];
                  },
                ),
              ),
            ),

            Container(
              height: isMoreRequesting ? 50.0 : 0,
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> onFresh() async {
    setState(() {
      nextPage = 0;
      items.clear();
    });
    // nextPage = 0;
    // items.clear();
    // setState(() {
    //   items += getItems.getPosts().sublist(nextPage, (nextPage * 10));
      // items += getItems.getPosts().sublist(0, (10));
      // 다음을 위해 페이지 증가
      // nextPage += 1;
    // });
    return await Future.delayed(Duration(milliseconds: 1000));
  }


  // 서버에서 추가 데이터 가져올 때
  Future<void> requestMore() async {
    int nextDataPosition = (nextPage * 10);   // 읽을 데이터 위치 얻기
    int dataLength = 20;                      // 읽을 데이터 크기

    // 읽을 데이터가 서버에 있는 데이터 총 크기보다 크다면 더이상 읽을 데이터가 없다고 판다.
    if (nextDataPosition > serverItemLeng) {
      return;
    }

    // 읽을 데이터는 있지만 20개가 안되는 경우
    if ((nextDataPosition + 20) > serverItemLeng) {
      // 가능한 최대 개수 얻기
      dataLength = serverItemLeng - nextDataPosition;
    }
    setState(() {
      // 데이터 읽기
      items += getItems.getPosts().sublist(nextDataPosition, nextDataPosition + dataLength);
      // 다음을 위해 페이지 증가
      nextPage += 2;
    });

    // 가상으로 잠시 지연 줌
    return await Future.delayed(Duration(milliseconds: 1000));
  }


}


