# Employee Demo Container

Container to run the Sync Gateway and Couchbase Server components for the Couchbase Mobile [Employee Android Demo](https://github.com/mminichino/sgw-android-example).

Run the container:

````
./rundemo.sh --run
````

Watch the container console output:

````
./rundemo.sh --tail
````

Stop the container:
````
./rundemo.sh --stop
````

Docker command to run the container:
````
docker run -d --name empdemo \
                -p 8091:8091 \
                -p 8092:8092 \
                -p 8093:8093 \
                -p 8094:8094 \
                -p 8095:8095 \
                -p 8096:8096 \
                -p 8097:8097 \
                -p 11210:11210 \
                -p 9102:9102 \
                -p 4984:4984 \
                -p 4985:4985 \
                mminichino/empdemo
````
