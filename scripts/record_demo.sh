#!/bin/bash

# Скрипт для записи демо-видео приложения TaskFlow AI
# Записывает 30-60 секундное демо-видео с демонстрацией основных функций

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="$PROJECT_DIR/demo_video"
OUTPUT_FILE="$OUTPUT_DIR/taskflow_ai_demo.mp4"
SCREENSHOT_DIR="$OUTPUT_DIR/screenshots"

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🎬 TaskFlow AI Demo Video Recorder${NC}"
echo "=================================="

# Создаем директорию для вывода
mkdir -p "$OUTPUT_DIR"
mkdir -p "$SCREENSHOT_DIR"

# Проверяем доступность инструментов
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${YELLOW}⚠️  ffmpeg не установлен. Устанавливаю через Homebrew...${NC}"
    if command -v brew &> /dev/null; then
        brew install ffmpeg
    else
        echo -e "${RED}❌ Ошибка: ffmpeg не установлен и Homebrew недоступен${NC}"
        echo "Установите ffmpeg вручную: brew install ffmpeg"
        exit 1
    fi
fi

# Получаем UDID iOS симулятора
echo -e "${GREEN}📱 Поиск iOS симулятора...${NC}"
SIMULATOR_UDID=$(xcrun simctl list devices available | grep -i "iPhone" | head -1 | grep -oE '([A-F0-9-]{36})' | head -1)

if [ -z "$SIMULATOR_UDID" ]; then
    echo -e "${RED}❌ iOS симулятор не найден${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Найден симулятор: $SIMULATOR_UDID${NC}"

# Запускаем симулятор
echo -e "${GREEN}🚀 Запуск симулятора...${NC}"
xcrun simctl boot "$SIMULATOR_UDID" 2>/dev/null || true
open -a Simulator

# Ждем запуска симулятора
sleep 5

# Запускаем приложение
echo -e "${GREEN}📲 Запуск приложения...${NC}"
cd "$PROJECT_DIR"
flutter run -d "$SIMULATOR_UDID" --release &
FLUTTER_PID=$!

# Ждем полной загрузки приложения
echo -e "${YELLOW}⏳ Ожидание загрузки приложения (15 секунд)...${NC}"
sleep 15

# Метод 1: Используем QuickTime Player для записи экрана (если доступен)
if command -v screencapture &> /dev/null; then
    echo -e "${GREEN}🎥 Начинаем запись экрана...${NC}"
    echo -e "${YELLOW}📝 Инструкции:${NC}"
    echo "1. Откройте QuickTime Player"
    echo "2. File > New Screen Recording"
    echo "3. Выберите окно симулятора"
    echo "4. Нажмите Record"
    echo "5. Продемонстрируйте функции приложения (30-60 секунд)"
    echo "6. Остановите запись"
    echo ""
    echo -e "${GREEN}✅ Запись сохранена в Movies/Screen Recording${NC}"
    echo -e "${YELLOW}💡 После записи переместите видео в: $OUTPUT_DIR${NC}"
    
    # Открываем QuickTime для записи
    open -a "QuickTime Player"
    sleep 2
    
    # Автоматически открываем окно для записи экрана
    osascript <<EOF
tell application "QuickTime Player"
    activate
    delay 1
end tell

tell application "System Events"
    keystroke "n" using {command down, shift down}
end tell
EOF
fi

# Метод 2: Используем xcrun simctl для записи (если доступен)
echo ""
echo -e "${GREEN}🎬 Альтернативный метод: Запись через xcrun simctl...${NC}"
echo "Запись будет начата через 5 секунд..."
sleep 5

RECORDING_FILE="$OUTPUT_DIR/simulator_recording.mov"
xcrun simctl io "$SIMULATOR_UDID" recordVideo "$RECORDING_FILE" &
RECORD_PID=$!

echo -e "${GREEN}🔴 ИДЕТ ЗАПИСЬ...${NC}"
echo "Демонстрируйте функции приложения в течение 45 секунд"

# Демонстрация функций (автоматические действия можно добавить через UI Automator)
sleep 45

# Останавливаем запись
kill $RECORD_PID 2>/dev/null || true
sleep 2

if [ -f "$RECORDING_FILE" ]; then
    echo -e "${GREEN}✅ Запись завершена: $RECORDING_FILE${NC}"
    
    # Конвертируем в MP4 с оптимизацией
    echo -e "${GREEN}🎞️  Обработка видео...${NC}"
    ffmpeg -i "$RECORDING_FILE" \
        -c:v libx264 \
        -preset medium \
        -crf 23 \
        -c:a aac \
        -b:a 128k \
        -movflags +faststart \
        -vf "scale=1080:-2" \
        -y \
        "$OUTPUT_FILE" 2>/dev/null
    
    if [ -f "$OUTPUT_FILE" ]; then
        echo -e "${GREEN}✅ Демо-видео готово: $OUTPUT_FILE${NC}"
        ls -lh "$OUTPUT_FILE"
        
        # Открываем файл
        open "$OUTPUT_FILE"
    else
        echo -e "${YELLOW}⚠️  Используйте оригинальную запись: $RECORDING_FILE${NC}"
    fi
fi

# Останавливаем Flutter процесс
kill $FLUTTER_PID 2>/dev/null || true

echo ""
echo -e "${GREEN}✨ Готово!${NC}"
echo -e "Видео сохранено в: ${YELLOW}$OUTPUT_FILE${NC}"

