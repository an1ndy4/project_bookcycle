import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/book_controller.dart';
import '../../controllers/category_controller.dart';
import '../../models/book_model.dart';
import '../../models/category_model.dart';
import '../book/book_detail_screen.dart';
import '../book/sell_book_screen.dart';
import 'profile_screen.dart';
import '../widgets/book_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookController>(context, listen: false).fetchAllBooks();
      Provider.of<CategoryController>(context, listen: false).fetchAllCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'BookCycle',
          style: TextStyle(
            color: Color(0xFF087F3E),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Navigate to notifications
            },
            icon: const Icon(
              Icons.notifications_none,
              color: Color(0xFF092B8F),
            ),
          ),
        ],
      ),
      body: _buildCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF087F3E),
        unselectedItemColor: const Color(0xFF092B8F),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Jual',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildSearchPage();
      case 2:
        return SellBookScreen();
      case 3:
        return _buildNotificationsPage();
      case 4:
        return const ProfileScreen();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F7FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari buku, judul, penulis, atau kategori...',
                hintStyle: TextStyle(fontSize: 12, color: Color(0xFF7C8BA5)),
                prefixIcon: Icon(Icons.search, color: Color(0xFF092B8F)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                Provider.of<BookController>(context, listen: false)
                    .searchBooks(value);
              },
            ),
          ),
          const SizedBox(height: 25),
          // Header
          const Text(
            'Buku baru,\ncerita baru!',
            style: TextStyle(
              color: Color(0xFF087F3E),
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Temukan buku favoritmu dengan harga terbaik.',
            style: TextStyle(
              color: Color(0xFF092B8F),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
          // 3 Main Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _homeMenu(
                icon: Icons.shopping_cart_outlined,
                title: 'Beli',
                onTap: () {
                  Provider.of<BookController>(context, listen: false)
                      .fetchBooksByCategory(0);
                },
              ),
              _homeMenu(
                icon: Icons.upload_outlined,
                title: 'Jual',
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
              _homeMenu(
                icon: Icons.swap_horiz,
                title: 'Tukar',
                onTap: () {
                  // TODO: Navigate to exchange list
                },
              ),
            ],
          ),
          const SizedBox(height: 35),
          // Categories
          const Text(
            'Kategori',
            style: TextStyle(
              color: Color(0xFF092B8F),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Consumer<CategoryController>(
            builder: (context, controller, _) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _categoryChip('Semua', 0, controller);
                    }
                    final category = controller.categories[index - 1];
                    return _categoryChip(
                      category.namaKategori,
                      category.kategoriId ?? 0,
                      controller,
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          // Books List
          const Text(
            'Buku Tersedia',
            style: TextStyle(
              color: Color(0xFF092B8F),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<BookController>(
              builder: (context, controller, _) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.books.isEmpty) {
                  return const Center(
                    child: Text('Belum ada buku tersedia'),
                  );
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: controller.books.length,
                  itemBuilder: (context, index) {
                    return BookCard(book: controller.books[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, int id, CategoryController controller) {
    final isSelected = controller.selectedCategoryId == id;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Provider.of<BookController>(context, listen: false)
              .filterByCategory(id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF087F3E) : const Color(0xFFF2F7FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF092B8F),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _homeMenu({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              color: Color(0xFF087F3E),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 27),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF092B8F),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F7FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari buku...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF092B8F)),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                Provider.of<BookController>(context, listen: false)
                    .searchBooks(value);
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Consumer<BookController>(
              builder: (context, controller, _) {
                if (controller.books.isEmpty) {
                  return const Center(child: Text('Tidak ada hasil'));
                }
                return ListView.builder(
                  itemCount: controller.books.length,
                  itemBuilder: (context, index) {
                    return BookCard(book: controller.books[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsPage() {
    return const Center(
      child: Text('Fitur notifikasi akan segera hadir'),
    );
  }
}