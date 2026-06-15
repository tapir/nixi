#!/bin/sh

git pull
nixpkg flake update
git commit -am "nixpkg update"
git push
