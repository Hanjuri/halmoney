import 'package:flutter/material.dart';
import 'package:halmoney/signup_pages/signup_originalpage.dart';

class AgreementPage extends StatefulWidget {
  //statefulwidget : 변경 가능한 상태를 가진 위젯
  const AgreementPage({super.key});

  @override
  State<StatefulWidget> createState() => _TermsOfServiceAgreementState();
}

class _TermsOfServiceAgreementState extends State<AgreementPage>{
  List<bool> _isChecked = List.generate(4, (_) => false);
  //1,2번을 필수로 모두 체크했는지 확인
  bool get _buttonActive => _isChecked[1] && _isChecked[2];

  void _updateCheckState(int index) {
    setState(() {
      // 모두 동의 체크박스일 경우
      if (index == 0) {
        bool isAllChecked = !_isChecked.every((element) => element);
        _isChecked = List.generate(4, (index) => isAllChecked);
      } else {
        _isChecked[index] = !_isChecked[index];
        _isChecked[0] = _isChecked.getRange(1, 4).every((element) => element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Image(
              image: AssetImage('assets/images/img_logo.png'),
              width: 100,
              height: 120,
            ),
            const SizedBox(height:20),
            const Text(
                '할MONEY 서비스 제공을 위하여\n아래의 약관동의가 필요합니다.',
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 30),
            ..._renderCheckList(),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonActive ? const Color.fromARGB(250, 51, 51, 255) : Colors.grey,
                        minimumSize: const Size(300,45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupPageOne())
                      );
                    },
                    child: const Text('다음',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _renderCheckList() {
    List<String> labels = [
      '전체 동의',
      '(필수) 할MONEY 서비스 이용 약관',
      '(필수) 개인정보 수집 및 이용 동의서',
      '(선택) 위치정보 서비스 이용약관',
    ];

    List<Widget> list = [
      renderContainer(_isChecked[0], labels[0], () => _updateCheckState(0)),
      const Divider(thickness: 1.0),
    ];

    list.addAll(List.generate(3, (index) => renderContainer(_isChecked[index + 1], labels[index + 1], () => _updateCheckState(index + 1))));

    return list;
  }

  Widget renderContainer(bool checked, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        color: Colors.white,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: checked ? const Color.fromARGB(250, 51, 51, 255) : Colors.grey, width: 2.0),
                color: checked ? const Color.fromARGB(250, 51, 51, 255) : Colors.white,
              ),
              child: Icon(
                  Icons.check, color: checked ? Colors.white : Colors.grey,
                  size: 18),
            ),
            const SizedBox(width: 10), //아이콘과 텍스트 사이 거리
            Text(text,
                style: const TextStyle(color: Colors.black26, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
