#!/usr/bin/env bash
# ============================================================
#  stellar-coding-agent install v4.5.0 — phase state machine + coexistence
#
#  What this does:
#    1. Wipes and redeploys stellar-coding-agent (clean mirror)
#    2. Restores fullstack-dev to original (removes old wrapper from v4.0.x)
#    3. Cleans up legacy skill directories
#
#  Coexistence model:
#    stellar-coding-agent = process governance (phases, traceability, attestation)
#    fullstack-dev         = technical expertise (Next.js, UI, SDK, project structure)
#    Both can be loaded simultaneously — they are orthogonal, not competing.
#
#  Usage:
#    git clone https://github.com/hoshiyomiX/stellar-coding-agent.git /tmp/cap
#    cd /tmp/cap && bash setup.sh
#
#  Invoke:
#    Skill(command="stellar-coding-agent")
#
#  Trigger marker: ☄️
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/skill/stellar-coding-agent"
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
echo "  stellar-coding-agent v4.5.0"
echo "  Trigger marker: ☄️"
echo "============================================"
echo ""

if [ ! -f "${SOURCE_DIR}/SKILL.md" ]; then
    fail "Source files not found in ${SOURCE_DIR}/"
    echo "  Make sure you cloned the full repo."
    exit 1
fi

ERRORS=0

# ============================================================
# PART 1: Clean deploy — wipe and mirror from source
# ============================================================
echo ""
info "=== PART 1: Deploy stellar-coding-agent (clean mirror) ==="
echo ""

if [ -d "${STELLAR_DIR}" ]; then
    rm -rf "${STELLAR_DIR}"
    ok "Previous installation removed"
fi

cp -R "${SOURCE_DIR}" "${STELLAR_DIR}"

# Remove files that shouldn't be deployed
rm -f "${STELLAR_DIR}/_meta.json"

ok "All files mirrored from source"

# ============================================================
# PART 2: Restore fullstack-dev to original (remove old wrapper)
# ============================================================
echo ""
info "=== PART 2: Restore fullstack-dev ==="
echo ""

if [ -f "${FULLSTACK_DIR}/SKILL.md.original" ]; then
    cp "${FULLSTACK_DIR}/SKILL.md.original" "${FULLSTACK_DIR}/SKILL.md"
    rm -f "${FULLSTACK_DIR}/SKILL.md.original"
    ok "fullstack-dev restored to original (wrapper removed)"
else
    ok "fullstack-dev not patched (no wrapper to remove)"
fi

# ============================================================
# PART 3: Cleanup legacy skill directories
# ============================================================
echo ""
info "=== PART 3: Cleanup legacy directories ==="
echo ""

if [ -d "${SKILLS_DIR}/code" ]; then
    rm -rf "${SKILLS_DIR}/code"
    ok "Duplicate 'code/' removed"
else
    ok "No duplicate found"
fi

if [ -d "${SKILLS_DIR}/coding-suisei" ]; then
    rm -rf "${SKILLS_DIR}/coding-suisei"
    ok "Legacy 'coding-suisei/' removed"
else
    ok "No coding-suisei found"
fi

# ============================================================
# PART 4: Verification
# ============================================================
echo ""
info "=== PART 4: Verification ==="
echo ""

if [ -f "${STELLAR_DIR}/SKILL.md" ]; then
    if grep -q "Phase State Machine" "${STELLAR_DIR}/SKILL.md"; then
        ok "Phase state machine present"
    else
        fail "Phase state machine MISSING"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "☄️" "${STELLAR_DIR}/SKILL.md"; then
        ok "☄️ marker present"
    else
        fail "☄️ marker MISSING"
        ERRORS=$((ERRORS + 1))
    fi

    for f in \
        procedure/phases.md \
        procedure/templates/problem-spec.md \
        procedure/templates/implementation-plan.md \
        procedure/templates/verification-report.md \
        procedure/templates/incident-report.md \
        procedure/decision-trees/error-resolution.md \
        constraints/code-standards.md \
        constraints/type-safety.md \
        knowledge/architecture.md \
        knowledge/conventions.md \
        knowledge/platform-constraints.md \
        knowledge/error-patterns.md \
        CHANGELOG.md; do
        if [ -f "${STELLAR_DIR}/${f}" ]; then
            ok "${f}"
        else
            fail "${f} MISSING"
            ERRORS=$((ERRORS + 1))
        fi
    done

    # Ensure no deprecated files leaked through
    for f in workflow/gates.md workflow/plan-template.md workflow/review-checklist.md knowledge/gotchas.md; do
        if [ -f "${STELLAR_DIR}/${f}" ]; then
            fail "${f} should not exist"
            ERRORS=$((ERRORS + 1))
        fi
    done
else
    fail "SKILL.md not found"
    ERRORS=$((ERRORS + 1))
fi

# ============================================================
# Summary
# ============================================================
echo ""
echo "============================================"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}  ☄️ stellar-coding-agent v4.5.0 installed!${NC}"
    echo ""
    echo "  • stellar-coding-agent -> skills/stellar-coding-agent/"
    echo "    Phase state machine + artifact templates + knowledge base"
    echo "  • Coexists with fullstack-dev (process + technical expertise)"
    echo "  • Invoke with: Skill(command=\"stellar-coding-agent\")"
    echo "============================================"
else
    echo -e "${RED}  Install completed with ${ERRORS} error(s)${NC}"
    echo "  Review errors above."
    echo "============================================"
    exit 1
fi
