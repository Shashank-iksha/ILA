#!/bin/bash

# Start All Services Script
# This script checks environment versions and starts both Frontend and Backend services

set -e  # Exit on error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Starting ILA Application Services"
echo "========================================="
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Node.js version
check_node_version() {
    if ! command_exists node; then
        echo -e "${RED}❌ Node.js is not installed${NC}"
        echo "Please install Node.js v20.19.6 using nvm: nvm install v20.19.6"
        exit 1
    fi

    NODE_VERSION=$(node -v | sed 's/v//')
    REQUIRED_VERSION="20.19.6"
    
    if [ "$NODE_VERSION" != "$REQUIRED_VERSION" ]; then
        echo -e "${YELLOW}⚠️  Node.js version mismatch${NC}"
        echo "Current: $NODE_VERSION"
        echo "Required: $REQUIRED_VERSION"
        echo "Switching to required version..."
        if command_exists nvm; then
            source "$HOME/.nvm/nvm.sh" 2>/dev/null || true
            nvm use "$REQUIRED_VERSION" || {
                echo -e "${RED}❌ Failed to switch Node.js version${NC}"
                echo "Please run: nvm use v20.19.6"
                exit 1
            }
        else
            echo -e "${RED}❌ nvm not found. Please install nvm and run: nvm use v20.19.6${NC}"
            exit 1
        fi
    fi
    
    echo -e "${GREEN}✅ Node.js version: $NODE_VERSION${NC}"
}

# Function to check Ruby version
check_ruby_version() {
    if ! command_exists ruby; then
        echo -e "${RED}❌ Ruby is not installed${NC}"
        exit 1
    fi

    RUBY_VERSION=$(ruby -v | awk '{print $2}' | sed 's/p.*//')
    REQUIRED_VERSION="3.2.5"
    
    if [ "$RUBY_VERSION" != "$REQUIRED_VERSION" ]; then
        echo -e "${YELLOW}⚠️  Ruby version mismatch${NC}"
        echo "Current: $RUBY_VERSION"
        echo "Required: $REQUIRED_VERSION"
        echo -e "${YELLOW}Please ensure you're using Ruby $REQUIRED_VERSION${NC}"
    fi
    
    echo -e "${GREEN}✅ Ruby version: $RUBY_VERSION${NC}"
}

# Function to check Rails version
check_rails_version() {
    if ! command_exists rails; then
        echo -e "${RED}❌ Rails is not installed${NC}"
        exit 1
    fi

    RAILS_VERSION=$(rails -v | awk '{print $2}' | sed 's/\.0$//')
    REQUIRED_VERSION="8.0.2.1"
    
    if [ "$RAILS_VERSION" != "$REQUIRED_VERSION" ]; then
        echo -e "${YELLOW}⚠️  Rails version mismatch${NC}"
        echo "Current: $RAILS_VERSION"
        echo "Required: $REQUIRED_VERSION"
    fi
    
    echo -e "${GREEN}✅ Rails version: $RAILS_VERSION${NC}"
}

# Create logs directory if it doesn't exist
mkdir -p "$PROJECT_ROOT/logs"

# Check versions
echo "Checking environment versions..."
check_node_version
check_ruby_version
check_rails_version
echo ""

# Check if services are already running
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

# Check Backend port (4000)
if check_port 4000; then
    echo -e "${YELLOW}⚠️  Port 4000 is already in use (Backend may already be running)${NC}"
else
    echo "Starting Backend (Rails) on port 4000..."
    cd "$PROJECT_ROOT/Backend"
    
    # Check if bundle install has been run
    if [ ! -d "vendor/bundle" ] && [ ! -f ".bundle/config" ]; then
        echo -e "${YELLOW}⚠️  Dependencies may not be installed. Running bundle install...${NC}"
        bundle install
    fi
    
    # Start Rails server in background
    rails server -p 4000 > "$PROJECT_ROOT/logs/backend.log" 2>&1 &
    BACKEND_PID=$!
    echo "$BACKEND_PID" > "$PROJECT_ROOT/logs/backend.pid"
    echo -e "${GREEN}✅ Backend started (PID: $BACKEND_PID)${NC}"
    echo "   Logs: $PROJECT_ROOT/logs/backend.log"
fi

# Wait a moment for backend to start
sleep 2

# Check Frontend port (5173)
if check_port 5173; then
    echo -e "${YELLOW}⚠️  Port 5173 is already in use (Frontend may already be running)${NC}"
else
    echo "Starting Frontend (Vite) on port 5173..."
    cd "$PROJECT_ROOT/Frontend"
    
    # Check if node_modules exists
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}⚠️  Dependencies not installed. Running npm install...${NC}"
        npm install
    fi
    
    # Start Vite dev server in background
    npm run dev > "$PROJECT_ROOT/logs/frontend.log" 2>&1 &
    FRONTEND_PID=$!
    echo "$FRONTEND_PID" > "$PROJECT_ROOT/logs/frontend.pid"
    echo -e "${GREEN}✅ Frontend started (PID: $FRONTEND_PID)${NC}"
    echo "   Logs: $PROJECT_ROOT/logs/frontend.log"
fi

echo ""
echo "========================================="
echo -e "${GREEN}All services started!${NC}"
echo "========================================="
echo "Backend:  http://localhost:4000"
echo "Frontend: http://localhost:5173"
echo ""
echo "To stop all services, run: ./scripts/stop-all.sh"
echo "To view logs:"
echo "  Backend:  tail -f logs/backend.log"
echo "  Frontend: tail -f logs/frontend.log"
