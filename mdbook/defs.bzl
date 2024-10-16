"""# rules_mdbook

Bazel rules for [mdBook](https://github.com/rust-lang/mdBook).

## Setup

```starlark
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# See releases for urls and checksums
http_archive(
    name = "rules_mdbook",
    integrity = "{integrity}",
    urls = ["https://github.com/abrisco/rules_mdbook/releases/download/{version}/rules_mdbook-{version}.tar.gz"],
)

load("@rules_mdbook//mdbook:repositories.bzl", "mdbook_register_toolchains", "rules_mdbook_dependencies")

rules_mdbook_dependencies()

mdbook_register_toolchains()

load("@rules_mdbook//mdbook:repositories_transitive.bzl", "rules_mdbook_transitive_deps")

rules_mdbook_transitive_deps()
```

## Rules

- [mdbook](#mdbook)
- [mdbook_toolchain](#mdbook_toolchain)

---
---
"""

load(
    "//mdbook/private:mdbook.bzl",
    _mdbook = "mdbook",
)
load(
    "//mdbook/private:toolchain.bzl",
    _mdbook_toolchain = "mdbook_toolchain",
)

mdbook = _mdbook
mdbook_toolchain = _mdbook_toolchain
