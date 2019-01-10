
ip link show
ip addr show brctl showmacs docker0
docker run -d gremlin9/flask-test
ip link show
brctl showmacs docker0
docker ps
docker exec -it xxxxx ip addr show


## The pid namespace
- In Linux,each and every process running on the system must have a unique number identifying it called the process ID or the PID.Process ID's start from 1(often assigned to the init process) and increment as more and more processes are  spawned by the system.

- In the following example, we are creating two different containers based on the Busybox image:

```
sudo docker run -d --name server1 busybox nc -l -l 0.0.0.0:7070
sudo docker run -d --name server2 busybox nc -l -l 0.0.0.0:8080
```
- Now let's see what processes does each container possess by running the ps command on each of them.You can run additional commands against the container in addition to the main command that it runs by using Docker'e exec command:
docker exec commadn as follows:

```
➜  ~ sudo docker exec server1 ps -ef                                
PID   USER     TIME  COMMAND
    1 root      0:00 nc -l -l 0.0.0.0:7070
    8 root      0:00 ps -ef

➜  ~ sudo docker exec server2 ps -ef
PID   USER     TIME  COMMAND
    1 root      0:00 nc -l -l 0.0.0.0:8080
    8 root      0:00 ps -ef
```

- As you can see from the output, each container has it own PID namespace, which makes processes start from 1 onwards as if it is a completely separate OS.

- Such an isolation level is one of the strength points Docker, as it prevents the container from guessing the PID's of the host operating system.

- You can manaually override thie bahavior by adding ```--pid host``` to the ```docker create``` or ```docker run``` commands.
