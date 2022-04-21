将registry镜像运行并生成一个容器

docker run -d -v opt/registry:/var/lib/registry -p 5000:5000 --restart=always --name registry registry:latest

