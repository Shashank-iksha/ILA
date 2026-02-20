# ILA Frontend

React application built with Vite.

## Setup

1. Make sure you have Node.js installed (use `nvm use v20.19.6` as specified in project guidelines)
2. Install dependencies:
   ```bash
   npm install
   ```

## Development

Start the development server:
```bash
npm run dev
```

The app will be available at `http://localhost:5173/`

## Features

- **Health Check Page**: Displays the backend health status by calling `http://localhost:4000/health`
  - Shows loading state while fetching
  - Displays status when successful
  - Shows error message if the backend is unavailable
  - Includes refresh/retry functionality

## Backend Integration

The frontend calls the backend API at `http://localhost:4000/health`. Make sure the Rails backend is running on port 4000 before testing the health check.

## Build

Build for production:
```bash
npm run build
```

Preview production build:
```bash
npm run preview
```
