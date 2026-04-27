# AgentVim Guidance

This Neovim configuration is not a Swift or iOS programming environment. Do not add Swift, iOS, SourceKit, Xcode, UIKit, SwiftPM, Objective-C, or Apple-platform-specific editor support unless explicitly requested for a one-off task.

Prefer changes that improve C++ systems work, computer vision, embedded development, and robotics workflows.

Primary focus areas:
- C and C++ with `clangd`, `clang-tidy`, `clang-format`, Conan, CMake, LLDB, and compile database support.
- Computer vision projects using OpenCV, camera pipelines, image processing, calibration, perception, and dataset tooling.
- Embedded projects using cross-compilers, serial workflows, RTOS-aware conventions, hardware-facing build recipes, and constrained-device debugging.
- Robotics projects using ROS 2, sensor integration, motion/control code, transforms, logging, simulation, and field-test workflows.

When adding new project templates, commands, keymaps, LSP servers, formatters, or debugging support, bias toward these domains and keep project-specific behavior in local `justfile` recipes where practical.

Do not edit files under `config/.config/homebrew/`, including the Brewfile, unless the user explicitly asks for Homebrew changes. If a tool or language server would require a new Homebrew package, ask first and offer the package name separately from the Neovim config change.
