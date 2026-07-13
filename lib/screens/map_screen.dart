import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safelanka/utils/constants.dart';
import 'package:safelanka/services/location_service.dart';
import 'place_details_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  StreamSubscription<Position>? _positionStreamSubscription;
  
  LatLng? _currentLocation;
  bool _isLoadingLocation = true;
  List<Map<String, dynamic>> _allPlaces = [];
  List<Map<String, dynamic>> _filteredPlaces = [];
  String _selectedFilter = "All";

  // Note: We keep these as fallback/demo markers, but distances will be dynamic
  final List<Map<String, dynamic>> _staticPlaces = [
    {
      "name": "Sri Jayawardenepura Hospital",
      "type": "Hospital",
      "location": const LatLng(6.8817, 79.9189),
      "phone": "+94112778610",
      "color": AppColors.sosRed,
      "icon": Icons.local_hospital_rounded,
    },
    {
      "name": "Police Station - Mirihana",
      "type": "Police",
      "location": const LatLng(6.8711, 79.8973),
      "phone": "+94112854853",
      "color": AppColors.primary,
      "icon": Icons.local_police_rounded,
    },
    {
      "name": "Gangodawila Community Center",
      "type": "Shelter",
      "location": const LatLng(6.8550, 79.8980),
      "phone": "+94112852278",
      "color": AppColors.safeGreen,
      "icon": Icons.home_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchNearbyPlacesFromFirestore();
    
    // Start tracking location immediately
    _startLocationUpdates();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLocationExplanation();
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _showLocationExplanation() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.location_on, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            const Text("Enable Precise Location", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              "SafeLanka needs your precise real-time location to show nearby emergency services accurately.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _fetchCurrentLocation(); // Initial fetch and move
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Allow Access", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startLocationUpdates() {
    _positionStreamSubscription = LocationService.getPositionStream().listen(
      (Position position) {
        if (mounted) {
          setState(() {
            _currentLocation = LatLng(position.latitude, position.longitude);
            _isLoadingLocation = false;
          });
          _applyFilter(); // Recalculate distances
        }
      },
      onError: (e) {
        debugPrint("Location update error: $e");
      }
    );
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final position = await LocationService.getCurrentLocation();
      final latLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentLocation = latLng;
        _isLoadingLocation = false;
      });
      _mapController.move(latLng, 15.0);
      _applyFilter();
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      // Fallback only if GPS fails completely
      _mapController.move(const LatLng(6.9271, 79.8612), 14.0); 
    }
  }

  Future<void> _fetchNearbyPlacesFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('safe_locations').get();
      List<Map<String, dynamic>> firestorePlaces = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        firestorePlaces.add({
          "name": data['name'] ?? "Unknown Place",
          "type": data['type'] ?? "Other",
          "location": LatLng((data['lat'] as num).toDouble(), (data['lng'] as num).toDouble()),
          "phone": data['phone'] ?? "No Phone",
          "color": _getColorForType(data['type']),
          "icon": _getIconForType(data['type']),
        });
      }
      setState(() {
        _allPlaces = List.from(_staticPlaces)..addAll(firestorePlaces);
        _applyFilter();
      });
    } catch (e) {
      debugPrint("Firestore error: $e");
      setState(() {
        _allPlaces = List.from(_staticPlaces);
        _applyFilter();
      });
    }
  }

  void _applyFilter() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      
      // 1. Filter by search and category
      List<Map<String, dynamic>> filtered = _allPlaces.where((place) {
        bool matchesSearch = place['name'].toString().toLowerCase().contains(query);
        bool matchesType = _selectedFilter == "All" || place['type'] == _selectedFilter;
        return matchesSearch && matchesType;
      }).toList();

      // 2. Calculate dynamic distance for all items
      for (var place in filtered) {
        if (_currentLocation != null) {
          double dist = Geolocator.distanceBetween(
            _currentLocation!.latitude, _currentLocation!.longitude,
            place['location'].latitude, place['location'].longitude
          );
          
          place['distRaw'] = dist;
          place['distance'] = dist >= 1000 
              ? "${(dist / 1000).toStringAsFixed(1)} km away" 
              : "${dist.round()} m away";
        } else {
          place['distRaw'] = 999999.0;
          place['distance'] = "Calculating...";
        }
      }

      // 3. Sort by distance
      filtered.sort((a, b) => (a['distRaw'] as double).compareTo(b['distRaw'] as double));
      _filteredPlaces = filtered;
    });
  }

  Color _getColorForType(String? type) {
    switch (type) {
      case 'Hospital': return AppColors.sosRed;
      case 'Police': return AppColors.primary;
      case 'Shelter': return AppColors.safeGreen;
      default: return Colors.grey;
    }
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'Hospital': return Icons.local_hospital_rounded;
      case 'Police': return Icons.local_police_rounded;
      case 'Shelter': return Icons.home_rounded;
      default: return Icons.location_on_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Safe Locations", style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _applyFilter(),
              decoration: InputDecoration(
                hintText: "Search safe places...",
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          
          // Filter Chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: ["All", "Hospital", "Police", "Shelter"].map((filter) {
                bool isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(filter, style: TextStyle(color: isSelected ? Colors.white : AppColors.textDark, fontSize: 12)),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() { _selectedFilter = filter; _applyFilter(); });
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.shade200)),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Map Container
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _currentLocation ?? const LatLng(6.9271, 79.8612), 
                        initialZoom: 14.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.safelanka',
                        ),
                        MarkerLayer(
                          markers: [
                            ..._filteredPlaces.map((place) {
                              return Marker(
                                point: place['location'],
                                width: 40, height: 40,
                                child: GestureDetector(
                                  onTap: () => _showPlaceInfo(place),
                                  child: Icon(Icons.location_on, color: place['color'], size: 40),
                                ),
                              );
                            }),
                            if (_currentLocation != null)
                              Marker(
                                point: _currentLocation!,
                                width: 50, height: 50,
                                child: _buildCurrentLocationMarker(),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20, right: 30,
                  child: FloatingActionButton(
                    mini: true, backgroundColor: Colors.white,
                    onPressed: _fetchCurrentLocation,
                    child: _isLoadingLocation 
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.my_location, color: AppColors.primary, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // Bottom List
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Safe Places Near You (${_filteredPlaces.length})",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _filteredPlaces.isEmpty
                      ? const Center(child: Text("No places found nearby."))
                      : ListView.builder(
                          itemCount: _filteredPlaces.length,
                          itemBuilder: (context, index) => _buildPlaceCard(_filteredPlaces[index]),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLocationMarker() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(width: 20, height: 20, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.3), shape: BoxShape.circle)),
        Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
      ],
    );
  }

  void _showPlaceInfo(Map<String, dynamic> place) {
    _mapController.move(place['location'], 15.0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${place['name']} - ${place['distance']}"), 
        behavior: SnackBarBehavior.floating,
        backgroundColor: place['color'],
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceDetailsScreen(
              placeName: place['name'], placeType: place['type'], distance: place['distance'], 
              lat: place['location'].latitude, lng: place['location'].longitude, phone: place['phone'],
            )));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
            ),
            child: ListTile(
              leading: Container(
                width: 44, height: 44, decoration: BoxDecoration(color: place['color'].withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(place['icon'], color: place['color'], size: 22),
              ),
              title: Text(place['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text(place['distance'], style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
