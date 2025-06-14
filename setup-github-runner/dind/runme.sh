docker stop gh-runner-instance
docker rm gh-runner-instance
docker run -d \
  --name gh-runner-instance \
  --env GH_TOKEN=ACHMXRB53XMSH65LHU2R5GTIJVZAU \
  --env GH_OWNER=lmcdasm \
  --env GH_REPO=dasmlab-home \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  github-runner-instance

