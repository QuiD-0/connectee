import 'package:flutter/material.dart';

class RecCardContent extends StatelessWidget {
  final data;
  const RecCardContent({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('${data.id} tapped');
      },
      child: Container(
        width: 331,
        height: 155,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '더미데이터더미데이터더미데이터더미데이터더미데이터더미데이터더미데이더미데이터더미데이터더미데이터더미데이더미데이터더미데이터더미데이터더미데이더미데이더미데이터더미데이터더미데이터더미데이더미데이터더미데이터더미데이터더미데이더미데이터더미데이터더미데이터더미데이',
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
          softWrap: false,
          style: TextStyle(color: Colors.black, height: 1.8, fontSize: 13),
        ),
      ),
    );
  }
}
