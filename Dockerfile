FROM java:8

MAINTAINER Johannes 'fish' Ziemke

ENV SPIGOT_URL       https://ci.mcadmin.net/job/Spigot/lastSuccessfulBuild/artifact/spigot-1.9.4.jar
ENV PROTOCOL_LIB_URL http://ci.dmulloy2.net/job/ProtocolLib/lastBuild/artifact/modules/ProtocolLib/target/ProtocolLib.jar
ENV MINE_VIVE_URL    https://github.com/possi/MineVive/releases/download/v0.3/MineVive.jar
ENV FRACTIONS_URL    https://dev.bukkit.org/media/files/919/916/Factions.jar
ENV MCORE_URL        https://dev.bukkit.org/media/files/919/920/MassiveCore.jar
ENV PROMETHEUS_URL   https://madoka.brage.info/release/prometheus-integration-1.0.1.jar

EXPOSE  25565 1234
WORKDIR /var/lib/minecraft

COPY spigot.yml .

RUN useradd -d /var/lib/minecraft minecraft \
    && chown -R minecraft:minecraft /var/lib/minecraft \
    && mkdir -p /opt/minecraft/plugins \
    && curl -sSfLo /opt/minecraft/spigot.jar                        $SPIGOT_URL \
    && curl -sSfLo /opt/minecraft/plugins/ProtocolLib.jar           $PROTOCOL_LIB_URL \
    && curl -sSfLo /opt/minecraft/plugins/MineVive.jar              $MINE_VIVE_URL \
    && curl -sSfLo /opt/minecraft/plugins/MassiveCore.jar           $MCORE_URL \
    && curl -sSfLo /opt/minecraft/plugins/Fractions.jar             $FRACTIONS_URL \
    && curl -sSfLo /opt/minecraft/plugins/PrometheusIntegration.jar $PROMETHEUS_URL

# FIXME: Verify checksums

USER minecraft
RUN chown minecraft:minecraft spigot.yml && java -jar /opt/minecraft/spigot.jar \
    && sed 's/.*eula=.*/eula=true/' -i eula.txt

VOLUME /var/lib/minecraft
USER   minecraft

ENTRYPOINT [ "java", "-jar", "/opt/minecraft/spigot.jar" ]
