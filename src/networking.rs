use std::fs::File;
use std::io::{Read, Write};
use std::net::TcpListener;
use std::net::TcpStream;
use std::thread;

// native TCP client
#[cfg(not(feature = "wasi"))]
pub fn execute(host_addr: &str, file_path: &str) {
    // Connect to the server
    let mut stream = match TcpStream::connect(host_addr) {
        Ok(s) => s,
        Err(e) => {
            println!("Error: {:?}", e);
            return;
        }
    };

    let mut file = File::open(file_path).unwrap();
    let mut buffer = [0; 1024];

    loop {
        let bytes_read = file.read(&mut buffer).unwrap();

        if bytes_read == 0 {
            break;
        }

        stream.write_all(&buffer[0..bytes_read]).unwrap();
    }

    println!("Done.");
}

// WASI TCP client
#[cfg(feature = "wasi")]
pub fn execute(host_addr: &str, file_path: &str) {
    use wasmedge_wasi_socket::{Shutdown, TcpStream as WasiTcpStream};

    let mut stream = WasiTcpStream::connect(host_addr).unwrap();

    let mut file = File::open(file_path).unwrap();
    let mut buffer = [0; 1024];

    // Read and send the file data in chunks
    loop {
        let bytes_read = file.read(&mut buffer).unwrap();

        if bytes_read == 0 {
            break;
        }

        // Send the chunk over the TCP connection
        stream.write_all(&buffer[0..bytes_read]).unwrap();
        // stream.write(&buffer[0..bytes_read]).unwrap();
    }

    stream.shutdown(Shutdown::Both).unwrap();
    println!("Done.");
}

fn handle_client(mut stream: TcpStream) {
    // Create a buffer to store received data
    let mut buffer = [0; 1024];

    // Create a new file to write received data
    let mut file = File::create("data/networking/out.txt").unwrap();

    // Read data from the client and write it to the file
    loop {
        let bytes_read = stream.read(&mut buffer).unwrap();

        if bytes_read == 0 {
            // End of stream
            break;
        }

        // Write the received chunk to the file
        file.write_all(&buffer[0..bytes_read]).unwrap();
    }

    println!("File received successfully.");
}

// TCP server
pub fn start_server(host_addr: &str) {
    // Bind the server to the specified IP address and port
    let listener = TcpListener::bind(host_addr).unwrap();

    println!("Server listening on {}...", host_addr);

    // Accept incoming connections and spawn a new thread to handle each client
    for stream in listener.incoming() {
        match stream {
            Ok(stream) => {
                // Spawn a new thread to handle the client
                thread::spawn(move || handle_client(stream));
            }
            Err(err) => {
                eprintln!("Error accepting connection: {}", err);
            }
        }
    }
}
