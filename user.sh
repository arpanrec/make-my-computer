#!/usr/bin/env bash
set -e

pip install --user --upgrade wheel
pip install --user --upgrade konsave virtualenv
konsave --force --remove makemyarch
BASEDIR=$(dirname "$0")
konsave --import-profile "$BASEDIR/makemyarch.knsv"
konsave --apply makemyarch
