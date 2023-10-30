# Pretty print functions

pTitle()    { echo "\033[1m$@\033[0m";  }
pDo()       { echo "  \033[1;33m➜\033[0m $@"; }
pDone()     { echo "  \033[1;32m✔\033[0m $@"; }
pGood()     { echo "    \033[1;32m✔\033[0m $@"; }
pBad()      { echo "    \033[1;31m✖\033[0m $@"; }
pWarn()     { echo "    \033[1;33m⚠\033[0m $@"; }

pTest() {
    pTitle Title
    pDo Do
    pGood Good
    pWarn Warn
    pBad Bad
    pDone Done
}
