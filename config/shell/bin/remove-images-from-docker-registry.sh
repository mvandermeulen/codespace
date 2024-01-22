echo "Removing images from daemon..."
docker image ls | grep "$IMAGE_NAME" | awk '{print $1":"$2}' | xargs -I {} docker image rm {}
echo "Removed images from daemon."

echo "Pruning images from daemon..."
docker image prune --force
echo "Pruned images from daemon."

echo "Removing images from registry..."
if curl --silent "$DOCKER_REGISTRY_BASE_URL/v2/_catalog" | jq --raw-output '.repositories[]' | grep -q "$IMAGE_NAME"; then
  REGISTRY_BUILD_IMAGE_TAGS=$(curl --silent "$DOCKER_REGISTRY_BASE_URL/v2/$IMAGE_NAME/tags/list" \
    | sed 's/"tags":null/"tags":[]/' \
    | jq --raw-output '.tags[]')
  for tag in $REGISTRY_BUILD_IMAGE_TAGS; do
    DIGEST=$(curl --silent --show-error --head --header 'Accept: application/vnd.docker.distribution.manifest.v2+json' "$DOCKER_REGISTRY_BASE_URL/v2/$IMAGE_NAME/manifests/$tag" \
      | grep --ignore-case 'Docker-Content-Digest' \
      | tr -d '\r' \
      | sed --regexp-extended 's/Docker-Content-Digest: (.*)/\1/i')
    curl --request DELETE --silent --show-error "$DOCKER_REGISTRY_BASE_URL/v2/$IMAGE_NAME/manifests/$DIGEST" && echo "Removed $IMAGE_NAME:$tag from registry."
  done
fi
echo "Removed images from registry."

echo "Running garbage collection on registry..."
# Assumes default config path /etc/docker/registry/config.yml.
docker exec $DOCKER_REGISTRY_CONTAINER_NAME registry garbage-collect /etc/docker/registry/config.yml
echo "Ran garbage collection on registry."