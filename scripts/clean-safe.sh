#!/bin/bash

# Safe Cleanup Script
# Removes temporary artifacts and cache files without affecting:
# - node_modules, vendor/bundle (dependencies)
# - Database files
# - Git files
# - Configuration files
# - Source code

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Safety confirmation
echo "========================================="
echo "Safe Cleanup Utility"
echo "========================================="
echo ""
echo "This script will remove:"
echo "  ✅ Log files (keeps last 100 lines)"
echo "  ✅ Temporary files (tmp/)"
echo "  ✅ Cache files"
echo "  ✅ Build artifacts"
echo ""
echo "This script will NOT remove:"
echo "  ❌ node_modules (dependencies)"
echo "  ❌ vendor/bundle (Ruby gems)"
echo "  ❌ Database files"
echo "  ❌ Git files (.git/)"
echo "  ❌ Configuration files"
echo "  ❌ Source code"
echo ""

read -p "Continue with cleanup? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo "Starting cleanup..."
echo ""

# Function to safely truncate log files (keep last 100 lines)
truncate_log() {
    local log_file=$1
    local log_name=$2
    
    if [ -f "$log_file" ]; then
        local size_before=$(du -h "$log_file" 2>/dev/null | cut -f1)
        tail -n 100 "$log_file" > "${log_file}.tmp" 2>/dev/null && mv "${log_file}.tmp" "$log_file"
        local size_after=$(du -h "$log_file" 2>/dev/null | cut -f1)
        echo -e "${GREEN}✅${NC} Truncated $log_name (was $size_before, now $size_after)"
    fi
}

# Clean Backend temporary files
echo -e "${BLUE}=== Backend Cleanup ===${NC}"
if [ -d "$PROJECT_ROOT/Backend" ]; then
    cd "$PROJECT_ROOT/Backend"
    
    # Clean Rails tmp directory (safe)
    if [ -d "tmp" ]; then
        # Remove cache, pids, sockets, but keep structure
        rm -rf tmp/cache/* 2>/dev/null
        rm -rf tmp/pids/*.pid 2>/dev/null
        rm -rf tmp/sockets/* 2>/dev/null
        echo -e "${GREEN}✅${NC} Cleaned Backend tmp/cache, tmp/pids, tmp/sockets"
    fi
    
    # Clean log files (truncate, don't delete)
    if [ -d "log" ]; then
        truncate_log "log/development.log" "Backend development log"
        truncate_log "log/test.log" "Backend test log"
        truncate_log "log/production.log" "Backend production log"
    fi
    
    # Clean Rails cache
    if command_exists rails; then
        rails tmp:clear 2>/dev/null && echo -e "${GREEN}✅${NC} Cleared Rails temporary files" || echo -e "${YELLOW}⚠️${NC} Could not clear Rails tmp (server may be running)"
    fi
    
    echo -e "${GREEN}✅${NC} Backend cleanup complete"
else
    echo -e "${YELLOW}⚠️${NC} Backend directory not found"
fi

# Clean Frontend temporary files
echo ""
echo -e "${BLUE}=== Frontend Cleanup ===${NC}"
if [ -d "$PROJECT_ROOT/Frontend" ]; then
    cd "$PROJECT_ROOT/Frontend"
    
    # Clean Vite cache
    if [ -d "node_modules/.vite" ]; then
        rm -rf node_modules/.vite 2>/dev/null
        echo -e "${GREEN}✅${NC} Cleared Vite cache"
    fi
    
    # Clean dist directory (build artifacts)
    if [ -d "dist" ]; then
        rm -rf dist 2>/dev/null
        echo -e "${GREEN}✅${NC} Removed build artifacts (dist/)"
    fi
    
    # Clean npm cache (optional, but safe)
    # This doesn't remove node_modules, just npm's cache
    if command_exists npm; then
        echo -e "${GREEN}✅${NC} Frontend cleanup complete"
    fi
    
    echo -e "${GREEN}✅${NC} Frontend cleanup complete"
else
    echo -e "${YELLOW}⚠️${NC} Frontend directory not found"
fi

# Clean project-level logs
echo ""
echo -e "${BLUE}=== Project Logs Cleanup ===${NC}"
if [ -d "$PROJECT_ROOT/logs" ]; then
    truncate_log "$PROJECT_ROOT/logs/backend.log" "Backend service log"
    truncate_log "$PROJECT_ROOT/logs/frontend.log" "Frontend service log"
    
    # Remove old PID files (they're regenerated on start)
    rm -f "$PROJECT_ROOT/logs/backend.pid" 2>/dev/null
    rm -f "$PROJECT_ROOT/logs/frontend.pid" 2>/dev/null
    echo -e "${GREEN}✅${NC} Removed PID files"
else
    echo -e "${YELLOW}⚠️${NC} Logs directory not found"
fi

# Clean OS-specific files
echo ""
echo -e "${BLUE}=== OS Files Cleanup ===${NC}"
# Remove .DS_Store files (macOS)
find "$PROJECT_ROOT" -name ".DS_Store" -type f -delete 2>/dev/null && echo -e "${GREEN}✅${NC} Removed .DS_Store files" || true

# Remove Thumbs.db files (Windows)
find "$PROJECT_ROOT" -name "Thumbs.db" -type f -delete 2>/dev/null && echo -e "${GREEN}✅${NC} Removed Thumbs.db files" || true

# Summary
echo ""
echo "========================================="
echo -e "${GREEN}Cleanup complete!${NC}"
echo "========================================="
echo ""
echo "Cleaned:"
echo "  • Temporary files and caches"
echo "  • Log files (truncated to last 100 lines)"
echo "  • Build artifacts"
echo "  • OS-specific files"
echo ""
echo "Preserved:"
echo "  • All dependencies (node_modules, vendor/bundle)"
echo "  • Database files"
echo "  • Source code"
echo "  • Configuration files"
echo "  • Git repository"
echo ""
