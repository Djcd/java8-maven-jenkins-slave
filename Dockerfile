# The FROM will be replaced when building in OpenShift
FROM openshift/base-centos7

# Install headless Java
USER root
RUN yum install -y --setopt=tsflags=nodocs --enablerepo=centosplus epel-release && \
    rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 && \
    yum install -y --setopt=tsflags=nodocs install java-1.8.0-openjdk-headless nss_wrapper && \
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
