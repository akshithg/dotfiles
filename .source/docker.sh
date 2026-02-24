# docker - Docker CLI

if ! command -v docker >/dev/null 2>&1; then
    return
fi

fpath=("$HOME/.docker/completions" $fpath)
