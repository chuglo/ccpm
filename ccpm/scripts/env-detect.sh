#!/bin/bash
# CCPM Environment Detection
# Detects whether running under Claude Code, OpenCode, or standalone
# Sets appropriate environment variables for path resolution

# Determine the environment
detect_environment() {
    # Check for explicit environment variable override
    if [ -n "$CCPM_FORCE_ENV" ]; then
        echo "$CCPM_FORCE_ENV"
        return 0
    fi
    
    # Try to detect from current working directory or calling context
    local current_dir="$PWD"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Check if we're being called from .opencode/ directory structure
    if [[ "$current_dir" == *"/.opencode/"* ]] || [[ "$script_dir" == *"/.opencode/"* ]]; then
        echo "opencode"
        return 0
    fi
    
    # Check if we're being called from ${CCPM_DIR}/ directory structure  
    if [[ "$current_dir" == *"/${CCPM_DIR}/"* ]] || [[ "$script_dir" == *"/${CCPM_DIR}/"* ]]; then
        echo "claude-code"
        return 0
    fi
    
    # Check for .opencode directory in project root
    local project_root="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [ -n "$project_root" ]; then
        if [ -d "$project_root/.opencode" ]; then
            echo "opencode"
            return 0
        fi
        
        if [ -d "$project_root/.claude" ]; then
            echo "claude-code"
            return 0
        fi
    fi
    
    # Default to standalone if no environment detected
    echo "standalone"
    return 0
}

# Get the base directory for the detected environment
get_base_dir() {
    local env="$1"
    
    case "$env" in
        "claude-code")
            echo ".claude"
            ;;
        "opencode")
            echo ".opencode"
            ;;
        "standalone"|*)
            echo "ccpm"
            ;;
    esac
}

# Get the ccpm directory (where actual files live)
get_ccpm_dir() {
    local env="$1"
    
    # ccpm/ is always the actual location regardless of environment
    # ${CCPM_DIR}/ and .opencode/ just symlink to it
    echo "ccpm"
}

# Get full path to ccpm subdirectory
get_ccpm_path() {
    local subdir="$1"  # e.g., "epics", "prds", "commands"
    local ccpm_dir="$(get_ccpm_dir "$CCPM_ENV")"
    
    echo "${ccpm_dir}/${subdir}"
}

# Initialize environment variables
init_environment() {
    # Detect environment
    export CCPM_ENV=$(detect_environment)
    
    # Set base directory
    export CCPM_BASE_DIR=$(get_base_dir "$CCPM_ENV")
    
    # Set ccpm directory (always "ccpm")
    export CCPM_DIR=$(get_ccpm_dir "$CCPM_ENV")
    
    # Set common paths
    export CCPM_EPICS_DIR="${CCPM_DIR}/epics"
    export CCPM_PRDS_DIR="${CCPM_DIR}/prds"
    export CCPM_COMMANDS_DIR="${CCPM_DIR}/commands"
    export CCPM_AGENTS_DIR="${CCPM_DIR}/agents"
    export CCPM_CONTEXT_DIR="${CCPM_DIR}/context"
    export CCPM_SCRIPTS_DIR="${CCPM_DIR}/scripts"
    export CCPM_RULES_DIR="${CCPM_DIR}/rules"
    export CCPM_HOOKS_DIR="${CCPM_DIR}/hooks"
    
    # Set settings file path
    export CCPM_SETTINGS_FILE="${CCPM_DIR}/settings.local.json"
    
    # Debug output (only if CCPM_DEBUG is set)
    if [ -n "$CCPM_DEBUG" ]; then
        echo "[CCPM] Environment: $CCPM_ENV" >&2
        echo "[CCPM] Base Dir: $CCPM_BASE_DIR" >&2
        echo "[CCPM] CCPM Dir: $CCPM_DIR" >&2
        echo "[CCPM] Epics: $CCPM_EPICS_DIR" >&2
        echo "[CCPM] PRDs: $CCPM_PRDS_DIR" >&2
    fi
}

# Helper function: Check if running in specific environment
is_claude_code() {
    [ "$CCPM_ENV" = "claude-code" ]
}

is_opencode() {
    [ "$CCPM_ENV" = "opencode" ]
}

is_standalone() {
    [ "$CCPM_ENV" = "standalone" ]
}

# Helper function: Get environment display name
get_env_display_name() {
    case "$CCPM_ENV" in
        "claude-code")
            echo "Claude Code"
            ;;
        "opencode")
            echo "OpenCode"
            ;;
        "standalone")
            echo "Standalone"
            ;;
        *)
            echo "Unknown"
            ;;
    esac
}

# Export all functions for use in other scripts
export -f detect_environment
export -f get_base_dir
export -f get_ccpm_dir
export -f get_ccpm_path
export -f init_environment
export -f is_claude_code
export -f is_opencode
export -f is_standalone
export -f get_env_display_name

# Auto-initialize when sourced (unless CCPM_NO_AUTO_INIT is set)
if [ -z "$CCPM_NO_AUTO_INIT" ]; then
    init_environment
fi
