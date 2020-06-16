#!/usr/bin/env bash
cd ../helpers
./fix_resources.sh create
./cfn_core.sh create
./webapi.sh create
cd ../resources