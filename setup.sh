#!/usr/bin/env bash
# ============================================================
#  coding-suisei patch v3.0 — fullstack-dev wrapper + quality gates
#
#  What this does:
#    1. Deploys coding-suisei skill (quality-gated coding workflow)
#    2. Patches fullstack-dev SKILL.md with routing wrapper
#       - Web dev tasks -> original fullstack-dev flow
#       - General coding -> delegates to coding-suisei
#    3. Removes _meta.json if present
#
#  Usage:
#    git clone https://github.com/hoshiyomiX/coding-agent-patch.git /tmp/cap
#    cd /tmp/cap && bash setup.sh
#
#  Trigger marker: ☄️
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/skill"
SKILLS_DIR="${HOME}/my-project/skills"

SUISEI_DIR="${SKILLS_DIR}/coding-suisei"
FULLSTACK_DIR="${SKILLS_DIR}/fullstack-dev"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
fail()  { echo -e "${RED}[FAIL]${NC}  $*"; }

echo ""
echo "============================================"
echo "  coding-suisei patch v3.0"
echo "  Trigger marker: ☄️"
echo "============================================"
echo ""

if [ ! -f "${SOURCE_DIR}/coding-suisei/SKILL.md" ]; then
    fail "Source files not found in ${SOURCE_DIR}/coding-suisei/"
    echo "  Make sure you cloned the full repo."
    exit 1
fi

ERRORS=0

# ============================================================
# PART 1: Deploy coding-suisei skill
# ============================================================
echo ""
info "=== PART 1: Deploy coding-suisei skill ==="
echo ""

mkdir -p "${SUISEI_DIR}"
mkdir -p "${SUISEI_DIR}/knowledge"
mkdir -p "${SUISEI_DIR}/workflow"
ok "Directories created"

# SKILL.md
cp "${SOURCE_DIR}/coding-suisei/SKILL.md" "${SUISEI_DIR}/SKILL.md"
ok "SKILL.md deployed"

# Knowledge files
for ref in architecture.md conventions.md gotchas.md error-patterns.md; do
    if [ -f "${SOURCE_DIR}/coding-suisei/knowledge/${ref}" ]; then
        cp "${SOURCE_DIR}/coding-suisei/knowledge/${ref}" "${SUISEI_DIR}/knowledge/${ref}"
        ok "knowledge/${ref}"
    fi
done

# Workflow files
for ref in gates.md plan-template.md review-checklist.md; do
    if [ -f "${SOURCE_DIR}/coding-suisei/workflow/${ref}" ]; then
        cp "${SOURCE_DIR}/coding-suisei/workflow/${ref}" "${SUISEI_DIR}/workflow/${ref}"
        ok "workflow/${ref}"
    fi
done

# Reference files
for ref in memory-template.md state.md criteria.md; do
    if [ -f "${SOURCE_DIR}/coding-suisei/${ref}" ]; then
        cp "${SOURCE_DIR}/coding-suisei/${ref}" "${SUISEI_DIR}/${ref}"
        ok "${ref}"
    fi
done

# Remove _meta.json if exists
if [ -f "${SUISEI_DIR}/_meta.json" ]; then
    rm -f "${SUISEI_DIR}/_meta.json"
    ok "_meta.json removed"
else
    ok "_meta.json not present"
fi

# ============================================================
# PART 2: Patch fullstack-dev with routing wrapper
# ============================================================
echo ""
info "=== PART 2: Patch fullstack-dev wrapper ==="
echo ""

if [ ! -d "${FULLSTACK_DIR}" ]; then
    fail "fullstack-dev directory not found at ${FULLSTACK_DIR}"
    ERRORS=$((ERRORS + 1))
else
    if [ ! -f "${FULLSTACK_DIR}/SKILL.md.original" ]; then
        cp "${FULLSTACK_DIR}/SKILL.md" "${FULLSTACK_DIR}/SKILL.md.original"
        ok "Original SKILL.md backed up"
    else
        ok "Backup already exists"
    fi

    if [ -f "${SOURCE_DIR}/fullstack-dev-SKILL.md" ]; then
        cp "${SOURCE_DIR}/fullstack-dev-SKILL.md" "${FULLSTACK_DIR}/SKILL.md"
        ok "Wrapper SKILL.md deployed"
    else
        fail "Wrapper file not found"
        ERRORS=$((ERRORS + 1))
    fi
fi

# ============================================================
# PART 3: Cleanup
# ============================================================
echo ""
info "=== PART 3: Cleanup ==="
echo ""

if [ -d "${SKILLS_DIR}/code" ]; then
    rm -rf "${SKILLS_DIR}/code"
    ok "Duplicate 'code/' removed"
else
    ok "No duplicate found"
fi

# Remove old coding-agent if exists (migration)
if [ -d "${SKILLS_DIR}/coding-agent" ] && [ ! -d "${SUISEI_DIR}/_migrated_from_coding_agent" ]; then
    cp "${SKILLS_DIR}/coding-agent/memory.md" "${SUISEI_DIR}/memory.md" 2>/dev/null || true
    touch "${SUISEI_DIR}/_migrated_from_coding_agent"
    ok "Migrated memory from coding-agent"
fi

# ============================================================
# PART 4: Verification
# ============================================================
echo ""
info "=== PART 4: Verification ==="
echo ""

# Check coding-suisei
if [ -f "${SUISEI_DIR}/SKILL.md" ]; then
    if grep -q "QUALITY GATES" "${SUISEI_DIR}/SKILL.md"; then
        ok "coding-suisei: Quality gates present"
    else
        fail "coding-suisei: Quality gates MISSING"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "☄️" "${SUISEI_DIR}/SKILL.md"; then
        ok "coding-suisei: ☄️ marker present"
    else
        fail "coding-suisei: ☄️ marker MISSING"
        ERRORS=$((ERRORS + 1))
    fi

    for f in knowledge/architecture.md knowledge/conventions.md knowledge/gotchas.md knowledge/error-patterns.md workflow/gates.md workflow/plan-template.md workflow/review-checklist.md; do
        if [ -f "${SUISEI_DIR}/${f}" ]; then
            ok "${f} present"
        else
            fail "${f} MISSING"
            ERRORS=$((ERRORS + 1))
        fi
    done
else
    fail "coding-suisei: SKILL.md not found"
    ERRORS=$((ERRORS + 1))
fi

# Check fullstack-dev wrapper
if [ -f "${FULLSTACK_DIR}/SKILL.md" ]; then
    if grep -q "ROUTING DECISION" "${FULLSTACK_DIR}/SKILL.md"; then
        ok "fullstack-dev: Routing wrapper present"
    else
        fail "fullstack-dev: Routing wrapper MISSING"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "coding-suisei" "${FULLSTACK_DIR}/SKILL.md"; then
        ok "fullstack-dev: coding-suisei delegation configured"
    else
        fail "fullstack-dev: coding-suisei delegation MISSING"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "☄️" "${FULLSTACK_DIR}/SKILL.md"; then
        ok "fullstack-dev: ☄️ marker present"
    else
        fail "fullstack-dev: ☄️ marker MISSING"
        ERRORS=$((ERRORS + 1))
    fi
else
    fail "fullstack-dev: SKILL.md not found"
    ERRORS=$((ERRORS + 1))
fi

# ============================================================
# Summary
# ============================================================
echo ""
echo "============================================"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}  ☄️ Patch v3.0 installed!${NC}"
    echo ""
    echo "  • coding-suisei -> skills/coding-suisei/ (with quality gates)"
    echo "  • fullstack-dev wrapper -> skills/fullstack-dev/"
    echo "  Rollback: cp ${FULLSTACK_DIR}/SKILL.md.original ${FULLSTACK_DIR}/SKILL.md"
    echo "============================================"
else
    echo -e "${RED}  Patch completed with ${ERRORS} error(s)${NC}"
    echo "  Review errors above."
    echo "============================================"
    exit 1
fi
