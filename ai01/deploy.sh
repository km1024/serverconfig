#!/bin/sh

scp docker-compose.yml ops@ai01:ai-stack
ssh ops@ai01 "(cd ai-stack; docker compose up -d)"

