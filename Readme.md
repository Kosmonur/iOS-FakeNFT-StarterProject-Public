# Fake NFT Application
## Описание приложения
Приложение помогает пользователям просматривать и покупать NFT (Non-Fungible Token) картинки. Функционал покупки иммитируется с помощью мокового сервера https://mockapi.io. Приложение написано на Swift. Архитектура MVVM. [Дизайн ](https://www.figma.com/file/k1LcgXHGTHIeiCv4XuPbND/FakeNFT-(YP)?type=design&node-id=597-48015&mode=design) в Figma.
Документация по API [здесь](https://github.com/Yandex-Practicum/iOS-FakeNFT-StarterProject-Public/blob/main/API.html).

Основные функции приложения:
- просмотр коллекций NFT;
- добавление удаление из корзины
- реализация избранных NFT
- просмотр и покупка NFT (иммитируется);
- просмотр рейтинга пользователей.
- просмотр профиля пользователя

Дополнительно было реализовано:
- локализация (Swiftgen)
- тёмная тема
- сообщение о сетевых ошибках
  
## Стек
- Архитектура MVVM.
- Вёрстка кодом с Auto Layout. Дизайн в Figma.
- UITableView, UICollectionView, UIScrollView, UITabBarController, UINavigationController.
- Работа с сетью через URLSession.
- Многопоточность; предотвращение race condition (DispatchQueue, блокировка UI).
- Используется Kingfisher. Добавлена через SPM.
- UI-тесты и Unit-тесты.

## Команда разработки и  [Доска проекта](https://github.com/users/artwist-polyakov/projects/1/views/1)
- [Aleksandr Pichugin](https://github.com/kosmonur)
- [Vitaly Alekseev](https://github.com/v-alekseev)
- [Aleksandr Polyakov](https://github.com/artwist-polyakov)
- [TMWF](https://github.com/TMWF)

## Скриншоты



# Видео с демонстрацией работы разделов приложения
- [Раздел Статистика](https://disk.yandex.ru/i/4UCK28rwtm1NLw)
- [Раздел Корзина](https://www.loom.com/share/cea611beadf2495b8d2ee65818b58dd1)
- [Раздела Профиль](https://www.loom.com/share/35b98ee263a24fffaae3fd841d5ded36?sid=2c25fbb6-6bb2-4b7d-aca0-afaa8192fb96)
