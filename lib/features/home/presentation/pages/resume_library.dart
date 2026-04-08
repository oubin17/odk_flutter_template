import 'package:flutter/material.dart';
import 'package:odk_flutter_template/features/home/data/models/resume_library.dart';
import 'package:odk_flutter_template/features/home/domain/home_resume_service.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/appbar/app_bar.dart';
import 'package:odk_flutter_template/widgets/button/basic_app_button.dart';

class ResumeLibraryPage extends StatefulWidget {
  const ResumeLibraryPage({super.key});

  @override
  State<ResumeLibraryPage> createState() => _ResumeLibraryPageState();
}

class _ResumeLibraryPageState extends State<ResumeLibraryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _idNoController = TextEditingController();
  final _workAddrController = TextEditingController();
  final _domicileController = TextEditingController();
  final _extendInfoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(title: Text('添加客户')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildNameField(),
              const SizedBox(height: 5),
              _buildMobileField(),
              const SizedBox(height: 5),
              _buildAgeField(),
              const SizedBox(height: 5),
              _buildGenderField(),
              const SizedBox(height: 5),
              _buildIdNoField(),
              const SizedBox(height: 5),
              _buildWorkAddrField(),
              const SizedBox(height: 5),
              _buildDomicileField(),
              const SizedBox(height: 5),
              _buildExtendInfoField(),
              const SizedBox(height: 16),

              BasicAppButton(
                onPressed: () {
                  _submitResume();
                },
                title: '提交',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitResume() async {
    if (_formKey.currentState!.validate()) {
      // 提交数据
      final resume = ResumeLibraryInfo(
        name: _nameController.text,
        mobile: _mobileController.text,
        age: _ageController.text,
        gender: _genderController.text == '男' ? '1' : '2',
        domicile: _domicileController.text,
        extendInfo: _extendInfoController.text,
        workAddr: _workAddrController.text,
        idNo: _idNoController.text,
      );
      final result = await HomeResumeService().privateResumeAdd(resume);

      if (result == true) {
        // 这会清空所有输入框的内容，并清除所有校验错误提示
        _formKey.currentState?.reset();
        // 提交成功
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('简历提交成功！')));
      } else {
        // 提交失败
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result)));
      }
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: '姓名',
        prefixIcon: Icon(Icons.person),
        // border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '姓名不能为空';
        }
        if (value.length < 2 || value.length > 50) {
          return '名称长度在 2 到 50 个字符';
        }
        return null;
      },
    );
  }

  Widget _buildMobileField() {
    return TextFormField(
      controller: _mobileController,
      decoration: const InputDecoration(
        labelText: '手机号',
        prefixIcon: Icon(Icons.phone),
        // border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '手机号不能为空';
        }
        final RegExp phoneRegex = RegExp(r'^1[3-9]\d{9}$');

        if (!phoneRegex.hasMatch(value)) {
          return '手机号格式不正确';
        }
        return null;
      },
    );
  }

  Widget _buildAgeField() {
    return TextFormField(
      controller: _ageController,
      decoration: const InputDecoration(
        labelText: '年龄(不低于18周岁)',
        prefixIcon: Icon(Icons.calendar_today),
        // border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '年龄不能为空';
        }
        if (int.tryParse(value) != null && int.tryParse(value)! > 18) {
          return null;
        } else {
          return '请输入正确的年龄格式';
        }
      },
    );
  }

  Widget _buildGenderField() {
    return TextFormField(
      controller: _genderController,
      decoration: const InputDecoration(
        labelText: '性别',
        prefixIcon: Icon(Icons.wc),
        // border: OutlineInputBorder(),
      ),
      readOnly: true,
      onTap: () {
        _showGenderDialog();
      },
    );
  }

  Widget _buildIdNoField() {
    return TextFormField(
      controller: _idNoController,
      decoration: const InputDecoration(
        labelText: '身份证号',
        prefixIcon: Icon(Icons.perm_identity_rounded),
        // border: OutlineInputBorder(),
      ),
      validator: (value) {
        // 如果为空字符串，转为 null（或者直接用 value?.isEmpty 判断）
        if (value?.isEmpty == true) return null;

        // 正则：18位，前17位数字，最后一位数字或X/x
        final RegExp regex = RegExp(r'^\d{17}[\dXx]$');

        if (!regex.hasMatch(value!)) {
          return '请输入正确的身份证号';
        }
        return null;
      },
    );
  }

  Widget _buildWorkAddrField() {
    return TextFormField(
      controller: _workAddrController,
      decoration: const InputDecoration(
        labelText: '工作地址',
        prefixIcon: Icon(Icons.location_on),
        // border: OutlineInputBorder(),
      ),
      validator: (value) {
        // if (value == null || value.isEmpty) {
        //   return '工作地址不能为空';
        // }
        return null;
      },
    );
  }

  Widget _buildDomicileField() {
    return TextFormField(
      controller: _domicileController,
      decoration: const InputDecoration(
        labelText: '户籍地址',
        prefixIcon: Icon(Icons.location_on),
        // border: OutlineInputBorder(),
      ),
      validator: (value) {
        // if (value == null || value.isEmpty) {
        //   return '户籍地址不能为空';
        // }
        return null;
      },
    );
  }

  Widget _buildExtendInfoField() {
    return TextFormField(
      controller: _extendInfoController,
      decoration: const InputDecoration(
        labelText: '扩展信息',
        prefixIcon: Icon(Icons.info),
        // border: OutlineInputBorder(),
      ),
      validator: (value) {
        // if (value == null || value.isEmpty) {
        //   return '扩展信息不能为空';
        // }
        return null;
      },
    );
  }

  void _showGenderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择性别'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('男'),
                onTap: () {
                  _genderController.text = '男';
                  NavigatorUtils.pop();
                },
              ),
              ListTile(
                title: const Text('女'),
                onTap: () {
                  _genderController.text = '女';
                  NavigatorUtils.pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
