import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/edit_company_dialog.dart';
import 'product_list_screen.dart';

import '../data/hive_setup.dart';

class CompanyListScreen extends StatelessWidget {
  const CompanyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Companies'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Company>('companies').listenable(),
        builder: (context, Box<Company> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('No companies added yet.'));
          }

          final companies = box.values.toList();

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemCount: companies.length,
            itemBuilder: (context, index) {
              final company = companies[index];

              final color = company.colorValue != null
                  ? Color(company.colorValue!)
                  : Colors.primaries[(company.name.hashCode & 0x7FFFFFFF) %
                        Colors.primaries.length];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductListScreen(
                          companyId: company.id,
                          companyName: company.name,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    showEditCompanyDialog(context, company);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        child: Text(
                          company.name.isNotEmpty
                              ? company.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          company.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
