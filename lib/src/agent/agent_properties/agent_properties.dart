import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleeky_flutter/API/api_config.dart';
import 'package:gleeky_flutter/src/agent/bottom/agent.dart';
import 'package:gleeky_flutter/src/agent/controllers/agent_properties_controller.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/app_images.dart';
import 'package:gleeky_flutter/utills/snackBar.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:shimmer/shimmer.dart';

class AgentProperties extends StatefulWidget {
  const AgentProperties({Key? key}) : super(key: key);

  @override
  State<AgentProperties> createState() => _AgentPropertiesState();
}

class _AgentPropertiesState extends State<AgentProperties> {
  final ScrollController _scrollController = ScrollController();
  RxBool showCircle = false.obs;

  RxInt offset = 1.obs;
  @override
  initState() {
    AgentPropertiesController.to.agentPropertiesList.clear();
    AgentPropertiesController.to.agentPropertiesApi(
      params: {'status': 'All', 'page': offset.value, 'limit': 5},
      success: () {
        isShimmer.value = false;
        offset.value = offset.value + 1;
      },
      error: (e) {
        showSnackBar(title: ApiConfig.error, message: e.toString());
      },
    );

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        showCircle.value = true;
        AgentPropertiesController.to.agentPropertiesApi(
            params: {'status': 'All', 'page': offset.value, 'limit': 5},
            success: () {
              showCircle.value = false;
              offset.value = offset.value + 1;
            },
            error: (e) {});
      }
    });
    super.initState();
  }

  RxString dropDownValue = 'All'.obs;
  RxBool isShimmer = true.obs;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        agentSelectedBottom.value = 0;
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: Obx(() {
          return showCircle.value
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      CupertinoActivityIndicator(color: AppColors.colorFE6927),
                )
              : const SizedBox();
        }),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 27, right: 27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    /* IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.menu,
                        size: 25,
                      ),
                    ),*/
                    Expanded(
                      child: Center(
                        child: Text(
                          'Properties',
                          style: color00000s18w600,
                        ),
                      ),
                    ),
                    /*Opacity(
                      opacity: 0,
                      child: IgnorePointer(
                        ignoring: true,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.menu,
                            size: 25,
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'All Listings',
                        style: color00000s14w500,
                      ),
                    ),
                    /*  Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Text(
                            'Sort By:',
                            style: color00000s14w500,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: StreamBuilder(
                                stream: dropDownValue.stream,
                                builder: (context, snapshot) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: AppColors.color000000
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: DropdownButton<String>(
                                      value: dropDownValue.value,
                                      underline: const SizedBox(),
                                      borderRadius: BorderRadius.circular(6),
                                      style: color00000s14w500,
                                      isExpanded: true,
                                      icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          size: 20,
                                          color: AppColors.color000000),
                                      items: <String>[
                                        'All',
                                        'Listed',
                                        'Unlisted',
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: color00000s14w500),
                                        );
                                      }).toList(),
                                      onChanged: (_) {
                                        dropDownValue.value = _.toString();
                                      },
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),*/
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Obx(
                    () {
                      return isShimmer.value
                          ? SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  3,
                                  (index) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor: AppColors.colorD9D9D9
                                              .withOpacity(0.2),
                                          highlightColor: AppColors.colorD9D9D9,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://www.myglobalviewpoint.com/wp-content/uploads/2020/01/Most-beautiful-places-in-Switzerland-585x390.jpg',
                                              placeholder: (context, url) =>
                                                  CupertinoActivityIndicator(
                                                      color: AppColors
                                                          .colorFE6927),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      AppImages.profile_image),
                                              height: 130,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Shimmer.fromColors(
                                          baseColor: AppColors.colorD9D9D9
                                              .withOpacity(0.2),
                                          highlightColor: AppColors.colorD9D9D9,
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Sr. :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            'Dummuy Text',
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Status :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            'Dummuy Text',
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Accommodates :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            'Dummuy Text',
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Kitchen :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            'Dummuy Text',
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Location :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            'Dummuy Text',
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Property Name :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            'Dummuy Text',
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Price :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            'Dummuy Text',
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Bedrooms :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            'Dummuy Text',
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Bedrooms :',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            'Dummuy Text',
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Last Modified : ',
                                                          style:
                                                              color000000s12w400,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            'Dummuy Text',
                                                            style:
                                                                color000000s12w400
                                                                    .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .color000000
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Divider(
                                          color: AppColors.color000000
                                              .withOpacity(0.2),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : AgentPropertiesController
                                  .to.agentPropertiesList.isEmpty
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Container(
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                            color: AppColors.colorD9D9D9,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 40, horizontal: 50),
                                        child: Text(
                                          'You don\'t have any Properties yet!!',
                                          style: color00000s14w500,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SingleChildScrollView(
                                  controller: _scrollController,
                                  child: Column(
                                    children: List.generate(
                                      AgentPropertiesController
                                          .to.agentPropertiesList.length,
                                      (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl: AgentPropertiesController
                                                            .to
                                                            .agentPropertiesList[
                                                        index]['cover_photo'] ??
                                                    "",
                                                placeholder: (context, url) =>
                                                    CupertinoActivityIndicator(
                                                        color: AppColors
                                                            .colorFE6927),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Icon(
                                                        Icons.error_outline),
                                                height: 130,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Sr. :',
                                                            style:
                                                                color000000s12w400,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              '${index + 1}',
                                                              style:
                                                                  color000000s12w400
                                                                      .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .color000000
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Status :',
                                                            style:
                                                                color000000s12w400,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              AgentPropertiesController
                                                                              .to
                                                                              .agentPropertiesList[
                                                                          index]
                                                                      [
                                                                      'status'] ??
                                                                  "",
                                                              style:
                                                                  color000000s12w400
                                                                      .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .color000000
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Accommodates :',
                                                            style:
                                                                color000000s12w400,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              (AgentPropertiesController
                                                                              .to
                                                                              .agentPropertiesList[index]
                                                                          [
                                                                          'accommodates'] ??
                                                                      0)
                                                                  .toString(),
                                                              style:
                                                                  color000000s12w400
                                                                      .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .color000000
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Kitchen :',
                                                            style:
                                                                color000000s12w400,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              (AgentPropertiesController
                                                                              .to
                                                                              .agentPropertiesList[index]
                                                                          [
                                                                          'kitchen'] ??
                                                                      0)
                                                                  .toString(),
                                                              style:
                                                                  color000000s12w400
                                                                      .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .color000000
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Location :',
                                                            style:
                                                                color000000s12w400,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              '${AgentPropertiesController.to.agentPropertiesList[index]['property_address']['city'] ?? ''}, ${AgentPropertiesController.to.agentPropertiesList[index]['property_address']['state'] ?? ''}, ${AgentPropertiesController.to.agentPropertiesList[index]['property_address']['country'] ?? ''}',
                                                              style:
                                                                  color000000s12w400
                                                                      .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .color000000
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Property Name :',
                                                            style:
                                                                color000000s12w400,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              (AgentPropertiesController
                                                                              .to
                                                                              .agentPropertiesList[index]
                                                                          [
                                                                          'name'] ??
                                                                      '')
                                                                  .toString(),
                                                              style:
                                                                  color000000s12w400
                                                                      .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .color000000
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Price :',
                                                            style:
                                                                color000000s12w400,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              '₹ ${AgentPropertiesController.to.agentPropertiesList[index]['property_price']?['price'] ?? '0'} /night',
                                                              style:
                                                                  color000000s12w400
                                                                      .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .color000000
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Bedrooms :',
                                                            style:
                                                                color000000s12w400,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              (AgentPropertiesController
                                                                              .to
                                                                              .agentPropertiesList[index]
                                                                          [
                                                                          'bedrooms'] ??
                                                                      '0')
                                                                  .toString(),
                                                              style:
                                                                  color000000s12w400
                                                                      .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .color000000
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Bathroom :',
                                                            style:
                                                                color000000s12w400,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              (AgentPropertiesController
                                                                              .to
                                                                              .agentPropertiesList[index]
                                                                          [
                                                                          'bathrooms'] ??
                                                                      '0')
                                                                  .toString(),
                                                              style:
                                                                  color000000s12w400
                                                                      .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .color000000
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Last Modified : ',
                                                            style:
                                                                color000000s12w400,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              (AgentPropertiesController
                                                                              .to
                                                                              .agentPropertiesList[index]
                                                                          [
                                                                          'updated_at'] ??
                                                                      '')
                                                                  .toString(),
                                                              style:
                                                                  color000000s12w400
                                                                      .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .color000000
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Divider(
                                              color: AppColors.color000000
                                                  .withOpacity(0.2),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
