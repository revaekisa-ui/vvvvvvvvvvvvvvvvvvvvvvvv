#!/bin/bash

# Supabase Seed Data Setup Script
# This script helps you replace the placeholder UUID in seed.sql with your actual user UUID

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

# Function to show usage
show_usage() {
    print_color $CYAN "Usage:"
    print_color $GRAY "  ./setup-seed.sh <USER_UUID> [EMAIL] [FULL_NAME]"
    print_color $GRAY ""
    print_color $CYAN "Examples:"
    print_color $GRAY "  ./setup-seed.sh 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'"
    print_color $GRAY "  ./setup-seed.sh 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' 'admin@mycompany.com' 'John Doe'"
    exit 1
}

# Check if UUID is provided
if [ $# -eq 0 ]; then
    print_color $RED "❌ Error: User UUID is required!"
    show_usage
fi

USER_UUID="$1"
EMAIL="${2:-your-email@example.com}"
FULL_NAME="${3:-Your Full Name}"

print_color $CYAN "🚀 Setting up Supabase seed data..."
echo ""

# Validate UUID format
UUID_PATTERN="^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
if [[ ! $USER_UUID =~ $UUID_PATTERN ]]; then
    print_color $RED "❌ Error: Invalid UUID format!"
    print_color $YELLOW "   Expected format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    print_color $YELLOW "   Example: a1b2c3d4-e5f6-7890-abcd-ef1234567890"
    exit 1
fi

SEED_FILE="./seed.sql"

if [ ! -f "$SEED_FILE" ]; then
    print_color $RED "❌ Error: seed.sql not found in current directory!"
    print_color $YELLOW "   Make sure you're running this script from the supabase folder."
    exit 1
fi

print_color $GREEN "📝 Updating seed.sql with your information:"
print_color $WHITE "   UUID: $USER_UUID"
print_color $WHITE "   Email: $EMAIL"
print_color $WHITE "   Name: $FULL_NAME"
echo ""

# Create backup
cp "$SEED_FILE" "${SEED_FILE}.backup.$(date +%Y%m%d_%H%M%S)"

# Replace placeholders
sed -i.tmp "s/YOUR_USER_UUID_HERE/$USER_UUID/g" "$SEED_FILE" && rm "${SEED_FILE}.tmp"
sed -i.tmp "s/your-email@example\\.com/$EMAIL/g" "$SEED_FILE" && rm "${SEED_FILE}.tmp" 
sed -i.tmp "s/Your Full Name/$FULL_NAME/g" "$SEED_FILE" && rm "${SEED_FILE}.tmp"

if [ $? -eq 0 ]; then
    print_color $GREEN "✅ Successfully updated seed.sql!"
    echo ""
    print_color $CYAN "📋 Next steps:"
    print_color $WHITE "1. Copy the content of seed.sql"
    print_color $WHITE "2. Paste and run it in your Supabase SQL Editor"
    print_color $WHITE "3. Test your app login with:"
    print_color $YELLOW "   Email: $EMAIL"
    echo ""
    print_color $GREEN "🎉 Setup complete!"
else
    print_color $RED "❌ Error updating seed.sql"
    exit 1
fi

echo ""
print_color $CYAN "💡 Usage examples:"
print_color $GRAY "  ./setup-seed.sh 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'"
print_color $GRAY "  ./setup-seed.sh 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' 'admin@mycompany.com' 'John Doe'"
