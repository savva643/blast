import 'package:share_plus/share_plus.dart';

void shareContent(String type, String id) {
  // Формируем ссылку в зависимости от типа контента
  final String url;
  switch (type) {
    case 'music':
      url = 'https://blast.keeppixel.store/music?id=$id';
      break;
    case 'video':
      url = 'https://blast.keeppixel.store/video?id=$id';
      break;
    case 'artist':
      url = 'https://blast.keeppixel.store/artist?id=$id';
      break;
    case 'playlist':
      url = 'https://blast.keeppixel.store/playlist?id=$id';
      break;
    case 'album':
      url = 'https://blast.keeppixel.store/album?id=$id';
      break;
    default:
      url = 'https://blast.keeppixel.store/';
  }

  // Поделиться ссылкой
  Share.share('Check this out: $url');
}
