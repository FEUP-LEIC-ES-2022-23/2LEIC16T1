import 'package:flutter/material.dart';

class SearchDropdown extends StatefulWidget {
  final String selectedItem;
  final List<String> items;
  final Function(String)? onChanged;

  const SearchDropdown({
    Key? key,
    required this.selectedItem,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  _SearchDropdownState createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  late TextEditingController _controller;
  List<String> _filteredItems = [];
  double _boxHeight = 0;
  FocusNode inputFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.selectedItem;
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) =>
              item.toLowerCase().contains(query.trim().toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(

              )
            )
          ),
          child: TextField(
            controller: _controller,
            focusNode: inputFocus,
            onChanged: _filterItems,
            decoration: const InputDecoration(
              hintText: ' what are you looking for',
              border: InputBorder.none,
              isDense: true
            ),
            onTap: () {
              inputFocus.requestFocus();
              _boxHeight = 200;
            },
            onTapOutside: (tap) {
              inputFocus.unfocus();
              _boxHeight = 0;
              if (!_filteredItems.contains(_controller.text)) {
                _controller.text = '';
              }
            },
            onEditingComplete: () {
              inputFocus.unfocus();
              _boxHeight = 0;
              if (!_filteredItems.contains(_controller.text)) {
                _controller.text = '';
              } else if (widget.onChanged != null) {
                widget.onChanged!(_controller.text);
              }
            },
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: SizedBox(
            height: _boxHeight,
            child: TextFieldTapRegion(
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return InkWell(
                    onTap: () {
                      if (widget.onChanged != null) {
                        widget.onChanged!(item);
                      }

                      inputFocus.unfocus();
                      _boxHeight = 0;

                      setState(() {
                        _controller.text = item;
                        _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Text(item),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
