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
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �zY �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/�����}�s:�n�O��/�i� h�<^Q�D^���Q�Dh�$�/�c��F~Nwc����V��N��4{��k��P����~�MC{9=��i��>dF\.�..��K�k�-Ae"\,!p��x���/ީ.�?J�x%�2p������+���p��	�Z�����?���:N�W&�����_��k�?�xv���'=�(`� ����Z�{��\@P�����I�y�;��q��Y��������O#��9��`���M����4��됄�{.�P������4E2�k;E�(����}�ܫ�s�!������?^��G�/>�|�!e������Ć��D^�ZO�M`���h�� ���@EYF�]6�/L�&����(ŵ`��l�ZЦ
3!���S>�A���U��,r�4A�8�:VblRzw��xn��E���uVz:��)K����ԍp7��A*�D������8�uY����G�D�ˁ/ԵoߠSgEUx�k�����ֿ�Eӥ��;���0���+%�������ď<���8�T�h��K��ϋ�!K2_��[�/�|��y�vC��eMYJ|2�{[f���-�e�6���|��i� f\�hY�%����98��R<��甶�I�=o݈L,C*�v��v�:���,���5$g�H�9QW s��D�݆�p��~|w�z\��P��-ƣVύܝ�#H0D\�\9^���H0�Lޫ����Ď��L�4��x :t�sh�su�4���6�P�I308׹�`uS��F���c�{q ~�-]̅�4.��O����xk��X��?�&��B�7�D��bD(m����|7�Ȕ�	Ӱ��X�1je�>�����f9+�d�r�v���,7Gq�;S��kQ�с�@��'�"�xy2��4��������5���'�K
P80y�(r�r�,��t�1)m�&Fv��Ê	��R=0�6H�\�h�D�i��&C!J !P�/k<y:9�����	t	#.b�fu0���n����ڹr�Iڒ�hj�x1��C&K f�ȱh�sfы��(�e��f�߽2��/��l������(^�)� �?*j����S��P���������'����G�y��S��]��H��9Zr;ˇr$��B?b�K����P�I9�S�bqU0U�좬�~�Wf�}�"�;� Z�XX���+9$�MY���q��h1Qt+����)�a�P_�&N�&.�n��s����2�]���4���j�Z�b�� 4��[�.u��z��3w�V�J�Bx��К0
�-�G�H�-MSΌ�5 �$./�@���y����n2�x-�cb��a�59p�k9�;�u]�����f�ڔ�Q"��0~:i=��E�F1�>��6s0!����8N�H�YD��M��_��~a(�v�7�6cyb|�M����u-�WS�ͬ��C��db<�?�/��~����I���?J����g�������������������s�_��o�	���	'*�/�$�ό���RP��T�?���I���D1�(�-�N�S$[�u���@X$�q��\֡0�\�P��Y������e����G�?�U�_� ��o���~�Ѥ���#��u�u<K�s�G ��e�?�����-ض�`FL�9i��e�l)�z�"��Ɨs�3ܠ��Ȃ�`�͍9�Z�+���u�`5J�`�Y��4��ދ_Z���S�������G�� t���@��W��U���߻��g��T�_
>H���?$����J������ߛ9	�G(L���.@^����`���W�%��wkp��L̇0�н4��>�
��*@�tb�I�7���txs�;��H��H�\u:w��f�z3�7l�k���AS�(^��b�.u�A��U;Ǝ�Y�{�u�9Ҷxd\�ǈ�#}/8���sr��8m�<V	�Ti��� =����4�+qz��	'��>Cm��LBDy�Z|g����haڳ'�&Te p�� j��a���ЬG����l�]wZ����Ҟ)-K�z��͎���#JH;#)ɜ�H^�n�@B�<�+���z�Z��|����?3����|��?#����RP����_���=�f����Nv9��V�)�D��������1%*�/�W�_������C�J=��(A���2p	�{�M:x�������Юoh�a8�zn�<ΰJ",�8, �Ϣ4K��]E��~(C����!4IV�_� �Oe®ȯV+U���؜����=�i�m����?��)���H�	�S����;����^����=��n�c�Vi�ہ�8"��	�y� ���`�ʇ7y��)%�v�Y��n<^�q��釧����Gi���/o����wf���U��.����eJ�r��$R��R�^�?(�}��r�\�4�ӕ���G�����G1�:�[
~��G�������2�)럥�p�Y�X�ql�t�b)��(�s	��l<!p�u<�Y�	ǷY���j��4�!���p������|\���Et�RKD�D�ń���6�F��w9W���i�~�~q�g5�	^�뺻�V��KQ=�#r�1v��2��-ptˇ`�Oe��4v��U뙈k���6H0{0��j��������q�w�]���w����^���1�[e�}>>i�?��4Z�B�(C���(A>��&����R�Z�W������?w�J���U�k,a	�0��Y�����?K�������a�Ui��U��n�/���Cw��ߜ�a=��%�~oh�A���v�8P8�4F`�t���_�.��tF��!1]���&�����k��4�Gx,�3��gr�CMf=Q'���7G����Q[x+.�K����Dӭ3�YO>�#ܖ�Q�2��8���u_;s.���k ��ݚ�rnk%ZV�y:E��ڔ�9��t��nw�cC��B�w{�C ����䶷�<����à�bM p"�r65�y{WW\����Vd���Fg9�,3�V�֟��A��߃ j�;%6�NГr�&{+~f��ni���p�5��!��x����/��_0@e�������������9�����[���j�?;�IUBe�������ߟ�����k���;��4r�����>��ǽ��O��|�o �y�9��s �{ܖ�^��}�5��r�5~�z�"1��C�MIiK[TwDck6�^�͵F߲���m{���L�ص4�aH���dNS�28�PеDr��8�I�|�ӄo�q6��K����>@ k��#'P#�ڬ��]z�M��J̳F��K]��O�\;|�՞ق%w��Z�o�~�;�F�&����-T�}z�x�ϳ���#��K� .������J�oa����?��?%�3�����A���?U��e���������j�����]Y`.��1�~��\.�˭�������,�W�_��������E=���~��\���G�4�a(�R�C�,�2��`���h��.��>J8d��T��>B�.�8�WY`~+�!�W��9��ce�}>.8���)�rrط̩�f�/0DhN=���l��y�-Z����?� ��q[iXW��E��5��ľ����UQRs̡��+8��)L�Z:Yg�Q�&���F}���ش������ݹ��?J�̿�G�����?Z����_�~��l�4+����_�_���v���W�Vsm�x�զ��_k�}�����N:u�\�뎡n(�
�F��+{�L��g��v����_��7�ծj�t����M����`��?��ձ~z�`����=�E#$���ϿNe�č����MjWn�����Ż�]%��݊`��k�>�I>������e����y�+�v:`���o��U��NC����0F��%Yݾ��[܎�rmO�~z���bV����͠����p;s�6��}eZ�6�hnuuA�E��!��:7�o�*]���!ק?/�>^�r_�fW�v��kM%��|��^�q�����W�v��}��]t�~O�u�(޼�Z���=����`{�F�S����j/�����-�D��i�Žyx<�}\!?�����7�[o?����<����oe߯�?_�ǖ����5����N]��t>]�7�4�Z��d�qb�'p��p8]O6�u��~��I�^�=,|�	�!�#%pVϗ��}��#���#��Ⱨa��z8U���m.R|Wo�&�U�+�7�H��hȊ��أ�*��o�t�?.6�b�����6���+Ó8[�[;���>[R��Å~���ۻ�׭2�^no���۩+�ہކ�ޢ;{�8·S��q�$�8��,�]���I��c�B* !�"+��Z��� 	~� ��c�Z>�B�n�J���I<�$��L����\�c�������ׯ�sN&
�����-^�Ŧ�9�`b�˕[r(!a�q(�R���e�||5<��@Wd��s�D�V:KFIhm��1�ɓ���/�e4�"�v��i=0-�@,���M=
D�yM:&��,� �1aZ�;]]Yt�UEQ\���ZM��p	24A���a�Ԏ�ɀ�a� ���]f\�a�Xxd��ݮf@݄�h<6UIp�>:��G��;��x��t.?�!h�R:˰�r�;-A�U�|O�B�[�9�&\�f��y��*���4b	�E��?p��m�}|ш_9|�r��xi�Xu�DM�Ԍ[�C�o����h��GS썍��0�u��� mN�����L�:pz68,�)� ��W��?X�i=���:��bg�oj
?�t�ש���G	�y���Q����.�礖����A7�f3i'����	�ӟ��\.7�ˎ(�=��U�E�p?� ede�sKW�5�o��C�<*QAohf�`���\���ՇC�r�.���ǖ/C�*�J�\̔�z��g�>&ׅ�P䦵@٪Fi�:*�n�a� ��,	5:}�%.-��^���:r�h_/����lI�7v�|�s���#�Zj4r�$�Bُۣ%)h��)3�%��t���]fLЊ�-�Y�xڛ�Ń�ht��ܽ�!,�bg�P��d�W�ת�N�.�l��ַ��s�.܁[����1�t�i��M������#�|>y�&�_�:���������������W?�_$�Ӡ�ua���O�������V�O�cuo����CL!>�c�~<Xq/���E<��}��z�G"P�|B|.��>q�����\}{�������=�z����O������ֳ��A�x����|�A��wO�����o�0.�����7��7���_C�p�ܵ��_�x�1,���g�����]i��H7�y����r9��B������� eN��I��di��"�`d��o�1D��=Po�[*�A�Qo"U�ʽ�n	�S���
�RL��ώ9����%�9���B�d�a�N�A3�����f����l3�KVLEr�6g��+Q�*�^� �Ch����l��,�gÓ��yr&�J��[�,Er��h��Z����SJ��k4��#%[��������w�����<N��2�*��2<_��!���3�����CFP�r���%�	�0a&�&LX��'"�~�DX�X���m�	����]��[jFHy �=57BֽzD@)�oĳ-�a���'����~�
�W�fRE�F��]��"�K�`�5�X�)8-�t��S
0�:��ܸ�e�l5�r4R�n,���B�������X�����.J��ah�LF0T��^�(f��(W�1:�	��<�0�d#J-�iY��kE߸/Գ�T��%J-)�Gz��@��b�n���+K���e��ʲ����#Z���d�@��GAo�%�Y�8��b}@�� 't��b�G��y�3�E�Q����m&\J2���u1�P�Fu��gN�,$��E��016Z��òl�+����YR�#��k�%���H�<ĳ�1M}1�vJ�*�zz����E�mV&1KYF�z��?�k�0���u&k�B���z�H��P�(Rzm�%�JY�+�ex��47P�8����{5��Ӵ7�)��#O��i�76څ��G�ZV;dil!=Jj�wP�Ƶj�O����JO5�=��D�tCI�b��CU��1.����-)��ٵ��EvQ�8@��=^oY��K(;��A9�hQ<%����-`p� '�� @��F[��R�JM�X���2_�a��ח.�Z�q��v|6�gs|��|��K��3�8���7��n �B�m݉� [�%����;W�7ϿJۙ|`z��@\P��sy��+�y�*+�SU����0�d3Į�������.���6l�G�J��AUi#��~p)��%err�a� 5�)dE��7���5Wս<#v���i"��\UQm7��jM�1�� ����3�|���3.�6�v�\E�l�	���l�ྰI,�J�f�y+r/��~s���f�LO��̞�r�o_�IM�}1������3�bE���";�����č\ �eEҷ�Ύ��O������˟���o#��}X��R�l�R�܉C�d����� ۡ)�����R�
;���o/���t���Hɬ��梃��dа��{8��`�+G�9��Z,Oc�Ysȃ��{��A��T��c
퍙]�5,�~���4"�+�>΅���j�T'��#X#�A��R*,��%��RċйM7ٴ!T��8\cI��ʑ�=�8֚dL�=!ca)k�ӧ13�%�!{���JD��bz���ן���D�����5
4�J�8�d�b���P�ԒAm��h���|ԇuP���7�F`\l펇#c��B�$�pG��hӋ�n�D }�F�j���R�(�	=�8܎q8���	~���Kzyt*�:�\^6���c2�c�3m��=�G�����s�E.�}ޙ��=���n����1���'�������r"io�Hڦ�Hn.8·*�Z��H]Hs�&��GĒ��|�����b�GkQ�I�`����D�Y�"�V�IPd�Ys�5�+�w��Nok)B�hI9B��Q8�ΐ������0.z��p4����!$��j}mE��둪�GG�a �f+cR4^������Cc!T��_DA��)��+m��hg_�{R�~�Em��_�Y:(W�7&���W252-��Ru�y.�1�|<�rpak{ji����rjO!т�<-�f����i��hVh�إ�7���p����8N��x#~9e�S;e96}m�� ̶s<h��"|�����H����=݊n����ķ�M�V�E��k��{����u�=-�T$ނ�Fd\��I�?p���z呥8��$�<."�;l7�&��]���O^�����c��?�◞��w|���>��� �����VW��|7'-���Ϲ�����������-	�w\_��}�)����.�GF��d�'?������Of�F��E�ߓ�KI��$���4�~�W�rW4&Ӊ5d�����|߻��h�?������Ǒ_|�_?��G~À��W��9j����ˋ��_:�N���P;��Cp���W���W\' ��j�C�t������l�j�����z���Mh�Ap�2C�\���m�����@=�x�9Cg}�������#/�Q^@����9<�S��)��8���k�38G����Af�����٬�93N�ՙ3�Lp�8sf�p��6̙9�|�3L��3sn�w���Mi��.y�ɜ��/�;h�1��$'9�INzݦ�dҞD  