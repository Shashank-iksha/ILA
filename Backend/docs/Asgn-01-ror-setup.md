# Asgn-01-ror-setup

## Environment
- Ruby 3.2.5
- Rails 8.0.2.1

## Setup steps
1. Install Rails:
   ```bash
   gem install rails -v 8.0.2.1
   ```
2. Verify Rails version:
   ```bash
   rails -v
   ```
3. Create the Rails app in the current folder:
   ```bash
   rails new .
   ```
4. Start the server (optional):
   ```bash
   bin/rails server
   ```
5. Health endpoint:
   - URL: `GET /health`
   - Response: `{ "status": "ok" }`
