FROM qnib/alpn-jre7

ENV GOCD_VER=16.3.0 \
    GOCD_SUBVER=3183
RUN apk add --update git wget \
 && wget -qO /tmp/go-server.zip https://download.go.cd/binaries/${GOCD_VER}-${GOCD_SUBVER}/generic/go-server-${GOCD_VER}-${GOCD_SUBVER}.zip \
 && mkdir -p /opt/ && cd /opt/ \
 && unzip -q /tmp/go-server.zip && rm -f /tmp/go-server.zip \
 && mv /opt/go-server-${GOCD_VER} /opt/go-server \
 && rm -rf /var/cache/apk/* /tmp/*
RUN chmod +x /opt/go-server/*server.sh
ENV DOCKER_TASK_VER=0.1.23 \
    SCRIPT_EXEC_VER=0.2 \
    SLACK_NOTIFY_VER=1.2.1 \
    RIEMANN_NOTIFY_VER=0.8 \
    GITHUB_PR_STATUS_VER=1.1 \
    SLACK_TASK_VER=1.2 \
    GITHUB_PR_BUILD=1.2.4 \
    GEN_ARTIFACT_POLLER=0.1.0 \
    S3_POLLER=1.0.0 \
    S3_ARTIFACTS_POLLER=2.0.2
RUN mkdir -p /opt/go-server/plugins/external/ \
 && cd /opt/go-server/plugins/external/ \
 && wget -q https://github.com/manojlds/gocd-docker/releases/download/${DOCKER_TASK_VER}/docker-task-assembly-${DOCKER_TASK_VER}.jar \
 && wget -q https://github.com/gocd-contrib/script-executor-task/releases/download/${SCRIPT_EXEC_VER}/script-executor-${SCRIPT_EXEC_VER}.jar \
 && wget -q https://github.com/ashwanthkumar/gocd-slack-build-notifier/releases/download/v${SLACK_NOTIFY_VER}/gocd-slack-notifier-${SLACK_NOTIFY_VER}.jar \
 && wget -q https://github.com/rsr5/gocd-riemann-notifier/releases/download/${RIEMANN_NOTIFY_VER}/gocd-riemann-notifier-${RIEMANN_NOTIFY_VER}.jar \
 && wget -q https://github.com/gocd-contrib/gocd-build-status-notifier/releases/download/${GITHUB_PR_STATUS_VER}/github-pr-status-${GITHUB_PR_STATUS_VER}.jar \
 && wget -q https://github.com/gocd-contrib/deb-repo-poller/releases/download/1.2/deb-repo-poller-1.2.jar \
 && wget -q https://github.com/manojlds/gocd-docker/releases/download/0.1.23/docker-task-assembly-0.1.23.jar \
 && wget -q https://github.com/Haufe-Lexware/gocd-plugins/releases/download/v1.0.0-beta/gocd-docker-pipeline-plugin-1.0.0.jar \
 && wget -q https://github.com/Vincit/gocd-slack-task/releases/download/v${SLACK_TASK_VER}/gocd-slack-task-${SLACK_TASK_VER}.jar \
 && wget -q https://github.com/ashwanthkumar/gocd-build-github-pull-requests/releases/download/v${GITHUB_PR_BUILD}/github-pr-poller-${GITHUB_PR_BUILD}.jar \
 && wget -q https://github.com/ashwanthkumar/gocd-build-github-pull-requests/releases/download/v${GITHUB_PR_BUILD}/git-fb-poller-${GITHUB_PR_BUILD}.jar \
 && wget -q https://github.com/varchev/go-generic-artifactory-poller/releases/download/${GEN_ARTIFACT_POLLER}/go-generic-artifactory-poller.jar \
 && wget -q https://github.com/schibsted/gocd-s3-poller/releases/download/${S3_POLLER}/gocd-s3-poller-${S3_POLLER}.jar \
 && wget -q https://github.com/ind9/gocd-s3-artifacts/releases/download/v${S3_ARTIFACTS_POLLER}/s3material-assembly-${S3_ARTIFACTS_POLLER}.jar \
 && wget -q https://github.com/ind9/gocd-s3-artifacts/releases/download/v${S3_ARTIFACTS_POLLER}/s3fetch-assembly-${S3_ARTIFACTS_POLLER}.jar \
 && wget -q https://github.com/ind9/gocd-s3-artifacts/releases/download/v${S3_ARTIFACTS_POLLER}/s3publish-assembly-${S3_ARTIFACTS_POLLER}.jar \
ADD etc/supervisord.d/gocd-server.ini /etc/supervisord.d/
ADD opt/qnib/gocd/server/bin/start.sh \
    opt/qnib/gocd/server/bin/restore.sh \
    opt/qnib/gocd/server/bin/backup.sh \
    /opt/qnib/gocd/server/bin/
ADD opt/go-server/config/cruise-config.xml /opt/go-server/config/
