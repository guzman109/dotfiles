local M = {}

local function exists(path)
	return vim.uv.fs_stat(path) ~= nil
end

local function write_if_missing(root, path, lines)
	local full_path = root .. "/" .. path
	if exists(full_path) then
		return false, path
	end

	local dir = vim.fs.dirname(full_path)
	if dir and dir ~= root and not exists(dir) then
		vim.fn.mkdir(dir, "p")
	end

	vim.fn.writefile(lines, full_path)
	return true, path
end

local function editorconfig(indent_size)
	return {
		"root = true",
		"",
		"[*]",
		"charset = utf-8",
		"end_of_line = lf",
		"insert_final_newline = true",
		"trim_trailing_whitespace = true",
		"indent_style = space",
		"indent_size = " .. indent_size,
		"",
		"[*.md]",
		"trim_trailing_whitespace = false",
	}
end

local function justfile(lines)
	return vim.list_extend({
		"set dotenv-load := true",
		"set export := true",
		"",
		"default:",
		"\t@just --list",
		"",
	}, lines)
end

local common_gitignore = {
	"",
	"# Agent / local memory",
	".claude/",
	".memsearch/",
	"",
	"# Secrets",
	".env",
	".env.*",
	"!.env.example",
	"!.env.*.example",
	".secrets/",
	"secrets.*",
	"*.pem",
	"*.key",
	"*.p12",
	"*.pfx",
}

local function gitignore(lines)
	return vim.list_extend(vim.deepcopy(lines), common_gitignore)
end

local function prose_files()
	return {
		[".vale.ini"] = {
			"StylesPath = .github/styles",
			"MinAlertLevel = suggestion",
			"Packages = write-good",
			"",
			"[*.{md,txt}]",
			"BasedOnStyles = Vale, write-good",
			"write-good.E-Prime = NO",
			"write-good.Passive = suggestion",
		},
		[".harper-dictionary.txt"] = {
			"# One accepted project term per line.",
			"# Harper uses this file as the workspace dictionary.",
		},
	}
end

local templates = {
	["Prose"] = vim.tbl_extend("force", {
		["justfile"] = justfile({
			"prose-sync:",
			"\tvale sync",
			"",
			"prose:",
			"\tvale .",
		}),
		[".editorconfig"] = editorconfig(2),
		["README.md"] = {
			"# Project",
			"",
		},
		[".gitignore"] = gitignore({
			".vale/",
		}),
	}, prose_files()),
	["C++"] = {
		["justfile"] = justfile({
			"deps-debug:",
			"\tconan install . --output-folder build/debug --build=missing -s build_type=Debug",
			"",
			"deps-release:",
			"\tconan install . --output-folder build/release --build=missing -s build_type=Release",
			"",
			"configure:",
			"\tjust configure-debug",
			"",
			"configure-debug:",
			"\tjust deps-debug",
			"\tcmake -S . -B build/debug -DCMAKE_TOOLCHAIN_FILE=build/debug/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
			"",
			"configure-release:",
			"\tjust deps-release",
			"\tcmake -S . -B build/release -DCMAKE_TOOLCHAIN_FILE=build/release/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
			"",
			"build:",
			"\tcmake --build build/debug",
			"",
			"build-release:",
			"\tcmake --build build/release",
			"",
			"test:",
			"\tctest --test-dir build/debug --output-on-failure",
			"",
			"test-release:",
			"\tctest --test-dir build/release --output-on-failure",
			"",
			"fmt:",
			"\tclang-format -i src/**/*.cpp src/**/*.hpp include/**/*.hpp include/**/*.h",
			"\tgersemi -i CMakeLists.txt",
		}),
		[".editorconfig"] = editorconfig(2),
		[".clangd"] = {
			"CompileFlags:",
			"  CompilationDatabase: build/debug",
			"Diagnostics:",
			"  ClangTidy:",
			"    Add: [modernize-*, performance-*, readability-*]",
		},
		[".clang-tidy"] = {
			"Checks: >",
			"  bugprone-*,",
			"  clang-analyzer-*,",
			"  modernize-*,",
			"  performance-*,",
			"  readability-*",
			"WarningsAsErrors: ''",
			"HeaderFilterRegex: '.*'",
			"FormatStyle: file",
		},
		[".clang-format"] = {
			"BasedOnStyle: LLVM",
			"IndentWidth: 2",
			"ColumnLimit: 100",
		},
		[".gitignore"] = gitignore({
			"build/",
			".cache/",
			"compile_commands.json",
		}),
		["conanfile.py"] = {
			"from conan import ConanFile",
			"from conan.tools.cmake import cmake_layout",
			"",
			"",
			"class AppRecipe(ConanFile):",
			'    name = "app"',
			'    version = "0.1.0"',
			'    package_type = "application"',
			'    settings = "os", "compiler", "build_type", "arch"',
			'    generators = "CMakeToolchain", "CMakeDeps"',
			"",
			"    def layout(self):",
			"        cmake_layout(self)",
		},
		["CMakeLists.txt"] = {
			"cmake_minimum_required(VERSION 3.25)",
			"",
			"project(app LANGUAGES CXX)",
			"",
			"set(CMAKE_CXX_STANDARD 23)",
			"set(CMAKE_CXX_STANDARD_REQUIRED ON)",
			"set(CMAKE_CXX_EXTENSIONS OFF)",
			"",
			"add_executable(app src/main.cpp)",
		},
		["src/main.cpp"] = {
			"#include <iostream>",
			"",
			"int main() {",
			'  std::cout << "Hello from C++\\n";',
			"  return 0;",
			"}",
		},
	},
	["Zig"] = {
		["justfile"] = justfile({
			"build:",
			"\tzig build",
			"",
			"test:",
			"\tzig build test",
			"",
			"run:",
			"\tzig build run",
			"",
			"fmt:",
			"\tzig fmt .",
		}),
		[".editorconfig"] = editorconfig(4),
		[".gitignore"] = gitignore({
			".zig-cache/",
			"zig-out/",
		}),
		["build.zig"] = {
			'const std = @import("std");',
			"",
			"pub fn build(b: *std.Build) void {",
			"    const target = b.standardTargetOptions(.{});",
			"    const optimize = b.standardOptimizeOption(.{});",
			"",
			"    const exe = b.addExecutable(.{",
			'        .name = "app",',
			'        .root_source_file = b.path("src/main.zig"),',
			"        .target = target,",
			"        .optimize = optimize,",
			"    });",
			"",
			"    b.installArtifact(exe);",
			"",
			"    const run_cmd = b.addRunArtifact(exe);",
			'    const run_step = b.step("run", "Run the app");',
			"    run_step.dependOn(&run_cmd.step);",
			"}",
		},
		["src/main.zig"] = {
			'const std = @import("std");',
			"",
			"pub fn main() !void {",
			'    try std.io.getStdOut().writer().print("Hello from Zig\\n", .{});',
			"}",
		},
	},
	["Python uv"] = {
		["justfile"] = justfile({
			"run:",
			"\tuv run python main.py",
			"",
			"test:",
			"\tuv run pytest",
			"",
			"lint:",
			"\tuv run ruff check .",
			"",
			"fmt:",
			"\tuv run ruff format .",
		}),
		[".editorconfig"] = editorconfig(4),
		[".gitignore"] = gitignore({
			".venv/",
			".pytest_cache/",
			".ruff_cache/",
			"__pycache__/",
		}),
		["pyproject.toml"] = {
			"[project]",
			'name = "app"',
			'version = "0.1.0"',
			'requires-python = ">=3.12"',
			"dependencies = []",
			"",
			"[tool.ruff]",
			"line-length = 100",
		},
		["main.py"] = {
			'print("Hello from Python")',
		},
	},
	["Lua"] = {
		["justfile"] = justfile({
			"fmt:",
			"\tstylua .",
			"",
			"check:",
			'\tlua -e "print(\\"ok\\")"',
		}),
		[".editorconfig"] = editorconfig(2),
		["stylua.toml"] = {
			"column_width = 120",
			'indent_type = "Tabs"',
			"indent_width = 2",
		},
		[".luarc.json"] = {
			"{",
			'  "runtime.version": "LuaJIT",',
			'  "diagnostics.globals": ["vim"]',
			"}",
		},
		[".gitignore"] = gitignore({
			".luarc.json.bak",
		}),
	},
	["TypeScript"] = {
		["justfile"] = justfile({
			"dev:",
			"\tbun run dev",
			"",
			"build:",
			"\tbun run build",
			"",
			"test:",
			"\tbun test",
			"",
			"lint:",
			"\tbunx biome check .",
			"",
			"fmt:",
			"\tbunx biome format --write .",
		}),
		[".editorconfig"] = editorconfig(2),
		[".gitignore"] = gitignore({
			"node_modules/",
			"dist/",
		}),
		["package.json"] = {
			"{",
			'  "type": "module",',
			'  "scripts": {',
			'    "dev": "tsx src/main.ts",',
			'    "build": "tsc -p tsconfig.json",',
			'    "test": "bun test"',
			"  },",
			'  "devDependencies": {',
			'    "@biomejs/biome": "latest",',
			'    "tsx": "latest",',
			'    "typescript": "latest"',
			"  }",
			"}",
		},
		["tsconfig.json"] = {
			"{",
			'  "compilerOptions": {',
			'    "target": "ES2022",',
			'    "module": "ESNext",',
			'    "moduleResolution": "Bundler",',
			'    "strict": true,',
			'    "skipLibCheck": true',
			"  },",
			'  "include": ["src"]',
			"}",
		},
		["biome.json"] = {
			"{",
			'  "$schema": "https://biomejs.dev/schemas/2.0.0/schema.json",',
			'  "formatter": { "enabled": true },',
			'  "linter": { "enabled": true }',
			"}",
		},
		["src/main.ts"] = {
			'console.log("Hello from TypeScript");',
		},
	},
}

function M.create(kind, root)
	root = root or vim.fn.getcwd()
	if not exists(root) then
		vim.fn.mkdir(root, "p")
	end

	local template = templates[kind]
	if not template then
		vim.notify("Unknown project template: " .. tostring(kind), vim.log.levels.ERROR)
		return
	end

	local created = {}
	local skipped = {}
	for path, lines in pairs(template) do
		local ok, name = write_if_missing(root, path, lines)
		table.insert(ok and created or skipped, name)
	end

	if #created > 0 then
		vim.notify("Created: " .. table.concat(created, ", "), vim.log.levels.INFO)
	end
	if #skipped > 0 then
		vim.notify("Skipped existing: " .. table.concat(skipped, ", "), vim.log.levels.WARN)
	end
end

function M.pick()
	local kinds = vim.tbl_keys(templates)
	table.sort(kinds)
	vim.ui.select(kinds, { prompt = "Project template: " }, function(kind)
		if kind then
			M.create(kind)
		end
	end)
end

return M
