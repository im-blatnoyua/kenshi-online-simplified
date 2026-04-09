#!/bin/bash

# ============================================
#  Kenshi Online - Установка для Linux/Wine
# ============================================

set -e

echo ""
echo "╔════════════════════════════════════════╗"
echo "║   Kenshi Online - Установка мода      ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Поиск Kenshi
KENSHI_PATH=""
STEAM_PROTON="$HOME/.steam/steam/steamapps/common/Kenshi"
STEAM_NATIVE="$HOME/.local/share/Steam/steamapps/common/Kenshi"
WINE_PREFIX="$HOME/.wine/drive_c/Program Files (x86)/Steam/steamapps/common/Kenshi"

if [ -f "$STEAM_PROTON/kenshi_x64.exe" ]; then
    KENSHI_PATH="$STEAM_PROTON"
    echo -e "${GREEN}[✓]${NC} Найден Kenshi (Steam/Proton): $KENSHI_PATH"
elif [ -f "$STEAM_NATIVE/kenshi_x64.exe" ]; then
    KENSHI_PATH="$STEAM_NATIVE"
    echo -e "${GREEN}[✓]${NC} Найден Kenshi (Steam): $KENSHI_PATH"
elif [ -f "$WINE_PREFIX/kenshi_x64.exe" ]; then
    KENSHI_PATH="$WINE_PREFIX"
    echo -e "${GREEN}[✓]${NC} Найден Kenshi (Wine): $KENSHI_PATH"
else
    echo -e "${RED}[!]${NC} Kenshi не найден автоматически!"
    echo ""
    read -p "Введите путь к Kenshi (где находится kenshi_x64.exe): " KENSHI_PATH
    if [ ! -f "$KENSHI_PATH/kenshi_x64.exe" ]; then
        echo -e "${RED}[!]${NC} Неверный путь! kenshi_x64.exe не найден."
        exit 1
    fi
fi

echo ""
echo "════════════════════════════════════════"
echo " Установка файлов..."
echo "════════════════════════════════════════"

# Копирование файлов
echo -e "${YELLOW}[→]${NC} Копирование KenshiMP.Core.dll..."
cp -f "dist/KenshiMP.Core.dll" "$KENSHI_PATH/" || {
    echo -e "${RED}[!]${NC} Ошибка копирования DLL"
    exit 1
}
echo -e "${GREEN}[✓]${NC} KenshiMP.Core.dll установлен"

echo -e "${YELLOW}[→]${NC} Копирование KenshiMP.Injector.exe..."
cp -f "dist/KenshiMP.Injector.exe" "$KENSHI_PATH/"
echo -e "${GREEN}[✓]${NC} KenshiMP.Injector.exe установлен"

echo -e "${YELLOW}[→]${NC} Копирование KenshiMP.Server.exe..."
cp -f "dist/KenshiMP.Server.exe" "$KENSHI_PATH/"
echo -e "${GREEN}[✓]${NC} KenshiMP.Server.exe установлен"

echo -e "${YELLOW}[→]${NC} Копирование server.json..."
cp -f "dist/server.json" "$KENSHI_PATH/"
echo -e "${GREEN}[✓]${NC} server.json установлен"

echo -e "${YELLOW}[→]${NC} Копирование kenshi-online.mod..."
cp -f "dist/kenshi-online.mod" "$KENSHI_PATH/"
echo -e "${GREEN}[✓]${NC} kenshi-online.mod установлен"

# Настройка Plugins_x64.cfg
echo -e "${YELLOW}[→]${NC} Настройка Plugins_x64.cfg..."
PLUGINS_CFG="$KENSHI_PATH/Plugins_x64.cfg"

if [ ! -f "$PLUGINS_CFG" ]; then
    echo -e "${RED}[!]${NC} Plugins_x64.cfg не найден!"
    exit 1
fi

if ! grep -q "Plugin=KenshiMP.Core" "$PLUGINS_CFG"; then
    echo "Plugin=KenshiMP.Core" >> "$PLUGINS_CFG"
    echo -e "${GREEN}[✓]${NC} Добавлена запись в Plugins_x64.cfg"
else
    echo -e "${GREEN}[✓]${NC} Plugins_x64.cfg уже настроен"
fi

# Копирование GUI файлов
echo -e "${YELLOW}[→]${NC} Копирование GUI файлов..."
mkdir -p "$KENSHI_PATH/data/gui/layout"
cp -f "dist/Kenshi_MultiplayerPanel.layout" "$KENSHI_PATH/data/gui/layout/"
cp -f "dist/Kenshi_MultiplayerHUD.layout" "$KENSHI_PATH/data/gui/layout/"
cp -f "dist/Kenshi_MainMenu.layout" "$KENSHI_PATH/data/gui/layout/"
echo -e "${GREEN}[✓]${NC} GUI файлы установлены"

# Создание скрипта запуска
echo -e "${YELLOW}[→]${NC} Создание скрипта запуска..."
cat > "$HOME/kenshi-online.sh" << 'EOF'
#!/bin/bash
KENSHI_PATH="KENSHI_PATH_PLACEHOLDER"
cd "$KENSHI_PATH"
wine KenshiMP.Injector.exe
EOF

sed -i "s|KENSHI_PATH_PLACEHOLDER|$KENSHI_PATH|g" "$HOME/kenshi-online.sh"
chmod +x "$HOME/kenshi-online.sh"
echo -e "${GREEN}[✓]${NC} Скрипт запуска создан: ~/kenshi-online.sh"

echo ""
echo "════════════════════════════════════════"
echo " ✓ Установка завершена!"
echo "════════════════════════════════════════"
echo ""
echo "Запустите игру через:"
echo "  • ~/kenshi-online.sh"
echo "  • Или: cd '$KENSHI_PATH' && wine KenshiMP.Injector.exe"
echo ""
echo "Для запуска сервера:"
echo "  • cd '$KENSHI_PATH' && wine KenshiMP.Server.exe"
echo ""
