import 'package:flutter/material.dart';
import 'package:halmoney/screens/resume/step3_stren.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:halmoney/screens/resume/user_prompt_factor.dart';

class StepFieldPage extends StatefulWidget {
  final UserInfo userInfo;
  final UserPromptFactor userPromptFactor;

  StepFieldPage({
    super.key,
    required this.userInfo,
    required this.userPromptFactor,
  });

  @override
  State<StepFieldPage> createState() => _StepFieldPageState();
}

class _StepFieldPageState extends State<StepFieldPage> {
  late List<String> selectedFields;

  @override
  void initState() {
    super.initState();
    selectedFields = widget.userPromptFactor.getSelctedFields();
  }

  void updateSelectedFields(List<String> fields) {
    setState(() {
      selectedFields = fields;
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
                  '1 / 5',
                  style: TextStyle(
                    fontFamily: 'NanumGothicFamily',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                )),
            GestureDetector(
              onTap: () {
                widget.userPromptFactor.editSelectedFields(selectedFields);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepStrenPage(
                        userInfo: widget.userInfo,
                        userPromptFactor: widget.userPromptFactor,
                      ),
                    ));
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
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text('어떤 일을 하고 싶은가요?',
                        style: TextStyle(
                          fontFamily: 'NanumGothicFamily',
                          fontWeight: FontWeight.w500,
                          fontSize: 28.0,
                          color: Colors.black,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text('하고싶은 일을 검색하거나 직접 입력하세요',
                        style: TextStyle(
                          fontFamily: 'NanumGothicFamily',
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0,
                          color: Colors.black,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              FieldChooseWidget(
                selectedFields: selectedFields,
                onSelectedFieldsChanged: updateSelectedFields,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FieldChooseWidget extends StatefulWidget {
  final List<String> selectedFields;
  final ValueChanged<List<String>> onSelectedFieldsChanged;

  const FieldChooseWidget({
    super.key,
    required this.selectedFields,
    required this.onSelectedFieldsChanged,
  });

  @override
  State<FieldChooseWidget> createState() => _FieldChooseWidgetState();
}

class _FieldChooseWidgetState extends State<FieldChooseWidget> {
  List<String> fields = [
    '개발·데이터',
    '건축·시설',
    '고객상담·TM',
    '고객서비스·리테일',
    '공공·복지',
    '교육',
    '금융·보험',
    '기획·전략',
    '디자인',
    '마케팅·광고·MD',
    '물류·무역',
    '미디어·문화·스포츠',
    '법무·사무·총무',
    '식음료',
    '엔지니어링·설계',
    '영업',
    '운전·운송·배송',
    '의료·바이오',
    '인사·HR',
    '제조·생산',
    '회계·세무'
  ];

  TextEditingController _searchTextEditingController = TextEditingController();

  String get _searchText => _searchTextEditingController.text.trim();

  @override
  void initState() {
    super.initState();
    _searchTextEditingController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    super.dispose();
  }

  List<String> _filterFields() {
    if (_searchText.isEmpty) return fields;

    return fields
        .where(
            (field) => field.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  void _addNewTag(String tag) {
    setState(() {
      fields.add(tag);
      widget.selectedFields.add(tag);
    });
    widget.onSelectedFieldsChanged(widget.selectedFields);
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
      children: widget.selectedFields.map((field) {
        return Chip(
          label: Text(
            field,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: Color.fromARGB(250, 51, 51, 255),
          deleteIcon: Icon(Icons.close, color: Colors.white),
          onDeleted: () {
            setState(() {
              widget.selectedFields.remove(field);
            });
            widget.onSelectedFieldsChanged(widget.selectedFields);
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
                hintText: '직무를 검색하거나 추가하세요',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
              ),
            ),
          ),
          if (_searchText.isNotEmpty)
            GestureDetector(
              onTap: () {
                if (!widget.selectedFields.contains(_searchText)) {
                  _addNewTag(_searchText);
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
          children: _filterFields().map((field) {
            final isSelected = widget.selectedFields.contains(field);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    widget.selectedFields.remove(field);
                  } else {
                    widget.selectedFields.add(field);
                  }
                });
                widget.onSelectedFieldsChanged(widget.selectedFields);
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
