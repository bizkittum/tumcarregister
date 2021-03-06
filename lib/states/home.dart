// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:tumregistercar/models/info_car_model.dart';
import 'package:tumregistercar/states/add_new_car.dart';
import 'package:tumregistercar/utility/my_constant.dart';
import 'package:tumregistercar/utility/sqlite_helper.dart';
import 'package:tumregistercar/widgets/show_button.dart';
import 'package:tumregistercar/widgets/show_progress.dart';
import 'package:tumregistercar/widgets/show_text.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<InfoCarModel>? infoCarModels;
  bool load = true;
  bool? haveData;

  @override
  void initState() {
    super.initState();
    readAllCar();
  }

  Future<void> readAllCar() async {
    await SQLiteHelper().readInfoCar().then((value) {
      infoCarModels = value;
      print('infoCarModels ==>> $infoCarModels');

      if (infoCarModels!.isEmpty) {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        setState(() {
          load = false;
          haveData = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ShowButton(
        label: 'Add New Car',
        pressFunc: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewCart(),
            )).then((value) => readAllCar()),
      ),
      appBar: AppBar(),
      body: load
          ? const ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: infoCarModels!.length,
                  itemBuilder: (context, index) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShowText(
                            label: infoCarModels![index].idRegister,
                            textStyle: MyConstant().h1Style(),
                          ),
                          ShowText(
                            label: infoCarModels![index].province,
                            textStyle: MyConstant().h2Style(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ShowText(label: '?????????????????? = ${infoCarModels![index].car}'),
                                 ShowText(label: '?????? = ${infoCarModels![index].color}'),
                                  ShowText(label: '???????????? = ${infoCarModels![index].model}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: ShowText(
                    label: 'No Car',
                    textStyle: MyConstant().h1Style(),
                  ),
                ),
    );
  }
}
