#!/bin/bash

# Check if required environment variables are set
if [ -z "$MONGO_INITDB_ROOT_USERNAME" ] || [ -z "$MONGO_INITDB_ROOT_PASSWORD" ] || [ -z "$MONGO_INITDB_DATABASE" ]; then
  echo "Error: Missing required environment variables."
  echo "Ensure MONGO_INITDB_ROOT_USERNAME, MONGO_INITDB_ROOT_PASSWORD, and MONGO_INITDB_DATABASE are set."
  exit 1
fi

# Wait for MongoDB to start
until mongosh --eval "print(\"waited for connection\")"; do
  echo "Waiting for MongoDB to start..."
  sleep 2
done

# Create a new user
mongosh <<EOF
use $MONGO_INITDB_DATABASE;
db.createUser({
  user: "$MONGO_INITDB_ROOT_USERNAME",
  pwd: "$MONGO_INITDB_ROOT_PASSWORD",
  roles: [
    { role: "readWrite", db: "$MONGO_INITDB_DATABASE" }
  ]
});
print("Application user created successfully");
EOF