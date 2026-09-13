# Практическая работа №5 — ООО «Тмыв денег»

Продолжение ПР4. Добавлены аутентификация, регистрация, три роли, защита маршрутов, токены, обновление токена и выход по неактивности.

## Запуск

1. Сервер:

```powershell
cd server
node mock-server.js --port 8080 --origin http://localhost:5555
```

2. Клиент в другом PowerShell:

```powershell
flutter pub get
flutter run -d chrome --web-port=5555 --dart-define=API_BASE_URL=http://localhost:8080/api
```

## Учебные аккаунты

- `reader / Reader!123` — каталог, собственные выдачи, продление.
- `librarian / Librarian!123` — книги, справочники, читатели и выдачи.
- `admin / Admin!123` — пользователи и роли, статистика, восстановление и физическое удаление.

## Проверка обновления токена

Запустить сервер с TTL 60 секунд:

```powershell
node server/mock-server.js --port 8080 --origin http://localhost:5555 --ttl 60
```

После истечения access token клиент автоматически использует refresh token и повторяет защищённый запрос.

## Проверка клиентской защиты

Войти как `reader`. В DevTools → Application → Local Storage изменить ключ `flutter.demo_ui_role` на строковое значение `admin` (для shared_preferences значение может отображаться как JSON-строка). Обновить страницу. Интерфейс покажет админские пункты, но сервер всё равно знает настоящую роль из access token и на административную операцию ответит 403.

## Проверки

```powershell
flutter test
flutter analyze
```
