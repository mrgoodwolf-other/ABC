// get compilers
#!/bin/bash

# Exit immediately on errors
set -e

# Base directory for clones
BUILD_DIR="$HOME/compiler_alphabet"
LOG_DIR="$BUILD_DIR/logs"
mkdir -p "$BUILD_DIR" "$LOG_DIR"

# Compiler repositories
declare -A COMPILERS=(
    [A]="https://github.com/githwxi/ATS-Postiats.git"
    [B]="https://github.com/retroprom/ybc.git"
    [C]="git://repo.or.cz/tinycc.git"
    [D]="https://github.com/dlang/dmd.git"
    [E]="https://github.com/erlang/otp.git"
    [F]="https://github.com/dotnet/fsharp.git"
    [G]="https://gcc.gnu.org/git/gcc.git"
    [H]="https://gitlab.haskell.org/ghc/ghc.git"
    [I]="https://github.com/stevedekorte/io.git"
    [J]="https://github.com/janet-lang/janet.git"
    [K]="https://github.com/koka-lang/koka.git"
    [L]="https://github.com/lua/lua.git"
    [M]="https://github.com/mirah/mirah.git"
    [N]="https://github.com/nim-lang/Nim.git"
    [O]="https://github.com/ocaml/ocaml.git"
    [P]="https://gitlab.com/freepascal.org/fpc/source.git"
    [Q]="https://github.com/qorelanguage/qore.git"
    [R]="https://github.com/rust-lang/rust.git"
    [S]="https://github.com/scala/scala.git"
    [T]="git://repo.or.cz/tinycc.git"
    [U]="https://github.com/fuse-open/uno.git"
    [V]="https://github.com/vlang/v.git"
    [W]="https://github.com/wren-lang/wren.git"
    [X]="https://github.com/x10-lang/x10.git"
    [Y]="https://github.com/retroprom/ybc.git"
    [Z]="https://github.com/ziglang/zig.git"
)

# Function to clone and build a compiler
build_compiler() {
    local letter="$1"
    local repo_url="$2"

    echo "Processing $letter: $repo_url"

    # Clone repository
    local repo_dir="$BUILD_DIR/$letter"
    if [ ! -d "$repo_dir" ]; then
        git clone "$repo_url" "$repo_dir" > "$LOG_DIR/$letter-clone.log" 2>&1
    else
        echo "$letter already cloned."
    fi

    # Build repository
    cd "$repo_dir"
    if [ -f "configure" ]; then
        ./configure > "$LOG_DIR/$letter-build.log" 2>&1 && make >> "$LOG_DIR/$letter-build.log" 2>&1
    elif [ -f "CMakeLists.txt" ]; then
        mkdir -p build && cd build && cmake .. > "$LOG_DIR/$letter-build.log" 2>&1 && make >> "$LOG_DIR/$letter-build.log" 2>&1
    elif [ -f "Makefile" ]; then
        make > "$LOG_DIR/$letter-build.log" 2>&1
    else
        echo "No standard build system found for $letter. Check logs for details."
    fi

    cd "$BUILD_DIR"
    echo "$letter build completed. Logs available in $LOG_DIR/$letter-build.log"
}

# Iterate over all compilers
for letter in "${!COMPILERS[@]}"; do
    build_compiler "$letter" "${COMPILERS[$letter]}"
done

echo "All compilers processed. Check $LOG_DIR for logs."
