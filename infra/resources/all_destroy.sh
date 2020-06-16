#!/usr/bin/env bash
cd ../helpers
./webapi.sh destroy
./cfn_core.sh destroy
./fix_resources.sh destroy
cd ../resources