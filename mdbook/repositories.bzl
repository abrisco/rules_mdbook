"""rules_mdbook dependencies"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//mdbook/private:toolchain.bzl", "mdbook_toolchain_repository")

def rules_mdbook_dependencies():
    maybe(
        http_archive,
        name = "rules_rust",
        integrity = "sha256-JLN47ZcAbx9wEr5Jiib4HduZATGLiDgK7oUi/fvotzU=",
        urls = ["https://github.com/bazelbuild/rules_rust/releases/download/0.42.1/rules_rust-v0.42.1.tar.gz"],
    )

    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "cd55a062e763b9349921f0f5db8c3933288dc8ba4f76dd9416aac68acee3cb94",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.5.0/bazel-skylib-1.5.0.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.5.0/bazel-skylib-1.5.0.tar.gz",
        ],
    )

# buildifier: disable=unnamed-macro
def mdbook_register_toolchains():
    """Register toolchains for mdBook rules.
    """
    maybe(
        mdbook_toolchain_repository,
        name = "rules_mdbook_toolchain",
        mdbook = str(Label("@rules_mdbook//mdbook/private/3rdparty/crates:mdbook__mdbook")),
    )

    native.register_toolchains("@rules_mdbook_toolchain//:toolchain")
