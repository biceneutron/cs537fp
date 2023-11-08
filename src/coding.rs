use std::collections::HashMap;
use std::fs::File;
use std::io::{Read, Write};

pub struct Node {
    freq: i32,
    ch: Option<char>,
    left: Option<Box<Node>>,
    right: Option<Box<Node>>,
}

fn new_node(freq: i32, ch: Option<char>) -> Node {
    Node {
        freq,
        ch,
        left: None,
        right: None,
    }
}

fn new_box(n: Node) -> Box<Node> {
    Box::new(n)
}

// https://pramode.in/2016/09/26/huffman-coding-in-rust/
pub fn execute(input_file_path: &str, output_file_path: &str) {
    // read data
    let input = match read_file_to_string(input_file_path) {
        Ok(s) => s,
        Err(e) => panic!("{}", e),
    };

    let h = frequency(&input);
    let root = encode(h);

    let mut code_table: HashMap<char, String> = HashMap::new();
    assign_codes(&root, &mut code_table, "".to_string());

    // write
    let serialized = serde_json::to_string(&code_table).unwrap();
    let mut output = File::create(output_file_path).unwrap();
    output.write_all(serialized.as_bytes()).unwrap();

    println!("Done.");
}

fn read_file_to_string(file_path: &str) -> Result<String, std::io::Error> {
    let mut file = File::open(file_path)?;
    let mut content = String::new();
    file.read_to_string(&mut content)?;

    Ok(content)
}

fn frequency(s: &str) -> HashMap<char, i32> {
    let mut h = HashMap::new();
    for ch in s.chars() {
        let counter = h.entry(ch).or_insert(0);
        *counter += 1;
    }
    h
}

fn encode(h: HashMap<char, i32>) -> Box<Node> {
    let mut p: Vec<Box<Node>> = h
        .iter()
        .map(|x| new_box(new_node(*(x.1), Some(*(x.0)))))
        .collect();

    while p.len() > 1 {
        p.sort_by(|a, b| (&(b.freq)).cmp(&(a.freq)));
        let a = p.pop().unwrap();
        let b = p.pop().unwrap();
        let mut c = new_box(new_node(a.freq + b.freq, None));
        c.left = Some(a);
        c.right = Some(b);
        p.push(c);
    }

    p.pop().unwrap()
}

fn assign_codes(p: &Box<Node>, h: &mut HashMap<char, String>, s: String) {
    if let Some(ch) = p.ch {
        h.insert(ch, s);
    } else {
        if let Some(ref l) = p.left {
            assign_codes(l, h, s.clone() + "0");
        }
        if let Some(ref r) = p.right {
            assign_codes(r, h, s.clone() + "1");
        }
    }
}
