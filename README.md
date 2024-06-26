# Тұрақ орындарын табу үшін "ORYNTAPP" мобильді қосымшасын әзірлеу

## Сипаттама
Бұл жоба "ORYNTAPP" мобильді қосымшасының қосымша бөлігі болып табылады. Бұл жоба тұрақ орындарының бос немесе бос емес екенін анықтауға арналған.
Жобаның серверлік бөлігі мына сілтемеде: [GitHub](https://github.com/Bulychov-Ruslan/oryntapp_backend.git)
Қосымшадағы мүмкіндіктер:
– Авторизация;
– Регистрация;
– Верификация;
– Құпия сөзді қалпына келтіру;
– Автотұрақтар картасын: автотұрақтарды көру, пайдаланушы орнынан автотұраққа дейін маршрут қоя алу.
– Автотұрақтарді іздеу: Автотұрақтардың тізімі болады. Автотұрақ мекенжайы бойынша іздеу мүмкіндігі.
– Автотұрақты статустарын қарау: Автотұрақта қай орындар бос немесе бос емес екенін көру мүмкіндігі, барлық, бос және бос емес орындар бойынша фильтрлеу.
– Пайдаланушы профилі: сурет қою, суретті өшіру, пайдаланушы есімін өзгерту, қосымшанің тілін таңдау мүміндігі және қосымшада өз аккаунтыңнан шығу.


## Жобаны бастау үшін мына қадамдарды орындаңыз.

### Алғы шарттар

Flutter SDK ресми Flutter веб-сайтынан орнатыңыз. [flutter.dev](https://flutter.dev/docs/get-started/install)
Firebase деректер базасы ретінде қолданылады. Сондықтан өз аккаунтыңызбен байланыстыруыңз қажет. [Firebase](https://firebase.google.com/)

### Орнату

1. Репозиторийді клондау:
    ```bash
    git clone https://github.com/Bulychov-Ruslan/oryntapp_app.git
    ```
2. Жоба каталогына өту:
    ```bash
    cd oryntapp_app
    ```

3. Қосымшаны орнату үшін қажетті пакеттерді орнатыңыз:
    ```bash
    flutter pub get
    ```
   
4. Қолданбаны іске қосыңыз:
    ```bash
    flutter run
    ```
# Автор: Булычов Руслан
