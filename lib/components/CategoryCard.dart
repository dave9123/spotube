import 'package:flutter/material.dart' hide Page;
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/PlaylistCard.dart';
import 'package:spotube/components/PlaylistGenreView.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  CategoryCard(this.category);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.category.name ?? "Unknown",
                  style: Theme.of(context).textTheme.headline5,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return PlaylistGenreView(widget.category.id!);
                        },
                      ),
                    );
                  },
                  child: Text("See all"),
                )
              ],
            ),
          ),
          Consumer<SpotifyDI>(
            builder: (context, data, child) =>
                FutureBuilder<Page<PlaylistSimple>>(
                    future: data.spotifyApi.playlists
                        .getByCategoryId(widget.category.id!)
                        .getPage(4, 0),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("Error occurred"));
                      }
                      if (!snapshot.hasData) {
                        return Center(child: Text("Loading.."));
                      }
                      return Wrap(
                        spacing: 20,
                        children: snapshot.data!.items!
                            .map((playlist) => PlaylistCard(playlist))
                            .toList(),
                      );
                    }),
          )
        ],
      ),
    );
  }
}
