# Kenshi Online v1.0.2 - Финальная версия

## 🔧 Исправления

- ✅ Удалены старые скрипты установки (install.bat, setup.bat)
- ✅ Оставлен только улучшенный INSTALL.bat
- ✅ Все необходимые файлы включены в dist/
- ✅ Исправлена структура релиза

## 📦 Что включено

### Готовые бинарники в dist/:
- `KenshiMP.Core.dll` - основной мод (1.3 MB)
- `KenshiMP.Injector.exe` - лаунчер
- `KenshiMP.Server.exe` - выделенный сервер
- `KenshiMP.MasterServer.exe` - мастер-сервер
- GUI файлы (layout)
- Конфигурация сервера

### Инсталляторы:
- `INSTALL.bat` - автоматическая установка для Windows
- `install.sh` - автоматическая установка для Linux/Wine

## 🚀 Установка

### Windows
1. Скачайте `kenshi-online-v1.0.2.tar.gz`
2. Распакуйте архив
3. Запустите `INSTALL.bat` от имени администратора
4. Следуйте инструкциям на экране

### Linux
```bash
tar -xzf kenshi-online-v1.0.2.tar.gz
cd release-package
chmod +x install.sh
./install.sh
```

## ✨ Возможности

- До 16 игроков на сервере
- Полная синхронизация (персонажи, NPC, бои, строительство)
- Встроенный чат и HUD
- Выделенный сервер с консольными командами
- Автоматический поиск Kenshi (8+ путей Windows, 7+ путей Linux)

## 📖 Документация

- [README.ru.md](README.ru.md) - Полная документация на русском
- [JOINING.md](release-package/dist/JOINING.md) - Как подключиться к серверу

---

**Discord**: https://discord.gg/s5J5KBbsek
**Репозиторий**: https://github.com/im-blatnoyua/kenshi-online-simplified
