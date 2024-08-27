import 'package:flutter/material.dart';

class DappListScreen extends StatefulWidget {
  @override
  _DappListScreenState createState() => _DappListScreenState();
}

class _DappListScreenState extends State<DappListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearching = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Simulate search results
    setState(() {
      _searchResults = List.generate(
        10,
        (index) => 'Result for "$value" $index',
      );
    });
  }

  void _onWillPop(bool didPop) {
    if (_isSearching) {
      setState(() {
        _searchFocusNode.unfocus();
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: _onWillPop,
      canPop: false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              expandedHeight: 150.0, // Increased for more space
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                      centerTitle: true,
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: constraints.maxHeight > 120 ? 300 : 300,
                          height: 50,
                          alignment: Alignment.center,
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Search for canister',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                            ),
                            onChanged: _onSearchChanged,
                          ),
                        ),
                      ));
                },
              ),
            ),
            if (_isSearching)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(
                    title: Text(_searchResults[index]),
                  ),
                  childCount: _searchResults.length,
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors
                                .primaries[index % Colors.primaries.length],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.apps, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text('App $index'),
                      ],
                    ),
                    childCount: 50,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
