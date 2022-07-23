//! The `rules_mdbook` process wrapper

use std::env;
use std::process::Command;

fn main() {
    let mut args = env::args();

    // Skip argv0 (process wrapper path)
    args.next();

    // Extract the first argument
    let mdbook = args
        .next()
        .expect("No arguments were passed to the rules_mdbook process wrapper.");

    // Run mdbook and save output
    let output = Command::new(mdbook)
        .args(args.map(|arg| {
            arg.replace(
                "${pwd}",
                &env::current_dir()
                    .expect("Unable to determine current working directory")
                    .to_string_lossy(),
            )
        }))
        .output()
        .expect("Failed to spawn mdbook command");

    if !output.status.success() {
        eprintln!("{}", String::from_utf8(output.stdout).unwrap());
        eprintln!("{}", String::from_utf8(output.stderr).unwrap());
        std::process::exit(output.status.code().unwrap_or(1));
    }
}
