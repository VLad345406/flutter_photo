import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> locales = [
  MapLocale('en', LocaleData.EN),
  MapLocale('uk', LocaleData.UK),
];

mixin LocaleData {
  //auth screens
  static const String login = 'LOG IN';
  static const String register = 'REGISTER';
  static const String nickName = 'Nick name';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm password';
  static const String forgotPassword = 'Forgot password? ';
  static const String restore = 'Restore';
  static const String continueWith = 'Continue with:';
  static const String loginError = 'Input email and password!';
  static const String registerError = 'Input data!';
  static const String confirmPasswordError = 'Wrong confirm password!';
  static const String passwordValidateError =
      'Password must be 8 characters or more! Minimum 1 Upper case symbol, '
      'Minimum 1 lowercase symbol, Minimum 1 Numeric Number symbol, '
      'Minimum 1 Special Character!';
  static const String registerUserNameError =
      'This user name is already exist!';
  static const String restoreMessage =
      'Password restore link sent! Check your email!';

  //main screens
  static const String discover = 'Discover';
  static const String notSubscibed = "You're not subscribed to anyone!\n"
      "Maybe you know that users:";
  static const String search = 'Search';
  static const String searchPhotos = 'Search all photos, profiles';
  static const String chats = 'Chats';
  static const String findUserMessage = 'Find user and start messaging!';
  static const String followers = 'Followers';
  static const String subscriptions = 'Subscriptions';
  static const String follow = 'Follow';
  static const String unfollow = 'Unfollow';
  static const String message = 'Message';
  static const String settings = 'Edit profile';
  static const String changeAvatar = 'Change avatar';
  static const String oldPassword = 'Old password';
  static const String name = 'Name';
  static const String save = 'Save';
  static const String exit = 'Exit';
  static const String removeAccount = 'Remove account';
  static const String language = 'Language';
  static const String successSave = 'Success save!';

  //chats
  static const String noMessages = 'No messages!';
  static const String you = 'You';
  static const String copy = 'Copy';
  static const String edit = 'Edit';
  static const String delete = 'Delete';

  //add bottom sheet
  static const String addContent = 'Add content';
  static const String camera = 'Camera';
  static const String gallery = 'Gallery';
  static const String music = 'Music';
  static const String video = 'Video';

  //add photo tags
  static const String addPhotoTags = 'Add photo tags';
  static const String tagsHintText = "Write tags without ',' or '#'";

  static const Map<String, dynamic> EN = {
    login: 'LOG IN',
    register: 'REGISTER',
    nickName: 'Nick name',
    password: 'Password',
    confirmPassword: 'Confirm password',
    forgotPassword: 'Forgot password? ',
    restore: 'Restore',
    continueWith: 'Continue with:',
    loginError: 'Input email and password!',
    registerError: 'Input data!',
    confirmPasswordError: 'Wrong confirm password!',
    passwordValidateError:
        'Password must be 8 characters or more! Minimum 1 Upper case symbol, '
            'Minimum 1 lowercase symbol, Minimum 1 Numeric Number symbol, '
            'Minimum 1 Special Character!',
    registerUserNameError: 'This user name is already exist!',
    restoreMessage: 'Password restore link sent! Check your email!',

    //main screens
    discover: 'Discover',
    notSubscibed: "You're not subscribed to anyone! "
        "Maybe you know that users:",
    search: 'Search',
    searchPhotos: 'Search all photos, profiles',
    chats: 'Chats',
    findUserMessage: 'Find user and start messaging!',
    followers: 'Followers',
    subscriptions: 'Subscriptions',
    follow: 'Follow',
    unfollow: 'Unfollow',
    message: 'Message',
    settings: 'Settings',
    changeAvatar: 'Change avatar',
    oldPassword: 'Old password',
    name: 'Name',
    save: 'Save',
    exit: 'Exit',
    removeAccount: 'Remove account',
    language: 'Language',
    successSave: 'Success save!',

    //chats
    noMessages: 'No messages!',
    you: 'You',
    copy: 'Copy',
    edit: 'Edit',
    delete: 'Delete',

    //add bottom sheet
    addContent: 'Add content',
    camera: 'Camera',
    gallery: 'Gallery',
    music: 'Music',
    video: 'Video',

    //add photo tags
    addPhotoTags: 'Add photo tags',
    tagsHintText: "Write tags without ',' or '#'",
  };
  static const Map<String, dynamic> UK = {
    login: 'ВХІД',
    register: 'РЕЄСТРАЦІЯ',
    nickName: 'Імʼя користувача',
    password: 'Пароль',
    confirmPassword: 'Підтвердити пароль',
    forgotPassword: 'Забули пароль? ',
    restore: 'Відновити',
    continueWith: 'Продовжити через:',
    loginError: 'Введіть електрону пошту та пароль!',
    registerError: 'Введіть інформацію!',
    confirmPasswordError: 'Неправильний пароль для підтвердження!',
    passwordValidateError:
        'Пароль повинен містити 8 символів або більше! Мінімум 1 символ верхнього регістру, '
            'Мінімум 1 символ нижнього регістру, Мінімум 1 символ цифри, '
            "Мінімум 1 спеціальний символ!",
    registerUserNameError: "Це ім'я користувача вже зайняте!",
    restoreMessage:
        "Посилання для відновлення паролю надіслано! Перевірте свою електронну пошту!",

    //main screens
    discover: 'Відкриття',
    notSubscibed: "Ви ще ні на кого не підписані! "
        "Можливо, вам відомі ці користувачі:",
    search: 'Пошук',
    searchPhotos: 'Пошук всіх фотографій та користувачів',
    chats: 'Бесіди',
    findUserMessage:
        'Знайдіть користувача і почніть обмінюватися повідомленнями!',
    followers: 'Підписники',
    subscriptions: 'Підписки',
    follow: 'Підписатися',
    unfollow: 'Відписатися',
    message: 'Повідомлення',
    settings: 'Налаштування',
    changeAvatar: 'Зміна аватару',
    oldPassword: 'Старий пароль',
    name: "Імʼя",
    save: 'Зберегти',
    exit: 'Вийти',
    removeAccount: 'Видалити аккаунт',
    language: 'Мова',
    successSave: 'Успішно збережено!',

    //chats
    noMessages: 'Немає повідомлень!',
    you: 'Ви',
    copy: 'Копіювати',
    edit: 'Редагувати',
    delete: 'Видалити',

    //add bottom sheet
    addContent: 'Додати контент',
    camera: 'Камера',
    gallery: 'Галерея',
    music: 'Музика',
    video: 'Відео',

    //add photo tags
    addPhotoTags: 'Додати теги до фото',
    tagsHintText: "Напишіть теги без символів ',' або '#'",
  };
}
