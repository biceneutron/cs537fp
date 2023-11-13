use std::env;

#[cfg(feature = "mm")]
mod mm;

#[cfg(feature = "coding")]
mod coding;

#[cfg(feature = "io")]
mod io;

#[cfg(feature = "networking")]
mod networking;

fn main() {
    let args: Vec<String> = env::args().collect();
    let task = &args[1];

    match task.as_str() {
        #[cfg(feature = "mm")]
        "mm" => {
            if args.len() != 8 {
                println!(
                    "usage: mm a_file_path, b_file_path, result_file_path, a_rows, a_cols, b_cols"
                );
                return;
            }

            let a_file_path = &args[2];
            let b_file_path = &args[3];
            let result_file_path = &args[4];
            let a_rows = args[5].parse::<usize>().unwrap();
            let a_cols = args[6].parse::<usize>().unwrap();
            let b_cols = args[7].parse::<usize>().unwrap();

            // mm::execute(
            //     a_file_path,
            //     b_file_path,
            //     result_file_path,
            //     a_rows,
            //     a_cols,
            //     b_cols,
            // )
            // read data
            let (a, b) = mm::read_matrices(a_file_path, b_file_path, a_rows, a_cols, b_cols);

            // multiplication
            let mut result = vec![vec![0.0; b[0].len()]; a.len()];
            mm::multiply_matrices(&a, &b, &mut result);

            // write
            mm::write_to_file(result, result_file_path);

            println!("Done.");
        }

        #[cfg(feature = "coding")]
        "coding" => {
            if args.len() != 4 {
                println!("usage: coding input_file_path, output_file_path");
                return;
            }

            let input_file_path = &args[2];
            let output_file_path = &args[3];

            coding::execute(input_file_path, output_file_path);
        }

        #[cfg(feature = "io")]
        "io" => {
            if args.len() != 4 {
                println!("usage: io input_file_path, output_file_path");
                return;
            }

            let input_file_path = &args[2];
            let output_file_path = &args[3];

            io::execute(input_file_path, output_file_path);
        }

        #[cfg(feature = "networking")]
        "networking" => {
            if args.len() != 4 {
                println!("usage: networking host_addr, file_path");
                return;
            }

            let host_addr = &args[2];
            let file_path = &args[3];

            networking::execute(host_addr, file_path);
        }

        #[cfg(feature = "networking")]
        "tcp-server" => {
            if args.len() != 3 {
                println!("usage: tcp-server host_addr");
                return;
            }

            let host_addr = &args[2];

            networking::start_server(host_addr);
        }
        _ => {
            println!("avalable tasks: mm, coding, io, networking, tcp-server");
            return;
        }
    }
}
