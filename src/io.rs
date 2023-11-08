use std::fs;
use std::io::{Read, Write};

pub fn execute(input_file_path: &str, output_file_path: &str) {
    if let Err(err) = process(&input_file_path, &output_file_path) {
        eprintln!("{}", err)
    }

    println!("Done.");
}

fn process(input_fname: &str, output_fname: &str) -> Result<(), String> {
    let mut input_file = fs::File::open(input_fname)
        .map_err(|err| format!("error opening input {}: {}", input_fname, err))?;
    let mut contents = Vec::new();
    input_file
        .read_to_end(&mut contents)
        .map_err(|err| format!("read error: {}", err))?;

    let mut output_file = fs::File::create(output_fname)
        .map_err(|err| format!("error opening output {}: {}", output_fname, err))?;
    output_file
        .write_all(&contents)
        .map_err(|err| format!("write error: {}", err))
}
