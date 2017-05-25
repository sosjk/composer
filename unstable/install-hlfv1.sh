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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� e�&Y �][s���g~�u^��'�~���:�MQAAD�ԩwo����j��e2���=��/��tM�^�[���u�}����xLC�˧ )@����$��x�/(��(Y����1��R#?�9����vZ�}Y��v��\��(�G�O|?�������4^f2".�?E�t%�2��oϠ�2.�?�^ɿ�Y���4��%	���P�wo{�{�h�\�Z�9�%���}��S���p��I�F*���k��O'^���r�I�8
�"�;y?=�{4�b$�ԗZ���w�O�x��z���C�1�O#��9��`���M����4��됄�{.�P������4E2�k;E�(����}�ث�s�!���Sċ�'���/��G��?��_��Y������.��km�:�AJ��&���ĻlR_�L~o�Q�k�VCٴ��MfBj��|����F_!X�b3h�q<u��ؤ������D�)�F=D!���t��S�N'[	��n C�T��>am�}yq �HqՏl���_�k߾A�Ɗ���c������������������?
#���R�Q�+�:��N���=^��(�cO�?NW��<�����$�ټ����7�n7�́P֔��'���e�ϚKq�"Zhsa���gݞ�	`ƅ����Y��i1o���h(ō :yNik�����֍��2ġ�i�2n��L���xYCrf�ԙsu0�O�m�w���q'�ǅ������b<j����)1�C�Aɕ��`!��C.��{�p.�������7Me'����\�8�E�୍=w��e�!�Eٔk��������VA�7Ks!?�� �|<4��Z*7V8���ϴ	B�D���MA� ����J��7�v}1ߍ$2%�F�4���5Vl�Z�:����6��Y�J.�\���+-5���Q��Δn�Z�lt�<����\��\�"Of�w�f��y4�P?�����seI
&oE�#]��EY�.2&����N�yX12[�FѦI����(�7͕��e(D�$�8�e�G �C'r����"�.a�E��,��~����a�];�Cn9I[RMM/F]}�d	�,�9�x�,z�4����������5����Ϧ���=��b�������O}�W�}��J`�����_���Dw��5��0o�w�~�K�[�{�<�CKn�c�0C��q"T�G�z	�B?bԷ*�!)Gv�A,�
�
�]�+�앙{N�� ��,,LCѕ�.�,�`w�8b�N��(��K�T�s԰�D�/['RS�w�йY��f�Ǧ�{E��bn5o;���;P �{-C���O�e�Y�l�S�r!<QuhM���ãr����)gF���E ���@��O�q���1�����8�t�܇�.��w|K3ymJ
�(�Hs?4���\rآQ��R�l�9��L�k|'p$�,���&��/�D�p����t��<�1>�@��亖L��)�fV}ȡ�a��?����k���������?J����g������E����*����*��s��_��o�	�����������?1�����RP��T�?����O�N����G'�)�-~��); 	h�e0�u(��%�q�#�*���B�%��Q�E U�W.����=q�w4)h��Hc=A]f��\������F��/���ec�m+��qCN���o�|�-[ʰ�l��a��%ǜ�L7�t;��=�csc����
p;�nX@�$�m��=�������3����R�Q�������e���������j��]��3�*�/$�G�?$����J������ߛ9	�G(L���.@^����`���W�%��7kpl�L̇0�н�4��ށ
��*@�tb�I�7���txs�;��H��H�\u:w��f�z3�7l�k���AS�(^��BA�:ܠ�ɪc��,�=Ѻ�i[<2.g�cFґ����9��A�6h�p*4�	Cr��}El	`�8�v�vS4���MV&�����-�3�q�|�0�ٓA�28	LE5�xǰW�|h֣�ZLB6ޮ;-�mvZgiϔ��uG=��f�TS�%������d�R$/k7t !s���IV=h��x��_�����CU�_>D����S�)���*����?�x��w�wov9��aT�_.��+4�".��@��KA���W��������R�}� ��P����K��cl����u(�p�v};@�Y�sG�%Pa�a� !}�Y���*���C�<��	������*vE~�Z������֘.�m��H�n�����'/H���?�@�N�ǝ:���А�Q����2�F�	�6v�3�J������nO@�C���V>����3�pN)9��ͪ��w��ǩ�����?J��9x����|�.�����������}}�Q�\�8AU�_
�+�'o_�l.�?�cd%�2��i9���/^����R�;��`8�|�']����O��F�"�g1"`1Ǳm�el��P��%X�=,�h��]�� g	&�f�G����P��/������O�������.���}�Z"&
/&�nPo��4L�˹z�t�H�����?�M��]��簺��\��@w��G��p��|�y�H>h��[>#~*�m��C��Z�D\TG��A�ك��W�?��G��K�A���d������CI��G!x����O��ŗfU(e����0�O�	��������>�y����;b%�A�*�5��`����l������п��c�ㆹ��T��bx�T�޺��p#s�m��}�֣}�����߻4��i�M;�L(�|�#�S:E_̋G�Km;��~�HLW���	�<�-b�Zt3����������P�YOԉ5�����j�s�ފ���{�A3Q�t�r֓��ex�L>2�kĠ��Ām���N��-���|�������	+�����Bm���_�SI�;�!qk!̻��!@]�Hr��pY�n���a���&8L9��Ӽ��+.��Sh+��mg#���s�O	+g�O�� r��A 5Ý�i'�I�D��?�}z��Vu}�Ț�Ґ^>�G��������Ǳ��/���O���7�s���U�[�����?[�I/+���m�G�~�Ǹ0l�^�-��If�����l�G���?�e~��Q~(�b�n!�[ׁ�����<�Z�� 컦�O����~Ѓ!c;9�ݔ����E%qG4�f#�e�\k�-[�)Ѷw�o�T�]K�t*�1I�4�.�S��]K$�_����4^�z�!����8��Х��cw �5�͑��hmւg�.��}{��Y#Yͥ.���d.���j�l��;�j��7|��N�aFHt��*�>=l<����O����� .������J�o�����?��?%�3��������g���������������j�������.0��X����K���ܻ���1
!���RP��������[��P�������J���Ox�M�V�5�8�.C�F��O�L�8��C�O��#��b��`x��o�2�������_H���)��J˔l99�[�Ԍa��"4����V�X�<�-j���c�鸭��+�{ɚ�zb��vp�*�(�9����Q���w-���3�(C�Sez��RGYl�C�j��{����O���8�������s�Gm���"������f���Z���2?�N]?�
�j����4�C�km�O�t�{a�����S�ʵ���"��k�����>}�_n�i�����|�Z��&N���4�����.�ë^�᧧&q�ξ_�_4B_��u:W��^z_k٤v���zz��Q���Uq��8[L~��;?���D��Bs�u>`�ڕS;-��z���ծ�Sl��&���5|ɮn_�����\�ӥ��,���}sw1��p�+܎����J_V��.[]]uQ�i�����MG��
A��o�������c_�+���
ߎ�}��$w~0������<��0��}�kgQ�ٗ��AG��d�[����ͫ�Yނ(K��/`t�7E�p�xV{����ǚ�LZ�����q��QC~z�A��/v�o?����<����/e�k￟k�����@.��=���SS�8�O��7M���8Y�a���	��.Nד�s]����#��[��'�X��"GC������sվ���}�������,n{����S�+��X�"��wu�oY廂x#�D~`����݁�=z ������N7��ӦR���ʪ�m����0<��5��S8�,�'u�=T��'{b1n���x������ƺN�q�\.����P�\p3\�=^��{�P��[���ۺ�Mɵ���m����&�_���M�F����'%�A�~Q>(��1���v[�v���s8\��䞮�?/}������=ϣ�Lg̃�M�Wn�͠��LCĮ�~�H&�X$�g����h� k$���R���H<��ֶ�P=I]���}N'��u�fZL�2:]Z�����ټ�yxfs��s@	��0.�Î��;��$�=�n��Dsp�n�\�wBs�-3���U�n z-��6`��j���G���n+����6j��U� ����3���s�J�~��d&;�!���d��u��ĸ�R������n猛p��>��kƙ����҈y$DfUJ��g�e�hY�}�F����[(-�KCƬ��+|��]�=t��,/j���r4E>�h�C޷h�Ц�9
�.�dé�G�S��b�p�~Gp:91�Ӏٝ�#Z����� vr��"�A�;�ʢ޾sa�����1�I�Vc�2Ǻj��/dtI:�4`q���9�:�!���p�w��9��S�l�k��f$tQ������7��]������
C0��e�����C�|��.8.���_�a*�Jc�1CJ��&o=�^��]�E.��-j�"Ƀ[kgk��.לP�Օ��М���H���=����L��*�T����
��w�y>��܃sэ\�f����ǜ�n��!3�%8��t�v1A3�6'f�aoZ�w:��Υ�S����0W����ꪽ$���u�v!Gk��]{�#Xvu����W��j:��>��Ѽqѹ�B�{��'�daý���U���ܨ�������������'�J<
k'6N�=���~~��ZK%.<��T�~��UO&�Xdۋ��~?�ƶ�,�X�g�W���Q�U�G8�rzF9�I�{����~�3����[���x�7�/?��K���s�+x���n<AA?s�kƁp�N��;؍�C/޹�s�*��sз�AO�����������}z��}O��)���7�׳�y`D��{Q�K�Y�G�c=:��%�I��9a�\/L�A��-��mf�7
�t��D�T��F�Hn��m�K��bg�Y��D?C�ݜ�����C�+��f�v�r/��|i����;]P�d�8̣X���'�9��-F�%��G��~��݂�0I��F���a�]��=L��~����юp�S��,>^$����YB�tv�W2��TQp�	�T����|��R^�+`XNU[BLHz.%5XHh[%U�)�͇���K�)Nz��R��C�\ڏ�=}�f��LX�	�
z�@��K티�M=u��6��D�����!\�kO͕�u��`�ck�tM�F�xP�*�'����&�e���G�~ee�h.O�B��j�Z�;J��0�m����D�!��$3�0i$]N�L�D�ɰX��'�9d�#<#;V0��x'�	���*�!VI�����.֊�x���|�&��4/^�@�0J��t}�3�r�t3��ۉx��R4���z��ǘȾ�h���>&eY�댲l�3����r)���TJÁߝhpp��$_�h��p�h8��mi�+�|+�Zb�
��b+-_�ʕ�A4���)�Ht^+JT�RU@�4�c�x�%��e����Re��<�+�ѴoHZ��ѭ+r���N$*g=�x�q�T���Z�yw�
�n!A�JFj~$�d��^��t�b	��U�[e�-R��e��,��%��z<C!�V�ˣ$���@HP� ACwR��fn��ya����^jX@�J�(o��ډa�\e�nu����@@N��,a1Y�b��E�@YIo�I�ҙ2� sʲGxFv��0�M�;�a|o�Uk}Z(�L�Y�W��K9o6�s�>t��7���#�}��rmB��<��g(F�I�-G�A��I;f?eq�>����>�j>��)��iN\SPkm^ՠ�@�֮�6�5�����g��_��L0>�.@]���<�Й�<�WNW���ʡ�ڸ\dۜh���N��\�����%r78C���9(%K5n ��n�9�Wڸ$�Nn�	n"F1�4��՚�UC�֦������-��e
�C��IM�dK�	�5[��y�f��X��琳?�n�iu�Y���U��^?a�\ 7
`��j���-������*��6Kf|bZf���=w��E�Q�Ϝ�^����釞�6]�ŉ�j|<� 't p�I_�?9Fֿ�:�G���ס�֡���g��/+�<~��=Zx0i-<H�HB�g*]�$�V������-<(��:"m����`8;4�E�A�΃�"Xu��Ҟ'�8ꂃ�V�Әn֔A�{b��0c	>nzh��;CjSj�W����R��2�p���%�!ъ#��P� 9��
�"Bpd�)�Ѽ��&�tR�J�zq�и�T���*u<F�	�=�#A!m��11���!�GM���c���ajt����D�;X�Uo%���r$ӈu����|~g�P�T�~e�m)�(�l؃�`����o�ol�m�v|��ń`KT�H
Q��k�f��I��[g���K5��K�xx_�p��a�m���]/�n�6ݩ�eʹ<m�Cc�d:��gZ1byv�@w肷Ne�:me��y'��@˽����ct�����a�/��eG�>8��U��Tp�m�$Rn�*�d�u���92P�x�#���*��r���A|&(2����E&����t��,�?=�.�f�!��T��Rv�b�J�`$�����8��
 LxG�p0%�e�	 ^V�$�i����e�;}_N�RBńp�0�����B�Bw;�l��aB�Ɩ�|;����JQ�u%
�6��J]��3�W,�mwD�Q�~�+�*x�����0₳L��٨f�A��lɅ���;<���-	�s.�n�$���\���&qW�^"�}�v^�ò��6��7�8��㞍��䔹���X!��RHn�0��Ep���m6�jb�%d�j�kwT3Z��=�0%�>�h╊�k��v�~��k����BqI��[���S�(����; �R��=G5��?���	�
�ͽ,f׫���ͭ�w|�_��KO=������_��е�~ ��U���5��N�i�D�c��@�'�ݻ������%���g����Ko��� �x���M|󦿾��W�? z�$��8x*�~p�ڕޯ��䊞n��h:Q�m@g߈��O~�/6~'����_/��׿�'��)�����4E�|�	�9K�|զv��N��i�l��M����߿��i; mS;mj�M��}6�g{?P;ͷ��|�� U�B����z��&�&�A�-"�N21����L��1��=��_��^��&��<ۭ�y��T�S��3���6���gp��X���`9_�MM�Y�i�sf�h�=gƞ`O�����a�e�3s���G�s9f�\8�0�!Bk��6�]��1�9��_ju��b��Nv������M��y�  