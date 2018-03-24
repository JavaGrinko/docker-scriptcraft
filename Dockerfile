from debian:sid
env DEBIAN_FRONTEND noninteractive
ARG MINE_JS_VERSION
run sed -e 's/deb.debian.org/debian.mirrors.ovh.net/g' -i /etc/apt/sources.list
run apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get clean
run apt-get update && \
    apt-get install -y openjdk-8-jre rsync ssh git unzip && \
    apt-get clean
# Spigot (Minecraft server)
add https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar /opt/minecraft/BuildTools.jar
workdir /opt/minecraft/
run java -jar BuildTools.jar --rev 1.12.2 .

# Plugins
add https://addons-origin.cursecdn.com/files/942/892/JPanel.jar /opt/minecraft/plugins/JPanel.jar
add https://build.true-games.org/job/ProtocolSupport/176/artifact/target/ProtocolSupport.jar /opt/minecraft/plugins/ProtocolSupport.jar
add https://addons-origin.cursecdn.com/files/2466/685/PlugMan.jar /opt/minecraft/plugins/PlugMan.jar
add https://dl.bintray.com/javagrinko/maven/ru/minejs/minejs-bukkit-plugin/$MINE_JS_VERSION/:minejs-bukkit-plugin-$MINE_JS_VERSION.jar /opt/minecraft/plugins/PlugMan.jar
#add https://addons-origin.cursecdn.com/files/909/154/PermissionsEx-1.23.4.jar /opt/minecraft/plugins/PermissionsEx.jar
#add https://addons-origin.cursecdn.com/files/2416/984/ChatEx.jar /opt/minecraft/plugins/ChatEx.jar
#add https://addons-origin.cursecdn.com/files/894/359/Vault.jar /opt/minecraft/plugins/Vault.jar
#add https://raw.githubusercontent.com/JavaGrinko/oauth2-bukkit/master/build/libs/oauth2-bukkit-1.0.0.jar /opt/minecraft/plugins/OAuth2.jar
#add https://addons-origin.cursecdn.com/files/780/922/Essentials.zip /opt/Essentials.zip
#run unzip -q /opt/Essentials.zip -d /opt && \
#    rm /opt/Essentials.zip && \
#    mv /opt/Essentials* /opt/minecraft/plugins/

# Configs
add server.properties /opt/minecraft/server.properties
add JPanel/config.yml /opt/minecraft/plugins/JPanel/config.yml
add PermissionsEx/permissions.yml /opt/minecraft/plugins/PermissionsEx/permissions.yml
add OAuth2 /opt/minecraft/plugins/OAuth2
add server-icon.png /opt/minecraft/server-icon.png

#add config.yml /opt/minecraft/plugins/scriptcraft/config.yml

run echo "eula=true" > /opt/minecraft/eula.txt
run mkdir -p /opt/minecraft/scriptcraft/players/

expose 25565 19132

ENTRYPOINT echo "jsp classroom on" | /usr/bin/java -Xmx1024M -jar spigot-1.12.2.jar
CMD java -jar /opt/minecraft/dragonproxy.jar