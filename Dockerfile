from debian:sid
env DEBIAN_FRONTEND noninteractive
run sed -e 's/deb.debian.org/debian.mirrors.ovh.net/g' -i /etc/apt/sources.list
run apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get clean
run apt-get update && \
    apt-get install -y openjdk-8-jre rsync ssh git && \
    apt-get clean
# Spigot (Minecraft server)
add https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar /opt/minecraft/BuildTools.jar
workdir /opt/minecraft/
run java -jar BuildTools.jar --rev 1.12.2 .

# Plugins
add http://scriptcraftjs.org/download/latest/scriptcraft-3.2.1/scriptcraft.jar /opt/minecraft/plugins/scriptcraft.jar
add https://addons-origin.cursecdn.com/files/942/892/JPanel.jar /opt/minecraft/plugins/JPanel.jar
add https://build.true-games.org/job/ProtocolSupport/176/artifact/target/ProtocolSupport.jar /opt/minecraft/plugins/ProtocolSupport.jar

# Configs
add server.properties /opt/minecraft/server.properties
add JPanel/config.yml /opt/minecraft/plugins/JPanel/config.yml
add server-icon.png /opt/minecraft/server-icon.png
#add config.yml /opt/minecraft/plugins/scriptcraft/config.yml

run echo "eula=true" > /opt/minecraft/eula.txt
run mkdir -p /opt/minecraft/scriptcraft/players/
run echo "root:minecraft" | chpasswd

expose 25565

ENTRYPOINT echo "jsp classroom on" | /usr/bin/java -Xmx8192M -jar spigot-1.12.2.jar