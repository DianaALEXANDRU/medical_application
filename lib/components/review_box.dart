import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/models/review.dart';

class ReviewWidget extends StatefulWidget {
  final Review review;

  const ReviewWidget({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: SizedBox(
        height: 180,
        width: 300,
        child: Container(
          margin: const EdgeInsets.only(left: 24, top: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person_pin_rounded,
                    color: Colors.black26,
                  ),
                  const Text(
                    ' Verified patient    ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      Text(
                        '${widget.review.stars}.0',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Date:  ${DateFormat("dd/MM/yyyy  HH:mm").format(widget.review.dateAndTime)}',
                style: const TextStyle(
                  color: Color(0xffababab),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Flexible(
                child: Text(
                  widget.review.comment,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    //fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
