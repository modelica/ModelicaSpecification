# Updating the docker image

The docker image is stored at the [docker hub](https://hub.docker.com/r/modelicaspec/latexml).
If you need write access to the organization, contact @sjoelund.

To update the image, update the Dockerfile .
Then build and tag the image and upload it.

```sh
docker build -t modelicaspec/latexml:`date +%Y%m%d` .
docker push modelicaspec/latexml:`date +%Y%m%d`
```

If the change is small you can base it on the old image instead of creating a new one from scratch.
Modify Dockerfile.incremental to be based on the image you want to update.
Make sure that the regular Dockerfile is also updated (so future builds incorporates these additions).

```sh
docker build -t modelicaspec/latexml:`date +%Y%m%d` - < Dockerfile.incremental
docker push modelicaspec/latexml:`date +%Y%m%d`
```

Once the docker image is updated, modify `../Jenkinsfile` to use this image.
Put all of this in the same commit and see if the CI build accepts it.
