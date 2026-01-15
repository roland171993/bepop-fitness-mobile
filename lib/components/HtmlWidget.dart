import '../utils/shared_import.dart';

import 'package:flutter_html/flutter_html.dart';

class HtmlWidget extends StatefulWidget {
  final String? postContent;
  final Color? color;

  HtmlWidget({this.postContent, this.color});

  @override
  State<HtmlWidget> createState() => _HtmlWidgetState();
}

class _HtmlWidgetState extends State<HtmlWidget> {
  String? extractSrc(String html) {
    RegExp regExp = RegExp(r'src="(.*?)"');
    final match = regExp.firstMatch(html);
    return match?.group(1);
  }

  String removeIframe(String html) {
    final RegExp iframeRegex = RegExp(r'<iframe.*?<\/iframe>', dotAll: true);
    return html.replaceAll(iframeRegex, '');
  }

  @override
  Widget build(BuildContext context) {
    print(
        "-------------------------->>>${extractSrc(widget.postContent ?? '')}");
    return Column(
      children: [
        extractSrc(widget.postContent ?? '').isEmptyOrNull
            ? SizedBox.shrink()
            : extractSrc(widget.postContent ?? '')!
                        .contains("https://www.youtu") ||
                    extractSrc(widget.postContent ?? '')!
                        .contains("https://youtu")
                ? AspectRatio(
                    aspectRatio: 12 / 7,
                    child: HtmlYoutubePlayer(
                        url: extractSrc(widget.postContent ?? '')))
                : SizedBox.shrink(),
        Html(
          data: removeIframe(widget.postContent ?? ''),
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
            "table": Style(backgroundColor: widget.color ?? transparentColor),
            "tr": Style(
                border: Border(
                    bottom: BorderSide(
                        color: Colors.black45.withValues(alpha: 0.5)))),
            "th": Style(
                padding: EdgeInsets.all(6),
                backgroundColor: Colors.black45.withValues(alpha: 0.5)),
            "td":
                Style(padding: EdgeInsets.all(6), alignment: Alignment.center),
            'embed': Style(
                color: widget.color ?? transparentColor,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'strong': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'a': Style(
                color: widget.color ?? Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'div': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'figure': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble()),
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero),
            'h1': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'h2': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'h3': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'h4': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'h5': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'h6': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'ol': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'ul': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'strike': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'u': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'b': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'i': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'hr': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'header': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'code': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'data': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'body': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'big': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'blockquote': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'audio': Style(
                color: widget.color ?? textPrimaryColorGlobal,
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'img': Style(
                width: context.width(),
                padding: EdgeInsets.only(bottom: 8),
                fontSize: FontSize(
                    getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble())),
            'li': Style(
              color: widget.color ?? textPrimaryColorGlobal,
              fontSize: FontSize(
                  getIntAsync(FONT_SIZE_PREF, defaultValue: 16).toDouble()),
              listStyleType: ListStyleType.DISC,
              listStylePosition: ListStylePosition.OUTSIDE,
            ),
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
              if (renderContext.tree.element!.innerHtml.contains('youtu.be')) {
                //log("${renderContext.tree.element!.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>")}");
                return YouTubeEmbedWidget(renderContext.tree.element!.innerHtml
                    .splitBetween(
                        '<div class="wp-block-embed__wrapper">', "</div>")
                    .replaceAll('<br>', '')
                    .toYouTubeId());
              } else if (renderContext.tree.element!.innerHtml
                  .contains('vimeo')) {
                return VimeoEmbedWidget(renderContext.tree.element!.innerHtml
                    .splitBetween(
                        '<div class="wp-block-embed__wrapper">', "</div>")
                    .replaceAll('<br>', '')
                    .splitAfter('com/'));
              } else if (renderContext.tree.element!.innerHtml
                  .contains('audio')) {
                return Container(
                    width: context.width(),
                    child: Html(
                      data: renderContext.tree.element!.innerHtml,
                    ).center());

                //return AudioPostWidget(postString: renderContext.tree.element!.innerHtml);
              } else {
                return child;
              }
            },
          },
        ),
      ],
    );
  }
}
