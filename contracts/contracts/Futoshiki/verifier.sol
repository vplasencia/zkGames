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
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() internal pure returns (G1Point memory) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() internal pure returns (G2Point memory) {
        // Original code point
        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
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
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return r the sum of two points of G1
    function addition(G1Point memory p1, G1Point memory p2) internal view returns (G1Point memory r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success,"pairing-add-failed");
    }
    /// @return r the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point memory p, uint s) internal view returns (G1Point memory r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success,"pairing-mul-failed");
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] memory p1, G2Point[] memory p2) internal view returns (bool) {
        require(p1.length == p2.length,"pairing-lengths-failed");
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint[1] memory out;
        bool success;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success,"pairing-opcode-failed");
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2) internal view returns (bool) {
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
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2
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
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2,
            G1Point memory d1, G2Point memory d2
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
contract FutoshikiVerifier {
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
            17990839064293588917489094234760766112814366507850766039045741687262452015463,
            3081523405176116600715016167950189992268373852437131499238426765693821835932
        );

        vk.beta2 = Pairing.G2Point(
            [17468361313098208904543511517911272024158035534422691717247288923127362495538,
             12258436564011567414464845642600216544525621353886605296958927510856061202910],
            [16896002099906213320994961522075662147838106385001764225306593623102520059553,
             7535329379251328667525378515293707655107676993877322908381988259800119161040]
        );
        vk.gamma2 = Pairing.G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );
        vk.delta2 = Pairing.G2Point(
            [3628882619380661110758436854578302725526485913739448678953726888636630564311,
             9864218264832769140586916945169612229883850639144839177412047356543792802188],
            [5200346157134165491468789807985037395126868633677598814939642892367847714615,
             10505545515421879201611204750967526240139441897730331239919645388479803836340]
        );
        vk.IC = new Pairing.G1Point[](41);
        
        vk.IC[0] = Pairing.G1Point( 
            7914319262129792222315855196547605361843435550983651477304232421767863784442,
            10192649763038380684825025345481824230383414829629740222406551252122574660787
        );                                      
        
        vk.IC[1] = Pairing.G1Point( 
            1605456067839026466856791605462297671075023948752218570800629442197794251809,
            13786191074461891735630322301532509060119667947763500956399582701628387881554
        );                                      
        
        vk.IC[2] = Pairing.G1Point( 
            12055996650307079121124270868885796984848711497012741108403242905896444581006,
            8363957248179000088764450203488380013207983380833594126724122236742164877196
        );                                      
        
        vk.IC[3] = Pairing.G1Point( 
            17462679008749437802508577340202613203459020255053921987996812480797476575016,
            10827463973397116903661399706967449982040581162096225461718449467307639230525
        );                                      
        
        vk.IC[4] = Pairing.G1Point( 
            17651359924038472214876291447160717492115119589906055362217752053419170927627,
            2077473703979413636596753377264339576583388657864043540695231864299265315878
        );                                      
        
        vk.IC[5] = Pairing.G1Point( 
            20516002311345273876010261857540014507624292131502569812020968118866305268631,
            16468413222173070106030875321601016232167977316435599626565639916805716122433
        );                                      
        
        vk.IC[6] = Pairing.G1Point( 
            19648922779260472050803231632958441647171237797479640146892631921441872212818,
            2825002952033892983566836301933492813045896240235976688965309942820462487247
        );                                      
        
        vk.IC[7] = Pairing.G1Point( 
            14431346876179824590739814726376146980726353336296323935438808531747970352183,
            18313886328453880620956468135661091107758426710282573513880106777411715892289
        );                                      
        
        vk.IC[8] = Pairing.G1Point( 
            20463826559095290746077251227615311677481149693866085389312857706821938291467,
            7417487821905755209468300517222083119489657763692589501150437516515809971815
        );                                      
        
        vk.IC[9] = Pairing.G1Point( 
            13806253023779098361805938897110015588214013798740811840911941947178682417270,
            4971726588362195884699797625065696862049508126927298472873607231373246555831
        );                                      
        
        vk.IC[10] = Pairing.G1Point( 
            15988116905231565333264426283876082195931401128098474374829277195143673466282,
            6820965562204435956610429543182809227645716786441081142247738200146764945660
        );                                      
        
        vk.IC[11] = Pairing.G1Point( 
            2470848658638442689343627536994517918444950838153639801003874936906438341139,
            3347261196191503362810596102591282131485871445984920043236628724604708771448
        );                                      
        
        vk.IC[12] = Pairing.G1Point( 
            11071061818000463281994658794418948092192687449663273360016310057747934418261,
            3957590122140954267771754094035177316956067540706172426375257966314916372425
        );                                      
        
        vk.IC[13] = Pairing.G1Point( 
            8746592224122611837718387554640282495354525116778404689951373100546353747094,
            6874766532793065290579090893652797518466738088377725500551251513470130691978
        );                                      
        
        vk.IC[14] = Pairing.G1Point( 
            17527541556262038376488276657678457240655459045754834059144914517021660754968,
            12226943268001503213073668097195319957464103896358258086753279285172955291980
        );                                      
        
        vk.IC[15] = Pairing.G1Point( 
            17007894148897539599708922927610588752517859862988731578000268947541156330573,
            19237909702757134901885723700531998320099906945958752753848692015660439523679
        );                                      
        
        vk.IC[16] = Pairing.G1Point( 
            14022166430781323942398220453339201549221956267934650531077013352983723127426,
            10087002154430662341805835657665256654058011439349157735327300113671897922016
        );                                      
        
        vk.IC[17] = Pairing.G1Point( 
            10820970855836135114835920948723467194416801035216489289772123962730381479505,
            3592751396642423957118920665147785391692921689954853143643187680885130159067
        );                                      
        
        vk.IC[18] = Pairing.G1Point( 
            19497364851633871859859757085726672174910539067614577598979447016381452110044,
            8624210133538492932673211368401011169814654632495542087833800870332985476674
        );                                      
        
        vk.IC[19] = Pairing.G1Point( 
            20206798475005618356283954233094646659536676975938309575165050874522734392520,
            18458807002290590052714462221775307346426355079521996075054801416175351765746
        );                                      
        
        vk.IC[20] = Pairing.G1Point( 
            17094715254377813927719226180964919074765957476421464952521042582075938042816,
            10415285391132908294254781440341339983125428054314668052145858008955447515700
        );                                      
        
        vk.IC[21] = Pairing.G1Point( 
            14691421900427545646556080664187039587892678888116452408247779215053352073852,
            9489530870254220364746213333565057923877151166809288343799452289569691611225
        );                                      
        
        vk.IC[22] = Pairing.G1Point( 
            2553093957052684172489131053643876436682850201575485149616012817428597838260,
            6817094919302433625186256795050018462737977381832406411739374826931741579718
        );                                      
        
        vk.IC[23] = Pairing.G1Point( 
            19726306502568206431547711718257685519165640614173089368618588570384536597969,
            4895573751229321217102455499208924912492249291213084987225712091360749279693
        );                                      
        
        vk.IC[24] = Pairing.G1Point( 
            11977705341180075175449927460144840432539289526097233679031036047774996252602,
            12380482839675177860453755736494812049957954852046235469494836071359215906347
        );                                      
        
        vk.IC[25] = Pairing.G1Point( 
            9108312507413099147907422545133409643122436192825268714552370436670288833709,
            17096225835027678377282316157347952980976989471114017243367354052405713105386
        );                                      
        
        vk.IC[26] = Pairing.G1Point( 
            17217599531016275992264430457246510556479063244642296957043049701447237073419,
            16129032039957224472335674329916610843216787093768741264190940241042504371721
        );                                      
        
        vk.IC[27] = Pairing.G1Point( 
            15423146413929917860271672342725239193419620776081477586557800895364859590199,
            8387973975245442582375200519527886362499835593346277388377769422805254263319
        );                                      
        
        vk.IC[28] = Pairing.G1Point( 
            6283725514021922505044751258338122122419119716951578018511485790493253046410,
            2666862931805402819776889304172415069886376777427613166994486319497790778965
        );                                      
        
        vk.IC[29] = Pairing.G1Point( 
            10722895086233863569464553580597801530104742948312611857802958915573524599855,
            14228127968241477865356683542558194418573602376619897909201843458754433096719
        );                                      
        
        vk.IC[30] = Pairing.G1Point( 
            1099403649131142214409410388573450193468386242872321862674962375769714053635,
            21276626373594539295991438715079811387048769083950151666957564711742366133471
        );                                      
        
        vk.IC[31] = Pairing.G1Point( 
            14893959307341123153777699824737328556051142661471260163141140857337495437384,
            10385867558149605771847858060612017504077718145162025528368855412328037196380
        );                                      
        
        vk.IC[32] = Pairing.G1Point( 
            10102999871035967054476139388299094930149245082904604213054611903956190576835,
            2155639235477009129064251209666518483464737064390951486223658084748823038713
        );                                      
        
        vk.IC[33] = Pairing.G1Point( 
            2181933486309896183755292670775264566136290506636697155536890898599693333780,
            4610349643245829228613335320268669546494170361269962542728177864812821609532
        );                                      
        
        vk.IC[34] = Pairing.G1Point( 
            2306798746224185707480435494996838898310956925158821537033353151585293564041,
            3119976178670223477863919006068845827792138990639208143930635558162675649531
        );                                      
        
        vk.IC[35] = Pairing.G1Point( 
            7262675915543572335487749593647683633821590521450801477262807240259108010295,
            14427712987582294823642755404819466944340634856873899637382623285557156824769
        );                                      
        
        vk.IC[36] = Pairing.G1Point( 
            16982571265264498927539372558153897839268746901545499333857453136952057107491,
            4110372329564255996060074050495730543876740925340571619192294563160794600743
        );                                      
        
        vk.IC[37] = Pairing.G1Point( 
            7447631165886503174293402511593630611215842554563896310565222935894203105367,
            16809477908497151801539591121038190158764275201298046534412898505695008339960
        );                                      
        
        vk.IC[38] = Pairing.G1Point( 
            16114938559007076593908745662821992090085150266369468088352729464830379778091,
            13815058889449911731403008037499939511241053050705762546373158639398851904455
        );                                      
        
        vk.IC[39] = Pairing.G1Point( 
            16803009835139799200382095398244576082528364559582161301166914843293371256029,
            17419988385824377675136505544956692666128718868967318235833379952181883113354
        );                                      
        
        vk.IC[40] = Pairing.G1Point( 
            19763926623541392627825647941920340429138335766772951113008820722943633474114,
            15502283941036758289637480835576303883130894512182371938772756263006853224860
        );                                      
        
    }
    function verify(uint[] memory input, Proof memory proof) internal view returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.IC.length,"verifier-bad-input");
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field,"verifier-gte-snark-scalar-field");
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.IC[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.IC[0]);
        if (!Pairing.pairingProd4(
            Pairing.negate(proof.A), proof.B,
            vk.alfa1, vk.beta2,
            vk_x, vk.gamma2,
            proof.C, vk.delta2
        )) return 1;
        return 0;
    }
    /// @return r  bool true if proof is valid
    function verifyProof(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[40] memory input
        ) public view returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }
}
