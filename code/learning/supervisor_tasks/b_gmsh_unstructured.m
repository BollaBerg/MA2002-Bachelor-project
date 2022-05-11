%  Matlab mesh
% task_model, Created by Gmsh
% ASCII
clear msh;
msh.nbNod = 121;
msh.POS = [
0 0 0;
0 1 0;
1 1 0;
1 0 0;
0.25 0.25 0;
0.75 0.75 0;
0 0.1249999999997731 0;
0 0.2499999999994107 0;
0 0.374999999999046 0;
0 0.4999999999986922 0;
0 0.6249999999990107 0;
0 0.7499999999993404 0;
0 0.8749999999996702 0;
0.1249999999997731 1 0;
0.2499999999994107 1 0;
0.374999999999046 1 0;
0.4999999999986922 1 0;
0.6249999999990107 1 0;
0.7499999999993404 1 0;
0.8749999999996702 1 0;
1 0.8749999999995015 0;
1 0.7500000000003476 0;
1 0.6250000000012155 0;
1 0.5000000000020615 0;
1 0.3750000000015629 0;
1 0.2500000000010419 0;
1 0.1250000000005209 0;
0.8749999999995015 0 0;
0.7500000000003476 0 0;
0.6250000000012155 0 0;
0.5000000000020615 0 0;
0.3750000000015629 0 0;
0.2500000000010419 0 0;
0.1250000000005209 0 0;
0.3125000000005964 0.3125000000005964 0;
0.3750000000005205 0.3750000000005205 0;
0.4375000000004337 0.4375000000004337 0;
0.5000000000003469 0.5000000000003469 0;
0.5625000000002602 0.5625000000002602 0;
0.6250000000001734 0.6250000000001734 0;
0.6875000000000867 0.6875000000000867 0;
0.6824729501338205 0.105030865197188 0;
0.3175270498663478 0.8949691348025404 0;
0.1161358444534873 0.5462306363820797 0;
0.8838641555467666 0.4537693636181204 0;
0.4418984609495225 0.1061067944139292 0;
0.5581015390511126 0.8938932055859052 0;
0.9044088583011273 0.1865224104904447 0;
0.09559114169877338 0.8134775895095523 0;
0.8888071063115767 0.8106304982905336 0;
0.1111928936886545 0.1893695017092965 0;
0.5605414673553192 0.1044248145746373 0;
0.6193641766756517 0.2057653639592412 0;
0.7299098297895734 0.2120401192524738 0;
0.6715534035784194 0.3049179209360307 0;
0.563574980531755 0.2997747220529694 0;
0.6144626374984984 0.3935208772219279 0;
0.7155576801744818 0.4004726877740666 0;
0.6627343387170908 0.4844326743589064 0;
0.763852438537421 0.4832728763659047 0;
0.4394585326451083 0.8955751854251666 0;
0.3806358233247325 0.7942346360402479 0;
0.2700901702106293 0.7879598807469024 0;
0.3284465964220719 0.6950820790631808 0;
0.4364250194687785 0.7002252779464968 0;
0.3855373625021897 0.6064791227772767 0;
0.2844423198261871 0.5995273122249906 0;
0.33726566128374 0.5155673256403763 0;
0.236147561463263 0.5167271236334676 0;
0.5053131593480962 0.2046651013347496 0;
0.4046342641886449 0.2020122945763706 0;
0.3313389502378251 0.1030958957377597 0;
0.4662907660895574 0.2946665464665489 0;
0.2038772369346652 0.109739845131684 0;
0.4946868406524903 0.7953348986648937 0;
0.595365735811991 0.7979877054234162 0;
0.6686610497627585 0.8969041042622031 0;
0.5337092339111196 0.7053334535331671 0;
0.7961227630656196 0.8902601548682553 0;
0.8977010774941114 0.6926366459359072 0;
0.8986091619071401 0.5772939359773124 0;
0.8139489950693408 0.6534705771317223 0;
0.1022989225062747 0.3073633540641684 0;
0.1013908380931486 0.4227060640229454 0;
0.1860510049310869 0.3465294228684097 0;
0.8845559863676241 0.3184757568237316 0;
0.1154440136325056 0.6815242431759815 0;
0.7047467368499937 0.5560821708596276 0;
0.2952532631507311 0.4439178291403058 0;
0.5158769852754099 0.3935979244683818 0;
0.4841230147252159 0.6064020755315618 0;
0.2288934106996617 0.6856551539003417 0;
0.7711065893006332 0.3143448460988721 0;
0.8099333182242091 0.1187919150812597 0;
0.1900666817756103 0.8812080849184832 0;
0.5816788751657468 0.4811753644245636 0;
0.4183211248350594 0.5188246355754198 0;
0.1962126300150209 0.6059328938633723 0;
0.8037873699853855 0.3940671061361391 0;
0.8325925751907803 0.7492651492518183 0;
0.1674074248093381 0.2507348507480062 0;
0.9084936490540351 0.9084936490539898 0;
0.09150635094596724 0.09150635094576684 0;
0.3092419901352765 0.1954386686814771 0;
0.6907580098651193 0.8045613313185147 0;
0.3836925175127572 0.2844742096746783 0;
0.6163074824877863 0.7155257903251334 0;
0.627331990146653 0.5418380419287063 0;
0.3726680098540969 0.4581619580714111 0;
0.9084936490535108 0.09150635094649474 0;
0.09150635094629629 0.9084936490535543 0;
0.8124353313335513 0.5560348817581288 0;
0.1875646686667026 0.4439651182417743 0;
0.1803770718995695 0.7668260597726597 0;
0.8196229281002823 0.2331739402266757 0;
0.4376552439489272 0.3607160345498085 0;
0.5623447560518661 0.6392839654503794 0;
0.7916560908866193 0.8009434267458243 0;
0.2083439091135869 0.1990565732540927 0;
0.7322718438755242 0.6380146049582898 0;
0.2677281561249395 0.3619853950419343 0;
];
msh.MAX = max(msh.POS);
msh.MIN = min(msh.POS);
msh.LINES =[
 1 7 0
 7 8 0
 8 9 0
 9 10 0
 10 11 0
 11 12 0
 12 13 0
 13 2 0
 2 14 0
 14 15 0
 15 16 0
 16 17 0
 17 18 0
 18 19 0
 19 20 0
 20 3 0
 3 21 0
 21 22 0
 22 23 0
 23 24 0
 24 25 0
 25 26 0
 26 27 0
 27 4 0
 4 28 0
 28 29 0
 29 30 0
 30 31 0
 31 32 0
 32 33 0
 33 34 0
 34 1 0
 5 35 0
 35 36 0
 36 37 0
 37 38 0
 38 39 0
 39 40 0
 40 41 0
 41 6 0
];
msh.TRIANGLES =[
 44 69 113 0
 45 60 112 0
 82 6 100 0
 85 5 101 0
 90 38 96 0
 91 38 97 0
 6 82 120 0
 5 85 121 0
 84 44 113 0
 81 45 112 0
 69 44 98 0
 60 45 99 0
 37 38 90 0
 39 38 91 0
 104 35 106 0
 105 41 107 0
 41 6 120 0
 35 5 121 0
 24 45 81 0
 10 44 84 0
 77 19 79 0
 72 33 74 0
 70 71 73 0
 75 76 78 0
 5 35 104 0
 6 41 105 0
 18 19 77 0
 32 33 72 0
 56 53 70 0
 65 62 75 0
 57 90 96 0
 66 91 97 0
 43 61 62 0
 42 52 53 0
 65 75 78 0
 56 70 73 0
 53 52 70 0
 62 61 75 0
 33 34 74 0
 19 20 79 0
 83 84 85 0
 80 81 82 0
 105 79 118 0
 104 74 119 0
 77 79 105 0
 72 74 104 0
 42 30 52 0
 43 16 61 0
 78 76 107 0
 73 71 106 0
 50 22 80 0
 51 8 83 0
 75 47 76 0
 70 46 71 0
 87 92 98 0
 86 93 99 0
 52 46 70 0
 61 47 75 0
 83 9 84 0
 80 23 81 0
 44 11 87 0
 45 25 86 0
 80 82 100 0
 83 85 101 0
 44 87 98 0
 45 86 99 0
 21 22 50 0
 7 8 51 0
 64 62 65 0
 55 53 56 0
 65 78 91 0
 56 73 90 0
 64 65 66 0
 55 56 57 0
 9 10 84 0
 23 24 81 0
 31 46 52 0
 17 47 61 0
 74 34 103 0
 79 20 102 0
 31 32 46 0
 17 18 47 0
 47 18 77 0
 46 32 72 0
 43 63 95 0
 42 54 94 0
 63 62 64 0
 54 53 55 0
 22 23 80 0
 8 9 83 0
 24 25 45 0
 10 11 44 0
 43 62 63 0
 42 53 54 0
 76 105 107 0
 71 104 106 0
 15 16 43 0
 29 30 42 0
 67 66 68 0
 58 57 59 0
 95 63 114 0
 94 54 115 0
 113 89 121 0
 112 88 120 0
 26 48 86 0
 12 49 87 0
 30 31 52 0
 16 17 61 0
 25 26 86 0
 11 12 87 0
 36 35 121 0
 40 41 120 0
 57 56 90 0
 66 65 91 0
 26 27 48 0
 12 13 49 0
 76 47 77 0
 71 46 72 0
 88 40 120 0
 89 36 121 0
 64 66 67 0
 55 57 58 0
 50 79 102 0
 51 74 103 0
 67 68 69 0
 58 59 60 0
 29 42 94 0
 15 43 95 0
 60 59 88 0
 69 68 89 0
 85 113 121 0
 82 112 120 0
 106 36 116 0
 107 40 117 0
 28 29 94 0
 14 15 95 0
 63 64 92 0
 54 55 93 0
 79 50 118 0
 74 51 119 0
 59 57 96 0
 68 66 97 0
 49 95 114 0
 48 94 115 0
 64 67 92 0
 55 58 93 0
 3 21 102 0
 20 3 102 0
 1 7 103 0
 34 1 103 0
 50 80 100 0
 51 83 101 0
 4 28 110 0
 2 14 111 0
 13 2 111 0
 27 4 110 0
 69 89 113 0
 60 88 112 0
 35 36 106 0
 41 40 107 0
 73 106 116 0
 78 107 117 0
 21 50 102 0
 7 51 103 0
 38 39 96 0
 38 37 97 0
 91 78 117 0
 90 73 116 0
 85 84 113 0
 82 81 112 0
 40 88 108 0
 36 89 109 0
 92 67 98 0
 93 58 99 0
 86 48 115 0
 87 49 114 0
 37 90 116 0
 39 91 117 0
 6 105 118 0
 5 104 119 0
 76 77 105 0
 71 72 104 0
 14 95 111 0
 28 94 110 0
 92 87 114 0
 93 86 115 0
 96 39 108 0
 97 37 109 0
 48 27 110 0
 49 13 111 0
 88 59 108 0
 89 68 109 0
 67 69 98 0
 58 60 99 0
 39 40 108 0
 37 36 109 0
 94 48 110 0
 95 49 111 0
 59 96 108 0
 68 97 109 0
 36 37 116 0
 40 39 117 0
 63 92 114 0
 54 93 115 0
 50 100 118 0
 51 101 119 0
 100 6 118 0
 101 5 119 0
];
msh.PNT =[
 1 0
 2 0
 3 0
 4 0
 5 0
 6 0
];