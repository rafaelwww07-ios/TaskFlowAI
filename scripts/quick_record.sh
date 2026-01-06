#!/bin/bash

# Быстрая запись демо-видео (упрощенная версия)

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="$PROJECT_DIR/demo_video"

mkdir -p "$OUTPUT_DIR"

echo "🎬 Быстрая запись демо-видео TaskFlow AI"
echo ""

# Получаем UDID симулятора
SIMULATOR=$(xcrun simctl list devices available | grep -i "iPhone" | head -1 | grep -oE '([A-F0-9-]{36})' | head -1)

if [ -z "$SIMULATOR" ]; then
    echo "❌ Симулятор не найден"
    exit 1
fi

echo "📱 Найден симулятор: $SIMULATOR"
echo "🚀 Запускаю приложение..."
cd "$PROJECT_DIR"

# Запускаем приложение в фоне
flutter run -d "$SIMULATOR" --release > /dev/null 2>&1 &
FLUTTER_PID=$!

sleep 10

echo ""
echo "✅ Приложение запущено!"
echo ""
echo "📹 Теперь записывайте экран:"
echo ""
echo "1️⃣  Откройте QuickTime Player (⌘+Space → QuickTime)"
echo "2️⃣  File → New Screen Recording"
echo "3️⃣  Выберите окно симулятора"
echo "4️⃣  Нажмите Record"
echo "5️⃣  Демонстрируйте функции (45-60 секунд)"
echo "6️⃣  Остановите запись (Cmd+Control+Esc)"
echo ""
echo "📝 Сценарий: scripts/demo_scenario.md"
echo "💾 Сохраните видео в: $OUTPUT_DIR"
echo ""
echo "⏸️  Нажмите Enter когда закончите запись..."

read -r

# Останавливаем Flutter
kill $FLUTTER_PID 2>/dev/null || true

echo ""
echo "✨ Готово!"

