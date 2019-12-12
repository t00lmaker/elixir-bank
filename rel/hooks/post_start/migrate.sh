#!/bin/sh

echo "Running migrations"

bin/bankapi eval "Bank.ReleaseTasks.migrate"
