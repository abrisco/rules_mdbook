"""rules_mdbook dependencies"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//mdbook/private:toolchain.bzl", "mdbook_toolchain_repository")

def rules_mdbook_dependencies():
    maybe(
        http_archive,
        name = "rules_rust",
        integrity = "sha256-heIBNyerJvsiq9/+SyrAwnotW2KWFnumPY9uExQPUfk=",
        urls = ["https://github.com/bazelbuild/rules_rust/releases/download/0.53.0/rules_rust-v0.53.0.tar.gz"],
    )

    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "bc283cdfcd526a52c3201279cda4bc298652efa898b10b4db0837dc51652756f",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
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
