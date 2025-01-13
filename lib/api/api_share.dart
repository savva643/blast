import 'package:share_plus/share_plus.dart';

void shareContent(String type, String id) {
  // Формируем ссылку в зависимости от типа контента
  final String url;
  switch (type) {
    case 'music':
      url = 'https://blast.kompot.site/music?id=$id';
      break;
    case 'video':
      url = 'https://blast.kompot.site/video?id=$id';
      break;
    case 'artist':
      url = 'https://blast.kompot.site/artist?id=$id';
      break;
    case 'playlist':
      url = 'https://blast.kompot.site/playlist?id=$id';
      break;
    case 'album':
      url = 'https://blast.kompot.site/album?id=$id';
      break;
    default:
      url = 'https://blast.kompot.site/';
  }

  // Поделиться ссылкой
  Share.share('Check this out: $url');
}
