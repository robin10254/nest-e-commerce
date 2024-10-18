#!/bin/sh

# Run Prisma migrations
npx prisma migrate deploy

# Start the application
npm run start:dev
