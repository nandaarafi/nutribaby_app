import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutribaby_app/features/authentication/presentation/cubit/user_data_cubit.dart';
import 'package:nutribaby_app/features/authentication/presentation/widgets/custom_button.dart';

import '../../data/user_data_data_service.dart';

class ShowUsersScreen extends StatefulWidget {
  const ShowUsersScreen({super.key});
  @override
  State<ShowUsersScreen> createState() => _ShowUsersScreenState();
}

class _ShowUsersScreenState extends State<ShowUsersScreen> {
  @override
  void dispose() {
    super.dispose();
  }
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    context.read<UserDataCubit>().getAllEmailData();
  }
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("CSV file saved successfully on Download folder"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Failed to save CSV file."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _downloadAllUserDataAsCSV() async {
    setState(() {
      _isLoading = true;
    });

    String csvData = await UserDataService().getAllUserDataAsCSV();
    if (csvData.isNotEmpty) {
      try {
        await UserDataService().writeCSVAllUserToFile(csvData, '/storage/emulated/0/Download/admin/');
        _showSuccessDialog();
      } catch (e) {
        print('Error saving CSV: $e');
        setState(() {
          _isLoading = false;
        });
        _showFailureDialog();
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _showFailureDialog();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _downloadUserDataAsCsv(String email, String userId) async {
    String csvData = await UserDataService().getUserDataAsCSV(userId);
    if (csvData.isNotEmpty) {
      try {
        await UserDataService().writeCSVToFile(csvData, '/storage/emulated/0/Download/admin/${email}/');
        _showSuccessDialog();
      } catch (e) {
        print('Error saving CSV: $e');
        _showFailureDialog();
      }
    } else {
      _showFailureDialog();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Data User")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<UserDataCubit, UserDataState>(
              builder: (context, state) {
                if (state is UserDataLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserDataSuccess) {
                  return Container(
                    width: double.infinity,
                    height: 300,
                    child: DataTable2(
                      columnSpacing: 6,
                      horizontalMargin: 6,
                      minWidth: 300,
                      columns: const [
                        DataColumn2(
                          label: Text(
                            'List User Email',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          size: ColumnSize.L,
                        ),
                        // DataColumn2(
                        //   label: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text(''),
                        //   ),
                        //   size: ColumnSize.S,
                        // ),
                      ],
                      rows: state.emails.map((data) {
                        return DataRow(
                          cells: [
                            DataCell(Text(data.email)),
                            // DataCell(
                            //       IconButton(
                            //         icon: Icon(Icons.download),
                            //         onPressed:(){ _downloadUserDataAsCsv(data.email, data.docId);
                            //       }),

                            // ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                } else if (state is UserDataFailed) {
                  return Center(child: Text(state.error));
                } else {
                  return Container();
                }
              },
            ),
            //Button Download All Files
            SizedBox(height: 30),
            _isLoading ? CircularProgressIndicator() :
            CustomButton(
                title: "Download All Data",
                onPressed: _downloadAllUserDataAsCSV,
                )
          ],
        ),
      ),
    );
  }

}
