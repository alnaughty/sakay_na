import 'package:flutter/material.dart';

Widget get loadingWidget => Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.black.withOpacity(.4),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
