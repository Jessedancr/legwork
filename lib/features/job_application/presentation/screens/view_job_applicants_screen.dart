import 'package:flutter/material.dart';
import 'package:legwork/Features/job_application/presentation/provider/job_application_provider.dart';
import 'package:provider/provider.dart';

class ViewJobApplicantsScreen extends StatefulWidget {
  final String jobId;
  final String clientId;

  const ViewJobApplicantsScreen({
    super.key,
    required this.jobId,
    required this.clientId,
  });

  @override
  State<ViewJobApplicantsScreen> createState() =>
      _ViewJobApplicantsScreenState();
}

class _ViewJobApplicantsScreenState extends State<ViewJobApplicantsScreen> {
  final TextEditingController proposalController = TextEditingController();

  // Init state to fetch all job applications when the screen loads
  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<JobApplicationProvider>(context, listen: false);
    provider.getJobApplications(widget.jobId);
  }

  @override
  Widget build(BuildContext context) {
    // Extract arguments passed to the next screen from the navigation
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    debugPrint("Job ID: ${args['jobId']}, Client ID: ${args['clientId']}");

    final String jobId = args['jobId'];
    final String clientId = args['clientId'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Job Applicants",
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer<JobApplicationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.allApplications.isEmpty) {
            debugPrint(
              "Job applications: ${provider.allApplications.toString()}",
            );
            return const Center(
              child: Text(
                "No applicants yet.",
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.allApplications.length,
            itemBuilder: (context, index) {
              final app = provider.allApplications[index];
              return ListTile(
                title: Text("Proposal by ${app.dancerId}"),
                subtitle: Text(app.proposal),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/job_application_detail',
                    arguments: app,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
