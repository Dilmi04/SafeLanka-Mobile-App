import 'package:flutter/material.dart';


class GuideDetailsScreen extends StatelessWidget {
  const GuideDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    final List<String> safetySteps = [
      'Move to higher ground immediately.',
      'Do not walk or drive through flooded areas.',
      'Turn off electricity at the main switch if safe.',
      'Keep emergency supplies in a safe place.',
      'Stay updated through official channels.',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {},
        ),
        title: const Text(
          'Flood Safety',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.black, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
       
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0C4DE), 
                      borderRadius: BorderRadius.circular(16.0),
                      image: const DecorationImage(
                        image: NetworkImage('https://placeholder.pics/svg/400x180/A2B9CE/FFFFFF/Flood%20Illustration'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                 
                  const Text(
                    'What to do during a flood?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  
                  ...safetySteps.map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0, right: 12.0),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0F172A),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            // Text block
                            Expanded(
                              child: Text(
                                step,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF334155),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                ],
              ),
            ),
          ),
          
        
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.15), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.offline_pin_outlined, 
                  color: Colors.grey[600], 
                  size: 18
                ),
                const SizedBox(width: 8),
                Text(
                  'This content is available offline',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}