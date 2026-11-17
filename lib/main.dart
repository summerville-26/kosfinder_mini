import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KosFinder Mini',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const KosListPage(),
    );
  }
}

class Kos {
  const Kos({
    required this.id,
    required this.name,
    required this.location,
    required this.monthlyPrice,
  });

  final String id;
  final String name;
  final String location;
  final String monthlyPrice;
}

const kosList = <Kos>[
  Kos(
    id: 'melati',
    name: 'Kos Melati',
    location: 'Jl. Mawar No. 10, Bandung',
    monthlyPrice: 'Rp1.200.000',
  ),
  Kos(
    id: 'mawar',
    name: 'Kos Mawar',
    location: 'Jl. Cempaka No. 5, Jakarta',
    monthlyPrice: 'Rp1.500.000',
  ),
  Kos(
    id: 'anggrek',
    name: 'Kos Anggrek',
    location: 'Jl. Kaliurang No. 21, Yogyakarta',
    monthlyPrice: 'Rp900.000',
  ),
  Kos(
    id: 'flamboyan',
    name: 'Kos Flamboyan',
    location: 'Jl. Dharmahusada No. 8, Surabaya',
    monthlyPrice: 'Rp1.000.000',
  ),
  Kos(
    id: 'kenanga',
    name: 'Kos Kenanga',
    location: 'Jl. Soekarno Hatta No. 15, Malang',
    monthlyPrice: 'Rp800.000',
  ),
  Kos(
    id: 'dahlia',
    name: 'Kos Dahlia',
    location: 'Jl. Pahlawan No. 12, Semarang',
    monthlyPrice: 'Rp950.000',
  ),
];

class KosListPage extends StatefulWidget {
  const KosListPage({super.key});

  @override
  State<KosListPage> createState() => _KosListPageState();
}

class _KosListPageState extends State<KosListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _favoriteKosIds = <String>{};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Kos> get _filteredKos {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return kosList;
    }

    return kosList
        .where((kos) => kos.name.toLowerCase().contains(query))
        .toList();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  void _toggleFavorite(Kos kos) {
    setState(() {
      if (_favoriteKosIds.contains(kos.id)) {
        _favoriteKosIds.remove(kos.id);
      } else {
        _favoriteKosIds.add(kos.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredKos = _filteredKos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('KosFinder Mini'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _updateSearchQuery,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: 'Cari nama kos',
                hintText: 'Cari nama kos...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _clearSearch,
                        tooltip: 'Hapus pencarian',
                        icon: const Icon(Icons.clear),
                      ),
              ),
            ),
          ),
          Expanded(
            child: filteredKos.isEmpty
                ? const Center(
                    child: Text('Kos tidak ditemukan'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredKos.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final kos = filteredKos[index];
                      final isFavorite = _favoriteKosIds.contains(kos.id);

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      kos.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(kos.location),
                                    const SizedBox(height: 12),
                                    Text(
                                      '${kos.monthlyPrice} / bulan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _toggleFavorite(kos),
                                tooltip: isFavorite
                                    ? 'Hapus dari favorit'
                                    : 'Tambah ke favorit',
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
