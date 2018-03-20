#!/bin/bash

read -p "Which certificate do you want to delete: " -r -e answer
if [ -n "$answer" ]; then
  $( which certbot ) delete --cert-name "$answer"
fi

