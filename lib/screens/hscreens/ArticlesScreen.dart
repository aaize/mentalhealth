import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'webview_screen.dart';

class Article {
  final String title;
  final String source;
  final String date;
  final String imageUrl;
  final String url;

  Article({
    required this.title,
    required this.source,
    required this.date,
    required this.imageUrl,
    required this.url,
  });
}

class ArticlesScreen extends StatefulWidget {
  final Color backgroundColor;
  const ArticlesScreen({Key? key, required this.backgroundColor}) : super(key: key);

  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Article> _filteredArticles = [];

  final List<Article> articles = [
    Article(
      title: 'Mental Fitness: How to Stay Sharp in a Distracted World',
      source: 'Journal Courier',
      date: 'February 23, 2025',
      imageUrl: 'lib/assets/articlesonmental.png',
      url: 'https://www.myjournalcourier.com/features/article/mental-fitness-in-stay-sharp-distracted-world-20149370.php',
    ),
    Article(
      title: 'Prescribing Stand-Up Comedy: A New Approach to Mental Health',
      source: 'The Times',
      date: 'February 20, 2025',
      imageUrl: 'lib/assets/articlesonmental.png',
      url: 'https://www.thetimes.co.uk/article/comedy-prescription-antidepressants-nhs-craic-health-0dc52zrkf',
    ),
    Article(
      title: 'PILLAR Expands Mental Health Support with New Grant',
      source: 'LMT Online',
      date: 'February 22, 2025',
      imageUrl: 'lib/assets/articlesonmental.png',
      url: 'https://www.lmtonline.com/local/article/webb-nonprofit-funding-methodist-ministries-laredo-20175717.php',
    ),
    Article(
      title: 'Narcissism and the Youth Mental Health Crisis',
      source: 'The Australian',
      date: 'February 19, 2025',
      imageUrl: 'lib/assets/articlesonmental.png',
      url: 'https://www.theaustralian.com.au/commentary/narcissism-at-the-heart-of-childrens-mental-health-crisis/news-story/f369002722fc008c3b3c2af3db32737a',
    ),
    Article(
      title: 'Supporting New Dads: Protecting Mental Health After Childbirth',
      source: 'Herald Sun',
      date: 'February 19, 2025',
      imageUrl: 'lib/assets/articlesonmental.png',
      url: 'https://www.heraldsun.com.au/health/mental-health/deakin-university-study-reveals-firsttime-dads-struggle-with-parenthood/news-story/9ab0237af75e22c19c42cd3dcd153f37',
    ),
    Article(
      title: 'Rise in Teenagers Seeking Mental Health Benefits Post-COVID',
      source: 'The Times',
      date: 'February 21, 2025',
      imageUrl: 'lib/assets/articlesonmental.png',
      url: 'https://www.thetimes.co.uk/article/more-teenagers-on-benefits-for-mental-health-than-before-covid-tskrlh5qv',
    ),
    Article(
      title: 'Top 10 Trends to Watch in 2025',
      source: 'American Psychological Association',
      date: 'January 2025',
      imageUrl: 'lib/assets/articlesonmental.png',
      url: 'https://www.apa.org/monitor/2025/01/top-10-trends-to-watch',
    ),
    Article(
      title: 'Recovering Wellbeing from the Diseases of Despair',
      source: 'Nature Mental Health',
      date: '2025',
      imageUrl: 'lib/assets/articlesonmental.png',
      url: 'https://www.nature.com/natmentalhealth/articles?year=2025',
    ),
    Article(
      title: 'A Mind Reading for 2025: Our Mental Health Forecast',
      source: 'Verywell Mind',
      date: 'February 2025',
      imageUrl: 'lib/assets/articlesonmental.png',
      url: 'https://www.verywellmind.com/mind-reading-2025-trends-8762268',
    ),
    Article(
      title: '4 Imperatives for Improving Mental Health Care in 2025',
      source: 'World Economic Forum',
      date: 'January 2025',
      imageUrl: 'lib/assets/articlesonmental.png',
      url: 'https://www.weforum.org/stories/2025/01/4-imperatives-for-improving-mental-health-care-in-2025/',
    ),
  ];


  @override
  void initState() {
    super.initState();
    _filteredArticles = articles;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _filteredArticles = articles.where((article) {
        return article.title.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: widget.backgroundColor,
        middle: _isSearching
            ? CupertinoSearchTextField(
          controller: _searchController,
          style: GoogleFonts.poppins(),
          prefixIcon: const Icon(CupertinoIcons.search),
        )
            : Text(
          'Articles',
          style: GoogleFonts.poppins(fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w400),
        ),
        leading: CupertinoButton(onPressed: () {
            Navigator.pop(context);
        },
        child: Icon(CupertinoIcons.back),
        sizeStyle: CupertinoButtonSize.medium,),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(_isSearching ? CupertinoIcons.xmark : CupertinoIcons.search),
          onPressed: () => setState(() => _isSearching = !_isSearching),
          sizeStyle: CupertinoButtonSize.small,
        ),
      ),
      child: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: _filteredArticles.length,
          itemBuilder: (context, index) {
            final article = _filteredArticles[index];
            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => WebViewScreen(url: article.url,backgroundColor: widget.backgroundColor,),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: CupertinoColors.darkBackgroundGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        article.imageUrl,
                        width: 120,
                        height: 86,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            style: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 16,
                            color: widget.backgroundColor),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${article.source} • ${article.date}',
                            style: GoogleFonts.poppins(fontSize: 12, color: CupertinoColors.systemGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
