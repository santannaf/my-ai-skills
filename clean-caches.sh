#!/bin/bash

set -euo pipefail

GRADLE_HOME="${HOME}/.gradle"
GRADLE_CACHES="${GRADLE_HOME}/caches"
GRADLE_WRAPPER="${GRADLE_HOME}/wrapper/dists"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "========================================"
echo "        Gradle Cache Cleaner"
echo "========================================"
echo ""

# Show current cache size before cleaning
if [ -d "$GRADLE_HOME" ]; then
    TOTAL_SIZE=$(du -sh "$GRADLE_HOME" 2>/dev/null | cut -f1)
    echo -e "${YELLOW}Current ~/.gradle size: ${TOTAL_SIZE}${NC}"
else
    echo -e "${YELLOW}No ~/.gradle directory found.${NC}"
    exit 0
fi

echo ""
echo "What do you want to clean?"
echo "  [1] Caches only       (~/.gradle/caches)"
echo "  [2] Wrapper dists     (~/.gradle/wrapper/dists)"
echo "  [3] Both (recommended)"
echo "  [4] Everything        (~/.gradle — includes global configs)"
echo "  [0] Cancel"
echo ""
read -rp "Choose an option: " OPTION

echo ""

clean_caches() {
    if [ -d "$GRADLE_CACHES" ]; then
        SIZE=$(du -sh "$GRADLE_CACHES" 2>/dev/null | cut -f1)
        echo -e "${YELLOW}Removing caches (${SIZE})...${NC}"
        rm -rf "$GRADLE_CACHES"
        echo -e "${GREEN}✔ Caches removed.${NC}"
    else
        echo -e "${GREEN}✔ No caches directory found, skipping.${NC}"
    fi
}

clean_wrapper() {
    if [ -d "$GRADLE_WRAPPER" ]; then
        SIZE=$(du -sh "$GRADLE_WRAPPER" 2>/dev/null | cut -f1)
        echo -e "${YELLOW}Removing wrapper dists (${SIZE})...${NC}"
        rm -rf "$GRADLE_WRAPPER"
        echo -e "${GREEN}✔ Wrapper dists removed.${NC}"
    else
        echo -e "${GREEN}✔ No wrapper/dists directory found, skipping.${NC}"
    fi
}

clean_all() {
    SIZE=$(du -sh "$GRADLE_HOME" 2>/dev/null | cut -f1)
    echo -e "${RED}Removing entire ~/.gradle (${SIZE})...${NC}"
    rm -rf "$GRADLE_HOME"
    echo -e "${GREEN}✔ ~/.gradle removed.${NC}"
    echo -e "${YELLOW}⚠  Global gradle.properties and init scripts were also deleted.${NC}"
}

case "$OPTION" in
    1) clean_caches ;;
    2) clean_wrapper ;;
    3) clean_caches && clean_wrapper ;;
    4)
        read -rp "⚠  This removes ALL Gradle config. Are you sure? (yes/N): " CONFIRM
        if [ "$CONFIRM" = "yes" ]; then
            clean_all
        else
            echo -e "${YELLOW}Cancelled.${NC}"
            exit 0
        fi
        ;;
    0)
        echo "Cancelled."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid option. Exiting.${NC}"
        exit 1
        ;;
esac

echo ""
echo "========================================"
echo -e "${GREEN}  Cache cleaned successfully!${NC}"
echo "========================================"
echo ""
echo "Next step — run inside your project directory:"
echo ""
echo "  ./gradlew build --refresh-dependencies"
echo ""