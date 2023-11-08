use std::fs;
use std::io::{BufRead, BufReader, Write};

pub fn execute(
    a_file_path: &str,
    b_file_path: &str,
    result_file_path: &str,
    a_rows: usize,
    a_cols: usize,
    b_cols: usize,
) {
    // read data
    let matrix_a: Vec<Vec<f64>> = read_matrix_from_file(a_file_path, a_rows, a_cols);
    let matrix_b: Vec<Vec<f64>> = read_matrix_from_file(b_file_path, a_cols, b_cols);

    // multiplication
    let mut result = vec![vec![0.0; matrix_b[0].len()]; matrix_a.len()];
    multiply_matrices(&matrix_a, &matrix_b, &mut result);

    // write
    let mut output_file = fs::File::create(result_file_path).expect("should open file");
    for row in result {
        let row_string = row
            .iter()
            .map(|x| x.to_string())
            .collect::<Vec<String>>()
            .join(" ");
        writeln!(output_file, "{}", row_string).expect("write should succeed");
    }

    // println!("{:?}", result);
    println!("Done.");
}

fn read_matrix_from_file(file_path: &str, rows: usize, cols: usize) -> Vec<Vec<f64>> {
    let file = fs::File::open(file_path).expect("Failed to open file");
    let reader = BufReader::new(file);
    let mut matrix = Vec::with_capacity(rows);

    for line in reader.lines().take(rows) {
        let row: Vec<f64> = line
            .expect("Failed to read line")
            .split_whitespace()
            .take(cols)
            .map(|num| num.parse().expect("Invalid number"))
            .collect();

        matrix.push(row);
    }

    matrix
}

fn multiply_matrices(
    matrix_a: &Vec<Vec<f64>>,
    matrix_b: &Vec<Vec<f64>>,
    result: &mut Vec<Vec<f64>>,
) {
    let rows_a = matrix_a.len();
    let cols_a = matrix_a[0].len();
    let cols_b = matrix_b[0].len();

    // let mut result = vec![vec![0.0; cols_b]; rows_a];

    for i in 0..rows_a {
        for j in 0..cols_b {
            for k in 0..cols_a {
                result[i][j] += matrix_a[i][k] * matrix_b[k][j];
            }
        }
    }
}
