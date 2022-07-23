"""Helper utiltiies for fetching dependencies"""

_BUILD_CONTENT = """\
toolchain(
    name = "toolchain",
    exec_compatible_with = {exec_constraint_sets_serialized},
    target_compatible_with = {target_constraint_sets_serialized},
    toolchain = "@{tools_repo_name}//:mdbook_toolchain",
    toolchain_type = "@rules_mdbook//mdbook:toolchain_type",
    visibility = ["//visibility:public"],
)
"""

def _mdbook_toolchain_repository_impl(repository_ctx):
    repository_ctx.file("WORKSPACE.bazel", """workspace(name = "{}")""".format(
        repository_ctx.name,
    ))

    repository_ctx.file("BUILD.bazel", _BUILD_CONTENT.format(
        repository_ctx.name,
    ))

mdbook_toolchain_repository = repository_rule(
    implementation = _mdbook_toolchain_repository_impl,
    docs = "A repository rule for defining an mdbook toolchain",
    attrs = {
        "exec_compatible_with": attr.string_list(
            doc = "",
        ),
        "target_compatible_with": attr.string_list(
            doc = "",
        ),
        "target_triple": attr.string(
            doc = "",
            mandatory = True,
        ),
        "tool_repo_name": attr.string(
            doc = "",
            mandatory = True,
        ),
        "version": attr.string(
            doc = "",
            mandatory = True,
        ),
    },
)
