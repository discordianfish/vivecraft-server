FROM java:8
MAINTAINER Johannes 'fish' Ziemke
ENV SPIGOT_URL https://ci.mcadmin.net/job/Spigot/lastSuccessfulBuild/artifact/spigot-1.9.4.jar
ENV PROTOCOL_LIB_URL http://ci.dmulloy2.net/job/ProtocolLib/lastBuild/artifact/modules/ProtocolLib/target/ProtocolLib.jar
ENV MINE_VIVE_URL https://github.com/possi/MineVive/releases/download/v0.3/MineVive.jar
EXPOSE  25565

WORKDIR /var/lib/minecraft
COPY spigot.yml .

RUN useradd -d /var/lib/minecraft minecraft \
    && chown -R minecraft:minecraft /var/lib/minecraft \
    && mkdir -p /opt/minecraft/plugins \
    && curl -sfLo /opt/minecraft/spigot.jar              $SPIGOT_URL \
    && curl -sfLo /opt/minecraft/plugins/ProtocolLib.jar $PROTOCOL_LIB_URL \
    && curl -sfLo /opt/minecraft/plugins/MineVive.jar    $MINE_VIVE_URL

USER minecraft
RUN chown minecraft:minecraft spigot.yml && java -jar /opt/minecraft/spigot.jar \
    && sed 's/.*eula=.*/eula=true/' -i eula.txt

VOLUME /var/lib/minecraft
USER   minecraft

ENTRYPOINT [ "java", "-jar", "/opt/minecraft/spigot.jar" ]
