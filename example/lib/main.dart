import 'dart:developer';
import 'dart:math' hide log;

import 'package:demo_plugin_example/components/custom_floating_action_button.dart';
import 'package:demo_plugin_example/components/recenter_button.dart';
import 'package:demo_plugin_example/components/reoder_waypoint_widget.dart';
import 'package:demo_plugin_example/components/route_control_buttons.dart';
import 'package:demo_plugin_example/core/map_action.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vietmap_flutter_navigation/vietmap_flutter_navigation.dart';

import 'components/bottom_sheet_address_info.dart';
import 'components/floating_search_bar.dart';
import 'data/models/vietmap_place_model.dart';
import 'data/models/vietmap_reverse_model.dart';
import 'domain/repository/vietmap_api_repositories.dart';
import 'domain/usecase/get_location_from_latlng_usecase.dart';
import 'domain/usecase/get_place_detail_usecase.dart';

void main() {
  runApp(MaterialApp(
    builder: EasyLoading.init(),
    title: 'VietMap Navigation example app',
    home: const VietMapNavigationScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class VietMapNavigationScreen extends StatefulWidget {
  const VietMapNavigationScreen({super.key});

  @override
  State<VietMapNavigationScreen> createState() =>
      _VietMapNavigationScreenState();
}

class _VietMapNavigationScreenState extends State<VietMapNavigationScreen> {
  MapNavigationViewController? _controller;
  late MapOptions _navigationOption;
  final _vietmapNavigationPlugin = VietMapNavigationPlugin();

  List<LatLng> waypoints = [];
  Widget instructionImage = const SizedBox.shrink();
  String guideDirection = "";
  Widget recenterButton = const SizedBox.shrink();
  RouteProgressEvent? routeProgressEvent;
  bool _isRouteBuilt = false;
  bool _isRunning = false;
  bool isEdittingWaypoints = false;
  FocusNode focusNode = FocusNode();
  MapAction? currentAction;
  LatLng? userLocation = const LatLng(10.759084389388574, 106.67596449603656);
  @override
  void initState() {
    super.initState();

    initialize();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var permissionLocation = await Geolocator.requestPermission();
      if (permissionLocation != LocationPermission.denied &&
          permissionLocation != LocationPermission.deniedForever) {
        var positionLocation = await Geolocator.getCurrentPosition();
        userLocation =
            LatLng(positionLocation.latitude, positionLocation.longitude);
      }
    });
  }

  Future<void> initialize() async {
    if (!mounted) return;

    _navigationOption = _vietmapNavigationPlugin.getDefaultOptions();
    _navigationOption.simulateRoute = false;

    _navigationOption.apiKey = 'YOUR_API_KEY_HERE';
    _navigationOption.mapStyle =
        "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=YOUR_API_KEY_HERE";

    _vietmapNavigationPlugin.setDefaultOptions(_navigationOption);
  }

  Future<void> resetActions() async {
    switch (currentAction) {
      case MapAction.removeAllMarkers:
        await _controller?.removeAllMarkers();
        break;
      case MapAction.buildRoute:
        await _controller?.clearRoute();
        waypoints.clear();
        setState(() {
          _isRouteBuilt = false;
          isEdittingWaypoints = false;
        });
        break;
      default:
        break;
    }
  }

  MapOptions? options;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButtonGroup(
        buttons: [
          CustomFloatingActionButton(
            onPressed: () {
              if (waypoints.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Vui lòng thêm điểm dừng để xây dựng tuyến đường')));
                return;
              }
              _controller?.buildRoute(waypoints: [userLocation!, ...waypoints]);
              currentAction = MapAction.buildRoute;
            },
            icon: Icons.route_outlined,
            heroTag: "build_route",
            backgroundColor: const Color(0xFF2196F3),
            tooltip: 'Xây dựng tuyến đường',
          ),
          CustomFloatingActionButton(
            onPressed: () async {
              await resetActions();
            },
            icon: Icons.clear_all_outlined,
            heroTag: "clear_all",
            backgroundColor: const Color(0xFFF44336),
            tooltip: 'Xóa tất cả',
          ),
          CustomFloatingActionButton(
            onPressed: () async {
              await Geolocator.getCurrentPosition().then((position) {
                _controller?.moveCamera(
                  latLng: LatLng(position.latitude, position.longitude),
                  zoom: 15,
                  tilt: 0,
                  bearing: 0,
                );
              });
            },
            icon: Icons.my_location,
            heroTag: "my_location",
            backgroundColor: Colors.green,
            tooltip: 'Vị trí',
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            NavigationView(
              onRouteBuildFailed: (p0) {
                EasyLoading.dismiss();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Không thể tìm tuyến đường')));
              },
              onMarkerClicked: (p0) {
                debugPrint(p0.toString());
                log("marker clicked");
                _controller?.removeMarkers([p0 ?? 0]);
              },
              mapOptions: _navigationOption,
              onNewRouteSelected: (p0) {
                log(p0.toString());
              },
              onMapCreated: (p0) {
                _controller = p0;
              },
              onMapMove: () => _showRecenterButton(),
              onRouteBuilt: (p0) {
                setState(() {
                  EasyLoading.dismiss();
                  _isRouteBuilt = true;
                });
                debugPrint(p0.geometry);
              },
              onMapRendered: () async {},
              onMapLongClick: (LatLng? latLng, Point? point) async {
                if (_isRunning) return;
                EasyLoading.show();
                var data =
                    await GetLocationFromLatLngUseCase(VietmapApiRepositories())
                        .call(LocationPoint(
                            lat: latLng?.latitude ?? 0,
                            long: latLng?.longitude ?? 0));
                EasyLoading.dismiss();
                data.fold((l) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Có lỗi xảy ra')));
                }, (r) => _showBottomSheetInfo(r));
              },
              onMapClick: (LatLng? latLng, Point? point) async {
                if (_isRunning) return;
                if (focusNode.hasFocus) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  return;
                }

                var dataQuery = await _controller?.queryRenderedFeatures(
                    point: Point(
                        point?.x.toDouble() ?? 0, point?.y.toDouble() ?? 0));
                log(dataQuery.toString());
                if (dataQuery?.isNotEmpty == true) {}

                EasyLoading.show();
                var data =
                    await GetLocationFromLatLngUseCase(VietmapApiRepositories())
                        .call(LocationPoint(
                            lat: latLng?.latitude ?? 0,
                            long: latLng?.longitude ?? 0));
                EasyLoading.dismiss();
                data.fold((l) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Không tìm thấy địa điểm gần vị trí bạn chọn')));
                }, (r) {
                  _showBottomSheetInfo(r);
                });
              },
              onRouteProgressChange: (RouteProgressEvent routeProgressEvent) {
                // print('-----------ProgressChange----------');
                // print(routeProgressEvent.currentLocation?.bearing);
                // print(routeProgressEvent.currentLocation?.altitude);
                // print(routeProgressEvent.currentLocation?.accuracy);
                // print(routeProgressEvent.currentLocation?.bearing);
                // print(routeProgressEvent.currentLocation?.latitude);
                // print(routeProgressEvent.currentLocation?.longitude);
                setState(() {
                  this.routeProgressEvent = routeProgressEvent;
                });
                _setInstructionImage(routeProgressEvent.currentModifier,
                    routeProgressEvent.currentModifierType);
              },
              onArrival: () {
                _isRunning = false;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Container(
                        height: 100,
                        color: Colors.red,
                        child: const Text('Bạn đã tới đích'))));
              },
            ),
            Positioned(
                top: MediaQuery.of(context).viewPadding.top,
                left: 0,
                child: BannerInstructionView(
                  routeProgressEvent: routeProgressEvent,
                  instructionIcon: instructionImage,
                )),
            Positioned(
                bottom: 0,
                child: BottomActionView(
                  recenterButton: recenterButton,
                  controller: _controller,
                  onOverviewCallback: _showRecenterButton,
                  onStopNavigationCallback: _onStopNavigation,
                  routeProgressEvent: routeProgressEvent,
                )),
            _isRunning
                ? const SizedBox.shrink()
                : Positioned(
                    top: MediaQuery.of(context).viewPadding.top + 20,
                    child: isEdittingWaypoints
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: ReoderWaypointWidget(
                              waypoints: waypoints,
                              onWaypointsChanged: (newWaypoints) {
                                waypoints = newWaypoints;
                                _controller?.buildRoute(waypoints: waypoints);
                              },
                              onBack: () {
                                setState(() {
                                  isEdittingWaypoints = false;
                                });
                              },
                              onWaypointDelete: (p0) {
                                setState(() {
                                  waypoints.removeAt(p0);
                                });
                                _controller?.buildRoute(waypoints: waypoints);
                              },
                              onWaypointTap: (p0) {
                                _controller?.moveCamera(
                                  latLng: waypoints[p0],
                                  zoom: 1,
                                  tilt: 0,
                                  bearing: 0,
                                );
                              },
                            ),
                          )
                        : FloatingSearchBar(
                            focusNode: focusNode,
                            onSearchItemClick: (p0) async {
                              EasyLoading.show();
                              VietmapPlaceModel? data;
                              var res = await GetPlaceDetailUseCase(
                                      VietmapApiRepositories())
                                  .call(p0.refId ?? '');
                              res.fold((l) {
                                EasyLoading.dismiss();
                                return;
                              }, (r) {
                                data = r;
                              });
                              waypoints.clear();
                              var location =
                                  await Geolocator.getCurrentPosition();
                              waypoints.add(LatLng(
                                  location.latitude, location.longitude));
                              if (data?.lat != null) {
                                waypoints.add(
                                    LatLng(data?.lat ?? 0, data?.lng ?? 0));
                              }
                              _controller?.buildRoute(waypoints: waypoints);
                            },
                          )),
            _isRouteBuilt && !_isRunning
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: RouteControlButtons(
                      onStartNavigation: () {
                        setState(() {
                          _isRunning = true;
                        });
                        _controller?.startNavigation();
                      },
                      onClearRoute: () {
                        _controller?.clearRoute();
                        waypoints.clear();
                        setState(() {
                          _isRouteBuilt = false;
                          isEdittingWaypoints = false;
                        });
                      },
                      onEditWaypoints: () {
                        var tempWaypoints = List<LatLng>.from(waypoints);
                        waypoints.clear();
                        waypoints.add(userLocation!);
                        waypoints.addAll(tempWaypoints);
                        setState(() {
                          isEdittingWaypoints = !isEdittingWaypoints;
                        });
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  _showRecenterButton() {
    setState(() {
      recenterButton = RecenterButton(
        onPressed: () {
          _controller?.recenter();
          setState(() {
            recenterButton = const SizedBox.shrink();
          });
        },
      );
    });
  }

  _setInstructionImage(String? modifier, String? type) {
    if (modifier != null && type != null) {
      List<String> data = [
        type.replaceAll(' ', '_'),
        modifier.replaceAll(' ', '_')
      ];
      String path = 'assets/navigation_symbol/${data.join('_')}.svg';
      setState(() {
        instructionImage = SvgPicture.asset(path, color: Colors.white);
      });
    }
  }

  _onStopNavigation() {
    setState(() {
      routeProgressEvent = null;
      _isRunning = false;
    });
  }

  _showBottomSheetInfo(VietmapReverseModel data) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => AddressInfo(
              data: data,
              addWaypoint: () async {
                waypoints.add(LatLng(
                    data.lat?.toDouble() ?? 0, data.lng?.toDouble() ?? 0));
                await _controller!.addImageMarkers([
                  NavigationMarker(
                      width: 40,
                      height: 40,
                      imagePath: 'assets/location.png',
                      latLng: LatLng(
                          data.lat?.toDouble() ?? 0, data.lng?.toDouble() ?? 0))
                ]);
                if (!mounted) return;
                Navigator.pop(context);
              },
              removeAllMarkers: () {
                _controller?.removeAllMarkers();
                _controller?.clearRoute();
                waypoints.clear();
                if (!mounted) return;
                Navigator.pop(context);
              },
              buildRoute: () async {
                EasyLoading.show();
                if (waypoints.isEmpty) {
                  Navigator.pop(context);
                  EasyLoading.dismiss();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Vui lòng thêm điểm dừng để xây dựng tuyến đường')));
                  return;
                }
                _controller
                    ?.buildRoute(waypoints: [userLocation!, ...waypoints]);
                if (!mounted) return;
                Navigator.pop(context);
              },
              buildAndStartRoute: () async {
                EasyLoading.show();
                if (waypoints.isEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Vui lòng thêm điểm dừng để xây dựng tuyến đường')));
                  return;
                }

                _controller?.buildAndStartNavigation(
                    waypoints: [userLocation!, ...waypoints],
                    profile: DrivingProfile.drivingTraffic);
                setState(() {
                  _isRunning = true;
                });
                if (!mounted) return;
                Navigator.pop(context);
              },
            ));
  }

  @override
  void dispose() {
    _controller?.onDispose();
    super.dispose();
  }
}
