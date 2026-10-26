import 'package:flutter/widgets.dart';

class AppStrings {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'Digital Balance',
      'home': 'Home',
      'insights': 'Insights',
      'focus': 'Focus',
      'appRules': 'App Rules',
      'you': 'You',
      'todayUsage': "Today's Screen Time",
      'dailyGoal': 'Daily Goal',
      'mostUsed': 'Most Used Apps',
      'startFocus': 'Start Focus',
      'activeRestrictions': 'Active Restrictions',
      'grantUsagePermission':
          'Grant Usage Access to view your on-device screen time',
      'openSettings': 'Open Settings',
      'takeABreath': 'Take a breath',
      'returnHome': 'Return Home',
      'unlock5Min': 'Unlock for 5 Minutes',
      'settings': 'Settings',
      'settingsAndPreferences': 'Settings & Preferences',
      'appearance': 'Appearance',
      'theme': 'Theme',
      'followSystem': 'Follow System',
      'lightTheme': 'Light Theme',
      'darkTheme': 'Dark Theme',
      'language': 'Language',
      'english': 'English',
      'bangla': 'বাংলা (Bangla)',
      'biometricOverride': 'Biometric Override Confirmation',
      'backupAndRestore': 'Backup & Restore',
      'privacyPolicy': 'Privacy Policy',
      'habits': 'Habits',
      'routines': 'Routines',
      'appCatalog': 'App Catalog',
      'zeroTraceDeletion': 'Zero-Trace Data Deletion',
      'deleteAllData': 'Delete All Local Data',
      'remaining': 'remaining',
      'target': 'Target',
      'syncUsage': 'Sync Usage',
      'weekly': 'Weekly',
      'monthly': 'Monthly',
      'dailyAverage': 'Daily Average',
      'topUsedApps': 'Top Used Applications',
      'categoryDistribution': 'Category Distribution',
      'createRule': 'Create Rule',
      'dailyLimit': 'Daily Limit',
      'timeWindow': 'Time Window',
      'overnight': 'Overnight Window',
    },
    'bn': {
      'appName': 'ডিজিটাল ব্যালেন্স',
      'home': 'হোম',
      'insights': 'অন্তর্দৃষ্টি',
      'focus': 'ফোকাস',
      'appRules': 'অ্যাপ নিয়ম',
      'you': 'আপনি',
      'todayUsage': 'আজকের স্ক্রিন টাইম',
      'dailyGoal': 'দৈনিক লক্ষ্য',
      'mostUsed': 'সর্বাধিক ব্যবহৃত অ্যাপ',
      'startFocus': 'ফোকাস শুরু করুন',
      'activeRestrictions': 'সক্রিয় বিধিনিষেধ',
      'grantUsagePermission': 'ডিভাইসের স্ক্রিন টাইম দেখতে অনুমতি দিন',
      'openSettings': 'সেটিংস খুলুন',
      'takeABreath': 'একটু বিরতি নিন',
      'returnHome': 'হোমে ফিরে যান',
      'unlock5Min': '৫ মিনিটের জন্য আনলক করুন',
      'settings': 'সেটিংস',
      'settingsAndPreferences': 'সেটিংস ও পছন্দসমূহ',
      'appearance': 'রূপরেখা ও থিম',
      'theme': 'থিম',
      'followSystem': 'সিস্টেম অনুসরণ করুন',
      'lightTheme': 'হালকা থিম (লাইট)',
      'darkTheme': 'গাঢ় থিম (ডার্ক)',
      'language': 'ভাষা',
      'english': 'English',
      'bangla': 'বাংলা',
      'biometricOverride': 'বায়োমেট্রিক নিশ্চিতকরণ',
      'backupAndRestore': 'ব্যাকআপ ও পুনরুদ্ধার',
      'privacyPolicy': 'গোপনীয়তা নীতি',
      'habits': 'অভ্যাসসমূহ',
      'routines': 'রুটিনসমূহ',
      'appCatalog': 'অ্যাপ ক্যাটালগ',
      'zeroTraceDeletion': 'সম্পূর্ণ ডেটা মুছে ফেলুন',
      'deleteAllData': 'স্থানীয় সব ডেটা মুছুন',
      'remaining': 'বাকি আছে',
      'target': 'লক্ষ্য',
      'syncUsage': 'ব্যবহার সিঙ্ক করুন',
      'weekly': 'সাপ্তাহিক',
      'monthly': 'মাসিক',
      'dailyAverage': 'দৈনিক গড়',
      'topUsedApps': 'শীর্ষ ব্যবহৃত অ্যাপ',
      'categoryDistribution': 'ক্যাটাগরি বিভাজন',
      'createRule': 'নতুন নিয়ম তৈরি করুন',
      'dailyLimit': 'দৈনিক সীমা',
      'timeWindow': 'নির্দিষ্ট সময়সূচী',
      'overnight': 'রাতের সময়সূচী',
    },
  };

  static String get(String key, {String locale = 'en'}) {
    return _localizedValues[locale]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    try {
      final loc = Localizations.localeOf(this).languageCode;
      return AppStrings.get(key, locale: loc);
    } catch (_) {
      return AppStrings.get(key, locale: 'en');
    }
  }
}
