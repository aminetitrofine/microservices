#!/bin/bash

rm -f joinMasters.sh joinWorkers.sh

echo "#!/bin/bash" >> joinMasters.sh
echo "#!/bin/bash" >> joinWorkers.sh

printf "%s" "sudo " >> joinMasters.sh
printf "%s" "sudo " >> joinWorkers.sh

string="kubeadm join";
command=1;
x=3;
y=2;
while read -r line;
do
    if [[ $line == *$string* ]]
    then
        if [[ $command == 1 ]]
        then
            while (($x > 0));
            do
                printf "%s" "$line" >> joinMasters.sh
                read -r line;
                x=$x-1

            done
            command=2
        else
            while (($y > 0));
            do
                printf "%s" "$line" >> joinWorkers.sh
                read -r line;
                y=$y-1 
            done
        fi
    fi
done < joinCommand.txt

printf "%s" " --cri-socket=unix:///var/run/containerd/containerd.sock" >> joinMasters.sh
printf "%s" " --cri-socket=unix:///var/run/containerd/containerd.sock" >> joinWorkers.sh

sed -i 's/\\/ /g' joinMasters.sh
sed -i 's/\\/ /g' joinWorkers.sh

