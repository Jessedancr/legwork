import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/Features/auth/presentation/Widgets/job_tile.dart';
import 'package:legwork/core/Constants/jobs_list.dart';

// TODO: COME BACK TO PROPERLY IMPLEMENT THE STATE CHANGE OF THE CHEKBOX

class JobSearchBar extends StatefulWidget {
  final SuggestionsBuilder suggestionsBuilder;
  final SearchController searchController;
  const JobSearchBar({
    super.key,
    required this.suggestionsBuilder,
    required this.searchController,
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
      barHintText: 'Skills',
      barHintStyle: WidgetStatePropertyAll(
        GoogleFonts.robotoSlab(
          color: Colors.grey,
        ),
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
