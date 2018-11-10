###########################################################
# Dockerfile that builds a CSGO Gameserver
###########################################################
FROM cm2network/steamcmd
LABEL maintainer="walentinlamonos@gmail.com"

# Add missing library
# Run Steamcmd and install CSGO
RUN ./home/steam/steamcmd/steamcmd.sh +login anonymous \
        +force_install_dir /home/steam/insserver/ \
        +app_update 581330 validate \
        +quit

RUN { \
		echo '@ShutdownOnFailedCommand 1'; \
		echo '@NoPromptForPassword 1'; \
		echo 'login anonymous'; \
		echo 'force_install_dir /home/steam/insserver/'; \
		echo 'app_update 581330'; \
		echo 'quit'; \
} > /home/steam/insserver/update.txt

ENV MaxPlayers=8 hostname="Insurgency Sandstorm Server" RconPassword="hello world"

VOLUME /home/steam/insserver

# Set Entrypoint; Technically 2 steps: 1. Update server, 2. Start server
ENTRYPOINT ./home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/insserver +app_update 581330 +quit && \
        ./home/steam/insserver/Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping \
		port=27102?queryport=27131?MaxPlayers=$MaxPlayers \
		-hostname=$hostname \
		-Rcon -RconPassword=$RconPassword -RconListenPort=27015

# Expose ports
EXPOSE 27102 27131 27015
