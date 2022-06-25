# Common Bazel Utils

Bazel rules to avoid repeating the same things across Bazel workspaces

```python
load("@bazel-utils:bazel-utils.bzl", "cc_dependencies")

cc_dependencies()

load("@hedron_compile_commands//:workspace_setup.bzl", "hedron_compile_commands_setup")
hedron_compile_commands_setup()
```

