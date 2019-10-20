import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TempTest());
  }
}

class TempTest extends StatelessWidget {
  static final String baseURL = "https://metaphysics-production.artsy.net/";
  final HttpLink httpLink = HttpLink(
    uri: baseURL,
  );

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<GraphQLClient> client =
        ValueNotifier<GraphQLClient>(GraphQLClient(
      link: httpLink,
      cache: InMemoryCache(),
    ));
    return GraphQLProvider(
      child: PageBody(),
      client: client,
    );
  }
}

class PageBody extends StatefulWidget {
  @override
  _PageBodyState createState() => _PageBodyState();
}

class _PageBodyState extends State<PageBody> {
  @override
  Widget build(BuildContext context) {
    var _width = 210.0;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: new Color(0xFF50514F),
          title: Text("Code Challenge"),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Query(
              options: QueryOptions(document: r"""
              query getArtworks {
                  artworks{
                      id
                      __id
                      _id
                      title
                      artist_names
                      availability
                      images{
                          id
                          url
                          cropped(width: 128, height: 128){
                              url
                          }
                      }
                      category
                 }
              }
              """),
              builder: (
                QueryResult result, {
                BoolCallback refetch,
                FetchMore fetchMore,
              }) {
                if (result.data != null) {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            FadeInImage.assetNetwork(
                              placeholder: 'assets/default_pic.jpg',
                              image: result.data['artworks'][index]['images'].length == 0
                                  ? 'Empty'
                                  : result.data['artworks'][index]['images'][0]
                                      ['cropped']['url'],
                              width: 128,
                              height: 128,
                              fit: BoxFit.fill,
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, top: 2, right: 8, bottom: 2),
                                  child: Container(
                                    width: _width,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      result.data['artworks'][index]['title'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, top: 2, right: 8, bottom: 2),
                                  child: Container(
                                    width: _width,
                                    child: Text(
                                      'Artist: ' +
                                          result.data['artworks'][index]
                                              ['artist_names'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, top: 2, right: 8, bottom: 2),
                                  child: Container(
                                    width: _width,
                                    child: Text(
                                      'Category: ' +
                                          result.data['artworks'][index]
                                              ['category'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: result.data['artworks'].length,
                  );
                } else {
                  print(result.errors);
                  return Text("Fetching Data...");
                }
              }),
        ));
  }
}
