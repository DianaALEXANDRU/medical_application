import 'package:flutter/material.dart';

class AnalyticInfoCard extends StatelessWidget {
  const AnalyticInfoCard({
    Key? key,
    required this.info,
    required this.infoImage,
    required this.infoColor,
    required this.infoValue,
  }) : super(key: key);

  final String info;
  final String infoImage;
  final Color infoColor;
  final int infoValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0 / 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                infoValue.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0 / 2),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.blue!.withOpacity(0.1),
                    shape: BoxShape.circle),
                child: Image.asset(
                  infoImage,
                  height: 20,
                  width: 20,
                ),
              )
            ],
          ),
          Text(
            info,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
