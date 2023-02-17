

import 'package:data_collect_v2/models/geo_political_zone.dart';
import 'package:data_collect_v2/models/positions.dart';

class TextUtil {
  static final positions = [
    PositionModel(
      name: 'National Officer',
      id: 1,
    ),
    PositionModel(
      name: 'Zonal Coordinator',
      id: 2,
    ),
    PositionModel(
      name: 'State Coordinator',
      id: 3,
    ),
    PositionModel(
      name: 'Local Government Coordinator',
      id: 4,
    ),
    PositionModel(
      name: 'Ward Coordinator',
      id: 5,
    ),
    PositionModel(
      name: 'Ward Canvasser',
      id: 6,
    ),
  ];

  static final geopoliticalZone = [
    GeoPoliticalZone(
      name: 'North East',
      zoneId: 1,
    ),
    GeoPoliticalZone(
      name: 'North West',
      zoneId: 2,
    ),
    GeoPoliticalZone(
      name: 'North Central',
      zoneId: 3,
    ),
    GeoPoliticalZone(
      name: 'South East',
      zoneId: 4,
    ),
    GeoPoliticalZone(
      name: 'South South',
      zoneId: 5,
    ),
    GeoPoliticalZone(
      name: 'South West',
      zoneId: 6,
    ),
  ];
}
