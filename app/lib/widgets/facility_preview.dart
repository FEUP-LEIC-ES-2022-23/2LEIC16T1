import 'package:flutter/material.dart';
import 'package:sportspotter/models/facility.dart';

class FacilityPreview extends StatefulWidget {
  final Facility facility;
  final Function onTap;

  const FacilityPreview({Key? key, required this.facility, required this.onTap})
      : super(key: key);

  @override
  _FacilityPreviewState createState() => _FacilityPreviewState();
}

class _FacilityPreviewState extends State<FacilityPreview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 20),
      child: Ink(
        height: 90,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0, 4),
                blurRadius: 4)
          ],
          color: Color.fromRGBO(243, 243, 243, 1),
        ),
        child: InkWell(
          onTap: () => widget.onTap(),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Stack(
            children: [
              Positioned(
                  top: 40,
                  left: 20,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 170,
                    child: Text(
                      widget.facility.name,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inter',
                        fontSize: 18,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  )),
              Positioned(
                  top: 5,
                  left: MediaQuery.of(context).size.width - 150,
                  child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                            image: widget.facility.photo == ''
                                ? Image.asset(
                                    'assets/images/error-image-generic.png',
                                  ).image
                                : Image.network(
                                    widget.facility.photo,
                                  ).image),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
