echo "calculating num of lines code for dir: "$1
num_line=`find $1 -name '*.mqh' | sed 's/.*/"&"/' | xargs  wc -l | tail -n 1`
echo $num_line
