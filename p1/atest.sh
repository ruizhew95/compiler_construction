make
for file in samples/*.frag; do
    file=$(echo $file | cut -d'.' -f1)
    filename=$(echo $file | cut -d'/' -f2)
    ./dcc < $file.frag > results/$filename.out 2>&1
done

for file in samples/*.decaf; do
    file=$(echo $file | cut -d'.' -f1)
    filename=$(echo $file | cut -d'/' -f2)
    ./dcc < $file.decaf > results/$filename.out 2>&1
done

    x=0
    y=0
for file in results/*.out; do
    file=$(echo $file | cut -d'.' -f1)
    filename=$(echo $file | cut -d'/' -f2)
    result=$(diff $file.out samples/$filename.out)
    if [ $? -eq 0 ]
    then echo "$filename pass!"
    x=$((x+1))
    elif [ $? -eq 1 ]
    then echo "$filename fail"
    y=$((y+1))
    else echo "error"
    fi
done
    z=$((x+y))
echo "pass $x/$z"
