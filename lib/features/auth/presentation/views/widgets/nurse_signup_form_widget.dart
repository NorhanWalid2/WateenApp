import 'package:flutter/material.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/custom_button_widget.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/info_warning_box.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/label_textfield_widget.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/labeled_upload_field_widget.dart';

class NurseSignupFormWidget extends StatelessWidget {
  const NurseSignupFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          LabeledTextFieldWidget(
            title: 'Full Name',
            hintText: 'Enter your full name',
            icon: Icon(Icons.person),
          ),
          const SizedBox(height: 15),
          LabeledTextFieldWidget(
            title: 'Email',
            hintText: 'Enter your Email',
            icon: Icon(Icons.email),
          ),
          const SizedBox(height: 15),
          LabeledTextFieldWidget(
            title: 'Password',
            hintText: 'Create a password',
            icon: Icon(Icons.lock),
          ),
          const SizedBox(height: 15),
          LabeledTextFieldWidget(
            title: 'Phone Number',
            hintText: 'Enter your phone number',
            icon: Icon(Icons.phone),
          ),
          const SizedBox(height: 15),
          LabeledTextFieldWidget(
            title: 'Specialty',
            hintText: 'Enter your phone number',
            icon: Icon(Icons.phone),
          ),
          const SizedBox(height: 15),
          LabeledTextFieldWidget(
            title: 'Years of Experience',
            hintText: 'Enter years of experience',
            icon: Icon(Icons.phone),
          ),
          const SizedBox(height: 15),
          LabeledUploadFieldWidget(
            title: 'Medical Syndicate ID',
            document: 'Upload license',
            subtitle: 'PDF, JPG or PNG (Max 5MB)',
          ),
          const SizedBox(height: 15),
          LabeledUploadFieldWidget(
            title: 'Personal ID',
            document: 'Upload personal ID',
            subtitle: 'PDF, JPG or PNG (Max 5MB)',
          ),
          const SizedBox(height: 15),
          LabeledUploadFieldWidget(
            title: 'Profile Photo',
            document: 'Upload profile photo',
            subtitle: 'JPG or PNG (Max 5MB)',
          ),
          const SizedBox(height: 15),
          InfoWarningBox(),
          const SizedBox(height: 15),
          CustomButtonWidget(text: 'Submit for Approval'),
        ],
      ),
    );
  }
}
