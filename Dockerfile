# The FROM will be replaced when building in OpenShift
FROM openshift/base-centos7

# Install headless Java
USER root
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm"
RUN yum install -y --setopt=tsflags=nodocs --enablerepo=centosplus epel-release && \
    yum install -y nss_wrapper && \
    yum localinstall -y jdk-8u60-linux-x64.rpm && \
    yum clean all && \
    mkdir -p /opt/app-root/jenkins && \
    chown -R 1001:0 /opt/app-root/jenkins && \
    chmod -R g+w /opt/app-root/jenkins


ENV MAVEN_VERSION 3.3.9

# Install Maven
RUN curl -sL -o /tmp/maven.tar.gz \
      https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/${MAVEN_VERSION}/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir -p /opt/app-root/jenkins/tools && \
    cd /opt/app-root/jenkins/tools && \
    tar xfz /tmp/maven.tar.gz && \
    mv /opt/app-root/jenkins/tools/apache-maven-${MAVEN_VERSION} /opt/app-root/jenkins/tools/maven && \
    chown -R 1001:0 /opt/app-root/jenkins/tools

# Copy the entrypoint
COPY contrib/openshift/* /opt/app-root/jenkins/
USER 1001

# Run the JNLP client by default
# To use swarm client, specify "/opt/app-root/jenkins/run-swarm-client" as Command
ENTRYPOINT ["/opt/app-root/jenkins/run-jnlp-client"]
