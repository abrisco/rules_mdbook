"""mdBook rules"""

def _mdbook_impl(ctx):
    output = ctx.actions.declare_directory(ctx.label.name)

    toolchain = ctx.toolchains["@rules_mdbook//mdbook:toolchain_type"]

    plugin_paths = depset([
        "${{pwd}}/{}".format(file.dirname)
        for file in depset(ctx.files.plugins, transitive = [toolchain.plugins]).to_list()
    ])
    is_windows = toolchain.mdbook.basename.endswith(".exe")
    path_sep = ";" if is_windows else ":"
    plugin_path = path_sep.join(plugin_paths.to_list())

    args = ctx.actions.args()
    args.add(toolchain.mdbook)
    args.add("build")
    args.add(ctx.file.book.dirname)
    args.add("--dest-dir", "${{pwd}}/{}".format(output.path))

    inputs = depset([ctx.file.book] + ctx.files.srcs)

    ctx.actions.run(
        mnemonic = "MdBookBuild",
        executable = ctx.executable._process_wrapper,
        tools = [toolchain.mdbook],
        outputs = [output],
        arguments = [args],
        env = {"MDBOOK_PLUGIN_PATH": plugin_path},
        inputs = inputs,
        toolchain = "@rules_mdbook//mdbook:toolchain_type",
    )

    return [DefaultInfo(
        files = depset([output]),
    )]

mdbook = rule(
    implementation = _mdbook_impl,
    doc = "Rules to create book from markdown files using `mdBook`.",
    attrs = {
        "book": attr.label(
            doc = "The `book.toml` file.",
            allow_single_file = ["book.toml"],
            mandatory = True,
        ),
        "srcs": attr.label_list(
            doc = "All inputs to the book.",
            allow_files = True,
        ),
        "plugins": attr.label_list(
            doc = (
                "Executables to inject into `PATH` for use in " +
                "[preprocessor commands](https://rust-lang.github.io/mdBook/format/configuration/preprocessors.html#provide-your-own-command)."
            ),
            allow_files = True,
            cfg = "exec",
        ),
        "_process_wrapper": attr.label(
            cfg = "exec",
            executable = True,
            default = Label("//mdbook/private:process_wrapper"),
        ),
    },
    toolchains = ["@rules_mdbook//mdbook:toolchain_type"],
)
