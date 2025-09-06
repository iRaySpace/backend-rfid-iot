#!/bin/bash
./gradlew clean shadowJar -x test
cd infra && terraform apply