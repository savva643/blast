import 'package:share_plus/share_plus.dart';

void shareContent(String type, String id) {
  // Формируем ссылку в зависимости от типа контента
  final String url;
  switch (type) {
    case 'music':
      url = 'https://blast.keep-pixel.ru/music?id=$id';
      break;
    case 'video':
      url = 'https://blast.keep-pixel.ru/video?id=$id';
      break;
    case 'artist':
      url = 'https://blast.keep-pixel.ru/artist?id=$id';
      break;
    case 'playlist':
      url = 'https://blast.keep-pixel.ru/playlist?id=$id';
      break;
    case 'album':
      url = 'https://blast.keep-pixel.ru/album?id=$id';
      break;
    default:
      url = 'https://blast.keep-pixel.ru/';
  }

  // Поделиться ссылкой
  Share.share('Check this out: $url');
}
