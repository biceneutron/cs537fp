use std::env;

#[cfg(feature = "mm")]
mod mm;

#[cfg(feature = "coding")]
mod coding;

#[cfg(feature = "io")]
mod io;

#[cfg(any(feature = "networking", feature = "tcp-server"))]
mod networking;

// #NOTE To use `perf record` and `perf report` to analyze the execution time of the task function, we need to tear down
// the execute() of each task module and put the code in main(), so perf can catch the information of the actual task
// function excluding read and write. (e.g. the current "mm" case)
//
// But if we just use the std::time to time the task function, we can leave the code in the module, time the task function
// there, and just call execute() in main.
fn main() {
    let args: Vec<String> = env::args().collect();
    // let task = &args[1];

    #[cfg(feature = "mm")]
    {
        use std::time::Instant;

        if args.len() != 7 {
            println!(
                "usage: mm a_file_path, b_file_path, result_file_path, a_rows, a_cols, b_cols"
            );
            return;
        }

        let a_file_path = &args[1];
        let b_file_path = &args[2];
        let result_file_path = &args[3];
        let a_rows = args[4].parse::<usize>().unwrap();
        let a_cols = args[5].parse::<usize>().unwrap();
        let b_cols = args[6].parse::<usize>().unwrap();

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

        let start = Instant::now();
        mm::multiply_matrices(&a, &b, &mut result);
        let duration = start.elapsed();

        // write
        mm::write_to_file(result, result_file_path);

        println!("Done. {:?}", duration);
    }

    #[cfg(feature = "coding")]
    {
        if args.len() != 3 {
            println!("usage: coding input_file_path, output_file_path");
            return;
        }

        let input_file_path = &args[1];
        let output_file_path = &args[2];

        coding::execute(input_file_path, output_file_path);
    }

    #[cfg(feature = "io")]
    {
        if args.len() != 3 {
            println!("usage: io input_file_path, output_file_path");
            return;
        }

        let input_file_path = &args[1];
        let output_file_path = &args[2];

        io::execute(input_file_path, output_file_path);
    }

    #[cfg(feature = "networking")]
    {
        if args.len() != 3 {
            println!("usage: networking host_addr, file_path");
            return;
        }

        let host_addr = &args[1];
        let file_path = &args[2];

        networking::execute(host_addr, file_path);
    }

    #[cfg(feature = "tcp-server")]
    {
        if args.len() != 2 {
            println!("usage: tcp-server host_addr");
            return;
        }

        let host_addr = &args[1];

        networking::start_server(host_addr);
    }
}
