
# Scripts
<br>
<br>

### Make a pipe
```
mkfifo -m a=rw request.pipe
```

### Write sequence of number to pipe
```
for i in `seq 30`; 
do
	echo $i;
  sleep 1;
done > some.pipe &
```