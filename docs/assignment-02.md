# Assignment 02: Command-Line and Rails CLI Proficiency

## Overview

This assignment focuses on improving command-line fluency for daily engineering operations including service checks, cleanup, and development diagnostics. Mastery of CLI operations is essential for efficient debugging and deployment workflows.

## Learning Objectives

- Automate repeated local checks
- Use Rails CLI confidently for project tasks
- Differentiate safe cleanup from destructive cleanup
- Build diagnostic and maintenance scripts

## Deliverables

1. ✅ `scripts/dev-status.sh` - App and database status checks
2. ✅ `scripts/clean-safe.sh` - Safe temporary artifact cleanup
3. ✅ Command catalogue (25 essential commands documented below)

## Scripts Overview

### dev-status.sh

**Purpose**: Comprehensive status check for both Frontend and Backend services.

**Checks**:
- Service status (ports 4000, 5173)
- Process status (PID files)
- HTTP endpoint health
- Database connection and migration status
- Routes availability
- Environment versions (Node.js, Ruby, Rails)
- Log file status

**Usage**:
```bash
./scripts/dev-status.sh
```

### clean-safe.sh

**Purpose**: Safe cleanup of temporary artifacts without affecting dependencies or data.

**Cleans**:
- Log files (truncates to last 100 lines)
- Temporary files (tmp/cache, tmp/pids, tmp/sockets)
- Cache files (Vite cache, Rails cache)
- Build artifacts (dist/)
- OS-specific files (.DS_Store, Thumbs.db)

**Preserves**:
- node_modules (dependencies)
- vendor/bundle (Ruby gems)
- Database files
- Git files (.git/)
- Configuration files
- Source code

**Usage**:
```bash
./scripts/clean-safe.sh
```

## Command Catalogue (25 Essential Commands)

### Category 1: Rails CLI Commands

#### 1. `rails -v`
**Purpose**: Check Rails version  
**Context**: Verify Rails installation and version compatibility  
**Example**:
```bash
rails -v
# Output: Rails 8.0.2.1
```

#### 2. `rails new .`
**Purpose**: Create new Rails application in current directory  
**Context**: Initialize Rails project structure  
**Example**:
```bash
cd Backend
rails new .
```

#### 3. `rails server -p 4000`
**Purpose**: Start Rails development server on specific port  
**Context**: Run backend API server  
**Example**:
```bash
rails server -p 4000
# Or: rails s -p 4000
```

#### 4. `rails routes`
**Purpose**: List all application routes  
**Context**: Verify route definitions and diagnose routing issues  
**Example**:
```bash
cd Backend
rails routes
# Shows: GET /health => health#show
```

#### 5. `rails db:migrate:status`
**Purpose**: Check database migration status  
**Context**: Verify if migrations are up to date  
**Example**:
```bash
cd Backend
rails db:migrate:status
# Shows: up/down status for each migration
```

#### 6. `rails runner "code"`
**Purpose**: Execute Ruby code in Rails context  
**Context**: Test database connections, run one-off scripts  
**Example**:
```bash
rails runner "ActiveRecord::Base.connection"
```

#### 7. `rails tmp:clear`
**Purpose**: Clear temporary files (cache, pids, sockets)  
**Context**: Clean up Rails temporary directory  
**Example**:
```bash
cd Backend
rails tmp:clear
```

#### 8. `rails log:clear`
**Purpose**: Clear log files  
**Context**: Remove old log entries  
**Example**:
```bash
cd Backend
rails log:clear
```

#### 9. `bundle install`
**Purpose**: Install Ruby gem dependencies  
**Context**: Set up or update project dependencies  
**Example**:
```bash
cd Backend
bundle install
```

#### 10. `bundle check`
**Purpose**: Verify if dependencies are installed  
**Context**: Quick check before running application  
**Example**:
```bash
cd Backend
bundle check
```

### Category 2: Node.js/npm Commands

#### 11. `npm create vite@latest . -- --template react --yes`
**Purpose**: Create Vite React app in current directory  
**Context**: Initialize frontend project with Vite  
**Example**:
```bash
cd Frontend
npm create vite@latest . -- --template react --yes
```

#### 12. `npm install`
**Purpose**: Install Node.js package dependencies  
**Context**: Set up frontend dependencies  
**Example**:
```bash
cd Frontend
npm install
```

#### 13. `npm run dev`
**Purpose**: Start Vite development server  
**Context**: Run frontend development server  
**Example**:
```bash
cd Frontend
npm run dev
```

#### 14. `node -v`
**Purpose**: Check Node.js version  
**Context**: Verify Node.js installation and version  
**Example**:
```bash
node -v
# Output: v20.19.6
```

#### 15. `nvm use 20.19.6`
**Purpose**: Switch to specific Node.js version  
**Context**: Use correct Node.js version for project  
**Example**:
```bash
nvm use 20.19.6
# Output: Now using node v20.19.6 (npm v10.8.2)
```

### Category 3: System and Process Commands

#### 16. `lsof -i :4000`
**Purpose**: Check if port is in use  
**Context**: Diagnose port conflicts, verify service status  
**Example**:
```bash
lsof -i :4000
# Shows process using port 4000
```

#### 17. `lsof -ti :4000`
**Purpose**: Get PID of process using port  
**Context**: Find process ID for port management  
**Example**:
```bash
lsof -ti :4000
# Output: 58388
```

#### 18. `ps -p <pid>`
**Purpose**: Check if process is running  
**Context**: Verify process status by PID  
**Example**:
```bash
ps -p 58388
```

#### 19. `curl http://localhost:4000/health`
**Purpose**: Test HTTP endpoint  
**Context**: Verify API endpoint is responding  
**Example**:
```bash
curl http://localhost:4000/health
# Output: {"status":"ok"}
```

#### 20. `du -h <file>`
**Purpose**: Show file size in human-readable format  
**Context**: Check log file sizes, database sizes  
**Example**:
```bash
du -h logs/backend.log
# Output: 2.5M logs/backend.log
```

#### 21. `tail -f <log>`
**Purpose**: Follow log file in real-time  
**Context**: Monitor application logs during development  
**Example**:
```bash
tail -f logs/backend.log
```

### Category 4: File and Directory Operations

#### 22. `find . -name ".DS_Store" -delete`
**Purpose**: Remove OS-specific files recursively  
**Context**: Clean up macOS system files  
**Example**:
```bash
find . -name ".DS_Store" -delete
```

#### 23. `chmod +x <script>`
**Purpose**: Make script executable  
**Context**: Enable script execution  
**Example**:
```bash
chmod +x scripts/dev-status.sh
```

#### 24. `mkdir -p <dir>`
**Purpose**: Create directory (with parents if needed)  
**Context**: Ensure directory structure exists  
**Example**:
```bash
mkdir -p logs
```

#### 25. `cd "$(dirname "${BASH_SOURCE[0]}")"`
**Purpose**: Get script's directory (portable path)  
**Context**: Avoid hardcoded paths in scripts  
**Example**:
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
```

## Command Categories Summary

### Rails CLI (10 commands)
Commands for Rails application management, database operations, and server control. Essential for backend development and debugging.

### Node.js/npm (5 commands)
Commands for Node.js version management and npm package operations. Critical for frontend development workflow.

### System and Process (6 commands)
Commands for process management, port checking, and HTTP testing. Used for service diagnostics and monitoring.

### File Operations (4 commands)
Commands for file system operations, permissions, and cleanup. Important for maintenance and script portability.

## Common Use Cases

### Diagnosing Backend Not Booting

1. **Check if port is available**:
   ```bash
   lsof -i :4000
   ```

2. **Verify Rails installation**:
   ```bash
   rails -v
   ```

3. **Check database connection**:
   ```bash
   cd Backend
   rails runner "ActiveRecord::Base.connection"
   ```

4. **Check for pending migrations**:
   ```bash
   rails db:migrate:status
   ```

5. **View logs**:
   ```bash
   tail -f log/development.log
   ```

### Verifying Routes Quickly

```bash
cd Backend
rails routes | grep health
# Shows: GET /health => health#show
```

### Safe Cleanup Operations

**Included in clean-safe.sh**:
- ✅ Log file truncation (keeps last 100 lines)
- ✅ Temporary file removal (tmp/cache, tmp/pids)
- ✅ Cache clearing (Vite, Rails)
- ✅ Build artifact removal (dist/)

**Intentionally Excluded**:
- ❌ `rm -rf node_modules` (destructive - removes dependencies)
- ❌ `rm -rf vendor/bundle` (destructive - removes Ruby gems)
- ❌ `rails db:drop` (destructive - deletes database)
- ❌ `rm -rf .git` (destructive - removes version control)
- ❌ `rm -rf storage/*.sqlite3` (destructive - deletes database files)

## Safety Assumptions

### dev-status.sh
- Assumes services may or may not be running
- Handles missing PID files gracefully
- Provides warnings instead of errors for optional checks
- Uses non-destructive read-only operations

### clean-safe.sh
- Requires user confirmation before cleanup
- Only removes temporary/cache files
- Preserves all dependencies and data
- Truncates logs instead of deleting them
- Never touches database files or source code

## Self-Check Questions

### 1. How would you diagnose backend not booting?

**Answer**: Use a combination of:
- `lsof -i :4000` to check port conflicts
- `rails -v` to verify Rails installation
- `rails runner "ActiveRecord::Base.connection"` to test database
- `rails db:migrate:status` to check migrations
- `tail -f log/development.log` to view error messages
- Or simply run `./scripts/dev-status.sh` for comprehensive check

### 2. Which command verifies routes quickly?

**Answer**: `rails routes` - Lists all application routes. Can be filtered with grep:
```bash
rails routes | grep health
```

### 3. What cleanup operation is intentionally excluded?

**Answer**: Destructive operations are excluded:
- `rm -rf node_modules` (would require reinstall)
- `rm -rf vendor/bundle` (would require bundle install)
- `rails db:drop` (would delete database)
- `rm -rf .git` (would remove version control)
- `rm -rf storage/*.sqlite3` (would delete database files)

The script only removes temporary artifacts, caches, and truncates logs.

## Script Output Examples

### dev-status.sh Output
```
=========================================
ILA Development Status Check
=========================================

=== Service Status ===
✅ Backend (Rails) is running on port 4000 (PID: 58388)
✅ Frontend (Vite) is running on port 5173 (PID: 58433)

=== Process Status ===
✅ Backend process found (PID: 58388)
✅ Frontend process found (PID: 58433)

=== Endpoint Health Checks ===
✅ Backend /health is responding: {"status":"ok"}

=== Backend Database Status ===
✅ Database file exists (Size: 12K)
✅ Database connection successful
✅ All migrations are up to date

=== Backend Routes ===
Available routes:
GET /health => health#show

=== Frontend Status ===
✅ Dependencies installed (node_modules exists)
✅ Frontend configuration found

=== Environment Versions ===
Node.js: v20.19.6
Ruby: 3.2.5
Rails: 8.0.2.1

=== Log Files ===
✅ Backend log exists (Size: 2.5M)
✅ Frontend log exists (Size: 1.2M)

=========================================
Status check complete!
=========================================
```

### clean-safe.sh Output
```
=========================================
Safe Cleanup Utility
=========================================

This script will remove:
  ✅ Log files (keeps last 100 lines)
  ✅ Temporary files (tmp/)
  ✅ Cache files
  ✅ Build artifacts

This script will NOT remove:
  ❌ node_modules (dependencies)
  ❌ vendor/bundle (Ruby gems)
  ❌ Database files
  ❌ Git files (.git/)
  ❌ Configuration files
  ❌ Source code

Continue with cleanup? (y/N): y

Starting cleanup...

=== Backend Cleanup ===
✅ Cleaned Backend tmp/cache, tmp/pids, tmp/sockets
✅ Truncated Backend development log (was 2.5M, now 12K)
✅ Cleared Rails temporary files

=== Frontend Cleanup ===
✅ Cleared Vite cache
✅ Removed build artifacts (dist/)
✅ Frontend cleanup complete

=== Project Logs Cleanup ===
✅ Truncated Backend service log (was 2.5M, now 12K)
✅ Truncated Frontend service log (was 1.2M, now 8K)
✅ Removed PID files

=== OS Files Cleanup ===
✅ Removed .DS_Store files

=========================================
Cleanup complete!
=========================================
```