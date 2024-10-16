<!-- Generated with Stardoc: http://skydoc.bazel.build -->

# rules_mdbook

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

<a id="mdbook"></a>

## mdbook

<pre>
mdbook(<a href="#mdbook-name">name</a>, <a href="#mdbook-srcs">srcs</a>, <a href="#mdbook-book">book</a>)
</pre>

Rules to create book from markdown files using `mdBook`.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="mdbook-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="mdbook-srcs"></a>srcs |  All inputs to the book.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="mdbook-book"></a>book |  The `book.toml` file.   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


<a id="mdbook_toolchain"></a>

## mdbook_toolchain

<pre>
mdbook_toolchain(<a href="#mdbook_toolchain-name">name</a>, <a href="#mdbook_toolchain-mdbook">mdbook</a>)
</pre>

A [mdBook](https://rust-lang.github.io/mdBook/) toolchain.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="mdbook_toolchain-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="mdbook_toolchain-mdbook"></a>mdbook |  A `mdBook` binary.   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


