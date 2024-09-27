import 'package:flutter/material.dart';
import 'package:halmoney/get_user_info/career.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:halmoney/get_user_info/step3_user_field.dart';

class StepUserCareer extends StatefulWidget {
  final UserInfo userInfo;

  StepUserCareer({
    super.key,
    required this.userInfo,
  });

  @override
  State<StepUserCareer> createState() => _StepUserCareerState();
}

class _StepUserCareerState extends State<StepUserCareer> {
  List<Career> careers = [];
  List<Map<String, TextEditingController>> userInputControllers = [];
  bool isEditing = false; // 편집 모드 여부
  int? editingIndex; // 편집 중인 경력의 인덱스
  Career? originalCareer; // 취소 시 복원할 원래 경력 정보

  //경력 추가하기
  void addCareer() {
    setState(() {
      careers.insert(0, Career());
      userInputControllers.insert(0, {
        'place': TextEditingController(),
        'duration' : TextEditingController(),
      });
      isEditing = true;
      editingIndex = 0;
    });
  }

  //경력 수정하기
  void editCareer(int index) {
    setState(() {
      isEditing = true;
      editingIndex = index;
      originalCareer = careers[index].clone();
    });
  }

  //경력 수정 완료하기
  void completeEdit() {
    setState(() {
      isEditing = false;
      editingIndex = null;
      originalCareer = null;
    });
  }

  // 경력 수정 취소하기
  void cancelEdit() {
    setState(() {
      if (editingIndex == 0 && originalCareer == null) {
        // 새로운 경력 작성 중에 취소한 경우, 해당 경력 삭제
        careers.removeAt(0);
        userInputControllers.removeAt(0);
      } else if (originalCareer != null && editingIndex != null) {
        // 기존 경력 수정 중에 취소한 경우, 원본 경력으로 복원
        careers[editingIndex!] = originalCareer!;
        userInputControllers[editingIndex!]['place']?.text = originalCareer!.workPlace;
        userInputControllers[editingIndex!]['duration']?.text = originalCareer!.workDuration;
      }
      isEditing = false;
      editingIndex = null;
      originalCareer = null;
    });
  }

  //경력 제거하기
  void removeCareer(int index) {
    setState(() {
      careers.removeAt(index);
      userInputControllers.removeAt(index);
    });
  }

  //경력 입력시 공란 여부 확인
  bool areAllFieldsFilled(int index) {
    final career = careers[index];
    return career.workDuration.isNotEmpty &&
        career.workUnit.isNotEmpty &&
        career.workPlace.isNotEmpty;
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
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: Column(
          children: [
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

                //다음 페이지로 이동
                GestureDetector(
                  onTap: () {
                    widget.userInfo.editCareers(careers);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StepUserField(userInfo: widget.userInfo)),
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
              height: 25,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('이력사항을 입력해주세요!',
                    style: TextStyle(
                      fontFamily: 'NanumGothicFamily',
                      fontWeight: FontWeight.w500,
                      fontSize: 28.0,
                      color: Colors.black,
                    )),
              ],
            ),
            const SizedBox(
              height: 25,
            ),

            GestureDetector(
              onTap: isEditing ? null : addCareer,
              child: Container(
                height: 80,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('경력 추가',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontFamily: 'NanumGothicFamily',
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 경력 표시 영역
            Expanded(
              child: ListView.builder(
                itemCount: careers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: CareerDisplay(
                      career: careers[index],
                      isEditing: isEditing && editingIndex == index,
                      onSave: areAllFieldsFilled(index)
                          ? () {
                              completeEdit();
                            }
                          : null,
                      onCancel: cancelEdit,
                      onEdit: () => editCareer(index),
                      onRemove: () => removeCareer(index),
                      onFieldChange: (String field, String value) {
                        setState(() {
                          if (field == 'duration') {
                            careers[index].workDuration = value;
                          } else if (field == 'unit') {
                            careers[index].workUnit = value;
                          } else if (field == 'place') {
                            careers[index].workPlace = value;
                          }
                        });
                      },
                      workPlaceController: userInputControllers[index]['place']!,
                      workDurationController: userInputControllers[index]['duration']!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CareerDisplay extends StatelessWidget {
  final Career career;
  final bool isEditing;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final VoidCallback onEdit;
  final VoidCallback onRemove;
  final void Function(String field, String value) onFieldChange;
  final TextEditingController workPlaceController;
  final TextEditingController workDurationController;

  const CareerDisplay({
    super.key,
    required this.career,
    required this.isEditing,
    required this.onSave,
    required this.onCancel,
    required this.onEdit,
    required this.onRemove,
    required this.onFieldChange,
    required this.workPlaceController,
    required this.workDurationController,
  });

  @override
  Widget build(BuildContext context) {
    if (career.workUnit.isEmpty) {
      career.workUnit = '년';
    }
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isEditing) ...[
            GridView.count(
              shrinkWrap: true,
              primary: false,
              crossAxisCount: 2,
              childAspectRatio: 3 / 1,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text("근무한 곳", style: TextStyle(fontSize: 20)),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    "근무한 기간",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value){
                      final newText = value;
                      final cursorPosition = workPlaceController.selection.baseOffset;

                      workPlaceController.value = workPlaceController.value.copyWith(
                        text: newText,
                        selection: TextSelection.collapsed(offset: cursorPosition),
                      );

                      onFieldChange('place', newText);
                    },
                    controller: workPlaceController,
                    decoration: const InputDecoration(
                      hintText: '(예시) 좋은기업',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              onFieldChange('duration', value),
                          controller: workDurationController,
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value:
                            career.workUnit.isNotEmpty ? career.workUnit : '년',
                        items: ['주', '개월', '년'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            onFieldChange('unit', newValue);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: onCancel, // 취소 버튼 동작
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: const Text('취소',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: onSave, // 완료 버튼 동작
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (onSave != null) {
                                return Colors.blue; // 활성화 시 파란색
                              }
                              return Colors.grey; // 비활성화 시 회색
                            },
                          ),
                        ),
                        child: const Text('완료',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ] else ...[
            GridView.count(
              shrinkWrap: true,
              primary: false,
              crossAxisCount: 2,
              childAspectRatio: 3 / 1,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text("근무한 곳", style: const TextStyle(fontSize: 20)),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text("근무한 기간", style: const TextStyle(fontSize: 20)),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    career.workPlace,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text('${career.workDuration} ${career.workUnit}',
                      style: const TextStyle(fontSize: 20)),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: onRemove,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: const Text('삭제',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: onEdit,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        child: const Text('편집',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
