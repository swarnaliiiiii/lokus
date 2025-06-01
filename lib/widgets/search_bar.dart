import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget{
  final Function(String) onSearch;

  const SearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}
class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  void _onSubmitted(String value) {
    widget.onSearch(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onSubmitted: _onSubmitted,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}