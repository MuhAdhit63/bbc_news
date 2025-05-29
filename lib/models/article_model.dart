class Article {
  final String id;
  final String title;
  final String summary;
  final String imageUrl;
  final String author;
  final String category;
  bool isBookmarked;

  Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.author,
    required this.category,
    this.isBookmarked = false,
  });
}

// Data Artikel

List<Article> dummyArticles = [
  Article(
    id: '1',
    title: 'Ekonomi Digital Konoha: Peluang dan Tantangan',
    summary: 'Indonesia memiliki potensi besar dalam ekonomi digital, namun juga dihadapkan pada berbagai tantangan seperti infrastruktur dan regulasi.',
    imageUrl: 'assets/images/article1.png',
    author: 'Naufal Sirojudin',
    category: 'Ekonomi',
    isBookmarked: false,
  ),
  Article(
    id: '2',
    title: 'AI dan Masa Depan Teknologi di Konoha',
    summary: 'Kecerdasan buatan (AI) semakin menjadi bagian penting dalam teknologi modern, dengan aplikasi yang luas mulai dari otomasi hingga analisis data.',
    imageUrl: 'assets/images/article2.png',
    author: 'Muhammad Adhitya',
    category: 'Teknologi',
    isBookmarked: true,
  ),
  Article(
    id: '2',
    title: 'Festival Budaya Konoha: Merayakan Keberagaman',
    summary: 'Festival budaya di Konoha menampilkan berbagai tradisi dan seni lokal, memperkuat identitas budaya dan komunitas.',
    imageUrl: 'assets/images/article3.png',
    author: 'Ilham Maulana Hasan',
    category: 'Budaya',
    isBookmarked: false,
  ),
];
