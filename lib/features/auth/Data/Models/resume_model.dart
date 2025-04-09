import 'package:legwork/features/auth/Domain/Entities/resume_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResumeModel extends ResumeEntity {
  // Constructor
  ResumeModel({
    required super.professionalTitle,
    required super.workExperience,
    super.resumeFile,
  });

  /// Convert firebase doc to Resume  so we can use in app
  factory ResumeModel.fromDocument(DocumentSnapshot doc) {
    return ResumeModel(
      professionalTitle: doc['professionalTitle'] ?? '',
      workExperience: doc['workExperience'] ?? [],
      resumeFile: doc['resumeFile'] ?? '',
    );
  }

  /// Convert resume to firebase doc
  Map<String, dynamic> toMap() {
    return {
      'professionalTitle': professionalTitle,
      'workExperience': workExperience,
      'resumeFile': resumeFile,
    };
  }

  // Convert Resume to entity for business logic use
  ResumeEntity toResumeEntity() {
    return ResumeEntity(
      professionalTitle: professionalTitle,
      workExperience: workExperience,
      resumeFile: resumeFile,
    );
  }
}
