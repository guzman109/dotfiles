#!/bin/bash

# Detect which C++ compiler is being used
if command -v clang++ &> /dev/null; then
    COMPILER=$(clang++ --version 2>&1 | head -1)
    if echo "$COMPILER" | grep -q "clang"; then
        # LLVM/Clang
        VERSION=$(echo "$COMPILER" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
        echo " v$VERSION"
        exit 0
    fi
fi

if command -v g++ &> /dev/null; then
    COMPILER=$(g++ --version 2>&1 | head -1)
    if echo "$COMPILER" | grep -q "GCC\|g++"; then
        # GCC
        VERSION=$(echo "$COMPILER" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
        echo " v$VERSION"
        exit 0
    fi
fi

# Fallback
echo " C++"
