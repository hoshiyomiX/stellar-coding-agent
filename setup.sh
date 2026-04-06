#!/usr/bin/env bash
# ============================================================
#  stellar-coding-agent patch v3.2 — fullstack-dev wrapper + quality gates
#
#  What this does:
#    1. Deploys stellar-coding-agent skill (quality-gated coding workflow)
#    2. Patches fullstack-dev SKILL.md with routing wrapper
#       - Web dev tasks -> original fullstack-dev flow
#       - General coding -> delegates to stellar-coding-agent
#    3. Removes _meta.json if present
#
#  Usage:
#    git clone https://github.com/hoshiyomiX/stellar-coding-agent.git /tmp/cap
#    cd /tmp/cap && bash setup.sh
#
#  Trigger marker: ☄️
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/skill"
SKILLS_DIR="${HOME}/my-project/skills"

STELLAR_DIR="${SKILLS_DIR}/stellar-coding-agent"
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
echo "  stellar-coding-agent patch v3.2"
echo "  Trigger marker: ☄️"
echo "============================================"
echo ""

if [ ! -f "${SOURCE_DIR}/stellar-coding-agent/SKILL.md" ]; then
    fail "Source files not found in ${SOURCE_DIR}/stellar-coding-agent/"
    echo "  Make sure you cloned the full repo."
    exit 1
fi

ERRORS=0

# ============================================================
# PART 1: Deploy stellar-coding-agent skill
# ============================================================
echo ""
info "=== PART 1: Deploy stellar-coding-agent skill ==="
echo ""

mkdir -p "${STELLAR_DIR}"
mkdir -p "${STELLAR_DIR}/knowledge"
mkdir -p "${STELLAR_DIR}/workflow"
ok "Directories created"

# SKILL.md
cp "${SOURCE_DIR}/stellar-coding-agent/SKILL.md" "${STELLAR_DIR}/SKILL.md"
ok "SKILL.md deployed"

# Knowledge files
for ref in architecture.md conventions.md gotchas.md error-patterns.md; do
    if [ -f "${SOURCE_DIR}/stellar-coding-agent/knowledge/${ref}" ]; then
        cp "${SOURCE_DIR}/stellar-coding-agent/knowledge/${ref}" "${STELLAR_DIR}/knowledge/${ref}"
        ok "knowledge/${ref}"
    fi
done

# Workflow files
for ref in gates.md plan-template.md review-checklist.md; do
    if [ -f "${SOURCE_DIR}/stellar-coding-agent/workflow/${ref}" ]; then
        cp "${SOURCE_DIR}/stellar-coding-agent/workflow/${ref}" "${STELLAR_DIR}/workflow/${ref}"
        ok "workflow/${ref}"
    fi
done

# Reference files
for ref in memory-template.md; do
    if [ -f "${SOURCE_DIR}/stellar-coding-agent/${ref}" ]; then
        cp "${SOURCE_DIR}/stellar-coding-agent/${ref}" "${STELLAR_DIR}/${ref}"
        ok "${ref}"
    fi
done

# Remove _meta.json if exists
if [ -f "${STELLAR_DIR}/_meta.json" ]; then
    rm -f "${STELLAR_DIR}/_meta.json"
    ok "_meta.json removed"
else
    ok "_meta.json not present"
fi

# Remove deprecated files from previous versions
for deprecated in criteria.md state.md; do
    if [ -f "${STELLAR_DIR}/${deprecated}" ]; then
        rm -f "${STELLAR_DIR}/${deprecated}"
        ok "${deprecated} removed (deprecated)"
    fi
done

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

# Migrate from old coding-suisei if exists
if [ -d "${SKILLS_DIR}/coding-suisei" ] && [ ! -d "${STELLAR_DIR}/_migrated_from_coding_suisei" ]; then
    cp "${SKILLS_DIR}/coding-suisei/memory.md" "${STELLAR_DIR}/memory.md" 2>/dev/null || true
    touch "${STELLAR_DIR}/_migrated_from_coding_suisei"
    ok "Migrated memory from coding-suisei"
fi

# Remove old coding-suisei if exists
if [ -d "${SKILLS_DIR}/coding-suisei" ]; then
    rm -rf "${SKILLS_DIR}/coding-suisei"
    ok "Old coding-suisei directory removed"
fi

# ============================================================
# PART 4: Verification
# ============================================================
echo ""
info "=== PART 4: Verification ==="
echo ""

# Check stellar-coding-agent
if [ -f "${STELLAR_DIR}/SKILL.md" ]; then
    if grep -q "QUALITY GATES" "${STELLAR_DIR}/SKILL.md"; then
        ok "stellar-coding-agent: Quality gates present"
    else
        fail "stellar-coding-agent: Quality gates MISSING"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "☄️" "${STELLAR_DIR}/SKILL.md"; then
        ok "stellar-coding-agent: ☄️ marker present"
    else
        fail "stellar-coding-agent: ☄️ marker MISSING"
        ERRORS=$((ERRORS + 1))
    fi

    for f in knowledge/architecture.md knowledge/conventions.md knowledge/gotchas.md knowledge/error-patterns.md workflow/gates.md workflow/plan-template.md workflow/review-checklist.md; do
        if [ -f "${STELLAR_DIR}/${f}" ]; then
            ok "${f} present"
        else
            fail "${f} MISSING"
            ERRORS=$((ERRORS + 1))
        fi
    done
else
    fail "stellar-coding-agent: SKILL.md not found"
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

    if grep -q "stellar-coding-agent" "${FULLSTACK_DIR}/SKILL.md"; then
        ok "fullstack-dev: stellar-coding-agent delegation configured"
    else
        fail "fullstack-dev: stellar-coding-agent delegation MISSING"
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
    echo -e "${GREEN}  ☄️ Patch v3.2 installed!${NC}"
    echo ""
    echo "  • stellar-coding-agent -> skills/stellar-coding-agent/ (with quality gates)"
    echo "  • fullstack-dev wrapper -> skills/fullstack-dev/"
    echo "  Rollback: cp ${FULLSTACK_DIR}/SKILL.md.original ${FULLSTACK_DIR}/SKILL.md"
    echo "============================================"
else
    echo -e "${RED}  Patch completed with ${ERRORS} error(s)${NC}"
    echo "  Review errors above."
    echo "============================================"
    exit 1
fi
