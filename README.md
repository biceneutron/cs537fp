## Get Started
1. Install Rust tool chain
```
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
2. Add wasm32-wasi as a target

```
$ rustc add wasm32-wasi
```

3. [Install wasmtime](https://docs.wasmtime.dev/cli-install.html)
```
$ curl https://wasmtime.dev/install.sh -sSf | bash
```

4. [Install wasmedge](https://wasmedge.org/docs/start/install)
```
$ curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash
$ source $HOME/.wasmedge/env
```

5. Install `perf`
```
$ apt-get install linux-tools-common linux-tools-generic
```

## Profiling
### Execution Time
Run
```
perf record ./path/to/the/binary
```
to get the event count of the execution. Then run
```
perf record
```
to view the `perf.data` in the terminal UI.

Run
```
perf stat
```
to get the elapsed time.


If `perf record` went wrong, do

```
$ sudo su
$ sysctl -w kernel.perf_event_paranoid=-1
$ echo 0 > /proc/sys/kernel/kptr_restrict
$ exit
```

### [Compilation Time](https://doc.rust-lang.org/nightly/cargo/reference/timings.html)
Use the `--timings` flag when compiling the Rust code:
```
cargo build --release --timings
```
It will generate an HTML file in `target/cargo-timings/`. Open it in browser.

To copy the HTML result from a VM to the local machine, do
```
scp <VM host name>@<VM address>:~/cs537fp/target/cargo-timings/cargo-timing.html .
```
