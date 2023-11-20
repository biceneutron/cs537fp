task=$1
HOS_ADDR="127.0.0.1:8080"

if [ "$task" == "mm" ]; then
    dimension=$2
    ./wasmedge/wasmedge --dir . bin/mm.wasm \
	data/mm/$dimension-$dimension-$dimension/a.txt data/mm/$dimension-$dimension-$dimension/b.txt data/mm/$dimension-$dimension-$dimension/out.txt $dimension $dimension $dimension

elif [ $task == "coding" ]; then
    size=$2
    ./wasmedge/wasmedge --dir . bin/coding.wasm \
	data/coding/$size.txt data/coding/out_$size.json

elif [ $task == "io" ]; then
    size=$2
    ./wasmedge/wasmedge --dir . bin/io.wasm \
	data/coding/$size.txt data/io/out_$size.txt

# elif [ $task == "networking" ]; then
#     size=$2
#     ./wasmedge/wasmedge --dir . bin/networking.wasm \
# 	$HOS_ADDR data/coding/$size.txt

else
    echo "executing io..."
fi