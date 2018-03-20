#!/bin/bash
# export makes the variable available for all subprocesses

# Assumes that mydom.tld www.mydom.tld and sub.mydom.tld are the domains that you want a certificate for
export DOMAINS="-d mydom.tld -d www.mydom.tld -d sub.mydom.tld"

$( which certbot ) certonly --config /etc/letsencrypt/cli.ini "$DOMAINS" # --dry-run

