https://github.com/rebuy-de/aws-nuke


aws-nuke -c nuke-config.yml --profile samsoftware-estepa


$ docker run \
    --rm -it \
    -v /full-path/to/nuke-config.yml:/home/aws-nuke/config.yml \
    -v /home/user/.aws:/home/aws-nuke/.aws \
    quay.io/rebuy/aws-nuke:v2.11.0 \
    --profile default \
    --config /home/aws-nuke/config.yml