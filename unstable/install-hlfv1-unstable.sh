ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

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

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� LgY �=�r�8���ڙ^Negʵ�]��fR��ӒH��,��ՔDɊu�us�$�(H�E�l^$�)���W��>������V� %S[�/J��35m888 �98 ���t�R��i�0dj�m��{ړ�A,���8��b���F��b������EQ`��[�����c�}վoQ�o�вUC���6E���
�w)
 _&�]��KwdU�֙.���8�d�=���:CZl���D������I B`{��av��I���e�=�;#�T�pX�H�T���ew��~ ǿ ���%���2t*jԡe�Tһ��h-�a�
�c��2�j#� M(9���pO�H���V,��U`���R��03[�A�>�>;�݅ú�U�"X��у����}�X��zR�5{Nj��Df&װ��B��M偙� %\K�̴-SٍD��ax!�Lb�v���3E��R>��td4P���i��ܞm���d��B�pC���5��1��6�i��z9�Sf��W3�p�^��.��Z9�lL�����*���bY�%ƌ�)�jR����"��fO%jT,Uk)=;����0��lQ׿t��K��oD<�/h�6�D����ǥ>��x=j�~$���O��p���a4���܏���'@xpN��>���V����;�����p����ǟ�"�/��a�<�m��u���"U�4d�Cنk)��_ �I�4U�<��cR��UJ�rJz�|���K|�=0M�+r�2�����s��>�O��\l��뀍��0G�MY��|��6������7����:x��L@�1>����x�5^��
Yb��&Fa�LX�R��6�fBTH���u��=&��$��eXh�Շ�a�m��0]/�|LK���ѱ\H�d���Ԧ����
�m�"	s�8/��h�׼^m�I�P�JGF�Fo1IW��M�����P�h٪��"�����_�d醫j͐l)�Op鶫� ��{r�	H��1-���z�GS�k4����$5ԾT�,6̏w��,��~Nb*gT��ݘ+�jc��T�e�'jZ�|������|��1q6cP:��ac��A��z��Z�N6Łӑ�U5�k��>D�X���z����M�َa�xI}��Cv���&!`� ��KJm�w؛<d����i��5&�#C���T�-�jg����D��FtW��W�P�Z*����\���X{7rT�2�Z=@�P�{�{13�@#�k�+�d "1�1����5�>�����q��m��� ����q�=��cf^�Α�̛ձ����ї�O�!p0%A��I���G��Obs0�8w�b��Q�}rQD��UR��4�ϡ�A��P���}�Aن��T0�Jĳ?��~�{/�p���lH��A��sWF��|BC�:6���_���5b�����|Npƛ���$��������׈S5���y=[���������Ж�i�p3��0g�ǂ�`{?V��An����Z`���e�����c���<��v�����������y;dkyzڴ���1��h
{�YKnxN�kY����1�!�Ε��`N��~�rVI�s�ս�!��b�7߳+�+����Wۘ%�,�.�����\�.�+�R���յ��;�@������9���x8�G.��{~�5�LQ�K���Y�Y�R��R�ճj� �j՛��@��;+�6D�մ_�4a��+xm�~������	%>�zN���߁w�����<� ����$Ĺ���]PD��t�׀~��{M�R�ⲸO4t�C'�nEB���&�߬���b�P�I)���Il��W�������w��`e��c������_6�]�ɖ��E�e�i�/.D7��xx������{��=��h@4�B�[����Af�X�{�����_���q&&l�?����p�p�r�������N�7�X~���h���������Z`����Wᆎ���� hY��#0-Uw�����7�0�W�!ؿ}�'|� D��q�e�О�*���p�=��8j�՜8�B-�9��|���b��\�fsw�\�Qժtc �:������v�?Lo=f{�������e�@�j���r��B>);�@�E~�[���B������a�������&�c-���z�q�����i�&� �9x#�0�`���c���`T�P��N�,Ƈ�0fF�pUK�����˟��������s�M��z�Q����Z�et��
,��eIL�p��r��F�����F��Ϟ��$`:�9o�C�Q��%,��w�,�(�#:��,�����?�{���rE�y�����K��E��+�@)�~�	H��yU��Qȡ9�?���et�qȃ�Q͊���%���Zǰ��]#䊐[�Ƈ�ȭ�n���w�
���K��ֻc�A(�˪SU�cQf|�H��F3Y�IQW��Q�ypn��H�:���@7�w�2�HW���а��ϴ��l�?��	��?q6���� � Y}_r3�/_��;�B`[*b���K��
qL�s�.Z�
I�\)�Sg)�LD���b2/���1O ��������b�]Sہ�X�`
�S�`J�X��y�@�T��%�|&��e�Rk�RZ�J�*a7�V/���K�bu���d�#}يX���Q�F�E�l6W̞奺��KK�Zv��\z��L��A�LB�w���(����հ�e�+R�V�UO&��r)�G��{WgSM��B�,Kս����U��٨"lMջ���� �R���Ah�5��t�	�s�x�������μ!ڝ�����a�����-���c����m���>��?�7z;~� �S�5o�W�n���� "���������ѭaj��.�w@W���x�?�]�~�3@,����E�V����o�nq����^Q@K���?x��7��M���ò��K���0,75�Ѩ�n��:�s��{��R�:��xvRX�+�-a �#��.����Գ%���ny������U5
vb'n	@���SW`����-p�SK�>,k��s)�B��������<������|�����]�Qx�o�ZT@�WCW��_��Q�j���i6&��i�����\
�H�g�9a���>���bG��R�S�4�Lh���QK��38_B�Ѳ��C���Ë����6��Z���(�?,E�����9���i��uiA���qץ(Ŝc10���B�� W
^�za���ᙹo�|�L7�0��Ć�������++��`�E���\"$&Q�z[d�)s�(�E漑2JxC$�Ի�V,|�榇m���h?���-p �&���K��#w�:V��g�����Z`��6b�y
;��X�-���� D7�������:�>|�����?�����?O�??��F�y.��RX��r��╝D"�j$8��ːg!��D�Wd>!$l#�#p�A���������&����7�O�ij*�_�#��t�O���m�ɷ�)*e�a9����׭��F��u�������$��7_M����@����������5��_�Fy<�T	�֟����'�2�7L���|
�1��G�fX]����R���(����;���9�e�X`���������>�k���?⥆�Di�m�qTf�#-���A���?h�u���`�
D��L�һi[m�ݸY�8C�²�,7�5Z�߉2;��l)|cGI�\FY!�Ӕ��"�;q9�`㲜�y$!�
uL�#�@dj[x��	aHJ�\��r5�ɥĪDR��\.�=O�D%����ΕŢ[���W�f$�o�!u��A�}�;0Ns�猄pʥ�G�nVdkR�SH���R,'��:"UMu��FV�5�o\�X�Ȝ�5/O���(OMf��J/�p��	�s���o=�*e��K�=}��4�&�ӊp������({8���;��|o.�`��UeP<�q�j�)Us�1N;'i�(��~|�l��A��$]?:�J�7�ڥT-��íK%G\Ɩ�O�JO0O��q!y���P|�׸���N�'�¹��x޸�Z�$C0�������ǂ��B/Tf3�����b�QM���L����J�O�m)�J��Ҿ���d��9�H���E�Z��~��V=98>�X��q��&������V��N�� #7+�*��Ss��)V�9��<,�Nyi�mΫ�d� �h,���@JFGx���i���z�\H��I<�B�ƭj�G�B�@�%{֩�Ɠ�d�n����A�W��4 '�J���
*�F�GR�Dc�24�)�i�����x��(�^OI�_���ȗ	�8�觯�� +�qmPO�S�H;׮1�W|3lC2e)7($�n���^�?�u���~�X+�{�u"�R1=G諫�p$�%o����?V\k����~�/�zwC�}�ecL�	�??0���a8��-���������~��S�}k�������(�
��k���tX���� ����*��hNo���Yf c���0�A>�<0�HB�6bO�ӒXg*�[X�kZ_ˤ�rY>8�9��\��(��~�>��f�ֽ�ȩ���:�Kiƫl?��z�6<*C!�A�V��j;�9�k��VK�dE��k�0�ޯ2����QH=��3�l�>u�>�y�����/l��u�'���Ƨn��|�?7g��7��������R��?�H��}�#%��B�⑒>j��XR&]���7����Y��mʇ��S�(eN3���|�֭gʉ�a�F�d��KGwz�x8`�:�`��ޮ�����N�Ӝ}�^����h:,i���P^��������h|��xR�9�H�d.Y@���05�q�ʐ�E3L=ñ��鷡���r���m��������C���D�.yH%�m� Ұ��*��2Z8�K��K�!m����m|o��D�|��R�|z�a�cz~�@;�r�j  m�dU���*���uc�tń
�
� v��P3$	�:$n+�)B`߰�t�/;/ȣ�.-��kZ�G�<����G^B�Zr��[|�~M�A�8��鐗��/	C]nhп�G;�R����D�
��k����ڵ�\�(��㮍����@���&ƕ#�'�(��D~��°
�D��������>)����?��9����v��n�����zR��.���"N\�pB $pA �vBHh9�u\����m���ͼyp��̳���������U5�g��$RT����|�h���僛�v�	&�@�DX/k�)&��A�J[��MU	�Z�ABW�ˮ�}��q$����O58�xB�}���n"��4��t��E�~���23F��x\�&�Op]��r�Yn�Ѕƾ�L4o�3\��C�ʰ}̂tO����m���Į��}��^�??�������ޕLܻ�%���e;�6�71��2��>k���NP��2?''�9Fm�苃{�k���=Ài���}A���K0�NS�=i�)D�RCB�sM�(|t�L�jl�"$H��J�\���?��i�����j�����j�������D�D0j�\�.C<����D7�����my��A�'kLG�S�vmc
��b�����M������q�'�;�с���������'.;����OQ��R�i�&Ӯ��G�����'k*X6�f��oIt�!�T|8��H Шt��	��
�X�
)V���t�&sT:PՉ�"�N�]��5\6�萩���\[����w]�L���F��f�H����Fb?$~�Je�u��˜�?�_y�MϟC
w�ܟ:5M|��}�we ��P�[I���g&y
�1�e�a�h�a��=�7w����D���*#��I��D����T<Il���Q���^ɇ��%����[�����?>���	�o����?��M��ɿ�C����� ~u���_�}k�/0V�m�#�I�ɟ}��9*)�^\V�d$�K�X������^L��r�����N$�9	3$����R7���'=y�j?Y���g�~f��������|������H��#���x{��5C�A��l݆~�0�{W8��=����7�ׯ���A����[X��#��!��2� c5�(U��ts�ҋ���0Ϛ6��G����g�j���g����"�<| Xu��d����*�+0�b;�M�턴��#��
g��pVKg �NZ�O#��0�.�Bk��~,
u�朦�=fۭ��3�,����m;G�gΦD؄�Z�Ұ<�F�3�>�s6&8��lw^��-ʖ��i;����m�UL�ܼ|�n$��`��Ԡ]i3lz00���Qq���y?\
�\'a��y{lQK����X7uŢs�b�U/�$����ʳunϔ|�����>(��\�fQ5�*]+����
t�ƊP>��L��m��ĢCܴi�>[�c�:��9^��y`��)�SQ����98�b����Ɵ�R{4�����M�"[�,�4�f����<��6�T�"晴�X�k�fr����YS���Qi�f����m&�`�j4�:����XJ���5��cE�ZOH���jy�������t�%qW�%qW�%qW�%qW�%qW�%qW�%qW�%qW�%qW�%qW�%�sy�b0�o6
t4���H|��4X�v�}���ND��aΖT�\�D�zv���v��'ng5�BK�ϗ�=wq=J
�[���۹��]���p�ND*�����9�����t��S�il�DK����T�%6�g}��L�Ȓ5��I��Ή����\�;u[�3Փ	5ƶz�Z�z�Cx��E�O�cн�,��G �ir���5�x�賥MuS2��c�ڹ}��)хY<S��)��$jO�	�b2M�΍�-5�-1����,O��R��˅AT��c-��4+�n��#=��^v8K'��Z����ڋ��o};�K;���vBo���ym�m�����9��`7�����,��q��a���E�|8?���]�>���Ў�w�Qإ��l�.���}˯S(���f��k~.���#T[���G��~���
��7w�����A�w�~�����ZSVZBS&������"�SeZ�2���$�^�������9�nx>?�����s��	���r����<=�E�&jZ.�1]5�S]�e[��D`��� ��P��DZdԮ�,xf�8��$�ӬF��,�\!5Mf��}v\Urg5"���[�#93�ʕa��څ}m�v��~7Ig���5�yۚwⴙ'�\Q��q�ؠ�6q"��ʤ���n�=�����͡�4KW�� #�Ș�B��Uk�e��-�C�U�n������T�y�Z���m�F�E����>"��Z.�,����(�A�$/Qb�9SQ9I�'A������A��0Q���#f��Q�>3R�q]���F�V�����7�����~�Z�ɢ@Y��Z����&LK%.]���__^�������{��� ��� ��r�󏄯UL�������3nQf��n�4�Ic�4���+y�N�V�=u'p�F�����/7�Z�����'�S�e1�<�-Sk��Lz�T���8-w��h�Pʥ����՚c����8��K�ձ��N�����_�Gi-{6w�t��>/�����Z�m'P�@9+д}�(���ټA���\Hj���\a>S��t?���9��U�(�<��l�(\p�Ȱ^��� �GݓtU�w��b�5��+6R�"��z�=��+��u*�ʊ�t������Rt�;Z�����A1BE�b��0��e����u�N�E�H+G"�g��xt����aJrĄQ�-��֑v�v�<�ŏ:q�%!ocgB�v	�s&�*�ҙ 8�I��C!�s��J�8�՚�ݣ�x�L�*GTGzk�e&\>2sY��Y����(�����L�]'�D��z�i��1}���4"��O�G��C!<��š����x�gj磥�n��Z�������w�	1 q� nX^ߡ0�~Ik�J�5i>��q����If^�gC"�G
e4���њa�؍y;2C���ܪ-#.������t[�F��+�U�䇥�U��8��wq黡w��[0���<S�6o�Ǐ�?"�a����F�wCooDM�n���n�ZWLk�9/�B;>����|��95��X	�z�x�4t�'�#~��ЖJ�a����/������/I�{+i=�8�!H�	���AOn4��|F�ǠW&�@�d������r��x� ̾6Ri]5 Q�B{�5�~[���y��n�~�9�`���������n�в<QLS1C��.�
�MǇz]:yiҹAO�R�!^s���s��-��!<�5���y�I�.���F�~��*>���E�������M�$��z
>wr��rgb���
>6_&�����I���1+`�c0C��:'Bz�]U��Q�/�]�ݙ������6�f_]�榯��;�9$?s����\#�ѥ�yI,��VK=���k��,_�^dyM�~�.��g����-�8�R�O8 j�hOo-X���t�^��A$�(r�������N�� 䣃D�"�����3u�6 D�!FW�݃���P����A|��H.�Sӻ���$���-��S]&G
�Y�Q���Ӱ��SG^���l A=_��0�ʀ%LH8ӽ�-*�1鎟`uQ���v.�o�~�:^�@Šޙ�c\D��Y�����,2]��I1 ��Qϳ>Hd���öb��\2V�m�{����6v|f�Crm�P��k��@���`�`�Љ=�SS.|��{������:�F]m�C�n@��-�ĪSU��ew"�r����k?V6�������ݛ7o(wL4���	�v�aa?>Z�tޮ�M�G�z���ί8�$�4�Y�*�����ӑk���@�N���Өk���h]��B��]��o^b���)�2�ָ9�C܊�`�éI��$�?��eE�R^m��׸8s��@�����0>���fL0�u�aK�nɚ(:F�����6N��r�����M&�ʁ��*���
�R����(cC=��lƀ9 �Zt�Ø޽��;u�pJ@$N��|;x�e�n��x�t�J���!Byb��Q=mt������\( %��	.��Qs�;Z%Aq�Ț����*��07�x�^1�<�<
����7����6�� َ��6�g����]n9,�����з�b������K�X����	���ୃ&�ze�6K^UqU����s��%�gҤ�kW���زQ����׏��d�Mб�t���Jp��%b$:�Pi�֘�U�ɶ���ؕ@T�<r%r���0P231�=�
뚉�5�!%���Xeu��7���;Dxh���ۡP=6���0�T4�n�9�3�Lte)�����ȫ���/:�B��1��;��4��������8�1�H�lc2p��z��ҍ���W�
@�q�w�!��l��Wg�z�U�?/��w�N�k˸f�"M���G���_���J>�ǱB|�� �кNT����V��orW��xV�s4S糧Y�]��,�X��V~�ܒ��Տ�:�V�!�-�%>�*zu��K7(|5m]���8{0V�)�k�X9 �A/�HJQ �D*U@"���d���*=JN�( �R����RO�e� O+ �����d��v��+V�{Vp�{�K���.��f}���|
SPS�!7nŖ���(�cIe��L I�"�t$%��*�nd  �d<��"�dZ�IFwH��d:��S
�@��!�J�@����&�ʟbi�`�6T�:���7m���-f��F�m�n�lͿ����z��z[��\�<W��t�Tɗ�c��LV��z9��2Ͳu��x��U�Rj�o�o�X����b�5����[��d�����%�Q��g����]W�04��j^YA,�Ǉs�S�τ��V��6'ݰ�Y������Z�Z-��&���q��v���q�k����["��R7%K߾D�}�_��r���x�>[�sh���r���q�����g4_�V���,�4����)Wf��,>����a8F[��30	O�#7�:0��D���!y�R��S�KĉW�6��V�G0k����r�ϟ�9�U�	�u�<=:��]/tMw�5ɋD0��^���E�A��e�	��y"-r�_�i�npϲ�6T���>[if,����	ȻL5��]Ys�Z�}ׯ���=hn�W�iH ��rJb�$��/`;�!�c�[;q�������W��^-��o}B�X�|�I/����ջ�M�g�����0��"]F�]����r�������W�}��l���v����o�ܫ��}^�����G�:^F�_��f۾���-qa�����~�������i�w��r~�����v���x><��ʋ��.����~}��>���́�y���B����?(濠�;������\�o�?I�d`�Q෯�A�e���a�Q �o����&��>����i�el( P�������� ��)�9�_���<P�����}>-P��O�)�fn��ߑ �g�~�g~��Lя�/��ݙ��	P�8��s8�I�	bD�����(1\G~(	"ƼH�#&d8�	V�2�)���ӏ�;?7p�����0�	����d����|TL��d����]mC�z�Ѧ\3��2��Ŵ�i�>����4�3����u� ]#�6�sK���f6��sl7��;�RÑߡ2�?�Lml��p�Mz��x^S{)���?Y��uy��x�矵;<p��!�_>��
C�����@��o�����Q ���;��P��
�����������M���(��/e�E_�O������n�?��� ��v�^
� K�������?���?��x���G�P%����g��,���?�?H s:aN'����K8�,�u���?� �����?��Â�����D����?� ��s�m�'EA��/���%��_�?�z���[��u�s��͕���S!�������?���O�=�����f������I���3ϫcY5B?����퓘�4�M��Ғqjԏ�"jn��f9�=.˻��:mP�������8�+�����J���*k�P�|W;.~#7�_��|j�$~���g��I���]W����չ|�b��mV��p9����}��q;-��i�}=13� �s�T�4]~[J֬�F�6<5��D5��y�r���;n֑�KQޯ��:d�m�X�]��G��K��ߖ4�B���a�@�]D!P ����������Kj`����`�7���?���?���4�?�@���������[�a��������� V��M� p�����8�X��=������{���|��#�n4���ͻ��_|�_I���C\���^�w4����K���v�]%}�#���QG���&��Mga8�s�K6�:oxk)_�R�6�HrJ=I�������m�m�&C����e��5�'���cٔ�k\�?���,獇�~��vn����s���;�_ر���`'t�DF��i}���X[���xf��b1�U�d�t���>��2�(=�b�'�JFN,�Ȑԣ�I���[XC�?P������(�(������4[mc� ���[����̳{�����H��G���GE!�S'r+r$'IAL�l B�a����!�!Ʉ|�1�1	3~8��=�����w�����ט&ʪ]��-�HW��ߞ��z!K%f�צs�I�����o�b�,�lg����y��p��zG��*17��lph��p�/���[AK�D�h��l��c���u9�j�[v�������a����P�����ԷP��C�W����)�����s���8�?���w�;�ֻ��^�/���8���xy-������!���j���M�o�=5i�'�oS�.��z�gN�11ʝI���%g	�IR�گ4�甎�\��v���_�|������d�-w�����c��!�[0��C��p�7^�?8�A�Wq��/����/�����b�?�� �On��Y��C����w:뿄����Nج��~�[��A��~���G�B��Or���_YvR⬶��@\_|� �[={w�Y����<��w�*q�� �ޏVl�m��R3[1��jI�ș��R��4�Ѭ,���u��)�K���5��@֣��Yu?ж�!���z��S�ʖ�i�9�x�}�O������}�� ۭ(���ね���,>	y���-ڗk�$i�Vu�S�@�Nٶ+���hZ��J-�m���<t ���TJje�̽���_jZ%���n'���۪��dc�[W�b���B�46j�d2iFsI���f�c��Ք'�4�ʱ�ju�*���l�2kl?ۘ}1O�E���Y��،d�p�{G����P����Ї
|�b�_:�#o�?8������i�����#�O?l������H��Q ���������X�'
���GI~�s~$+�B�G�!�K���<+�)�b��At��34�R�
1��~����;��� �?H�;��V������c�K�$�{=Y=hVΎ�M�=�ɮl.~��u:Z0X'z��8'vj��F�#w���/�b�`��z�ȷ�I�c���{<)��\�����Lץ�f�J�W�n[$��@��k���O�w��@�	>��/EK���b�ߐ��i��(���7���C4��G�	x���������o������_���_8����W��i�(�����7T��[�ֲg��QY�Wa��gs���;<R����S��N[c�=�ߗ׈��~_�����~�y��w2����O��x����Ŧ����5{��^��a�?�2^�N��Ԗ�Y�'�;�h�7�Fŏ�Ʉ3O�ֹ&Z�`�f�����Iޘv�JӔ�*q9����/k[K�W�s+�����P$b�i���b�^8qh��֖T+�9��\����mUv"����ʦ�'T=��å�I��Ry��J�fp���yOګQ91�k�U?F��J_������s�AϬ�}rrTYI�G�ۑ�.�F��Y���߂�F��|w\����8��y���� ��(�8��w�y��� 꿡�꿡���A�}����)� ����[����p�_����G��,��;��4�?
��/����/��{�����������/-�{����%�g �G��&�����GT��������_<����P0��9D� ��/���;���� �s���_8�sw�@����`����W��@� ����K8�,�u����D�@�AgH����s�?,����� �G���B
 ��=��� ��������A�����@@��������/�s��"����������?���?�������t�@�Q���s�?,�������a�;`��P��8��P�_����������,�uG�Q��P �7��i���� ��?��Á��g��@�����b0 c�Fd(�)�D)�l �K31Cq��dx�ЧD��J�}�gYN�7��;�����������1z����)�������T�����vB�F�l*�դ,MfOx-�G:� ����|?�hqx�4�%�wdK���v���ku֦;;U|U(�z�B��JA�lo��w�*�s{5�:I�q�V�n��i?�˚�;6�Z���b�W��5���RE_p̀����š��?�éo��a����8`��P�S0������}1>!p��������!cr�R���Ҳ�&�Rs��i;:u��Y�ڇ�(�����u�Y�윹u*��R��n�F4��4{4���[�F�C�ؔ��N	���i<\��1�v����8'����6�i{�s������w��"���n��k�' ��/��*���_���_���Wl�4`�B���{�����_���W������Ǩ}u�/���N���ا�\�U�߭���E�i��xUj���@�5̺�ng�nX.i����Y�6\	Y�X"҂Mb��(�8�=Um&}��l�v�Ɣ�ʧS&mFLjY�I3����������UN�j�~�x�/ץS/���[QrS9�[%�+��'Oe�x�Y�E�r��$�ت�{���)��c�HQ$�A�qZ�ź���Y �M�V��p܍���#M�A�L�����G,̓7rv;�Tmμ�<Q�� b����W%�yV�$�^%�ڀ+Ż3+��kN����{{����mo�o�?��4)P<�R���	>b���~����S��h�C�G�w�?��	>���:�A��@�����,I���(���$u{���� ���O������!<�������
������*Gǯ���_���`"�LJR���g̛�<�~��GE��'��~~X�ʫ7�����J��[�~�����#�:��)�G|��ٹ�<�����ԥo*�S�sI]^2���[ے~W�*I��i5��YWSQ�KA�S_2��꺔�s��m�1�/ti�W��ZWSyԧŽg;FB�RwM�sYr�V�S�&e�s�]��Uf~w�	!���%惮�z8����k��>���˚+�P��,kr�)�G\��=�d�ʦz�'"-�'��ns��0%��,O�S�t��I}_��\iӇP�3�5k�gY�Īɚ���7'��P	[��ణ��ח��<H���_��bj�#Q&n�Wr�0$w�"�M�?d������Ώ]������-����=�������/"��B��O1~ �D��}iĄ�~��CiD�4I�Q(��4�!�C.$�@����:�?
8�����g��H�;��5>�5/��I0HB�����7�t���QD�=%~����+ߪ�-r�V����������}��w��C��ぃ���V�A�	<����(����[�ǁ�C�����%������ouӉ�V�GK:>�7�?��6��ǂ:=箹�K��x[�o��܏xO���#^�������k=����~���~63ɜ����JM��*_/�{Wڬ(�e��+�z/^�//�������<�L*���V�o�^3o�VeVV^�ҽ"2��p�u�>g�u�~�W}�F��项��x��b�6o��-����,�j��R$V��y把�Ⱦ2I���o���!w��TM8�Ǣ�ÎM��O���v����T��í=e����6���~�33N��L��=v�	���C�g�$D�0JC����:�L��ֺ�uGm�3lrc��5�W
��r{3D�������"�?�^���f��J�uR7�j�*f� �?�N^Q�a��F��ZU�X�GOt���S�J�T���*0����������g�7�o��9�'6hחp�-Rj��!ǚ076���V������4�7���ߗ-�jA�U�����⭟��������,P����[�����Y<�jZ�+<����y�?�凌��b�A�AV����?�M����g�/������a���\Aey����VK���������w��9�����|�G��N��>�ݎ}5Q@>Lq�>*����Y	�N}}�l��6����a[<Y	����SWי+�y��;���0��t��K_gᅼ�y8+��j��T�EK��Z=b.��}g���=ohtZhy=u�cߘ��u�D�Aˈ��]�p�Vw}��zU�_��E����]���;^�f�����e�G�Ͳq�2���~,oYk������H�ǃ�1�efj�/�u!��N�X���o����	}�f�꾩Ϫ=CZL�1]��K_P��AA��)Ǯ�[���q0�k�GdUjH�o8������H�l|�`8F��>��*�پ�/�����7��d�,�]�࿨�����_���Y�?$����o�?�3�B�'�B�'����{����� 
	��[���a�??d��`W0"���Kv��& �7��7��w�o��_V���.��,��?����٠�������gFȆ�o���G(�������;��0��	���t\0�{ �����~���?e�<�|!��?���O�Y�������	Y����H�@�G& �� ���E!�vg��?2A���B������
�������E������o����L ��� ��� ��������? �l�W�����P�_��P�����!������ ��� ���������L�����s�����
���������H�����!�?7@�?��C�����a�''����)����~�����_��������CF(��4���U�%��5�`�f���MuiV��a0U�IZ7M��&{(��jS�1�z��O��G��B������^����<I¢RS�_���Z���w�I�6YK��x��u,48	��tl�߷h����_���i�ϑ@��*���SS��5���n��l:]=j{f�C'e>.en7����R�]���o,;��@U�����~����=NZx����|֪��InvG�5V��c�wsSy7x�P���?�C^���Y�"��?�����?�!O��|�S��
��"�?���{��j�	i/z��q3�r\Ӎ`w,k3���>W{k>��Ma��.;�����`;�v��ⳑK��I�#�6��x��N�����9^**'R�S$����2��%��m�z.x������+0�����u�I~�F���_P����꿠��`��_N�?�sD!�E��
�/|���Y�u?�nǊ���:0�G�!c�p�O�w�����-$����g:�[|>؆�mc1������Oa�.���n�SU�,��7+3U�8N�33��wL��K�\���D�m���kb�ص7�ү�}u_���cУ��J�s�6K^��%�?�*Ed[g��Zn8._�p� r}��\��9�?n��{�}ւ�K�'�/@.onJ�u���|�%�J�ɉ�YG`q�|�8���񾤋�Y#T�[l���9����8�F��b�T�8`��b�ΰ]�hwBj��H�qW�0��8����k��(���)��o��� �E���������
��B��ۣ��ܩ�b���@f������	���?o�'��O1�ȕ��"�������;��w�`�'����ϻ-������?y'��3A��\ �GV�����' �#��#�?������3��/��`�\��c�B�?���
����c.(D�O���bP��	�X�qN�?ԏ�rT=tG�����#0��4���u�m��������z��H+�o��]?�~����ڏ������Y�_k�׺����uu���}fO�R��=C\���#����❮��ڼQv\��p��N���z�Kqt\�lX5��+*�#��$-�E����Z��ܩ�U5��:�Z;6�2?)3L�J�+[�S}.������3�D������8�{3I�G��u'862f��uy~ga���Cw=�u�����u7>��&�ڜg���(/^k*����f�'��׏3`P����!w��j�����c�B�?���"���K������a0��	����������I���	�뿏����	��[���)�?'��� o�B���������i��+�Ge7�6vĎO�N��5j��?���h}���8����D砻���NN�2�?�@^��PP=�;�v8d�k��ݬ�uUGif�(����eu�!ܕ�T�F�"rt�V��I���]��(���F���;~��j2֚п_��E � I� ��`�񀕭isS�k���q�=ԣ��6$�S�厙�D���������e�
knG��Fd��T���Q;	C��f��~'�l�������_��+��>,�wK<& �l�W���w�+��Y�8�O�HFW+�iҪ�֪���`aR�F�N&A`՚Aẉ�f��nhmԪ�����[�~d����	����{��9b��!��֚/|�L$�<�;*����l1�*�Z4�Q�|]��T>mg�<Xe�T!���F����liMɱ�[U�K�>W��:�{J�%Ἔ6�E<L3`�$ >��U?����_�"�����r���E��n�G����C!��rC����`���"�?���{��t���+Q�I
�.1���Iu��:ްӊ�џ�>;Qw���!�v�ю�}�N6[{�ܠ|���S
��P�P3�2a�1B���w�WZ��QW�t�c���lC��ƛМ=����kQ���&��J���o���]��sD!��+7@��A�����<�@�"�?�����	_��T�Y�G�ײu��z���el5��;̻I���뿗����� �.����½��h���2�0~Y1�3<m����mј�:x"�j���E��N4=�#ۭt�rml�)����P�xuQ���f�s��2Iu��q�����{�������c�����"�����{����ָ�W���5�*ȼ�����Dጥ)i_�Q.op|r[y��h֋����S!=���>�E�3�@��#N��v�4��/�<3�Ξ��h�����8ȗ��e�{h�����:�kQ˦�� 4'�bk����/�sr�W�5�o'�4���8�j{g�|��_�g��12���?A�
�?\�s��J�?#P#���s������餺	��m�D���{^����Q㗟{�:r9.:��{�[��%��ӽH)���	K����G�f��KO~_���'-���g�m����T|`$���qt|}R��1�Ŗ���z��eK1�7��>��S��{�B��}���p����'������?�����F������^�t�0*A��]�ǋJ�f�>1��-�'$4��;㐾G
T��FI����tC���	�˃_~��_%}YJ�Kvx�k$���a���;���b���O��������x��JΊ<��������9F�eB
��|�Pzg��~z���ݔ��������һez������J��ociA��H��m��	Is<]MN�5/��b;!�`�y�g�6	E���%'�F�SR�����Hn����ިA�I��Ռ�C�����w�oH�1�w�&Ww!����B{�{N���K�a��6��ׁ�����%�r�w�ҝ��������\��F�HG폍�^��Q��l��.)i�W7���]�K~b|w ��	��}{��Q��;���H��aJ|��?��􀟾�aV���>����,�E?=�OO��    �X���\� � 