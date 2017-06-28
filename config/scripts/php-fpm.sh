#!/bin/bash
set -e

# Additional setup
mkdir -p /src/logs

# Run fpm with command options
php-fpm "$@"
