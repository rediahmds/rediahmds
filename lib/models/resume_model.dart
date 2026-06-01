class ResumeModel {
  final PersonalModel personal;
  final SkillsModel skills;
  final List<EducationModel> education;
  final List<ExperienceModel> experience;
  final List<ProjectModel> projects;
  final List<CertificateModel> certificates;

  ResumeModel({
    required this.personal,
    required this.skills,
    required this.education,
    required this.experience,
    required this.projects,
    required this.certificates,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      personal: PersonalModel.fromJson(json['personal']),
      skills: SkillsModel.fromJson(json['skills']),
      education: (json['education'] as List)
          .map((e) => EducationModel.fromJson(e))
          .toList(),
      experience: (json['experience'] as List)
          .map((e) => ExperienceModel.fromJson(e))
          .toList(),
      projects: (json['projects'] as List)
          .map((e) => ProjectModel.fromJson(e))
          .toList(),
      certificates: (json['certificates'] as List)
          .map((e) => CertificateModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personal': personal.toJson(),
      'skills': skills.toJson(),
      'education': education.map((e) => e.toJson()).toList(),
      'experience': experience.map((e) => e.toJson()).toList(),
      'projects': projects.map((e) => e.toJson()).toList(),
      'certificates': certificates.map((e) => e.toJson()).toList(),
    };
  }
}

class PersonalModel {
  final String name;
  final String location;
  final String email;
  final String github;
  final String linkedin;
  final String title;
  final String bio;

  PersonalModel({
    required this.name,
    required this.location,
    required this.email,
    required this.github,
    required this.linkedin,
    required this.title,
    required this.bio,
  });

  factory PersonalModel.fromJson(Map<String, dynamic> json) {
    return PersonalModel(
      name: json['name'],
      location: json['location'],
      email: json['email'],
      github: json['github'],
      linkedin: json['linkedin'],
      title: json['title'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'email': email,
      'github': github,
      'linkedin': linkedin,
      'title': title,
      'bio': bio,
    };
  }
}

class SkillsModel {
  final List<String> languages;
  final List<String> backendCloud;
  final List<String> mobile;
  final List<String> devopsTools;

  SkillsModel({
    required this.languages,
    required this.backendCloud,
    required this.mobile,
    required this.devopsTools,
  });

  factory SkillsModel.fromJson(Map<String, dynamic> json) {
    return SkillsModel(
      languages: List<String>.from(json['languages']),
      backendCloud: List<String>.from(json['backend_cloud']),
      mobile: List<String>.from(json['mobile']),
      devopsTools: List<String>.from(json['devops_tools']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languages': languages,
      'backend_cloud': backendCloud,
      'mobile': mobile,
      'devops_tools': devopsTools,
    };
  }
}

class EducationModel {
  final String institution;
  final String location;
  final String degree;
  final String period;
  final List<String> details;

  EducationModel({
    required this.institution,
    required this.location,
    required this.degree,
    required this.period,
    required this.details,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      institution: json['institution'],
      location: json['location'],
      degree: json['degree'],
      period: json['period'],
      details: List<String>.from(json['details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'location': location,
      'degree': degree,
      'period': period,
      'details': details,
    };
  }
}

class ExperienceModel {
  final String company;
  final String location;
  final String role;
  final String period;
  final List<String> bullets;

  ExperienceModel({
    required this.company,
    required this.location,
    required this.role,
    required this.period,
    required this.bullets,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      company: json['company'],
      location: json['location'],
      role: json['role'],
      period: json['period'],
      bullets: List<String>.from(json['bullets']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'location': location,
      'role': role,
      'period': period,
      'bullets': bullets,
    };
  }
}

class ProjectModel {
  final String name;
  final String period;
  final String github;
  final List<String> bullets;

  ProjectModel({
    required this.name,
    required this.period,
    required this.github,
    required this.bullets,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      name: json['name'],
      period: json['period'],
      github: json['github'],
      bullets: List<String>.from(json['bullets']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'period': period,
      'github': github,
      'bullets': bullets,
    };
  }
}

class CertificateModel {
  final String name;
  final String date;
  final String url;

  CertificateModel({
    required this.name,
    required this.date,
    required this.url,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      name: json['name'],
      date: json['date'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date,
      'url': url,
    };
  }
}
