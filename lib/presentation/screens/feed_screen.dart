import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamnest/core/constants/font_constants.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_typography.dart';
import '../widgets/section_header.dart';
import '../providers/movie_provider.dart';
import 'widgets/heroidgets.dart';
import '../../data/models/movie.dart';
import 'package:dio/dio.dart';
import '../../data/models/suggestedMdel.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<SuggestedUser> _suggestedUsers = [];
  bool _isLoadingSuggested = false;
  bool _hasInitializedSuggestedUsers = false;

  Future<void> _fetchSuggestedUsers([Function? setModalState]) async {
    if (_isLoadingSuggested || _hasInitializedSuggestedUsers) return;

    print('Fetching suggested users...');
    setState(() => _isLoadingSuggested = true);
    setModalState?.call(() {}); // Trigger modal rebuild

    try {
      final response = await Dio().get(
        'https://api.streamnest.tv/friends/suggested',
      );
      final data = response.data as List;
      print('Suggested users API response:');
      print(data);
      setState(() {
        _suggestedUsers = data.map((e) => SuggestedUser.fromJson(e)).toList();
        _hasInitializedSuggestedUsers = true;
      });
      setModalState?.call(() {}); // Trigger modal rebuild
    } catch (e) {
      print('Error fetching suggested users: $e');
      setState(() => _suggestedUsers = []);
      setModalState?.call(() {}); // Trigger modal rebuild
    } finally {
      setState(() => _isLoadingSuggested = false);
      setModalState?.call(() {}); // Trigger modal rebuild
    }
  }

  void _showFriendsBottomSheet(BuildContext context) {
    // Reset the flag when opening the bottom sheet
    setState(() {
      _hasInitializedSuggestedUsers = false;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final height = MediaQuery.of(context).size.height * 0.95;
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Trigger fetch when the bottom sheet is first built
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_hasInitializedSuggestedUsers && !_isLoadingSuggested) {
                print('Bottom sheet built: Fetching suggested users...');
                _fetchSuggestedUsers(setModalState);
              }
            });

            return DefaultTabController(
              length: 2,
              child: SizedBox(
                height: height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    TabBar(
                      onTap: (index) {
                        if (index == 1) {
                          print('TabBar onTap: Fetching suggested users...');
                          _fetchSuggestedUsers(setModalState);
                        }
                      },
                      labelColor: const Color(0xFF4d7fff),
                      unselectedLabelColor: AppColors.textSecondary,
                      indicatorColor: const Color(0xFF4d7fff),
                      tabs: const [
                        Tab(text: 'Friends'),
                        Tab(text: 'Suggested Users'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Friends tab
                          SingleChildScrollView(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text('Friends List Here'),
                              ),
                            ),
                          ),
                          // Suggested Users tab
                          _isLoadingSuggested
                              ? Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  itemCount: _suggestedUsers.length,
                                  itemBuilder: (context, index) {
                                    final user = _suggestedUsers[index];
                                    return ListTile(
                                      trailing:
                                          user.matchesReceived?.percentage !=
                                              null
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFF4d7fff,
                                                ).withOpacity(0.1),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFF4d7fff,
                                                  ),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '${(double.tryParse(user.matchesReceived?.percentage?.toString() ?? '0') ?? 0).toInt()}% matches',
                                                style: AppTypography.bodySmall
                                                    .copyWith(
                                                      color: const Color(
                                                        0xFF4d7fff,
                                                      ),
                                                      fontWeight: FontConstants
                                                          .semiBold,
                                                    ),
                                              ),
                                            )
                                          : null,
                                      subtitle: Text(
                                        "Sign in to view Profile",
                                        style: AppTypography.bodySmall.copyWith(
                                          color: const Color(0xFFCBD5E2),
                                          fontWeight: FontConstants.semiBold,
                                        ),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          user.avatarUrl,
                                        ),
                                      ),
                                      title: Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: AppTypography.bodyMedium1,
                                      ),
                                      // Add more user info as needed
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Call loadFeedMovies with default/empty filter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = context.read<MovieProvider>();
      movieProvider.loadFeedMovies({
        "availability": null,
        "genre": [],
        "releaseYear": "",
        "languages": [],
        "rating": "",
        "duration": "",
        "ageSuitability": [],
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFF4d7fff),
          onPressed: () => _showFriendsBottomSheet(context),
          child: Icon(Icons.group, color: AppColors.textPrimary),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoadingFeed) {
            return const Center(child: CircularProgressIndicator());
          }
          if (movieProvider.feedError != null) {
            return Center(
              child: Text(
                movieProvider.feedError!,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              // Content
              SliverPadding(
                padding: const EdgeInsets.all(0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Feed Items
                    ...movieProvider.feedItems.map((item) {
                      final movie = item.movie;
                      final title = item.title;
                      final content = item.content;
                      final authors = item.authors;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Container(
                          color: AppColors.herobackground,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (authors.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        // First author avatar
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundImage: NetworkImage(
                                            authors[0].avatarUrl,
                                          ),
                                          backgroundColor: AppColors.primary
                                              .withOpacity(0.1),
                                        ),
                                        if (authors.length > 1) ...[
                                          const SizedBox(width: 4),
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: AppColors.primary
                                                .withOpacity(0.15),
                                            child: Text(
                                              '+${authors.length - 1}',
                                              style: AppTypography.bodySmall
                                                  .copyWith(
                                                    color: AppColors.primary,
                                                    fontWeight:
                                                        FontConstants.bold,
                                                  ),
                                            ),
                                          ),
                                        ],
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (title.isNotEmpty)
                                              Text(
                                                title,
                                                style: AppTypography.titleSmall
                                                    .copyWith(
                                                      fontWeight:
                                                          FontConstants.bold,
                                                    ),
                                              ),
                                            if (content.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 8,
                                                ),
                                                child: Text(
                                                  content,
                                                  style: AppTypography
                                                      .labelSmall
                                                      .copyWith(
                                                        fontWeight:
                                                            FontConstants
                                                                .semiBold,
                                                      ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                if (movie != null)
                                  buildMovieTab(movie, false, null, context),
                                if (movie == null)
                                  Text(
                                    'No movie data',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.error,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    if (movieProvider.feedMovies.isEmpty)
                      Center(
                        child: Text(
                          'No feed movies found.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    const SizedBox(height: 100), // Bottom padding
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
