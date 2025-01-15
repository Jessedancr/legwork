import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/jobs_list.dart';

class LegworkSearchBar extends StatelessWidget {
  const LegworkSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return SearchAnchor.bar(
      suggestionsBuilder: (context, controller) {
        return jobs.where(
            // A bool functton returns true for elements to display
            (job) {
          return controller.text.isEmpty ||
              job.toLowerCase().contains(
                    controller.text.toLowerCase(),
                  );
        }).map(
          (job) => ListTile(
            title: Text(job),
            leading: Icon(Icons.select_all),
          ),
        );
      },
    );
  }
}
