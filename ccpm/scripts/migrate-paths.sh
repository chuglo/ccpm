#!/bin/bash
# CCPM Path Migration Script
# Replaces hardcoded ${CCPM_DIR}/ references with environment-aware variables

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CCPM_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

echo "CCPM Path Migration Script"
echo "=========================="
echo "Root: $CCPM_ROOT"
echo ""

# Backup directory
BACKUP_DIR="${CCPM_ROOT}/.ccpm-migration-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Creating backup in: $BACKUP_DIR"

# Function to backup and update a file
update_file() {
    local file="$1"
    local pattern="$2"
    local replacement="$3"
    
    if grep -q "$pattern" "$file" 2>/dev/null; then
        # Create backup
        local rel_path="${file#$CCPM_ROOT/}"
        local backup_file="$BACKUP_DIR/$rel_path"
        mkdir -p "$(dirname "$backup_file")"
        cp "$file" "$backup_file"
        
        # Apply replacement
        sed -i "s|$pattern|$replacement|g" "$file"
        echo "  ✓ Updated: $rel_path"
        return 0
    fi
    return 1
}

# Count files to update
total_files=$(grep -r "\${CCPM_DIR}/" ccpm/ --include="*.md" --include="*.sh" --include="*.json" -l 2>/dev/null | wc -l)
echo "Found $total_files files to update"
echo ""

# Update .sh files (shell scripts)
echo "Updating shell scripts..."
while IFS= read -r file; do
    # Pattern 1: "${CCPM_EPICS_DIR}" -> "${CCPM_EPICS_DIR}"
    update_file "$file" '\${CCPM_EPICS_DIR}' '${CCPM_EPICS_DIR}' || true
    update_file "$file" '\${CCPM_PRDS_DIR}' '${CCPM_PRDS_DIR}' || true
    update_file "$file" '\${CCPM_COMMANDS_DIR}' '${CCPM_COMMANDS_DIR}' || true
    update_file "$file" '\${CCPM_AGENTS_DIR}' '${CCPM_AGENTS_DIR}' || true
    update_file "$file" '\${CCPM_CONTEXT_DIR}' '${CCPM_CONTEXT_DIR}' || true
    update_file "$file" '\${CCPM_SCRIPTS_DIR}' '${CCPM_SCRIPTS_DIR}' || true
    update_file "$file" '\${CCPM_RULES_DIR}' '${CCPM_RULES_DIR}' || true
    update_file "$file" '\${CCPM_HOOKS_DIR}' '${CCPM_HOOKS_DIR}' || true
    
    # Pattern 2: Generic "${CCPM_DIR}/" -> "${CCPM_DIR}/"
    update_file "$file" '\${CCPM_DIR}/' '${CCPM_DIR}/' || true
done < <(find ccpm -name "*.sh" -type f 2>/dev/null)

# Update .md files (markdown - commands, agents, docs)
echo ""
echo "Updating markdown files..."
while IFS= read -r file; do
    # For markdown, we use the same replacements but in backticks/code blocks
    update_file "$file" '\${CCPM_EPICS_DIR}' '${CCPM_EPICS_DIR}' || true
    update_file "$file" '\${CCPM_PRDS_DIR}' '${CCPM_PRDS_DIR}' || true
    update_file "$file" '\${CCPM_COMMANDS_DIR}' '${CCPM_COMMANDS_DIR}' || true
    update_file "$file" '\${CCPM_AGENTS_DIR}' '${CCPM_AGENTS_DIR}' || true
    update_file "$file" '\${CCPM_CONTEXT_DIR}' '${CCPM_CONTEXT_DIR}' || true
    update_file "$file" '\${CCPM_SCRIPTS_DIR}' '${CCPM_SCRIPTS_DIR}' || true
    update_file "$file" '\${CCPM_RULES_DIR}' '${CCPM_RULES_DIR}' || true
    update_file "$file" '\${CCPM_HOOKS_DIR}' '${CCPM_HOOKS_DIR}' || true
    update_file "$file" '\${CCPM_DIR}/' '${CCPM_DIR}/' || true
done < <(find ccpm -name "*.md" -type f 2>/dev/null)

# Update .json files
echo ""
echo "Updating JSON files..."
while IFS= read -r file; do
    update_file "$file" '\${CCPM_EPICS_DIR}' '${CCPM_EPICS_DIR}' || true
    update_file "$file" '\${CCPM_PRDS_DIR}' '${CCPM_PRDS_DIR}' || true
    update_file "$file" '\${CCPM_COMMANDS_DIR}' '${CCPM_COMMANDS_DIR}' || true
    update_file "$file" '\${CCPM_AGENTS_DIR}' '${CCPM_AGENTS_DIR}' || true
    update_file "$file" '\${CCPM_CONTEXT_DIR}' '${CCPM_CONTEXT_DIR}' || true
    update_file "$file" '\${CCPM_SCRIPTS_DIR}' '${CCPM_SCRIPTS_DIR}' || true
    update_file "$file" '\${CCPM_RULES_DIR}' '${CCPM_RULES_DIR}' || true
    update_file "$file" '\${CCPM_HOOKS_DIR}' '${CCPM_HOOKS_DIR}' || true
    update_file "$file" '\${CCPM_DIR}/' '${CCPM_DIR}/' || true
done < <(find ccpm -name "*.json" -type f 2>/dev/null)

echo ""
echo "Migration complete!"
echo ""
echo "Backup saved to: $BACKUP_DIR"
echo ""
echo "Next steps:"
echo "1. Review changes: git diff"
echo "2. Test the system: source ccpm/ccpm.config && env | grep CCPM"
echo "3. If everything works, you can delete: $BACKUP_DIR"
echo ""
