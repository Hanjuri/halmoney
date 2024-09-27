// 작성자 : 황제하

import 'package:flutter/material.dart';
import 'package:halmoney/get_user_info/step4_workhours.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:halmoney/myAppPage.dart';

class StepUserField extends StatefulWidget {
  final UserInfo userInfo;

  StepUserField({
    super.key,
    required this.userInfo,
  });

  @override
  State<StepUserField> createState() => _StepUserFieldState();
}

class _StepUserFieldState extends State<StepUserField> {
  List<String> selectedFields = [];

  void updateSelectedFields(List<String> fields) {
    setState(() {
      selectedFields = fields;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/img_logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  '할MONEY',
                  style: TextStyle(
                    fontFamily: 'NanumGothicFamily',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                )),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 25.0, right: 30.0, top: 25.0, bottom: 15.0),
        child: Column(
          children: [
            // 페이지 이동 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 이전 페이지로 이동
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: 30,
                      ),
                      Text('이전',
                          style: TextStyle(
                            fontFamily: 'NanumGothicFamily',
                            fontSize: 20.0,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),

                // 다음 페이지로 이동
                GestureDetector(
                  onTap: () {
                    widget.userInfo.editSelectedFields(selectedFields);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //임시 코드
                        // 우선 홈페이지로 이동
                        // 나중에 근무 가능 시간 조사 페이지로
                          builder: (context) =>StepWorkHours(userInfo: widget.userInfo)),
                    );
                  },
                  child: const Row(
                    children: [
                      Text('다음',
                          style: TextStyle(
                            fontFamily: 'NanumGothicFamily',
                            fontSize: 20.0,
                            color: Colors.black,
                          )),
                      Icon(
                        Icons.chevron_right,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 질문 텍스트 상자
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('어떤 일을 하고 싶은가요?',
                            style: TextStyle(
                              fontFamily: 'NanumGothicFamily',
                              fontWeight: FontWeight.w500,
                              fontSize: 28.0,
                              color: Colors.black,
                            )),
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
                    const SizedBox(height: 15),

                    // 직무 선택 영역
                    FieldChooseWidget(
                      selectedFields: selectedFields,
                      onSelectedFieldsChanged: updateSelectedFields,
                    ),
                  ],
                ),
              ),
            ),
          ],
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
        _buildTags(),
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
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
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
                hintText: '예시) 교육',
                hintStyle: TextStyle(color: Colors.grey),
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
              child: Icon(Icons.add, color: Colors.blue.shade600),
            )
          else
            Icon(Icons.search, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
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
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.grey.shade300,
          ),
        );
      }).toList(),
    );
  }
}
