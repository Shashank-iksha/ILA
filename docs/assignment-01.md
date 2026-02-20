# Assignment 01: Setup Phase

## Overview

This document outlines the complete setup process for the ILA (Individual Learning Assignment) project, including both Frontend and Backend components.

## Project Structure

```
ILA/
├── Backend/          # Rails 8.0.2.1 API server
├── Frontend/         # React + Vite application
├── scripts/          # Utility scripts for managing services
├── docs/             # Documentation
└── README.md         # Project overview
```

## Environment Requirements

### Backend
- **Ruby**: 3.2.5
- **Rails**: 8.0.2.1
- **Port**: 4000

### Frontend
- **Node.js**: v20.19.6 (use `nvm use v20.19.6`)
- **Package Manager**: npm
- **Port**: 5173 (Vite default)

## Setup Steps

### 1. Repository Initialization

1. Created GitHub repository
2. Cloned repository locally
3. Created separate `Frontend/` and `Backend/` folders
4. Created README files in each folder
5. Initial commit: `Asgn-01-initialise-repo` to `main` branch

### 2. Backend Setup (Rails)

#### Prerequisites
```bash
# Verify Ruby version
ruby -v  # Should be 3.2.5

# Install Rails if not already installed
gem install rails -v 8.0.2.1
```

#### Setup Commands
```bash
cd Backend

# Install dependencies
bundle install

# Verify Rails version
rails -v  # Should be 8.0.2.1
```

#### Health Endpoint
- **URL**: `GET /health`
- **Response**: `{ "status": "ok" }`
- **Controller**: `app/controllers/health_controller.rb`
- **Route**: Defined in `config/routes.rb`

#### CORS Configuration
To allow Frontend to communicate with Backend:

1. Added `rack-cors` gem to `Gemfile`:
   ```ruby
   gem "rack-cors"
   ```

2. Created `config/initializers/cors.rb`:
   ```ruby
   Rails.application.config.middleware.insert_before 0, Rack::Cors do
     allow do
       origins 'http://localhost:5173'
       resource '*',
         headers: :any,
         methods: [:get, :post, :put, :patch, :delete, :options, :head],
         credentials: false
     end
   end
   ```

3. After adding gem:
   ```bash
   bundle install
   # Restart Rails server
   ```

#### Starting Backend
```bash
cd Backend
rails server -p 4000
```

Backend will be available at: `http://localhost:4000`

### 3. Frontend Setup (React + Vite)

#### Prerequisites
```bash
# Switch to required Node.js version
nvm use v20.19.6

# Verify Node.js version
node -v  # Should be v20.19.6
```

#### Setup Commands
```bash
cd Frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

Frontend will be available at: `http://localhost:5173`

#### Health Check Page
- **Component**: `src/components/Health.jsx`
- **Functionality**:
  - Fetches health status from `http://localhost:4000/health`
  - Displays loading state
  - Shows success status with visual indicator
  - Handles errors with retry functionality
  - Includes refresh button

### 4. Utility Scripts

#### Start All Services
```bash
./scripts/start-all.sh
```

This script:
- ✅ Checks Node.js version (v20.19.6)
- ✅ Checks Ruby version (3.2.5)
- ✅ Checks Rails version (8.0.2.1)
- ✅ Installs dependencies if needed
- ✅ Starts Backend on port 4000
- ✅ Starts Frontend on port 5173
- ✅ Creates log files in `logs/` directory
- ✅ Uses relative paths (no hardcoded paths)

#### Stop All Services
```bash
./scripts/stop-all.sh
```

This script:
- Stops Backend service
- Stops Frontend service
- Cleans up PID files
- Handles processes by both PID files and port numbers

## Verification

### Backend Health Check
```bash
curl http://localhost:4000/health
# Expected: {"status":"ok"}
```

### Frontend
1. Open browser: `http://localhost:5173`
2. Should see Health Check page
3. Should display "Status: ok" if backend is running

## Common Mistakes to Avoid

### ❌ Skipping Environment Version Checks
**Problem**: Running with wrong Node.js/Ruby versions can cause compatibility issues.

**Solution**: 
- Always verify versions before starting
- Use `nvm use v20.19.6` for Frontend
- Verify Ruby 3.2.5 and Rails 8.0.2.1 for Backend
- The `start-all.sh` script includes automatic version checks

### ❌ Hardcoding Local Paths in Scripts
**Problem**: Scripts with hardcoded paths won't work on different machines or when moved.

**Solution**:
- Use `$(dirname "${BASH_SOURCE[0]}")` to get script directory
- Use relative paths from project root
- Calculate project root dynamically
- Example from `start-all.sh`:
  ```bash
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
  ```

### ❌ Not Installing Dependencies
**Problem**: Services fail to start if dependencies aren't installed.

**Solution**:
- Run `bundle install` in Backend before first start
- Run `npm install` in Frontend before first start
- The `start-all.sh` script checks and installs automatically

### ❌ Forgetting CORS Configuration
**Problem**: Frontend can't communicate with Backend due to CORS errors.

**Solution**:
- Add `rack-cors` gem to Backend
- Configure CORS initializer
- Restart Rails server after adding gem

### ❌ Not Checking if Ports are Already in Use
**Problem**: Starting services when ports are already occupied causes errors.

**Solution**:
- Check ports before starting: `lsof -i :4000` and `lsof -i :5173`
- The `start-all.sh` script includes port checks
- The `stop-all.sh` script properly cleans up processes

## File Structure Summary

### Backend Files
- `Gemfile` - Ruby dependencies (includes `rack-cors`)
- `config/initializers/cors.rb` - CORS configuration
- `app/controllers/health_controller.rb` - Health endpoint controller
- `config/routes.rb` - Route definitions

### Frontend Files
- `package.json` - Node.js dependencies
- `src/components/Health.jsx` - Health check component
- `src/components/Health.css` - Component styles
- `src/App.jsx` - Main app component
- `vite.config.js` - Vite configuration

### Scripts
- `scripts/start-all.sh` - Start all services with version checks
- `scripts/stop-all.sh` - Stop all services cleanly

## Next Steps

After completing this setup:
1. ✅ Both services should start successfully
2. ✅ Frontend should display health status from Backend
3. ✅ No CORS errors in browser console
4. ✅ All environment versions verified

## Troubleshooting

### Backend won't start
- Check Ruby version: `ruby -v`
- Check Rails version: `rails -v`
- Run `bundle install`
- Check if port 4000 is available: `lsof -i :4000`

### Frontend won't start
- Check Node.js version: `node -v` (should be v20.19.6)
- Run `npm install`
- Check if port 5173 is available: `lsof -i :5173`

### CORS errors
- Verify `rack-cors` gem is installed: `bundle list | grep rack-cors`
- Check `config/initializers/cors.rb` exists
- Restart Rails server after adding CORS configuration

### Scripts not working
- Ensure scripts are executable: `chmod +x scripts/*.sh`
- Run from project root: `./scripts/start-all.sh`
- Check script paths are relative (no hardcoded paths)
