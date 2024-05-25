import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_text_controllers.dart';
import '../../data/model/path_model.dart';
import '../../data/repo/sharedpref_rep_imp.dart';
import '../../data/repo/webspark_rep_imp.dart';
import '../bloc/bfc_algorithm.dart';

class ApiUrlInputScreen extends StatefulWidget {
  const ApiUrlInputScreen({super.key});

  @override
  ApiUrlInputScreenState createState() => ApiUrlInputScreenState();
}

class ApiUrlInputScreenState extends State<ApiUrlInputScreen> {
  final TextEditingController _urlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SharedpreferencesRepImp _sharedpreferencesRepImp =
      SharedpreferencesRepImp();
  final WebsparkRepImp websparkRep = WebsparkRepImp();

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasScheme &&
        (uri.isScheme('http') || uri.isScheme('https'));
  }

  Future<List<PathData>> _fetchDataAndProcess() async {
    setState(() {});

    // ignore: inference_failure_on_instance_creation
    await Future.delayed(const Duration(seconds: 3));

    final result = await WebsparkRepImp().getInputParameters();
    final pathsData = <PathData>[];

    if (result?.data != null) {
      for (final data in result!.data) {
        final fieldMatrix = data.field.map((row) => row.split('')).toList();
        final start = [data.start.x, data.start.y];
        final end = [data.end.x, data.end.y];
        final pathFinder = PathFinder(fieldMatrix, start, end);
        final path = pathFinder.findShortestPath().join('->');
        pathsData.add(PathData(
          path: path,
          fieldMatrix: fieldMatrix,
          start: start,
          end: end,
        ));
      }
    } else {}

    setState(() {});
    return pathsData;
  }

  void _showResultPrompt(List<PathData> pathsData) {
    showModalBottomSheet<Widget>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Spacer(),
                const Text(
                  InputUrlController.showResults,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text(InputUrlController.sendResults),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(InputUrlController.closeButton),
                ),
              ],
            ),
          ),
        );
      },
      enableDrag: false,
    );
  }

  void _showLoadingIndicator() {
    final progressStream = (() async* {
      for (var i = 0; i <= 100; i++) {
        await Future.delayed(const Duration(milliseconds: 55));
        yield i;
      }
    })();

    showModalBottomSheet<Widget>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: StreamBuilder<int>(
                stream: progressStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final progress = snapshot.data!;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: progress / 100,
                              strokeWidth: 2,
                              strokeAlign: 20,
                            ),
                            Text(
                              '$progress%',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(InputUrlController.loading),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        );
      },
      enableDrag: false,
    );
  }

  Future<void> _showBottomSheet() async {
    _showLoadingIndicator();

    // Execute the main logic to fetch and process data
    final pathsData = await _fetchDataAndProcess();

    // Close the loading indicator and show the result prompt
    if (mounted) {
      Navigator.pop(context);
      _showResultPrompt(pathsData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(InputUrlController.apiUrlTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: InputUrlController.apiUrlHintText,
                  border: UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return InputUrlController.enterURL;
                  } else if (!_isValidUrl(value)) {
                    return InputUrlController.apiUrlErrorMessage;
                  }
                  return null;
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if ((_formKey.currentState?.validate() ?? false) == true) {
                      await _sharedpreferencesRepImp
                          .saveInputURl(_urlController.text);
                      await _showBottomSheet();
                    }
                  },
                  child:
                      const Text(InputUrlController.startElevatedButtonTitle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
