import 'package:bookstore/cart.dart';
import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart' as google_books;
import 'bookPage.dart';

class Book {
  final String title;
  final List<String> authors;
  final String thumbnailUrl;
  final String coverUrl;

  Book({
    required this.title,
    required this.authors,
    required this.thumbnailUrl,
    required this.coverUrl,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> genreList = [
    'Fantasy',
    'Romance',
    'Science Fiction',
    'Mystery',
    'Thriller',
    'Horror',
    'Non-Fiction',
    'Biography',
    'History',
    'Adventure',
  ];

  Future<List<Book>> fetchBooksForGenre(String genre) async {
    final List<google_books.Book> googleBooks =
        await google_books.GoogleBooksApi().searchBooks(
      genre,
      maxResults: 10,
      printType: google_books.PrintType.books,
      orderBy: google_books.OrderBy.relevance,
    );

    List<Book> books = googleBooks.map((book) {
      return Book(
        title:
            book.volumeInfo.title != null ? book.volumeInfo.title! : 'No Title',
        authors: book.volumeInfo.authors != null
            ? book.volumeInfo.authors!
            : ['Unknown Author'],
        thumbnailUrl: book.volumeInfo.imageLinks?['thumbnail']?.toString() ??
            'https://via.placeholder.com/128x196',
        coverUrl: book.volumeInfo.imageLinks?['medium']?.toString() ??
            'https://via.placeholder.com/350x500',
      );
    }).toList();

    return books;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(" TADAAAA ")),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                margin: EdgeInsets.all(15),
                child: ListView.builder(
                  itemCount: genreList.length,
                  itemBuilder: (context, position) {
                    String genre = genreList[position];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            genre,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 180,
                          child: FutureBuilder<List<Book>>(
                            future: fetchBooksForGenre(genre),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error fetching books'),
                                );
                              } else if (snapshot.hasData) {
                                List<Book> books = snapshot.data!;
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: books.map((book) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BookDetailsPage(book: book),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  // <-- Add Expanded here
                                                  child: Image.network(
                                                    book.coverUrl,
                                                    height: 300,
                                                    width: 200,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  book.title,
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  book.authors.join(', '),
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: Text('No books found'),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  },
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF1D1E33),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.home),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.library_books),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Cart(),
                              ));
                        },
                        icon: Icon(Icons.shopping_cart),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
