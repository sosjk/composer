(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� e�&Y �]o�0���ᦀ� �21�BJ�AI`�U��K�G˦���)���u��M��H!�9���s����4������[{w ��밻pم�;CEXDA��z5(tح����I��" �bb�8:�{����"���@��~!�bE� �V�GR���=k�$�ن���Y#Ҿ�V�͜��g�:M�굄fHP��c6:H�L@4.a�#��FfC~�I�{ȏ��<��5][����K��yԏI�2m[��)-��!|-�!�h!�6
6�ل���.�6���߬t�j�9�e��F��냅��dC����)M�h�NfF?���n�S��Iⷝl;�"z+R��x2������H�^�+>?�i�*��S��� ������o�+������B�w�~��h���u�(����t�U�����.�t�[��L�b�!��n�ua�M4"�t?�e��!�t@���r�UO:Q��9MN��/A3t����T�����iT-0����V4�P��U�Vq��n&c	|�9 ���n���7s�cEu�������CK��-Q�As~�pPd�O0��!1�&R����b*��\v>���r�8 ���	<��s��ϸM�C��-7*O������]h
�nMB��ࣆ/O�z�8�s� *kQJ�MV�z�*m�l�X86p�b�i��
���9��|^�{.1o*��x8+�ׄ<��Ň���O������W9���p8���p8���p8�����_KӼ (  