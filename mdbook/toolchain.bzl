"""MDBook toolchain implementations"""

def _mdbook_toolchain_impl(ctx):
    make_variable_info = platform_common.TemplateVariableInfo({
        "MDBOOK": ctx.file.mdbook.path,
    })

    toolchain = platform_common.ToolchainInfo(
        make_variables = make_variable_info,
        mdbook = ctx.file.mdbook,
    )

    return [
        toolchain,
        make_variable_info,
    ]

mdbook_toolchain = rule(
    implementation = _mdbook_toolchain_impl,
    docs = "A `mdBook` toolchain.",
    attrs = {
        "mdbook": attr.label(
            doc = "A `mdBook` binary.",
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
    },
)
