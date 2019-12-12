#!/bin/sh

echo "Running Seeds"

bin/bankapi eval "Bank.ReleaseTasks.seed"
