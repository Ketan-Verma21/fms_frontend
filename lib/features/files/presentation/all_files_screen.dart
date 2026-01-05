import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/file_controller.dart';
import '../models/file_model.dart';

Map<String, String> shelfDescriptions = {
  "3E4B7292": "Manoj Sir Cabin",
  "E0DF3BC7": "TM sir Cabin",
  "62B0F490": "Sandeep Sir Cabin",
  "5A6B9A7E": "Conference Room",
  "F03CCBBD": "Printer Area",
  "598251FE": "BPCL/DBG/SC01",
  "F9713C28": "BPCL/DBG/SC02",
  "D1711467": "BPCL/DBG/SC03",
  "0404B9EB": "BPCL/DBG/SC04",
  "C3D82730": "BPCL/DBG/SC05",
  "04E5D205": "BPCL/DBG/SC06",
  "0007FF64": "BPCL/DBG/SC07",
  "F0318F42": "BPCL/DBG/SC08",
  "8EFFCABE": "BPCL/DBG/SC09",
  "7C3C0538": "BPCL/DBG/SC10",
  "C0640A00": "BPCL/DBG/SC11",
  "8A6C9186": "BPCL/DBG/SC12",
  "57FB0541": "BPCL/DBG/SC13",
  "39E7194F": "BPCL/DBG/SC14",
  "DE1934E3": "BPCL/DBG/SC15",
  "16AB0CB6": "BPCL/DBG/SC16",
};

Map<String, String> placedBy = {
  "Adigoppula Manoj Nagesh": "AMN",
  "Bibek Jha": "BJ",
  "Ketan Verma": "KV",
  "Lalu Kumar Rey": "LKR",
  "Md. Shahansha": "MS",
  "Nilesh Nagawade": "NN",
  "Pinkesh Kumar": "PK",
  "Sandeep Singh": "SS",
  "Sanjeet Verma": "SV",
  "Titas Chakraborty": "TC"
};

// Optimized search index for instant lookups
class SearchIndex {
  final Map<String, List<FileModel>> _descriptionIndex = {};
  final Map<String, List<FileModel>> _shelfIndex = {};
  final Map<String, List<FileModel>> _placedByIndex = {};
  List<FileModel> _allFiles = [];

  void buildIndex(List<FileModel> files) {
    _allFiles = files;
    _descriptionIndex.clear();
    _shelfIndex.clear();
    _placedByIndex.clear();

    for (var file in files) {
      // Index description words
      final descWords = file.description.toLowerCase().split(RegExp(r'\s+'));
      for (var word in descWords) {
        if (word.isNotEmpty) {
          _descriptionIndex.putIfAbsent(word, () => []).add(file);
        }
      }

      // Index shelf
      final shelf = shelfDescriptions[file.shelfId]?.toLowerCase();
      if (shelf != null) {
        final shelfWords = shelf.split(RegExp(r'\s+'));
        for (var word in shelfWords) {
          if (word.isNotEmpty) {
            _shelfIndex.putIfAbsent(word, () => []).add(file);
          }
        }
      }

      // Index placed by
      final placed = placedBy[file.placedBy]?.toLowerCase();
      if (placed != null) {
        _placedByIndex.putIfAbsent(placed, () => []).add(file);
      }
      final placedFull = file.placedBy.toLowerCase();
      final placedWords = placedFull.split(RegExp(r'\s+'));
      for (var word in placedWords) {
        if (word.isNotEmpty) {
          _placedByIndex.putIfAbsent(word, () => []).add(file);
        }
      }
    }
  }

  List<FileModel> search(String query) {
    if (query.isEmpty) return _allFiles;

    final q = query.toLowerCase().trim();
    final words = q.split(RegExp(r'\s+'));
    
    // Use Set for O(1) lookups and automatic deduplication
    final resultSet = <FileModel>{};

    // Multi-field search with scoring
    for (var word in words) {
      if (word.isEmpty) continue;

      // Search in description index
      _descriptionIndex.forEach((key, files) {
        if (key.contains(word) || word.contains(key)) {
          resultSet.addAll(files);
        }
      });

      // Search in shelf index
      _shelfIndex.forEach((key, files) {
        if (key.contains(word) || word.contains(key)) {
          resultSet.addAll(files);
        }
      });

      // Search in placed by index
      _placedByIndex.forEach((key, files) {
        if (key.contains(word) || word.contains(key)) {
          resultSet.addAll(files);
        }
      });
    }

    // Fallback: if no results from index, do quick linear search
    if (resultSet.isEmpty) {
      for (var file in _allFiles) {
        if (file.description.toLowerCase().contains(q)) {
          resultSet.add(file);
        }
      }
    }

    return resultSet.toList();
  }
}

class AllFilesScreen extends ConsumerStatefulWidget {
  const AllFilesScreen({super.key});

  @override
  ConsumerState<AllFilesScreen> createState() => _AllFilesScreenState();
}

class _AllFilesScreenState extends ConsumerState<AllFilesScreen> {
  List<FileModel> allFiles = [];
  List<FileModel> filteredFiles = [];
  final SearchIndex _searchIndex = SearchIndex();
  final ScrollController _scrollController = ScrollController();
  
  final _searchController = TextEditingController();
  
  // Alphabet index data
  final List<String> _alphabet = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '#'
  ];
  Map<String, int> _letterToIndex = {};
  Set<String> _availableLetters = {};
  String? _selectedLetter;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _buildLetterIndex() {
    _letterToIndex.clear();
    _availableLetters.clear();
    
    for (int i = 0; i < filteredFiles.length; i++) {
      final firstChar = filteredFiles[i].description.trim().toUpperCase()[0];
      final letter = RegExp(r'^[A-Z]').hasMatch(firstChar) ? firstChar : '#';
      
      if (!_letterToIndex.containsKey(letter)) {
        _letterToIndex[letter] = i;
      }
      _availableLetters.add(letter);
    }
  }

  void _scrollToLetter(String letter) {
    if (_letterToIndex.containsKey(letter)) {
      final index = _letterToIndex[letter]!;
      // Calculate approximate position (each item is ~100 pixels + margin)
      final position = index * 112.0; // 100 (item height) + 12 (margin)
      
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
      
      setState(() {
        _selectedLetter = letter;
      });
      
      // Clear selection after animation
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _selectedLetter = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filesControllerProvider);

    state.whenData((files) {
      if (allFiles.length != files.length) {
        allFiles = files;
        _searchIndex.buildIndex(files);
        _filterFiles(_searchController.text);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'All Files',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh',
              onPressed: () {
                ref.read(filesControllerProvider.notifier).refresh();
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade200,
            height: 1,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search files, shelves, or people...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.grey.shade600,
                        size: 22,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color: Colors.grey.shade600,
                                size: 20,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _filterFiles('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onChanged: _filterFiles,
                  ),
                ),
              ),

              // Files List
              Expanded(
                child: state.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading files',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          e.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  data: (_) => filteredFiles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _searchController.text.isEmpty
                                    ? Icons.folder_open_rounded
                                    : Icons.search_off_rounded,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchController.text.isEmpty
                                    ? 'No files yet'
                                    : 'No results found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _searchController.text.isEmpty
                                    ? 'Register a file to get started'
                                    : 'Try a different search term',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 44, // Extra padding for alphabet index
                            top: 20,
                            bottom: 20,
                          ),
                          itemCount: filteredFiles.length,
                          itemBuilder: (_, i) => _FileTile(file: filteredFiles[i]),
                        ),
                ),
              ),
            ],
          ),
          
          // Alphabet Index Sidebar
          if (filteredFiles.isNotEmpty && _searchController.text.isEmpty)
            Positioned(
              right: 4,
              top: 100,
              bottom: 40,
              child: _AlphabetIndexBar(
                alphabet: _alphabet,
                availableLetters: _availableLetters,
                selectedLetter: _selectedLetter,
                onLetterTap: _scrollToLetter,
              ),
            ),
        ],
      ),
    );
  }

  void _filterFiles(String query) {
    setState(() {
      filteredFiles = _searchIndex.search(query);
      // Sort files alphabetically by description
      // filteredFiles.sort((a, b) => 
      //   a.description.toLowerCase().compareTo(b.description.toLowerCase())
      // );
      _buildLetterIndex();
    });
  }
}

class _AlphabetIndexBar extends StatefulWidget {
  final List<String> alphabet;
  final Set<String> availableLetters;
  final String? selectedLetter;
  final Function(String) onLetterTap;

  const _AlphabetIndexBar({
    required this.alphabet,
    required this.availableLetters,
    required this.selectedLetter,
    required this.onLetterTap,
  });

  @override
  State<_AlphabetIndexBar> createState() => _AlphabetIndexBarState();
}

class _AlphabetIndexBarState extends State<_AlphabetIndexBar> {
  String? _hoveredLetter;
  OverlayEntry? _overlayEntry;

  void _showLetterOverlay(String letter) {
    _removeOverlay();
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        right: 60,
        top: MediaQuery.of(context).size.height / 2 - 40,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localY = details.localPosition.dy;
        final height = box.size.height;
        final index = (localY / height * widget.alphabet.length).floor();
        
        if (index >= 0 && index < widget.alphabet.length) {
          final letter = widget.alphabet[index];
          if (widget.availableLetters.contains(letter)) {
            if (_hoveredLetter != letter) {
              setState(() => _hoveredLetter = letter);
              _showLetterOverlay(letter);
              widget.onLetterTap(letter);
            }
          }
        }
      },
      onVerticalDragEnd: (details) {
        setState(() => _hoveredLetter = null);
        _removeOverlay();
      },
      child: Container(
        width: 24,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(-2, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.alphabet.map((letter) {
            final isAvailable = widget.availableLetters.contains(letter);
            final isSelected = letter == widget.selectedLetter;
            final isHovered = letter == _hoveredLetter;
            
            return GestureDetector(
              onTap: isAvailable ? () => widget.onLetterTap(letter) : null,
              child: Container(
                width: 24,
                height: 14,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected || isHovered
                      ? const Color(0xFF4F46E5).withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isAvailable ? FontWeight.w600 : FontWeight.w400,
                    color: isAvailable
                        ? (isSelected || isHovered
                            ? const Color(0xFF4F46E5)
                            : const Color(0xFF1A1A2E))
                        : Colors.grey.shade400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _FileTile extends StatelessWidget {
  final FileModel file;
  const _FileTile({required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File Number with Icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: Color(0xFF4F46E5),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    file.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Info Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: Icons.inventory_2_rounded,
                  label: 'Shelf ${shelfDescriptions[file.shelfId] ?? 'Unknown'}',
                  color: const Color(0xFF10B981),
                ),
                Tooltip(
                  message: file.placedBy,
                  triggerMode: TooltipTriggerMode.tap,
                  child: _InfoChip(
                    icon: Icons.person_rounded,
                    label: placedBy[file.placedBy] ?? 'Unknown',
                    color: const Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}