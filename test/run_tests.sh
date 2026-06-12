#!/bin/bash

# Aurix Gold Wallet — Test Runner Script
# Usage: bash test/run_tests.sh [command]

set -e

echo "🧪 Aurix Gold Wallet Test Suite"
echo "================================"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Command handling
case "${1:-all}" in
  "all")
    echo -e "${BLUE}Running all tests...${NC}"
    flutter test
    ;;
  
  "models")
    echo -e "${BLUE}Running model tests...${NC}"
    flutter test test/models/
    ;;
  
  "services")
    echo -e "${BLUE}Running service tests...${NC}"
    flutter test test/services/
    ;;
  
  "coverage")
    echo -e "${BLUE}Running tests with coverage...${NC}"
    flutter test --coverage
    echo -e "${GREEN}✓ Coverage report generated${NC}"
    echo -e "${YELLOW}To view: open coverage/html/index.html${NC}"
    ;;
  
  "user")
    echo -e "${BLUE}Running UserModel tests...${NC}"
    flutter test test/models/user_model_test.dart -v
    ;;
  
  "transaction")
    echo -e "${BLUE}Running TransactionModel tests...${NC}"
    flutter test test/models/transaction_model_test.dart -v
    ;;
  
  "price")
    echo -e "${BLUE}Running GoldPriceModel tests...${NC}"
    flutter test test/models/gold_price_model_test.dart -v
    ;;
  
  "auth")
    echo -e "${BLUE}Running AuthService tests...${NC}"
    flutter test test/services/auth_service_test.dart -v
    ;;
  
  "transactions")
    echo -e "${BLUE}Running TransactionService tests...${NC}"
    flutter test test/services/transaction_service_test.dart -v
    ;;
  
  "storage")
    echo -e "${BLUE}Running StorageService tests...${NC}"
    flutter test test/services/storage_service_test.dart -v
    ;;
  
  "goldapi")
    echo -e "${BLUE}Running GoldPriceService tests...${NC}"
    flutter test test/services/gold_price_service_test.dart -v
    ;;
  
  "watch")
    echo -e "${BLUE}Running tests in watch mode...${NC}"
    flutter test --watch
    ;;
  
  "verbose")
    echo -e "${BLUE}Running all tests with verbose output...${NC}"
    flutter test -v
    ;;
  
  "analyze")
    echo -e "${BLUE}Running code analysis...${NC}"
    flutter analyze
    ;;
  
  "help"|"--help"|"-h")
    echo "Usage: bash test/run_tests.sh [command]"
    echo ""
    echo "Commands:"
    echo "  all           Run all tests (default)"
    echo "  models        Run all model tests"
    echo "  services      Run all service tests"
    echo "  coverage      Run tests with coverage report"
    echo "  user          Run UserModel tests"
    echo "  transaction   Run TransactionModel tests"
    echo "  price         Run GoldPriceModel tests"
    echo "  auth          Run AuthService tests"
    echo "  transactions  Run TransactionService tests"
    echo "  storage       Run StorageService tests"
    echo "  goldapi       Run GoldPriceService tests"
    echo "  watch         Run tests in watch mode"
    echo "  verbose       Run all tests with verbose output"
    echo "  analyze       Run Flutter analyzer"
    echo "  help          Show this help message"
    ;;
  
  *)
    echo -e "${YELLOW}Unknown command: $1${NC}"
    echo "Run 'bash test/run_tests.sh help' for available commands"
    exit 1
    ;;
esac

echo ""
echo -e "${GREEN}✓ Test run completed${NC}"
