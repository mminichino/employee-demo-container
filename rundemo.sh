#!/bin/bash
#
YES=0
container=empdemo
image=mminichino/${container}

function print_usage {
if [ -n "$PRINT_USAGE" ]; then
   echo "$PRINT_USAGE"
fi
}

function err_exit {
   if [ -n "$1" ]; then
      echo "[!] Error: $1"
   else
      print_usage
   fi
   exit 1
}

docker ps >/dev/null 2>&1
if [ $? -ne 0 ]; then
   echo "Can not run docker."
   exit 1
fi

while true; do
  case "$1" in
    --run )
            shift
            echo "Starting container ${container} from image ${image}"
            [ -n "$(docker ps -q -a -f name=${container})" ] && docker rm ${container}
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
                                ${image}
            exit
            ;;
    --show )
            shift
            docker ps --filter name=${container}
            exit
            ;;
    --shell )
            shift
            docker exec -it ${container} /bin/bash
            exit
            ;;
    --log )
            shift
            docker logs -n 50 ${container}
            exit
            ;;
    --tail )
            shift
            docker logs -f ${container}
            exit
            ;;
    --local )
            shift
            image=${container}
            ;;
    --stop )
            shift
            if [ "$YES" -eq 0 ]; then
              echo -n "Container will stop. Continue? [y/n]: "
              read ANSWER
              [ "$ANSWER" = "n" -o "$ANSWER" = "N" ] && exit
            fi
            docker stop ${container}
            exit
            ;;
    --start )
            shift
            docker start ${container}
            exit
            ;;
    --rm )
            shift
            if [ "$YES" -eq 0 ]; then
              echo -n "WARNING: removing the container can not be undone. Continue? [y/n]: "
              read ANSWER
              [ "$ANSWER" = "n" -o "$ANSWER" = "N" ] && exit
            fi
            for container_id in $(docker ps -q -a -f name=${container}); do
              docker stop ${container_id}
              docker rm ${container_id}
            done
            exit
            ;;
    --rmi )
            shift
            if [ "$YES" -eq 0 ]; then
              echo -n "Remove container images? [y/n]: "
              read ANSWER
              [ "$ANSWER" = "n" -o "$ANSWER" = "N" ] && exit
            fi
            for image in $(docker images ${image} | tail -n +2 | awk '{print $3}'); do docker rmi $image ; done
            exit
            ;;
    --yes )
            shift
            YES=1
            ;;
    * )
            print_usage
            exit 1
            ;;
  esac
done
