import 'package:flutter/material.dart';

class JobSearchBar extends StatefulWidget {
  final SuggestionsBuilder suggestionsBuilder;
  final SearchController searchController;
  final String? barHintText;
  const JobSearchBar({
    super.key,
    required this.suggestionsBuilder,
    required this.searchController,
    this.barHintText,
  });

  @override
  State<JobSearchBar> createState() => _JobSearchBarState();
}

class _JobSearchBarState extends State<JobSearchBar> {
  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return SearchAnchor.bar(
      searchController: widget.searchController,
      barElevation: const WidgetStatePropertyAll(0.0),
      barBackgroundColor: WidgetStatePropertyAll(
        Theme.of(context).colorScheme.surfaceContainer,
      ),
      barHintText: widget.barHintText,
      barHintStyle: WidgetStatePropertyAll(
        TextStyle(color: Colors.grey[500]),
      ),

      barSide: WidgetStatePropertyAll(
        BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      dividerColor: Colors.grey,

      // SUGGESTIONS BUILDER
      suggestionsBuilder: widget.suggestionsBuilder,
    );
  }
}
