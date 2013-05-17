#!/bin/sh
set -e

brew update
brew install xctool
git clone git://github.com/kstenerud/iOS-Universal-Framework.git && pwd && cd iOS-Universal-Framework/Real\ Framework  && ls -la
printf "\ny" | ./install.sh