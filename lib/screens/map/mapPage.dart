import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../AI_pages/cond_search_result_page.dart';
import '../../address/address_bloc.dart';
import '../../address/address_event.dart';
import '../../address/address_model.dart';
import '../../address/address_state.dart';
import '../../FirestoreData/user_Info.dart';
import '../../FirestoreData/JobProvider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  final UserInfo userInfo;
  const MapScreen({super.key, required this.userInfo});

  //지역 필터링
  Future<void> placefilterJobs(BuildContext context, AddressDepthState state) async {
    // 선택한 주소 값 불러오기
    final majorAdd = state.address?.major.current?.name ?? "주요 주소 없음";
    final middleAdd = state.address?.middle.current?.name ?? "중간 주소 없음";
    final minorAdd = state.address?.minor.current?.name ?? "하위 주소 없음";
    // 결과출력-테스트용
    print('test : Major - $majorAdd, Middle-$middleAdd, Minor-$minorAdd');

    // JobsProvider에서 데이터를 가져옴
    final jobsProvider = Provider.of<JobsProvider>(context, listen: false);

    try {
      // JobsProvider에서 이미 가져온 jobs 데이터를 활용
      final jobDocuments = jobsProvider.jobs;

      // 공고 필터링
      final filteredJobs = jobDocuments.where((job) {
        final address = job['address'] as String;

        final GuMatch = middleAdd.isEmpty || address.contains(middleAdd);
        final DongMatch = minorAdd.isEmpty || address.contains(minorAdd);

        return GuMatch || DongMatch;
      }).toList();

      print('Filtered jobs count: ${filteredJobs.length}');
      if (filteredJobs.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CondSearchResultPage(userInfo: userInfo, jobs: filteredJobs),
          ),
        );
      } else {
        print('매칭된 공고 페이지가 없습니다');
        _showNoJobsDialog(context);
      }
    } catch (error) {
      print("Failed to update interest place: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update interest place: $error")),
      );
    }
  }

  // 조건에 맞는 공고 없을 시 팝업
  void _showNoJobsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('조건에 맞는 공고가 없습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<AddressDepthBloc>(
      create: (_) => AddressDepthBloc(),
      child: BlocConsumer<AddressDepthBloc, AddressDepthState>(
        listener: (context, state) {
          if (state is AddressDepthErrorState) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is AddressDepthInitState) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Color(0xff1044FC),
                ),
              ),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: GoogleFonts.notoSansKrTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            home: SafeArea(
              top: true,
              left: false,
              bottom: true,
              right: false,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('지역 검색'),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    color: Colors.grey,
                  ),
                ),
                body: ListView(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: const Text(
                                  "채용 공고를 검색할 지역을 선택하세요",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              if (state.address!.major.current != null) ...[
                                GestureDetector(
                                  onTap: () => context
                                      .read<AddressDepthBloc>()
                                      .add(AddressDepthResetEvent(type: 0)),
                                  child: SizedBox(
                                    width: width / 3,
                                    child: Center(
                                      child: Text(
                                        state.address!.major.current!.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                SizedBox(
                                  width: width / 3,
                                  child: const Center(
                                    child: Text(
                                      "시/도",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              const Icon(Icons.keyboard_arrow_right),
                              if (state.address!.middle.current != null) ...[
                                GestureDetector(
                                  onTap: () => context
                                      .read<AddressDepthBloc>()
                                      .add(AddressDepthResetEvent(type: 0)),
                                  child: SizedBox(
                                    width: width / 3 - 30,
                                    child: Center(
                                      child: Text(
                                        state.address!.middle.current!.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                SizedBox(
                                  width: width / 3 - 30,
                                  child: const Center(
                                    child: Text(
                                      "시/구/군",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              const Icon(Icons.keyboard_arrow_right),
                              if (state.address!.minor.current != null) ...[
                                SizedBox(
                                  width: width / 3 - 30,
                                  child: Center(
                                    child: Text(
                                      state.address!.minor.current!.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                )
                              ] else ...[
                                SizedBox(
                                  width: width / 3 - 30,
                                  child: const Center(
                                    child: Text(
                                      "동",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  placefilterJobs(context, state);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  height: 30,
                                  width: 80,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff1044FC),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "검색하기",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 260,
                      child: Row(
                        children: [
                          _listView(
                            width: width / 3,
                            color: Colors.white,
                            selecteColor: Colors.grey,
                            onTap: (i) => context.read<AddressDepthBloc>().add(
                              AddressDepthMiddleEvent(
                                  selected: state.address!.major.address[i]),
                            ),
                            address: state.address!.major.address,
                            selected: state.address!.major.current,
                          ),
                          if (state is AddressDepthMiddleState ||
                              state is AddressDepthMinorState) ...[
                            _listView(
                              width: width / 3,
                              color: Colors.white,
                              selecteColor: Colors.grey,
                              onTap: (i) => context.read<AddressDepthBloc>().add(
                                AddressDepthMinorEvent(
                                    selected:
                                    state.address!.middle.address[i]),
                              ),
                              address: state.address!.middle.address,
                              selected: state.address!.middle.current,
                            )
                          ],
                          if (state is AddressDepthMinorState) ...[
                            _listView(
                              width: width / 3,
                              color: Colors.white,
                              selecteColor: Colors.grey,
                              onTap: (i) => context.read<AddressDepthBloc>().add(
                                AddressDepthFinishEvent(
                                    selected:
                                    state.address!.minor.address[i]),
                              ),
                              address: state.address!.minor.address,
                              selected: state.address!.minor.current,
                            )
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _listView({
    required double width,
    required Function(int) onTap,
    required List<AddressDepthServerModel> address,
    required Color color,
    required Color selecteColor,
    required AddressDepthServerModel? selected,
  }) {
    return Container(
      color: color,
      width: width,
      child: ListView.builder(
        itemCount: address.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              color: selected == null
                  ? Colors.transparent
                  : selected == address[index]
                  ? selecteColor
                  : color,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      address[index].name,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
