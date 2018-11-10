###########################################################
# Dockerfile that builds a sandstorm Gameserver
###########################################################

# Man this repo is really shit
FROM cm2network/steamcmd
LABEL authors="walentinlamonos@gmail.com, Steve Fan <stevefan1999-personal@github.com>"
ENV MaxPlayers=8 \
  hostname="Insurgency Sandstorm Server Example" \
  RconPassword="hello world" \
  port=20000 \
  queryport=30000 \
  RconListenPort=40000

# These two arguments should be exposed, but I don't, cause container permission in Docker is too fucked up
# (Well actually they still do...anyway as they are constants don't modify them)
ENV HOME /home/steam
ENV SERVERDIR $HOME/insserver/Insurgency

# 1. Move to container home
# 2. Copy the update batch from our repository root
# 3. Run an immutable SteamCMD fetch (BUG: Space consuming!)
WORKDIR $HOME
COPY ./update-sandstorm.txt .
RUN [ \
  "./steamcmd/steamcmd.sh", \
  "+runscript /home/steam/update-sandstorm.txt" ]

# 4. Finally start the server, these default configs are subjectable to the volume change below
WORKDIR $SERVERDIR/Binaries/Linux/
CMD $HOME/steamcmd/steamcmd.sh +runscript /home/steam/update-sandstorm.txt && \
  ./InsurgencyServer-Linux-Shipping -Log \
    port=$port?queryport=$queryport?MaxPlayers=$MaxPlayers \
    -hostname=$hostname \
    -Rcon -RconPassword=$RconPassword -RconListenPort=$RconListenPort

# These are the port used according to the CMD above, use -p/--port <host-dest>:<container-src> to map as arguments
# EXPOSE 27102 27131 27015 27102/udp 27131/udp 27015/udp

# Here's the problem: We should be using a container level unionfs instead of feeding the available volume mount point ourselves
# Too ghetto I'd say...
VOLUME [ \
  "$SERVERDIR/Config/", \
  "$SERVERDIR/Saved/" ] 
# Of course you could go masochist mode that you create a unionfs on your host that distributes to your config directory, but hell knows how to do it
