#!/bin/bash
# bump_version.sh

CMAKE_FILE="CMakeLists.txt"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Работаем только в main/master
if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
    exit 0
fi

# Получаем текущую версию из CMakeLists.txt
CURRENT_VERSION=$(grep -E '^project\([^)]*VERSION[[:space:]]+([0-9]+\.[0-9]+\.[0-9]+)' $CMAKE_FILE | sed -E 's/.*VERSION[[:space:]]+([0-9]+\.[0-9]+\.[0-9]+).*/\1/')

if [ -z "$CURRENT_VERSION" ]; then
    echo "Не удалось найти версию в $CMAKE_FILE"
    exit 1
fi

echo "Текущая версия: $CURRENT_VERSION"

# Функция увеличения версии
bump_version() {
    local version=$1
    local type=$2
    
    IFS='.' read -r major minor patch <<< "$version"
    
    case $type in
        major)
            echo "$((major + 1)).0.0"
            ;;
        minor)
            echo "$major.$((minor + 1)).0"
            ;;
        patch)
            echo "$major.$minor.$((patch + 1))"
            ;;
        *)
            echo "$version"
            ;;
    esac
}

# Читаем сообщение коммита
COMMIT_MSG=$(cat "$1" 2>/dev/null || echo "")

# Определяем тип обновления
if echo "$COMMIT_MSG" | grep -qE '^breaking|^major|!:' || \
   echo "$COMMIT_MSG" | grep -qE 'BREAKING CHANGE:'; then
    NEW_VERSION=$(bump_version "$CURRENT_VERSION" "major")
    TYPE="MAJOR"
elif echo "$COMMIT_MSG" | grep -qE '^feat|^feature|^new'; then
    NEW_VERSION=$(bump_version "$CURRENT_VERSION" "minor")
    TYPE="MINOR"
elif echo "$COMMIT_MSG" | grep -qE '^fix|^bugfix|^hotfix|^patch'; then
    NEW_VERSION=$(bump_version "$CURRENT_VERSION" "patch")
    TYPE="PATCH"
else
    echo "Версия не изменена (нет ключевого слова в commit message)"
    exit 0
fi

# Обновляем CMakeLists.txt
sed -i.bak -E "s/^(project\([^)]*VERSION[[:space:]]+)[0-9]+\.[0-9]+\.[0-9]+/\1$NEW_VERSION/" $CMAKE_FILE
rm -f ${CMAKE_FILE}.bak

echo "Версия обновлена: $CURRENT_VERSION → $NEW_VERSION ($TYPE)"

# Добавляем изменённый файл в коммит
git add $CMAKE_FILE

# Генерируем version.h для C++ (после обновления версии)
cat > include/version.h << EOF
#pragma once
// Автоматически сгенерировано, не редактировать вручную
#define PROJECT_VERSION "$NEW_VERSION"
EOF

git add include/version.h