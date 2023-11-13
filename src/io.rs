use std::fs;
use std::io::{Read, Write};
use std::time::Instant;

pub fn execute(input_file_path: &str, output_file_path: &str) {
    let start = Instant::now();

    let mut input_file = fs::File::open(input_file_path)
        .map_err(|err| format!("error opening input {}: {}", input_file_path, err))
        .unwrap();

    let mut contents = Vec::new();
    input_file
        .read_to_end(&mut contents)
        .map_err(|err| format!("read error: {}", err))
        .unwrap();

    let mut output_file = fs::File::create(output_file_path)
        .map_err(|err| format!("error opening output {}: {}", output_file_path, err))
        .unwrap();

    output_file
        .write_all(&contents)
        .map_err(|err| format!("write error: {}", err))
        .unwrap();

    let duration = start.elapsed();
    println!("Done. {:?}", duration);
}
