import 'package:flutter/material.dart';

class CategoryTypeButton extends StatelessWidget {
  final int? selected;
  final Function? callback;
  final List<dynamic>? category;
  const CategoryTypeButton({this.selected, this.callback, this.category, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: ListView.separated(
        scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => callback!(index),
          child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: index == 0 ? Color(0xffD9F2EA) 
                  : index == 1 ? Color(0xffFBEEDC) : index == 2 ? Color(0xffF9DFDF) : index == 3 ? Color(0xffEDF3FF) :
                  index == 4 ? Color(0xffEDF3FF) : index == 5 ? Color(0xffFFEAFC) : index == 6? Color(0xffD9F2EA) : Color(0xffF9DFDF),
                  borderRadius: BorderRadius.circular(100)),
              child: Row(
                children: [
                  Container(
                    height: 30, width: 30,
                    child: Image.asset(
                      category![index]["assets"]!,
                    ),
                  ),
                  Text(
                    category![index]["title"],
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              )),
        ),
        separatorBuilder: (_, __) => SizedBox(
          width: 10,
        ),
        itemCount: category!.length,
      ),
    );
  }
}
