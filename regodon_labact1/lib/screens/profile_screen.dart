import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_button.dart';
import '../widgets/post_card.dart';
import '../constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int followers = 1250;
  int following = 342;

  final List<Map<String, dynamic>> profilePosts = [
    {
      'userName': 'Ivan Ezekiel Regodon',
      'postContent': 'We cute',
      'date': '2 hours ago',
      'likes': 45,
      'comments': 12,
      'shares': 3,
      'hasImage': true,
      'imageUrl': 'assets/images/bebi.jpg',
    },
    {
      'userName': 'Ivan Ezekiel Regodon',
      'postContent': 'First day sa gym, nabawasan ako ng 80 pesos!',
      'date': '1 day ago',
      'likes': 32,
      'comments': 8,
      'shares': 2,
      'hasImage': false,
      'imageUrl': '',
    },
  ];

  // Enhancement 5: Sample images for GridView
  final List<String> profilePhotos = [
    'https://via.placeholder.com/150/FF5733',
    'https://via.placeholder.com/150/33FF57',
    'https://via.placeholder.com/150/3357FF',
    'https://via.placeholder.com/150/FF33F5',
    'https://via.placeholder.com/150/F5FF33',
    'https://via.placeholder.com/150/33FFF5',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            image: const DecorationImage(
                              image: AssetImage("assets/images/pogi.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -50,
                          left: ScreenUtil().setWidth(20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                  "assets/icons/superpogi.jpg",
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.grey[300],
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(55)),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomFont(
                            text: 'Ivan Ezekiel Regodon',
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(20),
                            color: Colors.black,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(5)),
                          CustomFont(
                            text: 'Missouri, Texas',
                            fontSize: ScreenUtil().setSp(15),
                            color: Colors.black,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          CustomFont(
                            text: 'Passionate about coding and innovation',
                            fontSize: ScreenUtil().setSp(15),
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                CustomFont(
                                  text: followers.toString(),
                                  fontSize: ScreenUtil().setSp(16),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomFont(
                                  text: 'Followers',
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                CustomFont(
                                  text: following.toString(),
                                  fontSize: ScreenUtil().setSp(16),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomFont(
                                  text: 'Following',
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    // Action Buttons
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              buttonName: 'Follow',
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(10)),
                          Expanded(
                            child: CustomButton(
                              buttonName: 'Message',
                              buttonType: 'outlined',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                  ],
                ),
              ),
            ];
          },
          body: Column(
            children: [
              TabBar(
                indicatorColor: FB_DARK_PRIMARY,
                tabs: [
                  Tab(
                    child: CustomFont(
                      text: 'Posts',
                      fontSize: ScreenUtil().setSp(15),
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    child: CustomFont(
                      text: 'About',
                      fontSize: ScreenUtil().setSp(15),
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    child: CustomFont(
                      text: 'Photos',
                      fontSize: ScreenUtil().setSp(15),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView.builder(
                      itemCount: profilePosts.length,
                      itemBuilder: (context, index) {
                        final post = profilePosts[index];
                        return NewsFeedCard(
                          userName: post['userName'],
                          postContent: post['postContent'],
                          date: post['date'],
                          numOfLikes: post['likes'],
                          numOfComments: post['comments'],
                          numOfShares: post['shares'],
                          hasImage: post['hasImage'],
                          imageUrl: post['imageUrl'] ?? '',
                        );
                      },
                    ),

                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Details Section
                            CustomFont(
                              text: 'Details',
                              fontSize: ScreenUtil().setSp(18),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(15)),

                            // Profile/Profession
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.work,
                                    color: Colors.grey[600],
                                    size: ScreenUtil().setSp(20),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(12)),
                                  CustomFont(
                                    text: 'Junior Developer • Tech Enthusiast',
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),

                            // Location
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey[600],
                                    size: ScreenUtil().setSp(20),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(12)),
                                  CustomFont(
                                    text: 'Missouri, Texas',
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),

                            // Education
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.school,
                                    color: Colors.grey[600],
                                    size: ScreenUtil().setSp(20),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(12)),
                                  Expanded(
                                    child: CustomFont(
                                      text:
                                          'National University - Manila, 2023-2027',
                                      fontSize: ScreenUtil().setSp(14),
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: ScreenUtil().setHeight(20)),

                            // Skills Section
                            CustomFont(
                              text: 'Skills',
                              fontSize: ScreenUtil().setSp(16),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(10)),
                            Wrap(
                              spacing: ScreenUtil().setWidth(8),
                              runSpacing: ScreenUtil().setHeight(8),
                              children: [
                                _buildSkillChip('Flutter'),
                                _buildSkillChip('Dart'),
                                _buildSkillChip('FrontEnd'),
                                _buildSkillChip('React.js'),
                              ],
                            ),

                            SizedBox(height: ScreenUtil().setHeight(20)),

                            // Bio/Description Section
                            CustomFont(
                              text: 'Description',
                              fontSize: ScreenUtil().setSp(18),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(10)),
                            CustomFont(
                              text:
                                  'Hi! I\'m Ivan Ezekiel Regodon, a junior developer and tech enthusiast. I love creating beautiful and functional apps that make a difference. When I\'m not coding, you can find me exploring new places, playing basketball, or just bed rotting.',
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.grey[700] ?? Colors.grey,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(15)),
                            CustomButton(
                              buttonName: 'Edit public details',
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),

                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: ScreenUtil().setWidth(5),
                        mainAxisSpacing: ScreenUtil().setHeight(5),
                        childAspectRatio: 1,
                      ),
                      itemCount: profilePhotos.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          child: Image.network(
                            profilePhotos[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(12),
        vertical: ScreenUtil().setHeight(6),
      ),
      decoration: BoxDecoration(
        color: FB_DARK_PRIMARY.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FB_DARK_PRIMARY),
      ),
      child: CustomFont(
        text: skill,
        fontSize: ScreenUtil().setSp(12),
        color: FB_DARK_PRIMARY,
      ),
    );
  }
}
