import '../utils/shared_import.dart';

class CircularButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final Icon? icon;
  final String? image;
  final Function? onClick;

  CircularButton(
      {this.color,
      this.width,
      this.height,
      this.icon,
      this.image,
      this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: image != null
          ? InkWell(
              onTap: () {
                onClick?.call();
              },
              borderRadius: BorderRadius.circular(width! / 2),
              child: Center(
                child: Image.asset(
                  image ?? '',
                  width: 26,
                  height: 26,
                  color: Colors.white,
                  fit: BoxFit.contain,
                ),
              ),
            )
          : IconButton(
              icon: icon!,
              enableFeedback: true,
              onPressed: () {
                onClick?.call();
              },
            ),
    );
  }
}
