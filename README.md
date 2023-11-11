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