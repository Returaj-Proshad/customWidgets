import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String? Function(T?)? validator;
  final String Function(T) itemLabelBuilder;
  final void Function(T?)? onChanged;
  final T? initialValue;
  final bool isSearchEnabled;
  final String hintText;

  const AppDropdownField({
    super.key,
    required this.title,
    required this.items,
    required this.itemLabelBuilder,
    this.validator,
    this.onChanged,
    this.initialValue,
    this.isSearchEnabled = true,
    this.hintText = 'Select or type',
  });

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isDropdownOpen = false;
  late List<T> _filteredItems;
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _filteredItems = widget.items;
    _selectedItem = widget.initialValue;

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && widget.isSearchEnabled) {
        // When focused, show dropdown automatically
        setState(() => _isDropdownOpen = true);
      } else {
        // When unfocused, close dropdown
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) setState(() => _isDropdownOpen = false);
        });
      }
    });
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems =
          widget.items
              .where(
                (item) => widget
                    .itemLabelBuilder(item)
                    .toLowerCase()
                    .contains(query.toLowerCase()),
              )
              .toList();
      // Open dropdown automatically if typing
      if (query.isNotEmpty && !_isDropdownOpen) {
        _isDropdownOpen = true;
      }
    });
  }

  void _selectItem(T item) {
    setState(() {
      _selectedItem = item;
      _controller.text = widget.itemLabelBuilder(item);
      _isDropdownOpen = false;
    });
    widget.onChanged?.call(item);
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF12274F),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  focusNode: _focusNode,
                  readOnly: !widget.isSearchEnabled,
                  onChanged: widget.isSearchEnabled ? _filterItems : null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator:
                      (_) => widget.validator?.call(_selectedItem ?? null),
                ),
              ),
              InkWell(
                onTap: () => setState(() => _isDropdownOpen = !_isDropdownOpen),
                child: Icon(
                  _isDropdownOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        if (_isDropdownOpen)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10203D),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white24),
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final label = widget.itemLabelBuilder(item);
                return InkWell(
                  onTap: () => _selectItem(item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

