import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/update_profile_provider.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_loading_indicator.dart';
import 'package:legwork/features/home/presentation/widgets/job_preferences_card.dart';
import 'package:legwork/features/home/presentation/widgets/resume_detail_item.dart';
import 'package:provider/provider.dart';

class ResumeSection extends StatefulWidget {
  final UserEntity user;

  const ResumeSection({
    super.key,
    required this.user,
  });

  @override
  State<ResumeSection> createState() => _ResumeSectionState();
}

class _ResumeSectionState extends State<ResumeSection> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Check if the user (dancer or client) has portfolio
    final checkUserPortfoliio =
        (widget.user.isClient && widget.user.hasHiringHistory) ||
            (widget.user.isDancer && widget.user.hasResume);

    // Store the dancer's work experience
    final dancerWorkExp =
        widget.user.asDancer?.resume?['workExperiences'] ?? [];

    // Store the client's hiring history
    final clientHiringHistory =
        widget.user.asClient?.hiringHistory?['hiringHistories'] ?? [];

    // * FUNCTION TO DELETE DANCER WORK EXP AND CLIENT HIRING HISTORY
    void deleteWorkExp(int index) async {
      try {
        final provider =
            Provider.of<UpdateProfileProvider>(context, listen: false);
        // get a copy of the dancer's work experience
        final workExpCopy = List<dynamic>.from(dancerWorkExp);

        // Get a copy of the client's hiring history
        final hiringHistoryCopy = List<dynamic>.from(clientHiringHistory);

        // Delete work experience from dancer's profile
        if (widget.user.isDancer) {
          // Handle case where there is an invalid index
          if (index < 0 || index >= workExpCopy.length) {
            hideLoadingIndicator(context);
            LegworkSnackbar(
              title: 'Error',
              subTitle: 'Invalid experience index',
              imageColor: Theme.of(context).colorScheme.onError,
              contentColor: Theme.of(context).colorScheme.error,
            ).show(context);
            return;
          }
          // remove a work experience from a particular index
          workExpCopy.removeAt(index);

          // This is now the updated data
          final updatedData = {'resume.workExperiences': workExpCopy};

          // Use the update profile provider
          showLoadingIndicator(context);
          final result = await provider.updateProfileExecute(data: updatedData);

          result.fold(
            // handle fail
            (fail) {
              debugPrint('Failed to delete work experience');
              hideLoadingIndicator(context);
              LegworkSnackbar(
                title: 'Omo!',
                subTitle: 'Failed to delete work experience',
                imageColor: colorScheme.onError,
                contentColor: colorScheme.error,
              ).show(context);
            },

            // handle success
            (_) {
              debugPrint('Deleted work exp');
              hideLoadingIndicator(context);
              // Notify parent widget of the change
              if (widget.user.isDancer && widget.user.asDancer != null) {
                widget.user.asDancer!.resume!['workExperiences'] = workExpCopy;
              }
              // Force UI update
              if (mounted) {
                setState(() {});
              }
              LegworkSnackbar(
                title: 'Sharp guy!',
                subTitle: 'Work experience deleted',
                imageColor: colorScheme.onPrimary,
                contentColor: colorScheme.primary,
              ).show(context);
            },
          );
        }

        // Delete hiring history from client profile
        if (widget.user.isClient) {
          // Handle case where there is an invalid index
          if (index < 0 || index >= hiringHistoryCopy.length) {
            hideLoadingIndicator(context);
            LegworkSnackbar(
              title: 'Error',
              subTitle: 'Invalid hiring history index',
              imageColor: Theme.of(context).colorScheme.onError,
              contentColor: Theme.of(context).colorScheme.error,
            ).show(context);
            return;
          }

          // Remove a hiring history from a particular index
          hiringHistoryCopy.removeAt(index);

          // This is now the updated data
          final updatedData = {
            'hiringHistory.hiringHistories': hiringHistoryCopy
          };

          // Use the update profile provider
          showLoadingIndicator(context);
          final result = await provider.updateProfileExecute(data: updatedData);

          result.fold(
            // Handle fail
            (fail) {
              debugPrint('Failed to delete Hiring history');
              hideLoadingIndicator(context);
              LegworkSnackbar(
                title: 'Omo!',
                subTitle: 'Failed to delete Hiring history',
                imageColor: colorScheme.onError,
                contentColor: colorScheme.error,
              ).show(context);
            },

            // Handle success
            (_) {
              debugPrint('Deleted Hiring history');
              hideLoadingIndicator(context);
              // Notify parent widget of change
              if (widget.user.isClient && widget.user.asClient != null) {
                widget.user.asClient!.hiringHistory!['hiringHistories'] =
                    hiringHistoryCopy;
              }
              // Force UI update
              if (mounted) {
                setState(() {});
              }
              LegworkSnackbar(
                title: 'Sharp guy!',
                subTitle: 'Hiring history deleted',
                imageColor: colorScheme.onPrimary,
                contentColor: colorScheme.primary,
              ).show(context);
            },
          );
        }
      } catch (e) {
        debugPrint(
            'Unexpected error occured while deleting work experience: ${e.toString()}');
        hideLoadingIndicator(context);
        LegworkSnackbar(
          title: 'Omo',
          subTitle: 'Failed to delete: ${e.toString()}',
          imageColor: colorScheme.onError,
          contentColor: colorScheme.error,
        ).show(context);
      }
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Descr icon + header text
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/briefcase.svg',
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.user.isDancer ? 'Resume' : 'Hiring History',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            if (checkUserPortfoliio)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.user.isDancer
                    ? dancerWorkExp?.length
                    : clientHiringHistory.length,
                itemBuilder: (context, index) {
                  // ALERT DIALOG TO CONFIRM DELETION OF WORK EXPERIENCE
                  void dialogBoxToDeleteExp() {
                    deleteExpDialogBox(
                      context: context,
                      textTheme: textTheme,
                      colorScheme: colorScheme,
                      deleteWorkExp: deleteWorkExp,
                      index: index,
                    );
                  }

                  // * WORK EXPERIENCE/HIRING HISTORY CARD
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Job title + date
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Job title
                                  Text(
                                    widget.user.isDancer
                                        ? dancerWorkExp[index]['jobTitle']
                                                ?.toString() ??
                                            'N/A'
                                        : clientHiringHistory[index]['jobTitle']
                                                ?.toString() ??
                                            'N/A',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  // Date
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      widget.user.isDancer
                                          ? dancerWorkExp[index]['date']
                                                  ?.toString() ??
                                              'N/A'
                                          : clientHiringHistory[index]['date']
                                                  ?.toString() ??
                                              'N/A',
                                      style: textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Employer
                              ResumeDetailItem(
                                label: widget.user.isDancer
                                    ? 'Employer'
                                    : 'Number of dancers hired',
                                value: widget.user.isDancer
                                    ? dancerWorkExp[index]['employer']
                                            ?.toString() ??
                                        'N/A'
                                    : clientHiringHistory[index]['numOfDancers']
                                            ?.toString() ??
                                        'N/A',
                                svgIconPath: widget.user.isDancer
                                    ? 'assets/svg/briefcase.svg'
                                    : 'assets/svg/hashtag_icon.svg',
                              ),
                              const SizedBox(height: 4),

                              // * IF LOGGED IN USER IS A CLIENT SHOW THIS
                              if (widget.user.isClient)
                                ResumeDetailItem(
                                  label: 'Payment Offered',
                                  value: clientHiringHistory[index]
                                      ['paymentOffered'],
                                  svgIconPath: 'assets/svg/naira_icon.svg',
                                ),

                              // Location
                              ResumeDetailItem(
                                label: 'location',
                                value: widget.user.isDancer
                                    ? dancerWorkExp[index]['location']
                                            ?.toString() ??
                                        'N/A'
                                    : clientHiringHistory[index]['location']
                                            ?.toString() ??
                                        'N/A',
                                svgIconPath: 'assets/svg/location.svg',
                              ),
                              const SizedBox(height: 8),

                              // Job Description
                              Text(
                                'Description:',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.user.isDancer
                                    ? dancerWorkExp[index]['jobDescription']
                                            ?.toString() ??
                                        'N/A'
                                    : clientHiringHistory[index]
                                                ['jobDescription']
                                            ?.toString() ??
                                        'N/A',
                                style: textTheme.bodyMedium?.copyWith(
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: -20,
                        top: -15,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 30,
                          onPressed: dialogBoxToDeleteExp,
                          icon: Icon(
                            Icons.delete_forever,
                            color: colorScheme.error,
                          ),
                        ),
                      )
                    ],
                  );
                },
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.work_off,
                        size: 48,
                        color: colorScheme.onSurface.withOpacity(0.3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No work experience added yet',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> deleteExpDialogBox({
    required BuildContext context,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    required void Function(int index) deleteWorkExp,
    required int index,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 150,
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Are you sure you want to delete this work experience?',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.error,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close dialog box
                    IconButton.filled(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          colorScheme.primary,
                        ),
                      ),
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),

                    // Delete forever
                    IconButton.filled(
                      color: colorScheme.onError,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(colorScheme.error),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        deleteWorkExp(index);
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
