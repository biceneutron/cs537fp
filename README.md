# Get Started
1. Install Rust toolchain
```
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
2. Add wasm32-wasi as a target

```
$ rustup target add wasm32-wasi
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

# Test on Android Phones
## Rust
### Build the app for Android
Follow [this example](https://github.com/ssrlive/rust_on_android) by ssrlive. This example uses [rust-android-gradle](https://github.com/mozilla/rust-android-gradle) plugin, which cross-compiles Rust Cargo project for Android targets so we can run Rust code in Android apps.

Open the project with Android Studio and install the tools shown in the picture in the example repo. Then build the app per the instruction.

- Note 1: Before running `gradlew`, we may need to set the execution flag for it.
```
$ chmod +x gradlew
```

- Note 2: For the `NDK is not installed` error, install the NDK version specified in `app/build.gradle`
```gradle
android {
    ndkVersion '25.1.8937393'
}
```

- Note 3: For the `linker-wrapper.sh: line 4: python: command not found` error, set the environment variable:
```
$ export RUST_ANDROID_GRADLE_PYTHON_COMMAND=python3
```
See [this](https://github.com/mozilla/rust-android-gradle#:~:text=RUST_ANDROID_GRADLE_PYTHON_COMMAND).

### Run the tasks
Copy the task functions (e.g. mm, coding) from this repo to `app/src/main/myrustlib/src/lib.rs` in the example repo. Everytime `lib.rs` is changed, we need to re-build the app by
```
$ ./gradlew cargoBuild
```
Then plug the Android phone to the laptop and run the app via Android Studio. We should see some text printed out on the main page of this app.

## WebAssembly
### [Build WasmEdge for Android](https://wasmedge.org/docs/contribute/source/os/android/build/)
- Note 1: Android NDK and CMake should be installed via Android Studio. See [this](https://developer.android.com/studio/projects/install-ndk#specific-version) for how to do that. Then `ANDROID_NDK_HOME` should be set as
```
$ export ANDROID_NDK_HOME=/Users/[username]/Library/Android/sdk/ndk/23.1.7779620
```

acording to [this](https://stackoverflow.com/questions/56228822/ndk-does-not-contain-any-platforms).

- Note 2: If it shows `CANNOT LINK EXECUTABLE` error when running `wasmedge` in Android shell, re-build with `-DWASMEDGE_BUILD_STATIC_LIB=ON -DWASMEDGE_LINK_TOOLS_STATIC=ON` flags added in line 14 of `build_for_android.sh`. (See [this](https://github.com/WasmEdge/WasmEdge/issues/2639#issuecomment-1703035777))


### Push .wasm and other auxiliaries onto Android
After pushing the `wasmedge` Android build onto the phone, do
```
$ make build-wasi
$ adb push bin data run-wasi.sh /data/local/tmp
```

### Run the tasks

```sh
$ adb shell

# In the Android shell
$ cd /data/local/tmp/

# Run matrices multiplication with dimension 100 x 100 x 100
$ sh run-wasi.sh mm 100

# Run Huffman encoding to a 1000-word article
$ sh run-wasi.sh coding 1000

# Run IO task with a 1000-word article
$ sh run-wasi.sh io 100
```

# Profiling
## Execution Time
Run
```
$ perf record ./path/to/the/binary
```
to get the event count of the execution. Then run
```
$ perf record
```
to view the `perf.data` in the terminal UI.

Run
```
$ perf stat
```
to get the elapsed time.


If `perf record` went wrong, do

```
$ sudo su
$ sysctl -w kernel.perf_event_paranoid=-1
$ echo 0 > /proc/sys/kernel/kptr_restrict
$ exit
```

## [Compilation Time](https://doc.rust-lang.org/nightly/cargo/reference/timings.html)
Use the `--timings` flag when compiling the Rust code:
```
$ cargo build --release --timings
```
It will generate an HTML file in `target/cargo-timings/`. Open it in browser.

To copy the HTML result from a VM to the local machine, do
```
$ scp <VM host name>@<VM address>:~/cs537fp/target/cargo-timings/cargo-timing.html .
```
