import '../utils/shared_import.dart';

class DisclaimerSection extends StatelessWidget {
  const DisclaimerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: primaryLightColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline),
              SizedBox(
                width: 4,
              ),
              Text(
                languages.disclaimer,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "${languages.dietDesclaimerNote}${languages.dietDesclaimerNote2}${languages.dietDesclaimerNote3} ",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const ReferenceDialog(),
              );
            },
            child: Text(languages.viewSourceReference),
          ),
        ],
      ),
    );
  }
}

class ReferenceDialog extends StatelessWidget {
  const ReferenceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(languages.sourceReference),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ReferenceLink(
              title: "NIH - Role of Diet in Autoimmune Diseases",
              url: "https://www.ncbi.nlm.nih.gov/",
            ),
            SizedBox(height: 8),
            ReferenceLink(
              title: "Harvard - Inflammatory Foods Impact",
              url: "https://www.health.harvard.edu/",
            ),
            SizedBox(height: 8),
            ReferenceLink(
              title: "WHO - Nutritional Guidelines for Illness",
              url: "https://www.who.int/",
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(languages.close),
        ),
      ],
    );
  }
}

class ReferenceLink extends StatelessWidget {
  final String title;
  final String url;

  const ReferenceLink({required this.title, required this.url, super.key});

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchURL,
      child: Text(
        '• $title\n  $url',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
