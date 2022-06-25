# Common Bazel Utils

Bazel rules to (somewhat) avoid repeating the same things across Bazel workspaces

# Using

Add to WORKSPACE:

```python
# Common setup
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel-utils_",
    sha256 = "18a5a55fdbef6670fcde4c5b81ee3e36150b653d7597b7c0969ae836774dc423",
    strip_prefix = "bazel-utils-1.1.0",
    url = "https://www.github.com/dave-hagedorn/bazel-utils/archive/1.1.0.zip",
)

load("@bazel-utils//:bazel-utils.bzl", "LLVM_VERSION", "cc_workspace_dependencies", "github_archive")

cc_workspace_dependencies()

# Macros can't load(), so load rules/macros fetched in cc_dependencies()
load("@hedron_compile_commands//:workspace_setup.bzl", "hedron_compile_commands_setup")
load("@com_grail_bazel_toolchain//toolchain:deps.bzl", "bazel_toolchain_dependencies")
load("@com_grail_bazel_toolchain//toolchain:rules.bzl", "llvm_toolchain")

# It would be better if these were in one convenience macro, but macros cannot contain undefined symbols
# - these calls have to appear after the load()'s above
hedron_compile_commands_setup()

bazel_toolchain_dependencies()

llvm_toolchain(
    name = "llvm_toolchain",
    llvm_version = LLVM_VERSION,
)

load("@llvm_toolchain//:toolchains.bzl", "llvm_register_toolchains")

llvm_register_toolchains()

# End common post-setup
```

