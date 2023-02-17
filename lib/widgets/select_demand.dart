import 'package:data_collect_v2/utils/alert.dart';
import 'package:data_collect_v2/utils/my_colors.dart';
import 'package:flutter/material.dart';

class SelectDemandCotainer extends StatefulWidget {
  final List<String> demandList;
  final Function getList;
  final int maxSelect;
  const SelectDemandCotainer(
      {required this.demandList,
      required this.getList,
      required this.maxSelect,
      super.key});

  @override
  State<SelectDemandCotainer> createState() => _SelectDemandCotainerState();
}

class _SelectDemandCotainerState extends State<SelectDemandCotainer> {
  List<String> listOfSelectedDemand = [];

  void _getList() {
    widget.getList(listOfSelectedDemand);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.demandList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        widget.demandList[index],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (listOfSelectedDemand
                            .contains(widget.demandList[index])) {
                          listOfSelectedDemand.remove(widget.demandList[index]);
                        } else if (!listOfSelectedDemand
                                .contains(widget.demandList[index]) &&
                            listOfSelectedDemand.length >= widget.maxSelect) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            Alert.snackBar(
                              message: 'You can select a maximum of ${widget.maxSelect} items',
                              context: context,
                            ),
                          );
                        } else {
                          listOfSelectedDemand.add(widget.demandList[index]);
                        }
                        _getList();
                        setState(() {});
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: MyColors.buttonColor,
                            width: 3,
                          ),
                        ),
                        child: listOfSelectedDemand
                                .contains(widget.demandList[index])
                            ? const Icon(
                                Icons.check,
                              )
                            : const Text(
                                '.',
                              ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
