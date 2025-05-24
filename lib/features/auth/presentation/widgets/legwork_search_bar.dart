import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class LegworkSearchBar extends StatefulWidget {
  final SuggestionsBuilder suggestionsBuilder;
  final SearchController searchController;
  final String? barHintText;
  final void Function(String)? onChanged;
  const LegworkSearchBar({
    super.key,
    required this.suggestionsBuilder,
    required this.searchController,
    this.barHintText,
    this.onChanged,
  });

  @override
  State<LegworkSearchBar> createState() => _LegworkSearchBarState();
}

class _LegworkSearchBarState extends State<LegworkSearchBar> {
  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return SearchAnchor.bar(
      onChanged: widget.onChanged,
      searchController: widget.searchController,
      barElevation: const WidgetStatePropertyAll(0.0),
      barBackgroundColor: WidgetStatePropertyAll(
        context.colorScheme.surfaceContainer,
      ),
      barHintText: widget.barHintText,
      barHintStyle: WidgetStatePropertyAll(
        TextStyle(color: context.colorScheme.onSurface),
      ),

      barSide: WidgetStatePropertyAll(
        BorderSide(
          color: context.colorScheme.secondary,
        ),
      ),
      dividerColor: Colors.grey,

      // SUGGESTIONS BUILDER
      suggestionsBuilder: widget.suggestionsBuilder,
    );
  }
}
