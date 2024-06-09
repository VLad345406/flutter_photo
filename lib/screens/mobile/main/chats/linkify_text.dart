import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkifyText extends StatelessWidget {
  final String text;

  const LinkifyText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Regular expression for finding references in text
    RegExp linkRegExp = RegExp(
      r'((https?:\/\/)?(www\.)?[\w-]+(\.[\w-]+)+(\.[\w]{2,})?(\.[\w]{2,})?(\/[\w-]*)*(\/\?[\w-]*)?)',
      caseSensitive: false,
    );

    // Find all references in the text
    Iterable<Match> matches = linkRegExp.allMatches(text);

    // Create a list of widgets for text with links
    List<InlineSpan> children = [];

    int lastMatchEnd = 0;
    for (Match match in matches) {
      if (match.start > lastMatchEnd) {
        children.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 17,
            ),
          ),
        );
      }

      String linkText = match.group(0)!;
      children.add(
        TextSpan(
          text: linkText,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w700,
            fontSize: 17,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchUrl(linkText);
            },
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      children.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 17,
          ),
        ),
      );
    }

    return SelectableText.rich(
      TextSpan(children: children),
    );
  }

  // open link function
  Future<void> launchUrl(String url) async {
    if (await _tryLaunchUrl(url)) return; // try opening the link as is

    // Try adding http:// and https:// and opening them one by one
    final urlsToTry = [
      if (!url.startsWith('http://')) 'http://$url',
      if (!url.startsWith('https://')) 'https://$url'
    ];

    for (var newUrl in urlsToTry) {
      if (await _tryLaunchUrl(newUrl)) return;
    }

    print('Could not launch $url');
  }

  Future<bool> _tryLaunchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      return true;
    }
    return false;
  }
}