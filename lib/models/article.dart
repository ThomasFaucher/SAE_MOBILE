class Article {
  int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rate;
  final int count;

  static int nb = 1;

  Article({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rate,
    required this.count,
  });

  set setId(int value) {
    id = value;
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rate: json["rate"].toDouble(),
      count: json['count'],
    );
  }

  factory Article.fromJsonAPI(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rate: json["rating"]["rate"].toDouble(),
      count: json["rating"]['count'],
    );
  }
  factory Article.newArticle(
      String title, double price, String description, String category, String image, double rate, int count) {
    nb++;
    return Article(
      id:nb+1, title: title, price: price, description: description, category: category, image: image, rate: rate, count: count
    );
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'],
      title: map['title'],
      price: map['price'],
      description: map['description'],
      category: map['category'],
      image: map['image'],
      rate: map['rate'],
      count: map['count'],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rate': rate,
      'count': count,
    };
  }

  @override
  String toString() {
    return 'Article{id: $id, title: $title, price: $price, description: $description, category: $category, image: $image, rate: $rate, count: $count}';
  }

}
