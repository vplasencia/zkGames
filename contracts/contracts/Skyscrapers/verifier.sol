//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// 2019 OKIMS
//      ported to solidity 0.6
//      fixed linter warnings
//      added requiere error messages
//
//
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

library Pairing {
    struct G1Point {
        uint256 X;
        uint256 Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint256[2] X;
        uint256[2] Y;
    }

    /// @return the generator of G1
    function P1() internal pure returns (G1Point memory) {
        return G1Point(1, 2);
    }

    /// @return the generator of G2
    function P2() internal pure returns (G2Point memory) {
        // Original code point
        return
            G2Point(
                [
                    11559732032986387107991004021392285783925812861821192530917403151452391805634,
                    10857046999023057135944570762232829481370756359578518086990519993285655852781
                ],
                [
                    4082367875863433681332203403145435568316851327593401208105741076214120093531,
                    8495653923123431417604973247489272438418190587263600148770280649306958101930
                ]
            );

        /*
        // Changed by Jordi point
        return G2Point(
            [10857046999023057135944570762232829481370756359578518086990519993285655852781,
             11559732032986387107991004021392285783925812861821192530917403151452391805634],
            [8495653923123431417604973247489272438418190587263600148770280649306958101930,
             4082367875863433681332203403145435568316851327593401208105741076214120093531]
        );
*/
    }

    /// @return r the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point memory p) internal pure returns (G1Point memory r) {
        // The prime q in the base field F_q for G1
        uint256 q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0) return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }

    /// @return r the sum of two points of G1
    function addition(G1Point memory p1, G1Point memory p2)
        internal
        view
        returns (G1Point memory r)
    {
        uint256[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success
            case 0 {
                invalid()
            }
        }
        require(success, "pairing-add-failed");
    }

    /// @return r the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point memory p, uint256 s)
        internal
        view
        returns (G1Point memory r)
    {
        uint256[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success
            case 0 {
                invalid()
            }
        }
        require(success, "pairing-mul-failed");
    }

    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] memory p1, G2Point[] memory p2)
        internal
        view
        returns (bool)
    {
        require(p1.length == p2.length, "pairing-lengths-failed");
        uint256 elements = p1.length;
        uint256 inputSize = elements * 6;
        uint256[] memory input = new uint256[](inputSize);
        for (uint256 i = 0; i < elements; i++) {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint256[1] memory out;
        bool success;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := staticcall(
                sub(gas(), 2000),
                8,
                add(input, 0x20),
                mul(inputSize, 0x20),
                out,
                0x20
            )
            // Use "invalid" to make gas estimation work
            switch success
            case 0 {
                invalid()
            }
        }
        require(success, "pairing-opcode-failed");
        return out[0] != 0;
    }

    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(
        G1Point memory a1,
        G2Point memory a2,
        G1Point memory b1,
        G2Point memory b2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }

    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
        G1Point memory a1,
        G2Point memory a2,
        G1Point memory b1,
        G2Point memory b2,
        G1Point memory c1,
        G2Point memory c2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }

    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
        G1Point memory a1,
        G2Point memory a2,
        G1Point memory b1,
        G2Point memory b2,
        G1Point memory c1,
        G2Point memory c2,
        G1Point memory d1,
        G2Point memory d2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}

contract SkyscrapersVerifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G1Point alfa1;
        Pairing.G2Point beta2;
        Pairing.G2Point gamma2;
        Pairing.G2Point delta2;
        Pairing.G1Point[] IC;
    }
    struct Proof {
        Pairing.G1Point A;
        Pairing.G2Point B;
        Pairing.G1Point C;
    }

    function verifyingKey() internal pure returns (VerifyingKey memory vk) {
        vk.alfa1 = Pairing.G1Point(
            12808198727013166908581179921107009124864743614616711749032272492793194432621,
            15342076796213874231575657626713432910691242598286322079301796152872777030014
        );

        vk.beta2 = Pairing.G2Point(
            [
                11493597054783747021896764952152366597334537725493129692450363335316845234998,
                18315559770861689997557852491373072942420910746653400234867516477963471848964
            ],
            [
                184741289837048174203602728307277231152436183562182123452835671421668194046,
                15493085463211155828799092337938969261379919328936567251372932105773077760402
            ]
        );
        vk.gamma2 = Pairing.G2Point(
            [
                11559732032986387107991004021392285783925812861821192530917403151452391805634,
                10857046999023057135944570762232829481370756359578518086990519993285655852781
            ],
            [
                4082367875863433681332203403145435568316851327593401208105741076214120093531,
                8495653923123431417604973247489272438418190587263600148770280649306958101930
            ]
        );
        vk.delta2 = Pairing.G2Point(
            [
                19478957687179488707565192396741420702558479002660618606860848947763237704553,
                11841775623916006276748574695161308177837862413130277775144406826391882688299
            ],
            [
                759271581411378582368119088581875774797336686955228982734333444170156449553,
                5704069035768354681618625705075321706999762263335828805001164821804382821914
            ]
        );
        vk.IC = new Pairing.G1Point[](46);

        vk.IC[0] = Pairing.G1Point(
            10180811248431171744143944573107001988835394776082749788677365338432884783585,
            9884406016181141369234142712972713754115073439974310914623967256626887649195
        );

        vk.IC[1] = Pairing.G1Point(
            9278888182375240798195944208269529590117527165611157942182294333309131524473,
            3453716212064690432566974616950433522132006394938942338565795121844972097676
        );

        vk.IC[2] = Pairing.G1Point(
            19285097173501193539536297631390967232734148800771464948115375061738324823986,
            21635473398260583918614433794702144621259288862123750738536717084159614960876
        );

        vk.IC[3] = Pairing.G1Point(
            4864169883759152806603411540048377723908007005433051925083050338053089770907,
            5677274070940518761925367826608022988175692458717779421811302118712250724922
        );

        vk.IC[4] = Pairing.G1Point(
            14913855340686810875304835420045350180224261544038596754604795649740984940947,
            714705504201776524585456874448938501249422243750128740589865870173172460693
        );

        vk.IC[5] = Pairing.G1Point(
            14825514008130997865619163260627329184411932288101425744832692347885406656201,
            9294607734053460758376470288284125626949561995127055789417986703734048885866
        );

        vk.IC[6] = Pairing.G1Point(
            5548843219545023131204964967257352699834511884194778357405044120782878955698,
            12363136876913525636137803520239482403391667412719349703335085364757523271893
        );

        vk.IC[7] = Pairing.G1Point(
            3125366613889396839616586559745076966704740429323592459102468111195035031758,
            18118568957645077865119500638257584064865544377636684937766338936941804519226
        );

        vk.IC[8] = Pairing.G1Point(
            12331628958830645078724645073888235982247673097872605644865530563434777563510,
            3215961480102682515847236485119573695851470523490018730894094427358324051447
        );

        vk.IC[9] = Pairing.G1Point(
            748709195445613377850518239541333140877347483781981803388249106480823430665,
            21115474709708743583450984843305815184774174977139427635184362569965344841648
        );

        vk.IC[10] = Pairing.G1Point(
            18506127382594092825880961827071609172186611992821791270575637631674831967652,
            2262033923561170267576425163404725897416145755907485256601994248702731248040
        );

        vk.IC[11] = Pairing.G1Point(
            4935783776448434904189945943279660572137102760945109792517207274621435897821,
            18500929911729394149963692022487320198785696941829510796508193169082931515370
        );

        vk.IC[12] = Pairing.G1Point(
            21348743567108696458236905892963470373063989264635440674409107488952456030461,
            18432663666489852323427746748483684934437129933414644446038988680042171552856
        );

        vk.IC[13] = Pairing.G1Point(
            15373794933517021563656297493321105562510469349788715736888749282402172281841,
            5825962073758875161042455672567244954246156042745442538519417012028869367711
        );

        vk.IC[14] = Pairing.G1Point(
            18772005132181035101267806218977273392047848366331254408789115202320048178947,
            7469618307335463022515493592443571082313991214649291336139020459504449426151
        );

        vk.IC[15] = Pairing.G1Point(
            4811589952029730031594783186962790940659830658755720918203261507704788561682,
            5214106918701803352941470662053665067195331174715304019607736107061661162
        );

        vk.IC[16] = Pairing.G1Point(
            10060501956782813892518043436926590130675407325649503411003900020058135758362,
            8001773651789010026167549278812199135171388175086364045572531298005921384164
        );

        vk.IC[17] = Pairing.G1Point(
            4094562454113412759084437311374461404349750116286900111222905267787444018783,
            16496471690200121581478938634622933428781255496685436806059837922621951415890
        );

        vk.IC[18] = Pairing.G1Point(
            14814151200961035604952922430750394292307697267951043459414191039707696130034,
            5160184857889437581567077210195417101362070143457764365098544320214476401929
        );

        vk.IC[19] = Pairing.G1Point(
            17183263211737366645751658340812048999669567660575124232666088065973323094830,
            4059817773540728560276382278324761093273321475160393559588585148530467239823
        );

        vk.IC[20] = Pairing.G1Point(
            19164719214842812608951234240641309169722833963029863816896777495838125141646,
            2239606495873407208021772945048801505800908636624791876697413067652305884375
        );

        vk.IC[21] = Pairing.G1Point(
            14024001200769462139737320058561149391208029145380108485100263204713031704655,
            14539118650996882860708329461972228739093695850691556372610826418203675888326
        );

        vk.IC[22] = Pairing.G1Point(
            16469838394276230533532962963606157787714043515796265834463963011198435888347,
            16363869329433429019552158555164920377905666543077747690505824658263308594786
        );

        vk.IC[23] = Pairing.G1Point(
            9397261259850291014920179215369766575979935847946594314677606477779240995659,
            8026936457867831046804863622162457761617140032204516169016080996972476197549
        );

        vk.IC[24] = Pairing.G1Point(
            4986527525581717184148100113570362898512461532395347325006271987064608885053,
            14428909309336946862091445356531708350754565614347772201531005059713626378587
        );

        vk.IC[25] = Pairing.G1Point(
            17057316509284073423064013818432779161355688901365042317786963544838551930839,
            8453867361460840222361960822389472595062968349484363242124547844250221839695
        );

        vk.IC[26] = Pairing.G1Point(
            8828628446239915876537348037802296940665158403326362803104250569076231495157,
            8435077768101913800387397675877880795553847565057349159730117392414996110893
        );

        vk.IC[27] = Pairing.G1Point(
            16457201128889646657760270697673994829047716532685427741944735335359842707895,
            15278003170183532736449432571953871749052621547593744111384841266227472964419
        );

        vk.IC[28] = Pairing.G1Point(
            4904080463224134769425553917229811643600379944450501014335669572750232930483,
            13496924091187248445493634536051716564275629376429295591828255704431264000428
        );

        vk.IC[29] = Pairing.G1Point(
            8153943513037827484108366227558759706288112985886036464319758881397210969879,
            8578713112732275367448698624202222087804109210673628238354036790369677811198
        );

        vk.IC[30] = Pairing.G1Point(
            20749859192860207624351710454229053988303154957769668197342093391432312438393,
            2172589029474204429188218948065799105560162893789958980716129798042225447075
        );

        vk.IC[31] = Pairing.G1Point(
            18359905018556997636822751690463692543056065704425981988337589245490737299475,
            4134007863089671055251079200869456524532388641004726631496059775320048709004
        );

        vk.IC[32] = Pairing.G1Point(
            13759707824817514891932950224363057006130024881637813352704371210619919610336,
            3745876690030308703074992673470498585074850676090513725060460281015141612026
        );

        vk.IC[33] = Pairing.G1Point(
            6289306873070813650407995475169078436783859276604406683697851524589606431962,
            263238490455155502929434422197347111907920945744295566604199796577037710742
        );

        vk.IC[34] = Pairing.G1Point(
            11452770039926302432488127345353973037204735357060193336907737764768536815003,
            7725846835905789133072173040229477602059983742386876178058795886475518492068
        );

        vk.IC[35] = Pairing.G1Point(
            9215972742544338042738159340297406958431826652697644590818654923311455826254,
            5327524386194931691418514304898101301665882513006738543911452685597937998459
        );

        vk.IC[36] = Pairing.G1Point(
            6677840770504797963046931469470428333360766838346842002050371538186140043821,
            1972379909122640399108708843098806421205712469791014650405958420302200274478
        );

        vk.IC[37] = Pairing.G1Point(
            7571869128490994960456301708781726031616120342873477963922275362355130387103,
            16317812752190415290292213673838972047247069555223255313924662352285924114658
        );

        vk.IC[38] = Pairing.G1Point(
            10662378350913235276612362139841978585858150510311434032775350765281451883754,
            12848037599486086534496843037012153408021135184120934897178372572031820313014
        );

        vk.IC[39] = Pairing.G1Point(
            661622026953851975123788363695422194635662665239374764469776238787407521840,
            19140056168288094853864210868361586009941614850866762644398879460088681197387
        );

        vk.IC[40] = Pairing.G1Point(
            16398503904937524109393214853120827095864515042376641985669773480720609646681,
            15828589565039970841532927181665350927288738668801988732561517281559878248975
        );

        vk.IC[41] = Pairing.G1Point(
            1959074274914110203547369492451420226307152131265460195924607156452053640580,
            5843275380309290867730477863192004731575089067649198824666194749422120844859
        );

        vk.IC[42] = Pairing.G1Point(
            10714914943698258823197523796100569826334192139632794075186243341468349681144,
            20649281286488855637516713915700341333831581204852391093606319366768116818358
        );

        vk.IC[43] = Pairing.G1Point(
            17704222071881538722701202119805187592777446773243041980778981546357586537677,
            15001399583343290824971310206066875568613759486163096023720291984360483559498
        );

        vk.IC[44] = Pairing.G1Point(
            9532452878303266103071432678233750016006469911665009769620850924939971448641,
            16992691050001953712202618673439864049623712735664850696321608993979885058967
        );

        vk.IC[45] = Pairing.G1Point(
            5135587226329460894378571182075048688361442195091424641949056654981141046513,
            16628202103712644091944363037427178907196130114913867665154081514159656133682
        );
    }

    function verify(uint256[] memory input, Proof memory proof)
        internal
        view
        returns (uint256)
    {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.IC.length, "verifier-bad-input");
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint256 i = 0; i < input.length; i++) {
            require(
                input[i] < snark_scalar_field,
                "verifier-gte-snark-scalar-field"
            );
            vk_x = Pairing.addition(
                vk_x,
                Pairing.scalar_mul(vk.IC[i + 1], input[i])
            );
        }
        vk_x = Pairing.addition(vk_x, vk.IC[0]);
        if (
            !Pairing.pairingProd4(
                Pairing.negate(proof.A),
                proof.B,
                vk.alfa1,
                vk.beta2,
                vk_x,
                vk.gamma2,
                proof.C,
                vk.delta2
            )
        ) return 1;
        return 0;
    }

    /// @return r  bool true if proof is valid
    function verifyProof(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[45] memory input
    ) public view returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        uint256[] memory inputValues = new uint256[](input.length);
        for (uint256 i = 0; i < input.length; i++) {
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }
}
