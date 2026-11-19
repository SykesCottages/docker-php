#!/usr/bin/env bash
set -uo pipefail

VERSIONS=("7.4" "8.0" "8.1" "8.2" "8.3" "8.4" "8.5")
VARIANTS=("cli" "fpm")
ARCHS=("amd64" "arm64")

PULL_FLAG="${1:---pull=always}"
FAILURES=0

printf "%-38s | %-10s | %-22s | %-8s\n" "IMAGE" "VERSION" "BUILT" "STATUS"
printf "%.0s-" {1..88}; echo

for VERSION in "${VERSIONS[@]}"; do
  MIN_SAFE=""
  case "$VERSION" in
    8.2) MIN_SAFE="8.2.36" ;;
    8.3) MIN_SAFE="8.3.37" ;;
    8.4) MIN_SAFE="8.4.28" ;;
    8.5) MIN_SAFE="8.5.13" ;;
  esac

  if [[ -n "$MIN_SAFE" ]]; then
    UPSTREAM=$(curl -fsSL "https://www.php.net/releases/index.php?json&version=${VERSION}" 2>/dev/null | jq -r '.version // empty' || true)
    if [[ -n "$UPSTREAM" && "$(printf '%s\n' "$MIN_SAFE" "$UPSTREAM" | sort -V | tail -n1)" == "$UPSTREAM" ]]; then
      MIN_SAFE="$UPSTREAM"
    fi
  fi

  for ARCH in "${ARCHS[@]}"; do
    PLATFORM="linux/${ARCH}"
    TAGS_TO_CLEAN=()

    for VARIANT in "${VARIANTS[@]}"; do
      if [[ "$VARIANT" == "fpm" ]]; then
        BIN_NAME="php-fpm"
        EXPECTED_SAPI="fpm-fcgi"
      else
        BIN_NAME="php"
        EXPECTED_SAPI="cli"
      fi

      TAG="sykescottages/php:${VERSION}-${VARIANT}-${ARCH}"
      TAGS_TO_CLEAN+=("$TAG")

      ERR_FILE=$(mktemp)
      OUTPUT=$(docker run --rm "$PULL_FLAG" --platform "$PLATFORM" --entrypoint "$BIN_NAME" "$TAG" -v 2>"$ERR_FILE")
      EXIT_CODE=$?
      ERR_MSG=$(grep -E '^docker:' "$ERR_FILE" | tail -n1 || tail -n1 "$ERR_FILE")
      rm -f "$ERR_FILE"

      if [[ $EXIT_CODE -ne 0 || -z "$OUTPUT" ]]; then
        printf "%-38s | %-10s | %-22s | ❌ FAIL (%s)\n" "$TAG" "-" "-" "${ERR_MSG:-run failed}"
        ((FAILURES++))
        continue
      fi

      FIRST_LINE=$(echo "$OUTPUT" | head -n1)
      FULL_VERSION=$(echo "$FIRST_LINE" | grep -oE '^PHP [0-9]+\.[0-9]+\.[0-9]+' | awk '{print $2}' || true)
      BUILT_RAW=$(echo "$FIRST_LINE" | sed -n 's/.*(built: \([^)]*\)).*/\1/p')

      BUILT_YMD=$(python3 -c '
import sys, datetime, re
s = re.sub(r"\s+", " ", sys.argv[1].strip())
try:
    print(datetime.datetime.strptime(s, "%b %d %Y %H:%M:%S").strftime("%Y%m%d"))
except Exception:
    print("0")
' "$BUILT_RAW")

      STATUS="✅ OK"
      REASON=""

      if [[ "$FIRST_LINE" != *"(${EXPECTED_SAPI})"* ]]; then
        STATUS="❌ FAIL"
        REASON="wrong SAPI"
      elif [[ -z "$FULL_VERSION" || "$FULL_VERSION" != "${VERSION}."* ]]; then
        STATUS="❌ FAIL"
        REASON="version mismatch"
      elif (( BUILT_YMD < 20261021 )); then
        STATUS="❌ FAIL"
        REASON="built < Oct 21"
      elif [[ -n "$MIN_SAFE" && "$(printf '%s\n' "$MIN_SAFE" "$FULL_VERSION" | sort -V | head -n1)" != "$MIN_SAFE" ]]; then
        STATUS="❌ FAIL"
        REASON="below ${MIN_SAFE}"
      fi

      if [[ "$STATUS" != "✅ OK" ]]; then
        ((FAILURES++))
        printf "%-38s | %-10s | %-22s | %s (%s)\n" "$TAG" "${FULL_VERSION:-?}" "${BUILT_RAW:-?}" "$STATUS" "$REASON"
      else
        printf "%-38s | %-10s | %-22s | %s\n" "$TAG" "$FULL_VERSION" "$BUILT_RAW" "$STATUS"
      fi
    done

    # Remove the checked fpm and cli images for this version/arch to avoid filling Docker disk
    docker rmi -f "${TAGS_TO_CLEAN[@]}" >/dev/null 2>&1 || true
  done
done

echo
if (( FAILURES > 0 )); then
  echo "❌ ${FAILURES} image(s) failed verification."
  exit 1
else
  echo "✅ All PHP 7.4+ CLI and FPM images (amd64 & arm64) passed verification."
fi
