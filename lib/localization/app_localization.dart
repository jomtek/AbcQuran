import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class AppLocalization {
  AppLocalization(this.locale);

  final Locale locale;

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static const Map<String, String> translations = {
    "en": "English",
    "ar": "بالعربية",
    "fr": "Français",
    "es": "Español"
  };

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'page': 'Page',
      'read_sidebar_title': 'Read and listen',
      'settings_sidebar_title': 'Settings',
      'sura_list_searchbar_hint': 'Sura, reciter...',
      'unstable': 'Unstable',
      'mushaf': 'Mushaf',
      'text': 'Text',
      'cancel': 'Close menu',
      'contribute': 'Contribute',
      'move_here': 'Move here',
      'start_here': 'Start here',
      'contribution_menu': 'Contribution menu',
      'data_for': 'Data for',
      'reciter': 'Reciter',
      'contribution_guide_label': 'Check out the guide',
      'contribution_guide_url': 'https://www.youtube.com/watch?v=CL2cN2zhCm0',
      'curr_time': 'Curr. time',
      'original': 'Original',
      'new': 'New',
      'previous_v': 'Previous v.',
      'mark_v': 'Mark v.',
      'skip_v': 'Skip v.',
      'submit': 'Submit',
      'sending_contributions': 'Sending contributions...',
      'sent': 'sent',
      'language': 'Language',
      'quran_language': 'Quran language',
      'help_us_github': 'You know your stuff ? Join us on Github !'
    },
    'ar': {
      'page': 'رقم',
      'read_sidebar_title': 'اقرأ واستمع',
      'settings_sidebar_title': 'الإعدادات',
      'sura_list_searchbar_hint': 'سورة أم القارئ ...',
      'unstable': 'ضعيف',
      'mushaf': 'مصحف',
      'text': 'ترجمة',
      'cancel': 'يفض',
      'contribute': 'المساهمة في المصحف',
      'move_here': 'تحرك هنا',
      'start_here': 'أبدأ هنا',
      'contribution_menu': 'قائمة المساهمة',
      'data_for': 'بيانات عن',
      'reciter': 'القارئ',
      'contribution_guide_label': 'اعرض البرنامج التعليمي',
      'contribution_guide_url': 'https://www.youtube.com/watch?v=CL2cN2zhCm0',
      'curr_time': 'موقف القراءة',
      'original': 'عتيق',
      'new': 'جديد',
      'previous_v': 'الآية السابقة',
      'mark_v': 'الآية التالية',
      'skip_v': 'تخطي الآية',
      'submit': 'ينشر',
      'sending_contributions': 'النشر قيد التقدم...',
      'sent': 'مساهمات',
      'language': 'اللغة',
      'quran_language': 'لغة الترجمة',
      'help_us_github': 'Github ساعدنا على'
    },
    'fr': {
      'page': 'Page',
      'read_sidebar_title': 'Lire et écouter',
      'settings_sidebar_title': 'Paramètres',
      'sura_list_searchbar_hint': 'Sourate, récitateur...',
      'unstable': 'Instable',
      'mushaf': 'Mushaf',
      'text': 'Traduction',
      'cancel': 'Fermer le menu',
      'contribute': 'Contribuer',
      'move_here': 'Se déplacer ici',
      'start_here': 'Commencer ici',
      'contribution_menu': 'Menu contribution',
      'data_for': 'Données pour',
      'reciter': 'Récitateur',
      'contribution_guide_label': 'Comment ça marche ? (tutoriel)',
      'contribution_guide_url': 'https://www.youtube.com/watch?v=p4eLZa9lC0M',
      'curr_time': 'Pos. (lecture)',
      'original': 'Original',
      'new': 'Réparé',
      'previous_v': 'Précédent',
      'mark_v': 'Suivant',
      'skip_v': 'Sauter',
      'submit': 'Publier',
      'sending_contributions': 'Publication en cours...',
      'sent': 'contrib. envoyées',
      'language': 'Langue du logiciel',
      'quran_language': 'Langue du Coran',
      'help_us_github': 'Contribuez au projet sur Github !'
    },
    'es': {
      'page': 'Página',
      'read_sidebar_title': 'Leer/escuchar',
      'settings_sidebar_title': 'Configuraciones',
      'sura_list_searchbar_hint': 'Sura, recitador...',
      'unstable': 'Inestable',
      'mushaf': 'Mushaf',
      'text': 'Traducción',
      'cancel': 'Cerrar el menú',
      'contribute': 'Contribuir',
      'move_here': 'Moverse aquí',
      'start_here': 'Empezar aquí',
      'contribution_menu': 'Menú de contribución',
      'data_for': 'Datos para',
      'reciter': 'Recitador',
      'contribution_guide_label': 'Ver el tutorial para contribuir',
      'contribution_guide_url': 'https://www.youtube.com/watch?v=CL2cN2zhCm0',
      'curr_time': 'Posición',
      'original': 'Original',
      'new': 'Nuevo',
      'previous_v': 'Regresar',
      'mark_v': 'Siguiente',
      'skip_v': 'Omitir',
      'submit': 'Publicar',
      'sending_contributions': 'Publicando...',
      'sent': 'publicaciones enviadas',
      'language': 'El idioma de la aplicación',
      'quran_language': 'El idioma del corán',
      'help_us_github': '¡Puedes ayudarnos en el Github!'
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? '** $key not found';
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar', 'fr', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<AppLocalization>(
      AppLocalization(locale),
    );
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
