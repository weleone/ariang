# weleone/ariang - 极简版：busybox httpd 伺候 AriaNg 静态文件
# 构建: docker buildx build --platform linux/amd64,linux/arm64 \
#         -t weleone/ariang:1.3.14 -t weleone/ariang:latest --push .

# ---- 下载解压 AriaNg ----
FROM alpine AS dl
ARG ARIANG_VERSION=1.3.14
RUN apk add --no-cache unzip && \
    wget -O /tmp/ariang.zip \
      https://github.com/mayswind/AriaNg/releases/download/${ARIANG_VERSION}/AriaNg-${ARIANG_VERSION}.zip && \
    mkdir -p /www && \
    unzip -o /tmp/ariang.zip -d /www && \
    rm /tmp/ariang.zip && \
    if [ ! -f /www/index.html ]; then \
      sub=$(ls /www) && mv /www/$sub/* /www/ && rmdir /www/$sub; \
    fi

# ---- 最终镜像 ----
FROM busybox:stable
COPY --from=dl /www /www
EXPOSE 6880
CMD ["httpd", "-f", "-p", "6880", "-h", "/www"]
