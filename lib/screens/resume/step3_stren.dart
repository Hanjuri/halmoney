import 'package:flutter/material.dart';
import 'package:halmoney/screens/resume/step4_career.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:halmoney/screens/resume/user_prompt_factor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StepStrenPage extends StatefulWidget {
  final UserInfo userInfo;
  final UserPromptFactor userPromptFactor;

  StepStrenPage({
    super.key,
    required this.userInfo,
    required this.userPromptFactor,
  });

  @override
  State<StepStrenPage> createState() => _StepStrenPageState();
}

class _StepStrenPageState extends State<StepStrenPage> {
  List<String> selectedAbilities = [];
  List<String> abilities = [];

  @override
  void initState(){
    super.initState();
    _fetchCoverLetterAndExtractAbilities();
  }

  //Firebase에서 역량 키워드 가져오기
  Future<void> _fetchCoverLetterAndExtractAbilities() async {
    try {
      // selectedFields 리스트에서 직무 카테고리 가져오기
      // 첫 번째 선택된 필드를 직무 카테고리로 사용한다고 가정
      if (widget.userPromptFactor.selectedFields.isEmpty) {
        print('직무 카테고리가 선택되지 않았습니다.');
        return;
      }

      String jobCategory = widget.userPromptFactor.selectedFields[0]; // 첫 번째 선택된 항목이 직무 카테고리라고 가정

      // Firebase에서 직무에 맞는 역량 키워드 가져오기
      final jobDoc = await FirebaseFirestore.instance
          .collection('coverLetter')
          .doc(jobCategory)
          .get();

      // jobDoc에서 'Ability' 필드가 있는지 확인
      if (jobDoc.exists && jobDoc.data()!.containsKey('Ability')) {
        List<dynamic> abilitiesArray = jobDoc.data()!['Ability'];

        // 배열을 문자열 리스트로 변환 [실시간]
        setState(() {
          abilities = abilitiesArray.cast<String>().toList(); // 상태에 저장
        });

        print('Abilities: $abilities');
      } else {
        print('Ability 필드가 존재하지 않습니다.');
      }

    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void updateSelecdtedAbilities(List<String> abilities){
    setState(() {
      selectedAbilities = abilities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 51, 51, 255),
        elevation: 1.0,
        leading: null,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Row(
                children: [
                  //SizedBox(width: 5),
                  Icon(
                    Icons.chevron_left,
                    size: 30,
                  ),
                  Text('이전',
                      style: TextStyle(
                        fontFamily: 'NanumGothicFamily',
                        fontSize: 20.0,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  '2 / 5',
                  style: TextStyle(
                    fontFamily: 'NanumGothicFamily',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                )),
            GestureDetector(
              onTap: () {
                widget.userPromptFactor.editSelectedStrens(selectedAbilities);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StepCareerPage(
                        userInfo: widget.userInfo,
                        userPromptFactor: widget.userPromptFactor,
                      )),
                );
              },
              child: const Row(
                children: [
                  Text('다음',
                      style: TextStyle(
                        fontFamily: 'NanumGothicFamily',
                        fontSize: 20.0,
                        color: Colors.white,
                      )),
                  Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                '자신의 장점은 무엇이라고 생각하나요?',
                style: TextStyle(
                  fontFamily: 'NanumGothicFamily',
                  fontWeight: FontWeight.w500,
                  fontSize: 28.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              AbilitiesChooseWidget(
                  abilities: abilities,
                  selectedAbilities: selectedAbilities,
                  onSelectedAbilitiesChanged: updateSelecdtedAbilities,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AbilitiesChooseWidget extends StatefulWidget {
  final List<String> abilities;
  final List<String> selectedAbilities;
  final ValueChanged<List<String>> onSelectedAbilitiesChanged;

  const AbilitiesChooseWidget({
    super.key,
    required this.abilities,
    required this.selectedAbilities,
    required this.onSelectedAbilitiesChanged,
  });

  @override
  State<AbilitiesChooseWidget> createState() => _AbilitiesChooseWidgetState();
}

class _AbilitiesChooseWidgetState extends State<AbilitiesChooseWidget>{
  TextEditingController _searchTextEditingController = TextEditingController();

  String get _searchText => _searchTextEditingController.text.trim();

  @override
  void initState(){
    super.initState();
    _searchTextEditingController.addListener((){
      setState(() {});
    });
  }

  @override
  void dispose(){
    _searchTextEditingController.dispose();
    super.dispose();
  }

  List<String> _filterAbilities() {
    if (_searchText.isEmpty) return widget.abilities;

    return widget.abilities
        .where(
            (ability) => ability.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  void _addNewTage(String tag){
    setState(() {
      widget.abilities.add(tag);
      widget.selectedAbilities.add(tag);
    });
    widget.onSelectedAbilitiesChanged(widget.selectedAbilities);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSelectedTags(),
        const SizedBox(height: 20),
        _buildSearchField(),
        const SizedBox(height: 20),
        SizedBox(
          height: 500,
          child: _buildTags(),
        ),
      ],
    );
  }

  Widget _buildSelectedTags() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.selectedAbilities.map((field) {
        return Chip(
          label: Text(
            field,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: Color.fromARGB(250, 51, 51, 255),
          deleteIcon: Icon(Icons.close, color: Colors.white),
          onDeleted: () {
            setState(() {
              widget.selectedAbilities.remove(field);
            });
            widget.onSelectedAbilitiesChanged(widget.selectedAbilities);
          },
        );
      }).toList(),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchTextEditingController,
              decoration: const InputDecoration.collapsed(
                hintText: '역량을 검색하거나 선택하세요',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
              ),
            ),
          ),
          if (_searchText.isNotEmpty)
            GestureDetector(
              onTap: () {
                if (!widget.selectedAbilities.contains(_searchText)) {
                  _addNewTage(_searchText);
                  _searchTextEditingController.clear();
                }
              },
              child: Icon(Icons.add, color: Colors.grey.shade600),
            )
          else
            Icon(Icons.search, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: _filterAbilities().map((field) {
          final isSelected = widget.selectedAbilities.contains(field);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  widget.selectedAbilities.remove(field);
                } else {
                  widget.selectedAbilities.add(field);
                }
              });
              widget.onSelectedAbilitiesChanged(widget.selectedAbilities);
            },
            child: Chip(
              label: Text(
                field,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              backgroundColor: Colors.grey.shade300,
            ),
          );
        }).toList(),
      ),
    );
  }
}
