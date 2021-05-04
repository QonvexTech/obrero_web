import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LogsLoader {
  static ListView load() {
    return ListView(
      children: List.generate(20, (index) => Shimmer(
        color: Colors.grey.shade100,
        direction: ShimmerDirection.fromLTRB(),
        enabled: true,
        interval: Duration(
          milliseconds: 900
        ),
        duration: Duration(
          seconds: 2
        ),
        child: Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.notification_important_rounded,color: Colors.grey,),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ListTile(
                    title: Container(
                      width: double.infinity,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300
                      ),
                    ),
                    subtitle: Container(
                      width: double.infinity,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade300
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ),
      )
      ),
    );
  }
}