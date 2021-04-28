import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/style.dart';

class GoshuinListJija extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

//
// class GoshuinListJija extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _State();
//   }
// }
//
// class PlaceItem {
//   bool isExpanded;
//   String name;
//   String image;
//
//   PlaceItem(this.isExpanded, this.name, this.image);
// }
//
// ExpansionPanel _createPanel(PlaceItem place) {
//   return ExpansionPanel(
//     headerBuilder: (BuildContext context, bool isExpanded) {
//       return Container(
//         padding: EdgeInsets.all(8.0),
//         child: Row(
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.only(right: 10.0),
//               child: Icon(Icons.image),
//             ),
//             Text(
//               place.name,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             )
//           ],
//         ),
//       );
//     },
//     body: Image.asset('assets/' + place.image),
//     isExpanded: place.isExpanded,
//   );
// }
//
// class _State extends State<GoshuinListJija> {
//   var _placeList = new List<PlaceItem>();
//
//   @override
//   void initState() {
//     _placeList.add(
//       PlaceItem(false, 'Huntington Beach', 'huntington-beach.jpg'),
//     );
//     _placeList.add(
//       PlaceItem(false, 'The Hat', 'the-hat.jpg'),
//     );
//     _placeList.add(
//       PlaceItem(false, 'Shake Shack', 'shake-shack.jpg'),
//     );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all(8.0),
//         child: ListView(
//           children: <Widget>[
//             ExpansionPanelList(
//               expansionCallback: (int index, bool isExpanded) {
//                 setState(() {
//                   _placeList[index].isExpanded = !_placeList[index].isExpanded;
//                 });
//               },
//               children: _placeList.map(_createPanel).toList(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
