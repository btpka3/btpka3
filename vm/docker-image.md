## 说明

docker 在最初的时候，都是 `docker rmi`, `docker rm` 等命令操作 image、container 的。
这些命令都混合在一起，比较混乱。现在是把 image 相关的命令都放到 `docker image *` 下面了


## 参考

- [docker image](https://docs.docker.com/engine/reference/commandline/image/)


## 示例

```bash
docker image build	    # Build an image from a Dockerfile
docker image history	# Show the history of an image
docker image import	    # Import the contents from a tarball to create a filesystem image
docker image inspect	# Display detailed information on one or more images
docker image load	    # Load an image from a tar archive or STDIN
docker image ls	        # List images
docker image prune	    # Remove unused images
docker image pull	    # Pull an image or a repository from a registry
docker image push	    # Push an image or a repository to a registry
docker image rm	        # Remove one or more images
docker image save	    # Save one or more images to a tar archive (streamed to STDOUT by default)
docker image tag	    # Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
```
