#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

BOILERPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURRENT_DIR="$(pwd)"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Flutter Boilerplate Project Generator${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

read -p "📂 생성할 폴더 경로 (기본값: 현재 폴더): " TARGET_BASE
if [[ -z "$TARGET_BASE" ]]; then
    TARGET_BASE="$CURRENT_DIR"
fi
TARGET_BASE="$(cd "$TARGET_BASE" 2>/dev/null && pwd)"
if [[ ! -d "$TARGET_BASE" ]]; then
    echo -e "${RED}⚠ 유효하지 않은 경로입니다: $TARGET_BASE${NC}"
    exit 1
fi

read -p "📦 Project 이름 (영문, snake_case): " PROJECT_NAME
while [[ -z "$PROJECT_NAME" ]]; do
    echo -e "${RED}⚠ Project 이름을 입력해주세요.${NC}"
    read -p "📦 Project 이름 (영문, snake_case): " PROJECT_NAME
done

if [[ ! "$PROJECT_NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
    echo -e "${RED}⚠ 영문 소문자, 숫자, _(underscore)만 가능합니다. 예: my_awesome_app${NC}"
    exit 1
fi

read -p "🍎 iOS Bundle ID (예: com.example.myapp): " BUNDLE_ID
while [[ -z "$BUNDLE_ID" ]]; do
    echo -e "${RED}⚠ Bundle ID를 입력해주세요.${NC}"
    read -p "🍎 iOS Bundle ID (예: com.example.myapp): " BUNDLE_ID
done

read -p "🏢 Organization Name (예: My Company): " ORG_NAME
while [[ -z "$ORG_NAME" ]]; do
    echo -e "${RED}⚠ Organization Name을 입력해주세요.${NC}"
    read -p "🏢 Organization Name (예: My Company): " ORG_NAME
done

PASCAL_CASE=$(echo "$PROJECT_NAME" | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2));}1' | tr -d ' ')

echo ""
echo -e "${YELLOW}📋 입력 확인:${NC}"
echo "  • 대상 폴더: $TARGET_BASE"
echo "  • Project Name: $PROJECT_NAME"
echo "  • Bundle ID: $BUNDLE_ID"
echo "  • Organization: $ORG_NAME"
echo ""

TARGET_DIR="$TARGET_BASE/$PROJECT_NAME"

if [[ -d "$TARGET_DIR" ]]; then
    echo -e "${RED}⚠ 이미 존재하는 폴더입니다: $TARGET_DIR${NC}"
    read -p "덮어쓰시겠습니까? (y/n): " CONFIRM
    if [[ "$CONFIRM" != "y" ]]; then
        echo "취소되었습니다."
        exit 0
    fi
    rm -rf "$TARGET_DIR"
fi

echo -e "${GREEN}✅ 새 프로젝트 폴더 생성: $TARGET_DIR${NC}"
mkdir -p "$TARGET_DIR"

COPY_ITEMS=(
    "lib" "android" "ios" "test" "supabase" "docs"
    "pubspec.yaml" "analysis_options.yaml" ".env.example"
    ".gitignore" ".metadata" "README.md" "DESIGN.md" "AGENTS.md"
    "flutter_template.iml"
)

echo -e "${GREEN}📂 파일 복사 중...${NC}"
for item in "${COPY_ITEMS[@]}"; do
    if [[ -e "$BOILERPLATE_DIR/$item" ]]; then
        cp -r "$BOILERPLATE_DIR/$item" "$TARGET_DIR/"
        echo "  ✓ $item"
    fi
done

replace_text() {
    local file="$1"
    local old="$2"
    local new="$3"

    if [[ -f "$file" ]]; then
        sed -i '' "s|$old|$new|g" "$file" 2>/dev/null || \
        sed -i "s|$old|$new|g" "$file"
    fi
}

echo ""
echo -e "${GREEN}🔧 텍스트 치환 중...${NC}"

cd "$TARGET_DIR"

replace_text "pubspec.yaml" "name: flutter_template" "name: $PROJECT_NAME"
echo "  ✓ pubspec.yaml (name)"

if [[ -f "android/app/build.gradle.kts" ]]; then
    replace_text "android/app/build.gradle.kts" "applicationId = \"com.example.flutter_template\"" "applicationId = \"$BUNDLE_ID\""
    replace_text "android/app/build.gradle.kts" "namespace = \"com.example.flutter_template\"" "namespace = \"${BUNDLE_ID//./_}\""
    echo "  ✓ android/app/build.gradle.kts"
fi

if [[ -f "ios/Runner.xcodeproj/project.pbxproj" ]]; then
    replace_text "ios/Runner.xcodeproj/project.pbxproj" "com.example.flutterTemplate" "$BUNDLE_ID"
    replace_text "ios/Runner.xcodeproj/project.pbxproj" "Flutter Template" "$PASCAL_CASE"
    echo "  ✓ ios/Runner.xcodeproj/project.pbxproj (Bundle ID)"
fi

if [[ -f "ios/Runner/Info.plist" ]]; then
    replace_text "ios/Runner/Info.plist" "Flutter Template" "$PASCAL_CASE"
    echo "  ✓ ios/Runner/Info.plist"
fi

if [[ -f "ios/Runner/Runner.entitlements" ]]; then
    replace_text "ios/Runner/Runner.entitlements" "com.example.flutterTemplate" "$BUNDLE_ID"
    echo "  ✓ ios/Runner/Runner.entitlements"
fi

if [[ -f "android/app/src/main/res/values/strings.xml" ]]; then
    replace_text "android/app/src/main/res/values/strings.xml" "flutter_template" "$PROJECT_NAME"
    echo "  ✓ android/app/src/main/res/values/strings.xml"
fi

for file in $(find lib -name "*.dart" -type f 2>/dev/null); do
    if [[ -f "$file" ]]; then
        replace_text "$file" "package:flutter_template/" "package:$PROJECT_NAME/"
    fi
done
echo "  ✓ lib/*.dart (package 경로)"

for file in $(find test -name "*.dart" -type f 2>/dev/null); do
    if [[ -f "$file" ]]; then
        replace_text "$file" "package:flutter_template/" "package:$PROJECT_NAME/"
    fi
done
echo "  ✓ test/*.dart (package 경로)"

if [[ -f "flutter_template.iml" ]]; then
    replace_text "flutter_template.iml" "flutter_template" "$PROJECT_NAME"
    mv "flutter_template.iml" "$PROJECT_NAME.iml" 2>/dev/null || true
    echo "  ✓ *.iml"
fi

if [[ -f "README.md" ]]; then
    replace_text "README.md" "flutter_template" "$PROJECT_NAME"
    echo "  ✓ README.md"
fi

if [[ -f "android/settings.gradle.kts" ]]; then
    replace_text "android/settings.gradle.kts" "rootProject.name = \"flutter_template\"" "rootProject.name = \"$PROJECT_NAME\""
    echo "  ✓ android/settings.gradle.kts"
fi

if [[ -f "ios/Podfile" ]]; then
    replace_text "ios/Podfile" "flutterTemplate" "$PROJECT_NAME"
    echo "  ✓ ios/Podfile"
fi

if [[ -f "android/gradle.properties" ]]; then
    replace_text "android/gradle.properties" "flutterTemplate" "$PROJECT_NAME"
    echo "  ✓ android/gradle.properties"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✅ 완료!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "📁 프로젝트 위치: ${BLUE}$TARGET_DIR${NC}"
echo ""
echo "📝 다음 단계:"
echo "  1. cd $TARGET_DIR"
echo "  2. flutter pub get"
echo "  3. flutter run"
echo ""