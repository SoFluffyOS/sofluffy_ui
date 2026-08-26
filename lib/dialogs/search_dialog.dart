import 'package:easy_debounce/easy_debounce.dart' show EasyDebounce;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class SearchDialog<T> extends StatefulWidget {
  final Future<List<T>> Function(String query) onSearch;
  final Widget Function(BuildContext context, T item, bool isSelected)
  itemBuilder;
  final void Function(T item) onItemSelected;
  final String? hintText;
  final String searchIcon;

  const SearchDialog({
    super.key,
    required this.onSearch,
    required this.itemBuilder,
    required this.onItemSelected,
    this.hintText,
    required this.searchIcon,
  });

  static Future<void> show<T>(
    BuildContext context, {
    required Future<List<T>> Function(String query) onSearch,
    required Widget Function(BuildContext context, T item, bool isSelected)
    itemBuilder,
    required void Function(T item) onItemSelected,
    String? hintText,
    required String searchIcon,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: FluffyColors.barrier,
      transitionDuration: FluffyDurations.dialogTransition,
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: child,
        );
      },
      pageBuilder: (context, anim1, anim2) => SearchDialog<T>(
        onSearch: onSearch,
        itemBuilder: itemBuilder,
        onItemSelected: onItemSelected,
        hintText: hintText,
        searchIcon: searchIcon,
      ),
    );
  }

  @override
  State<SearchDialog<T>> createState() => _SearchDialogState<T>();
}

class _SearchDialogState<T> extends State<SearchDialog<T>>
    with AfterLayoutMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  List<T> _results = [];
  bool _isLoading = false;
  int _selectedIndex = 0;
  String _lastQuery = '';

  @override
  void afterFirstLayout(BuildContext context) {
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) async {
    if (query == _lastQuery) {
      return;
    }

    _lastQuery = query;

    if (query.isEmpty) {
      setState(() {
        _results = [];
        _isLoading = false;
        _selectedIndex = 0;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _selectedIndex = 0;
    });

    try {
      final results = await widget.onSearch(query);
      if (!mounted) {
        return;
      }

      if (_controller.text != query) {
        return;
      }

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      _isLoading = false;
      _results = [];
      setState(() {});
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_results.isNotEmpty) {
        setState(() {
          _selectedIndex = (_selectedIndex + 1) % _results.length;
        });
        _scrollToSelected();
        return KeyEventResult.handled;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_results.isNotEmpty) {
        setState(() {
          _selectedIndex =
              (_selectedIndex - 1 + _results.length) % _results.length;
        });
        _scrollToSelected();
        return KeyEventResult.handled;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (_results.isNotEmpty) {
        _selectItem(_results[_selectedIndex]);
        return KeyEventResult.handled;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _scrollToSelected() {
    if (_results.isEmpty) return;
  }

  void _selectItem(T item) {
    widget.onItemSelected(item);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.fluffyTheme;
    final isDark = context.isDark;
    final scaffoldBg = isDark ? theme.colors.neutral7 : theme.colors.neutral1;
    final dividerColor = isDark ? theme.colors.neutral5 : theme.colors.neutral3;
    final onSurfaceColor = isDark
        ? theme.colors.neutral1
        : theme.colors.neutral7;

    final size = MediaQuery.sizeOf(context);
    final maxHeight = size.height * 0.6;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: size.height * 0.2,
          left: Spacing.d16,
          right: Spacing.d16,
        ),
        child: Container(
          width: 600,
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          decoration: ShapeDecoration(
            color: scaffoldBg,
            shape: RoundedSuperellipseBorder(
              borderRadius: Spacing.r12,
              side: BorderSide(color: dividerColor, width: 0.25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Focus(
                focusNode: FocusNode(),
                onKeyEvent: _handleKeyEvent,
                child: InputText(
                  focusNode: _focusNode,
                  controller: _controller,
                  hintText: widget.hintText ?? 'Search...',
                  onChanged: (text) {
                    EasyDebounce.debounce(
                      'search-posts',
                      const Duration(milliseconds: 500),
                      () => _handleSearch(text),
                    );
                  },
                  prefixIcon: widget.searchIcon,
                  inputPadding: EdgeInsets.all(Spacing.d16),
                  decorationBuilder: (context, _, _, _) {
                    return const BoxDecoration();
                  },
                  textStyle: theme.typography.headline6,
                ),
              ),
              if (_results.isNotEmpty || _isLoading)
                Container(
                  height: 1,
                  color: dividerColor,
                ),
              switch (_isLoading) {
                true => Container(
                  padding: EdgeInsets.all(Spacing.d24),
                  alignment: Alignment.center,
                  child: const LoadingBox(),
                ),
                false when _results.isNotEmpty => Flexible(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < _results.length; i++)
                          _buildItem(i, _results[i]),
                      ],
                    ),
                  ),
                ),
                false when _controller.text.isEmpty => Padding(
                  padding: EdgeInsets.all(Spacing.d24),
                  child: Text(
                    'No results found',
                    style: theme.typography.base2.copyWith(
                      color: onSurfaceColor.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                ),
                _ => const SizedBox(),
              },
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index, T item) {
    final isSelected = index == _selectedIndex;
    final theme = context.fluffyTheme;

    return Tappable(
      onTap: () => _selectItem(item),
      builder: (context, state) {
        final isHovered = state.isHovered;
        final isActive = isSelected || isHovered;

        Color backgroundColor = FluffyColors.transparent;
        if (isActive) {
          backgroundColor = theme.colors.primary.withValues(alpha: 0.1);
        }

        return Container(
          color: backgroundColor,
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.d16,
            vertical: Spacing.d12,
          ),
          child: widget.itemBuilder(context, item, isSelected),
        );
      },
    );
  }
}
