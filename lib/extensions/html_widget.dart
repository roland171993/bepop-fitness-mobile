import '../../utils/shared_import.dart';

import 'package:flutter_html/flutter_html.dart';

class HtmlWidget extends StatelessWidget {
  final String? postContent;
  final Color? color;
  final int? size;

  HtmlWidget({this.postContent, this.color, this.size});

  void printContent() {
    debugPrint("POST CONTENT::::: ${postContent}");
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printContent();
    });

    return Html(
      data: postContent!,
      onLinkTap: (s, _, __, ___) async {
        if (s!.split('/').last.contains('.pdf')) {
          PdfViewWidget(pdfUrl: s).launch(context);
        } else {
          launchUrls(s, forceWebView: false);
        }
      },
      onImageTap: (s, _, __, ___) {
        openPhotoViewer(context, Image.network(s!).image);
      },
      style: {
        "table": Style(backgroundColor: color ?? transparentColor),
        "tr": Style(
            border: Border(
                bottom:
                    BorderSide(color: Colors.black45.withValues(alpha: 0.5)))),
        "th": Style(
            padding: EdgeInsets.all(6),
            backgroundColor: Colors.black45.withValues(alpha: 0.5)),
        "td": Style(padding: EdgeInsets.all(6), alignment: Alignment.center),
        'embed': Style(
            color: color ?? transparentColor,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'strong': Style(
            // fontWeight: FontWeight.normal,
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'a': Style(
            color: color ?? Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'div': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'figure': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble()),
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero),
        'h1': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'h2': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'h3': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'h4': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'h5': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'h6': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'ol': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        // 'ul': Style(
        //     color: color ?? textPrimaryColorGlobal,
        //     fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16).toDouble())),
        'ul': Style(
          color: color ?? textPrimaryColorGlobal,
          fontSize: FontSize(
              getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16).toDouble()),
          padding: EdgeInsets.only(left: 16),
          margin: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
        ),
        'li': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble()),
            listStyleType: ListStyleType.CIRCLE,
            listStylePosition: ListStylePosition.OUTSIDE,
            margin: EdgeInsets.zero,
            alignment: Alignment.bottomRight),
        'strike': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'u': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'b': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'i': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'hr': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'header': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'code': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'data': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'body': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'big': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'blockquote': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'audio': Style(
            color: color ?? textPrimaryColorGlobal,
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        'img': Style(
            width: context.width(),
            padding: EdgeInsets.only(bottom: 8),
            fontSize: FontSize(
                getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16)
                    .toDouble())),
        // 'li': Style(
        //   color: color ?? textPrimaryColorGlobal,
        //   fontSize: FontSize(getIntAsync(FONT_SIZE_PREF, defaultValue: size ?? 16).toDouble()),
        //   listStyleType: ListStyleType.DISC,
        //   listStylePosition: ListStylePosition.OUTSIDE,
        // ),
      },
      customRender: {
        "embed": (RenderContext renderContext, Widget child) {
          var videoLink = renderContext.parser.htmlData.text
              .splitBetween('<embed>', '</embed');
          if (videoLink.contains('youtu.be')) {
            return YouTubeEmbedWidget(
                videoLink.replaceAll('<br>', '').toYouTubeId());
          } else if (videoLink.contains('vimeo')) {
            return VimeoEmbedWidget(videoLink.replaceAll('<br>', ''));
          } else {
            return child;
          }
        },
        "figure": (RenderContext renderContext, Widget child) {
          log("=======================");
          log(renderContext.tree.element!.innerHtml);
          if (renderContext.tree.element!.innerHtml.contains('youtu.be')) {
            log("${renderContext.tree.element!.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>")}");
            return YouTubeEmbedWidget(renderContext.tree.element!.innerHtml
                .splitBetween('<div class="wp-block-embed__wrapper">', "</div>")
                .replaceAll('<br>', '')
                .toYouTubeId());
          } else if (renderContext.tree.element!.innerHtml.contains('vimeo')) {
            return VimeoEmbedWidget(renderContext.tree.element!.innerHtml
                .splitBetween('<div class="wp-block-embed__wrapper">', "</div>")
                .replaceAll('<br>', '')
                .splitAfter('com/'));
          } else if (renderContext.tree.element!.innerHtml.contains('audio')) {
            return Container(
                width: context.width(),
                child: Html(
                  data: renderContext.tree.element!.innerHtml,
                ).center());
            // return AudioPostWidget(postString: renderContext.tree.element!.innerHtml);
          } else {
            return child;
          }
        },
      },
    );
  }
}

Widget iconsBackgroundWidget(BuildContext context,
    {String? name, String? image, Color? color}) {
  return Container(
    color: primaryColor,
    width: context.width() / 3 - 32,
    child: Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            //  CircleAvatar(child: SizedBox(height: 28, width: 28), backgroundColor: color, radius: 28),
            Image.asset(image.validate(),
                height: 28, width: 28, color: Colors.white),
          ],
        ),
        8.height,
        Text(name.validate(), style: secondaryTextStyle(color: white)),
      ],
    ),
  );
}
