import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverr/PERSISTENT/persistent.dart';
import 'package:fiverr/SERVICES/global_methods.dart';
import 'package:fiverr/SERVICES/global_variables.dart';
import 'package:fiverr/Widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class UploadJobNow extends StatefulWidget {
  UploadJobNow({Key? key}) : super(key: key);

  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  final TextEditingController _jobCategoryController =
      TextEditingController(text: "Select Job Category");
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _jobDeadlineController =
      TextEditingController(text: "Job Deadline Date");
  final _formKey = GlobalKey<FormState>();
  Timestamp? deadlineDateTimeStamp;
  DateTime? picked;
  bool _isLoading = false;

  @override
  void dispose() {
    _jobCategoryController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _jobDeadlineController.dispose();

    super.dispose();
  }

  Widget _textTitle({required String lable}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        lable,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textFormField({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Value is missing";
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: const TextStyle(
            color: Colors.white,
          ),
          maxLines: valueKey == "JobDescription" ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.black54,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 0),
      ),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _jobDeadlineController.text =
            "${picked!.year}-${picked!.month}-${picked!.day}";
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (
        ctx,
      ) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: const Text(
            "Job Category",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),
          content: Container(
            width: size.width * 0.9,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _jobCategoryController.text =
                            Persistent.jobCategoryList[index];
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.green,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _uploadTask() async {
    final jobId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (_jobDeadlineController.text == "Choose job Deadline date" ||
          _jobCategoryController.text == "Choose job category") {
        GlobalMethods.showErrorDialog(
            error: "Please pick everything", ctx: context);
        return;
      }
      setState(() {
        _isLoading == true;
      });
      try {
        await FirebaseFirestore.instance.collection("jobs").doc(jobId).set({
          "jobId": jobId,
          "uploadedBy": _uid,
          "email": user.email,
          "jobTitle": _jobTitleController.text,
          "jobDescription": _jobDescriptionController.text,
          "deadLineDate": _jobDeadlineController.text,
          "deadlineDateTimeStamp": deadlineDateTimeStamp,
          "jobCategory": _jobCategoryController.text,
          "jobComments": [],
          "recruitment": true,
          "createdAt": Timestamp.now(),
          "name": name,
          "userImage": userImage,
          "location": location,
          "applocants": 0,
        });
        await Fluttertoast.showToast(
            msg: "The task has been uploaded",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.grey,
            fontSize: 18);
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        setState(() {
          _jobCategoryController.text = "Choose job category";
          _jobDeadlineController.text = "Choose job deadline date";
        });
      } catch (e) {
        {
          setState(() {
            _isLoading = false;
          });
          GlobalMethods.showErrorDialog(error: e.toString(), ctx: context);
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("Its not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pinkAccent, Colors.redAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarApp(indexNum: 2),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Upload Job Now "),
          backgroundColor: const Color.fromARGB(49, 94, 1, 65),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Please fill all fields",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitle(lable: "Job Category"),
                            _textFormField(
                              valueKey: "Job Category: ",
                              controller: _jobCategoryController,
                              enabled: false,
                              fct: () {
                                _showTaskCategoriesDialog(size: size);
                              },
                              maxLength: 100,
                            ),
                            _textTitle(lable: "Job Titile"),
                            _textFormField(
                              valueKey: "Job Titile: ",
                              controller: _jobTitleController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100,
                            ),
                            _textTitle(lable: "Job Description"),
                            _textFormField(
                              valueKey: "JobDescription",
                              controller: _jobDescriptionController,
                              enabled: true,
                              fct: () {},
                              maxLength: 1000,
                            ),
                            _textTitle(lable: "Job Deadline"),
                            _textFormField(
                              valueKey: "Job Deadline Date",
                              controller: _jobDeadlineController,
                              enabled: false,
                              fct: () {
                                _pickDateDialog();
                              },
                              maxLength: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : MaterialButton(
                                onPressed: () {
                                  _uploadTask();
                                },
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "Post Now",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                      SizedBox(width: 9),
                                      Icon(
                                        Icons.upload,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
