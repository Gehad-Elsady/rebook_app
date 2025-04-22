import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebook_app/Screens/books/categories_screen.dart';
import 'package:rebook_app/Screens/home/widget/wellcom_part.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});
  final List<String> categories = [
    'School Books', //
    'University Books',
    'Reference Books',
    'Textbooks',
    'Novels',
    'Short Stories',
    'Comics & Graphic Novels',
    'Biographies & Autobiographies',
    'Science',
    'Mathematics', //
    'History', //
    'Geography',
    'Languages',
    'Religious Books',
    'Art & Design',
    'Engineering',
    'Medical',
    'Law',
    'Economics',
    'Psychology',
    'Philosophy',
    'Study Guides',
    'Exam Papers',
    'Handouts',
    'Notebooks',
    'Workbooks',
    'Children’s Books', //
    'Cookbooks', //
    'Self-Help', //
    'Technology & IT' //
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WelcomePart(),
                  const SizedBox(height: 10),
                  Divider(
                    color: Colors.black,
                    thickness: 1.5,
                    endIndent: 20,
                    indent: 10,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "All Categories",
                      style: GoogleFonts.domine(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return InkWell(
                    onTap: () {
                      // Handle navigation
                      Navigator.pushNamed(
                        context,
                        BooksCategoriesScreen
                            .routeName, // Replace with your route name
                        arguments: categories[index],
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                "assets/images/catrgores/${categories[index]}.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Center(
                              child: Text(
                                categories[index],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lora(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: categories.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}
