FROM java:8

MAINTAINER Johannes 'fish' Ziemke

ENV SPIGOT_URL       https://ci.mcadmin.net/userContent/archive/spigot/spigot-1.7.10-R0.1-SNAPSHOTBuild1646.jar
ENV PROTOCOL_LIB_URL http://ci.dmulloy2.net/job/ProtocolLib/lastBuild/artifact/modules/ProtocolLib/target/ProtocolLib.jar
ENV MINE_VIVE_URL    https://github.com/possi/MineVive/releases/download/v0.3/MineVive.jar
ENV FRACTIONS_URL    https://dev.bukkit.org/media/files/919/916/Factions.jar
ENV MCORE_URL        https://dev.bukkit.org/media/files/919/920/MassiveCore.jar
ENV PROMETHEUS_URL   https://madoka.brage.info/release/prometheus-integration-1.0.1.jar
ENV RWG_URL          https://cdn.minecraftmodarchive.org/Realistic%20World%20Gen/1.7.10/RWG-alpha-1.3.2.jar
ENV DYNMAP_URL       http://dev.bukkit.org/media/files/888/859/dynmap-2.2.jar

# 25565 = Minecraft, 1234 = Prometheus Metrics, 8123 = Dynmap
EXPOSE  25565 1234 8123
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
    && curl -sSfLo /opt/minecraft/plugins/RWG.jar                   $RWG_URL \
    && curl -sSfLo /opt/minecraft/plugins/DynMap.jar                $DYNMAP_URL \
    && curl -sSfLo /opt/minecraft/plugins/PrometheusIntegration.jar $PROMETHEUS_URL

# FIXME: Verify checksums

USER minecraft
RUN chown minecraft:minecraft spigot.yml && java -jar /opt/minecraft/spigot.jar \
    && sed 's/.*eula=.*/eula=true/' -i eula.txt \
    && ln -s /opt/minecraft/plugins/ . # Spigot is expecting plugs in jar root, not wd

VOLUME /var/lib/minecraft
USER   minecraft

ENTRYPOINT [ "java", "-Xms1G", "-Xmx2G", "-d64", "-jar", "/opt/minecraft/spigot.jar" ]
