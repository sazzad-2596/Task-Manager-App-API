

import 'package:flutter/material.dart';

import '../../data/models/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import '../../style/styles.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/task_list_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  bool getTaskListInProgress = false;
  TaskListModel taskListModel = TaskListModel();

  Future<void> getTaskList() async {
    getTaskListInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.getCompleteTaskList);
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }
    getTaskListInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummeryCard(),
            Expanded(
              child: Visibility(
                visible: getTaskListInProgress == false,
                replacement: Center(
                  child: CircularProgressIndicator(color: PrimaryColor.color),
                ),
                child: RefreshIndicator(
                  color: PrimaryColor.color,
                  onRefresh: getTaskList,
                  child: ListView.builder(
                    itemCount: taskListModel.taskList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskListCard(
                        statusColor: PrimaryColor.color,
                        task: taskListModel.taskList![index],
                        onStatusChangeRefresh: () {
                          getTaskList();
                        },
                        taskUpdateStatusInProgress: (inProgress) {
                          getTaskListInProgress = inProgress;
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}