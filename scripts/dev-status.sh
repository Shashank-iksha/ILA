#!/bin/bash

# Development Status Script
# Checks app and database status for both Frontend and Backend services

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper function
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "========================================="
echo "ILA Development Status Check"
echo "========================================="
echo ""

# Function to check if a port is in use
check_port() {
    local port=$1
    local service_name=$2
    
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        local pid=$(lsof -ti :$port 2>/dev/null | head -n1)
        echo -e "${GREEN}✅${NC} $service_name is running on port $port (PID: $pid)"
        return 0
    else
        echo -e "${RED}❌${NC} $service_name is not running on port $port"
        return 1
    fi
}

# Function to check if a process exists
check_process() {
    local pid_file=$1
    local service_name=$2
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file" 2>/dev/null)
        if ps -p "$pid" > /dev/null 2>&1; then
            echo -e "${GREEN}✅${NC} $service_name process found (PID: $pid)"
            return 0
        else
            echo -e "${YELLOW}⚠️${NC} $service_name PID file exists but process not found"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️${NC} $service_name PID file not found"
        return 1
    fi
}

# Function to test HTTP endpoint
test_endpoint() {
    local url=$1
    local endpoint_name=$2
    
    if curl -s -f -o /dev/null "$url" 2>/dev/null; then
        local response=$(curl -s "$url" 2>/dev/null)
        echo -e "${GREEN}✅${NC} $endpoint_name is responding: $response"
        return 0
    else
        echo -e "${RED}❌${NC} $endpoint_name is not responding"
        return 1
    fi
}

# Service Status
echo -e "${BLUE}=== Service Status ===${NC}"
check_port 4000 "Backend (Rails)"
check_port 5173 "Frontend (Vite)"

# Check PID files
echo ""
echo -e "${BLUE}=== Process Status ===${NC}"
check_process "$PROJECT_ROOT/logs/backend.pid" "Backend"
check_process "$PROJECT_ROOT/logs/frontend.pid" "Frontend"

# Test Endpoints
echo ""
echo -e "${BLUE}=== Endpoint Health Checks ===${NC}"
if check_port 4000 "Backend" > /dev/null 2>&1; then
    test_endpoint "http://localhost:4000/health" "Backend /health"
fi

# Backend Database Status
echo ""
echo -e "${BLUE}=== Backend Database Status ===${NC}"
if [ -d "$PROJECT_ROOT/Backend" ]; then
    cd "$PROJECT_ROOT/Backend"
    
    # Check if database exists
    if [ -f "storage/development.sqlite3" ]; then
        local db_size=$(du -h "storage/development.sqlite3" | cut -f1)
        echo -e "${GREEN}✅${NC} Database file exists (Size: $db_size)"
    else
        echo -e "${YELLOW}⚠️${NC} Database file not found"
    fi
    
    # Check database connection and migration status
    if command_exists rails; then
        echo ""
        echo "Checking database connection..."
        if rails runner "ActiveRecord::Base.connection" > /dev/null 2>&1; then
            echo -e "${GREEN}✅${NC} Database connection successful"
            
            # Check pending migrations
            echo ""
            echo "Checking migration status..."
            local pending=$(rails db:migrate:status 2>/dev/null | grep -c "down" || echo "0")
            if [ "$pending" -eq 0 ]; then
                echo -e "${GREEN}✅${NC} All migrations are up to date"
            else
                echo -e "${YELLOW}⚠️${NC} $pending pending migration(s)"
                rails db:migrate:status 2>/dev/null | grep "down" | head -5
            fi
        else
            echo -e "${RED}❌${NC} Database connection failed"
        fi
    else
        echo -e "${YELLOW}⚠️${NC} Rails not found, skipping database checks"
    fi
else
    echo -e "${RED}❌${NC} Backend directory not found"
fi

# Backend Routes Check
echo ""
echo -e "${BLUE}=== Backend Routes ===${NC}"
if [ -d "$PROJECT_ROOT/Backend" ] && command_exists rails; then
    cd "$PROJECT_ROOT/Backend"
    echo "Available routes:"
    rails routes 2>/dev/null | grep -E "(health|GET|POST)" | head -10 || echo "  (Unable to list routes)"
else
    echo -e "${YELLOW}⚠️${NC} Cannot check routes (Rails not available)"
fi

# Frontend Status
echo ""
echo -e "${BLUE}=== Frontend Status ===${NC}"
if [ -d "$PROJECT_ROOT/Frontend" ]; then
    cd "$PROJECT_ROOT/Frontend"
    
    # Check node_modules
    if [ -d "node_modules" ]; then
        echo -e "${GREEN}✅${NC} Dependencies installed (node_modules exists)"
    else
        echo -e "${YELLOW}⚠️${NC} Dependencies not installed (node_modules missing)"
    fi
    
    # Check package.json
    if [ -f "package.json" ]; then
        echo -e "${GREEN}✅${NC} Frontend configuration found"
    else
        echo -e "${RED}❌${NC} Frontend configuration missing"
    fi
else
    echo -e "${RED}❌${NC} Frontend directory not found"
fi

# Environment Versions
echo ""
echo -e "${BLUE}=== Environment Versions ===${NC}"
if command_exists node; then
    echo "Node.js: $(node -v)"
else
    echo -e "${RED}❌${NC} Node.js not found"
fi

if command_exists ruby; then
    echo "Ruby: $(ruby -v | awk '{print $2}')"
else
    echo -e "${RED}❌${NC} Ruby not found"
fi

if command_exists rails; then
    echo "Rails: $(rails -v | awk '{print $2}')"
else
    echo -e "${RED}❌${NC} Rails not found"
fi

# Log Files Status
echo ""
echo -e "${BLUE}=== Log Files ===${NC}"
if [ -d "$PROJECT_ROOT/logs" ]; then
    if [ -f "$PROJECT_ROOT/logs/backend.log" ]; then
        local backend_log_size=$(du -h "$PROJECT_ROOT/logs/backend.log" 2>/dev/null | cut -f1)
        echo -e "${GREEN}✅${NC} Backend log exists (Size: $backend_log_size)"
    else
        echo -e "${YELLOW}⚠️${NC} Backend log not found"
    fi
    
    if [ -f "$PROJECT_ROOT/logs/frontend.log" ]; then
        local frontend_log_size=$(du -h "$PROJECT_ROOT/logs/frontend.log" 2>/dev/null | cut -f1)
        echo -e "${GREEN}✅${NC} Frontend log exists (Size: $frontend_log_size)"
    else
        echo -e "${YELLOW}⚠️${NC} Frontend log not found"
    fi
else
    echo -e "${YELLOW}⚠️${NC} Logs directory not found"
fi

echo ""
echo "========================================="
echo "Status check complete!"
echo "========================================="
