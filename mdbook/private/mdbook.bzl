"""mdBook rules"""

def _map_inputs(file):
    return "{}={}".format(file.path, file.short_path)

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

    inputs = depset([ctx.file.book] + ctx.files.srcs)

    inputs_map_args = ctx.actions.args()
    inputs_map_args.use_param_file("%s", use_always = True)
    inputs_map_args.add_all(inputs, map_each = _map_inputs)

    args = ctx.actions.args()

    # This arg is used for `--dest-dir` within the action.
    args.add(output.path)
    args.add(toolchain.mdbook)
    args.add("build")
    args.add("${{pwd}}/{}".format(ctx.file.book.dirname))

    ctx.actions.run(
        mnemonic = "MdBookBuild",
        executable = ctx.executable._process_wrapper,
        tools = depset(ctx.files.plugins, transitive = [toolchain.all_files]),
        outputs = [output],
        arguments = [inputs_map_args, args],
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
        "plugins": attr.label_list(
            doc = (
                "Executables to inject into `PATH` for use in " +
                "[preprocessor commands](https://rust-lang.github.io/mdBook/format/configuration/preprocessors.html#provide-your-own-command)."
            ),
            allow_files = True,
            cfg = "exec",
        ),
        "srcs": attr.label_list(
            doc = "All inputs to the book.",
            allow_files = True,
        ),
        "_process_wrapper": attr.label(
            cfg = "exec",
            executable = True,
            default = Label("//mdbook/private:process_wrapper"),
        ),
    },
    toolchains = ["@rules_mdbook//mdbook:toolchain_type"],
)
