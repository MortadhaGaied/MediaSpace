import 'dart:convert';

import 'package:MediaSpaceFrontend/services/backend/auth-service.dart';
import 'package:MediaSpaceFrontend/services/backend/space-service.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';
import '../../services/backend/mediaInteraction-service.dart';
import '../../widgets/VideoPlayerItem.dart';
import '../../widgets/custom_bottomNavigationBar.dart';
import '../search-pages/space-details-page.dart';
import 'CommentScreen.dart';
import 'comment_section.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final MediaInteractionService mediaService = MediaInteractionService();
  final AuthenticationService authservice=AuthenticationService();
  final SpaceService spaceService=SpaceService();
  List<dynamic> videoList = [];
  List<int> userIdList=[];
  List<VideoPlayerController> videoControllers = [];

  int userId = 1;  // Replace with the actual user ID
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    pageController.addListener(_pageViewListener);


    _loadVideos();
  }
  void _pageViewListener() {
    int currentPage = pageController.page!.round();

    for (int i = 0; i < videoControllers.length; i++) {
      if (currentPage != i) {
        videoControllers[i].pause();
      } else {
        videoControllers[i].play();
      }
    }
  }
  void _showCommentSection(int videoId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CommentSection(id: videoId);
      },
      isScrollControlled: true,
    );
  }



  _loadVideos() async {
    videoList = await mediaService.getAllVideos();
    for (var data in videoList) {
      var spaceId=data['spaceId'];
      final spaceResponse= await spaceService.retrieveSpace(spaceId);
      if (spaceResponse.statusCode == 200) {
        var spaceData = json.decode(spaceResponse.body);
        userIdList.add(spaceData['ownerId']);
      } else {
        print('Failed to fetch space data for spaceId: $spaceId');
        userIdList.add(-1);  // Add a placeholder -1 to indicate failure
      }
      var videoUrl = await mediaService.getVideoUrl(data['id']);  // Assuming this fetches your video URL
      var controller = VideoPlayerController.network(videoUrl!)
        ..initialize().then((_) {
          setState(() {});
        });
      controller.setLooping(true);
      controller.play();
      videoControllers.add(controller);
    }

    setState(() {});

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
          itemCount: videoList.length,
          controller: pageController,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoList[index];
            return GestureDetector(
              onHorizontalDragEnd: (details){
                if(details.primaryVelocity!>0){
                  videoControllers[index].pause();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpaceDetailsPage(spaceId: data['spaceId']),
                    ),
                  );
                }else if(details.primaryVelocity!<0){
                  videoControllers[index].pause();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpaceDetailsPage(spaceId: data['spaceId']),
                    ),
                  );
                }
              },
              child:Stack(
                children: [
                  FutureBuilder<String?>(
                    future: mediaService.getVideoUrl(data['id']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(  // Center the loading widget
                          child: LoadingAnimationWidget.twistingDots(
                            leftDotColor: const Color(0xFF1A1A3F),
                            rightDotColor: const Color(0xFFEA3799),
                            size: 100,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        return VideoPlayerItem(
                          videoUrl: snapshot.data!,
                        );
                      }
                      return Center(
                        child: Text('Video URL not found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );    // Show an error message if URL couldn't be fetched
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FutureBuilder<Map<String, dynamic>>(
                          future: authservice.getUserById(userIdList[index]),
                          builder: (context, userSnapshot) {

                            if (userSnapshot.connectionState == ConnectionState.done && userSnapshot.hasData) {
                              return FutureBuilder<String>(
                                future: authservice.getUrlFile(userSnapshot.data!['profile_picture']),
                                builder: (context, urlSnapshot) {
                                  if (urlSnapshot.connectionState == ConnectionState.done && urlSnapshot.hasData) {
                                    return CircleAvatar(
                                      backgroundImage: NetworkImage(urlSnapshot.data!),
                                    );
                                  }
                                  return CircleAvatar(
                                    backgroundImage: AssetImage('assets/images/form.PNG'),  // Default image in case of error or loading
                                  );
                                },
                              );
                            }
                            return CircleAvatar(
                              backgroundImage: AssetImage('assets/images/form.PNG'),  // Default image in case of error or loading
                            );
                          },
                        ),

                        SizedBox(height: 20),
                        InkWell(
                          onTap: () async {
                            await mediaService.likeVideo(data['id'], userId);
                            _loadVideos();
                          },
                          child: Icon(
                            Icons.favorite,
                            color:  Colors.yellow,
                          ),
                        ),
                        Text(data['likeCount'].toString(),style: TextStyle(color: Colors.white)),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            _showCommentSection(data['id']);
                          },
                          child: Icon(
                            Icons.comment,
                            color: Colors.white,
                          ),
                        ),

                        FutureBuilder<List<dynamic>>(
                          future: mediaService.getCommentsForVideo(data['id']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              return Text(snapshot.data!.length.toString(), style: TextStyle(color: Colors.white));
                            }
                            return Text("0", style: TextStyle(color: Colors.white));  // Placeholder while loading
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "test test",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              )
            );
          }),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
  @override
  void dispose() {
    for (var controller in videoControllers) {
      controller.pause();
      controller.dispose();
    }
    super.dispose();
  }
}
