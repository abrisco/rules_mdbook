//! The `rules_mdbook` process wrapper

use std::env;
use std::process::Command;

#[cfg(target_family = "unix")]
const PATH_SEP: &str = ":";

#[cfg(target_family = "windows")]
const PATH_SEP: &str = ";";

fn main() {
    let mut args = env::args();

    // Skip argv0 (process wrapper path)
    args.next();

    // Extract the first argument
    let mdbook = args
        .next()
        .expect("No arguments were passed to the rules_mdbook process wrapper.");

    let pwd = env::current_dir().expect("Unable to determine current working directory");

    let mut command = Command::new(mdbook);

    // Inject plugin paths into PATH
    if let Ok(plugin_path) = env::var("MDBOOK_PLUGIN_PATH") {
        let path = env::var("PATH").unwrap_or_default();
        let plugin_path = plugin_path.replace("${pwd}", &pwd.to_string_lossy());
        command.env("PATH", format!("{}{}{}", plugin_path, PATH_SEP, path));
    }

    // Run mdbook and save output
    let output = command
        .args(args.map(|arg| arg.replace("${pwd}", &pwd.to_string_lossy())))
        .output()
        .unwrap_or_else(|e| panic!("Failed to spawn mdbook command\n{:?}\n{:#?}", e, command));

    if !output.status.success() {
        eprintln!("{}", String::from_utf8(output.stdout).unwrap());
        eprintln!("{}", String::from_utf8(output.stderr).unwrap());
        std::process::exit(output.status.code().unwrap_or(1));
    }
}
