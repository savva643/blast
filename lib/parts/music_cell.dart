import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'bottomsheet_about_music.dart';

Widget MussicCellNumber(int number, dynamic list, Function sac, BuildContext context) {
  print("object+"+list.toString());
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: Material(

      color: Color.fromARGB(0, 15, 15, 16),
      borderRadius: BorderRadius.circular(5),
      child: ListTile(
        contentPadding: EdgeInsets.only(
            left: 0, right: 0, bottom: 4, top: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)),
        onTap: () async {
          sac();
        },
        leadingAndTrailingTextStyle: TextStyle(),
        leading: SizedBox(width: 90,
          height: 60,
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 30, child: Text(
                (number).toString(),
                textAlign: TextAlign.center,

                style: TextStyle(

                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 246, 244, 244)
                ),
              ),), SizedBox(
                width: 60,
                height: 60,
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: list['img'],
                    imageBuilder: (context, imageProvider) =>
                        Container(
                          padding: EdgeInsets.only(
                              left: 0, right: 0, bottom: 0, top: 0),
                          width: 64.0,
                          height: 64.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: imageProvider),
                          ),
                        ),
                    placeholder: (context, url) =>
                        CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),),
            ],),),
        title: Text(
          list['name'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 246, 244, 244)
          ),
        ),
        subtitle: Text(
          list['message'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w300,
              color: Color.fromARGB(255, 246, 244, 244)
          ),
        ),
          trailing: Container(
            padding: EdgeInsets.only(right: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Минимальная ширина строки
              mainAxisAlignment: MainAxisAlignment.end, // Выравнивание по правому краю
              children: [
                // Символ наличия мата
                list['elir'].toString() == "1"
                    ? Text("𝖒", style: TextStyle(color: Colors.white, fontSize: 14), textAlign: TextAlign.center,)
                    : Container(),
                list['elir'].toString() == "1" ? SizedBox(width: 4) : Container(),

                // Иконка скачивания
                list['install'].toString() == "1"
                    ? Icon(Icons.file_download_outlined, color: Colors.green, size: 16)
                    : Container(),
                list['install'].toString() == "1" ? SizedBox(width: 4) : Container(),

                // Иконка лайка
                list['doi'].toString() == "1"
                    ? Icon(Icons.favorite, color: Colors.red, size: 16,)
                    : Container(),
                list['doi'].toString() == "1" ? SizedBox(width: 4) : Container(),

                // Кнопка "ещё"
                IconButton(
                  icon: Icon(Icons.more_vert),
                  color: Colors.white,
                  onPressed: () {
                    showTrackOptionsBottomSheet(context, list);
                  },
                ),
              ],
            ),
          ),

      ),
    ),
  );
}


Widget MussicCell(dynamic list, Function sac, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: Material(

      color: Color.fromARGB(0, 15, 15, 16),
      borderRadius: BorderRadius.circular(5),
      child: ListTile(
        contentPadding: EdgeInsets.only(
            left: 0, right: 0, bottom: 4, top: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)),
        onTap: () async {
          sac();
        },
        leadingAndTrailingTextStyle: TextStyle(),
        leading: SizedBox(width: 90,
          height: 60,
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: list['img'],
                    imageBuilder: (context, imageProvider) =>
                        Container(
                          padding: EdgeInsets.only(
                              left: 0, right: 0, bottom: 0, top: 0),
                          width: 64.0,
                          height: 64.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: imageProvider),
                          ),
                        ),
                    placeholder: (context, url) =>
                        CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),),
            ],),),
        title: Text(
          list['name'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 246, 244, 244)
          ),
        ),
        subtitle: Text(
          list['message'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w300,
              color: Color.fromARGB(255, 246, 244, 244)
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.only(right: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Минимальная ширина строки
            mainAxisAlignment: MainAxisAlignment.end, // Выравнивание по правому краю
            children: [
              // Символ наличия мата
              list['elir'].toString() == "1"
                  ? Text("𝖒", style: TextStyle(color: Colors.white, fontSize: 14), textAlign: TextAlign.center,)
                  : Container(),
              list['elir'].toString() == "1" ? SizedBox(width: 4) : Container(),

              // Иконка скачивания
              list['install'].toString() == "1"
                  ? Icon(Icons.file_download_outlined, color: Colors.green, size: 16)
                  : Container(),
              list['install'].toString() == "1" ? SizedBox(width: 4) : Container(),

              // Иконка лайка
              list['doi'].toString() == "1"
                  ? Icon(Icons.favorite, color: Colors.red, size: 16,)
                  : Container(),
              list['doi'].toString() == "1" ? SizedBox(width: 4) : Container(),

              // Кнопка "ещё"
              IconButton(
                icon: Icon(Icons.more_vert),
                color: Colors.white,
                onPressed: () {
                  showTrackOptionsBottomSheet(context, list);
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget MussicCellStaticWidth(dynamic list, Function sac, BuildContext context) {
  return Container(
    width: 200,
    margin: const EdgeInsets.only(bottom: 10),
    child: Material(

      color: Color.fromARGB(0, 15, 15, 16),
      borderRadius: BorderRadius.circular(5),
      child: ListTile(
        contentPadding: EdgeInsets.only(
            left: 0, right: 0, bottom: 4, top: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)),
        onTap: () async {
          sac();
        },
        leadingAndTrailingTextStyle: TextStyle(),
        leading: SizedBox(width: 90,
          height: 60,

          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: list['img'],
                    imageBuilder: (context, imageProvider) =>
                        Container(
                          padding: EdgeInsets.only(
                              left: 0, right: 0, bottom: 0, top: 0),
                          width: 64.0,
                          height: 64.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: imageProvider),
                          ),
                        ),
                    placeholder: (context, url) =>
                        CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),),
            ],),),
        title: Text(
          list['name'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 246, 244, 244)
          ),
        ),
        subtitle: Text(
          list['message'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w300,
              color: Color.fromARGB(255, 246, 244, 244)
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.only(right: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Минимальная ширина строки
            mainAxisAlignment: MainAxisAlignment.end, // Выравнивание по правому краю
            children: [
              // Символ наличия мата
              list['elir'].toString() == "1"
                  ? Text("𝖒", style: TextStyle(color: Colors.white, fontSize: 14), textAlign: TextAlign.center,)
                  : Container(),
              list['elir'].toString() == "1" ? SizedBox(width: 4) : Container(),

              // Иконка скачивания
              list['install'].toString() == "1"
                  ? Icon(Icons.file_download_outlined, color: Colors.green, size: 16)
                  : Container(),
              list['install'].toString() == "1" ? SizedBox(width: 4) : Container(),

              // Иконка лайка
              list['doi'].toString() == "1"
                  ? Icon(Icons.favorite, color: Colors.red, size: 16,)
                  : Container(),
              list['doi'].toString() == "1" ? SizedBox(width: 4) : Container(),

              // Кнопка "ещё"
              IconButton(
                icon: Icon(Icons.more_vert),
                color: Colors.white,
                onPressed: () {
                  showTrackOptionsBottomSheet(context, list);
                },
              ),
            ],
          ),
        )
      ),
    ),
  );
}