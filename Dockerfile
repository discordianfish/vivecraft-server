FROM java:8

MAINTAINER Johannes 'fish' Ziemke

ENV SPIGOT_URL       https://ci.mcadmin.net/userContent/archive/spigot/spigot-1.7.10-R0.1-SNAPSHOTBuild1646.jar
ENV PROTOCOL_LIB_URL http://ci.dmulloy2.net/job/ProtocolLib/232/artifact/target/ProtocolLib.jar
ENV MINE_VIVE_URL    https://github.com/possi/MineVive/releases/download/v0.3/MineVive.jar
ENV FRACTIONS_URL    https://dev.bukkit.org/media/files/919/916/Factions.jar
ENV MCORE_URL        https://dev.bukkit.org/media/files/919/920/MassiveCore.jar
ENV DYNMAP_URL       https://dev.bukkit.org/media/files/888/859/dynmap-2.2.jar
ENV DM_FACTIONS_URL  https://dev.bukkit.org/media/files/836/866/Dynmap-Factions-0.90.jar

# 25565 = Minecraft, 1234 = Prometheus Metrics, 8123 = Dynmap
EXPOSE  25565 1234 8123
WORKDIR /var/lib/minecraft

RUN useradd -d /var/lib/minecraft minecraft \
 && mkdir -p /opt/minecraft/plugins \
 && curl -sSfLo /opt/minecraft/spigot.jar $SPIGOT_URL

COPY run /opt/minecraft/
COPY . .
RUN chown -R minecraft:minecraft /var/lib/minecraft

USER minecraft
RUN curl -fLo plugins/ProtocolLib.jar           $PROTOCOL_LIB_URL \
 && curl -fLo plugins/MineVive.jar              $MINE_VIVE_URL \
 && curl -fLo plugins/MassiveCore.jar           $MCORE_URL \
 && curl -fLo plugins/Fractions.jar             $FRACTIONS_URL \
 && curl -fLo plugins/DynMap.jar                $DYNMAP_URL \
 && curl -fLo plugins/DynMapFactions.jar         $DM_FACTIONS_URL \
 && java -jar /opt/minecraft/spigot.jar \
 && sed 's/.*eula=.*/eula=true/' -i eula.txt

VOLUME /var/lib/minecraft
USER   minecraft

ENTRYPOINT [ "/opt/minecraft/run" ]
