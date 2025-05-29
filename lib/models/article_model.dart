class Article {
  final String id;
  final String title;
  final String summary;
  final String imageUrl;
  final String author;
  final String category;
  final DateTime publishedDate;
  final String articleBody;
  bool isBookmarked;

  Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.author,
    required this.category,
    required this.publishedDate,
    required this.articleBody,
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
    publishedDate: DateTime(2025, 5, 29),
    articleBody: 'Ekonomi digital di Konoha terus berkembang pesat, dengan banyak peluang baru yang muncul. Namun, tantangan seperti infrastruktur yang belum merata dan regulasi yang belum sepenuhnya mendukung masih menjadi hambatan. Pemerintah dan sektor swasta perlu bekerja sama untuk mengatasi isu-isu ini agar potensi ekonomi digital dapat dimaksimalkan.',
    isBookmarked: false,
  ),
  Article(
    id: '2',
    title: 'AI dan Masa Depan Teknologi di Konoha',
    summary: 'Kecerdasan buatan (AI) semakin menjadi bagian penting dalam teknologi modern, dengan aplikasi yang luas mulai dari otomasi hingga analisis data.',
    imageUrl: 'assets/images/article2.png',
    author: 'Muhammad Adhitya',
    category: 'Teknologi',
    publishedDate: DateTime(2025, 6, 1),
    articleBody: 'Kecerdasan buatan (AI) telah menjadi salah satu pendorong utama inovasi teknologi di Konoha. Dengan kemampuan untuk memproses data dalam jumlah besar dan membuat keputusan yang cerdas, AI digunakan dalam berbagai sektor seperti kesehatan, transportasi, dan keuangan. Namun, tantangan etika dan privasi juga perlu diperhatikan seiring dengan perkembangan teknologi ini.',
    isBookmarked: true,
  ),
  Article(
    id: '2',
    title: 'Festival Budaya Konoha: Merayakan Keberagaman',
    summary: 'Festival budaya di Konoha menampilkan berbagai tradisi dan seni lokal, memperkuat identitas budaya dan komunitas.',
    imageUrl: 'assets/images/article3.png',
    author: 'Ilham Maulana Hasan',
    category: 'Budaya',
    publishedDate: DateTime(2025, 6, 3),
    articleBody: 'Festival budaya Konoha adalah acara tahunan yang merayakan keberagaman budaya dan tradisi lokal. Acara ini menampilkan pertunjukan seni, kuliner khas, dan pameran kerajinan tangan dari berbagai daerah. Selain menjadi ajang promosi budaya, festival ini juga memperkuat rasa kebersamaan dan identitas komunitas di Konoha.',
    isBookmarked: false,
  ),
];
