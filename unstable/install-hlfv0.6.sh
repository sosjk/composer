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
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �zY �[o�0�yx����eb���AI`�
��ɹ�l�w��2HHXW��4�?�\���9>��ؾ�E�n�n����s�ʻ)�v���Nf�I�`E�D؂�f�%V���N���HF&�3��y�k�������WՋ�[(�/ p���>�X� �k$��.@�A���\l�3ʧ���ݬ�F�!����сO��e" �ց���.�Ԇ��s�Eer�h���/��e���i�f���Q*�m뚞-g���$��� D�-d��Z�&2���]1�U�&1�����UMY�E[�M����P����Z�ń&b0SGS�{�I!1�@bO�����-?h����p9Vʸ;Pn�ÒϏ]�����h��
�X��L�Y�荷�����Е�\��~(�h�xL��0Zw����bt'����k��`e�z{�LC�-Ӆ��-P���X�Ϸ`�L�����.��VV<�LE��49�߿��1wk�Ǟ]������R+[`6O'�-i�:��:�b_�ގ�2��w ���@��=Y=nf��
�rNA5�e�<��.�����Ta��"8`�`»cb�m:$t��ET����ܢ��t��'�F��.:�Yh2ndӬ`�	��쳸���?d�ژM�&�Ew�I�'`��9v �(�q�ūR�T����w_L8M�aA���ߢ�('yμ=_��I̛
n�.N�5&��n���:��_�8>���U���p8���p8���p8���p�&?��� (  