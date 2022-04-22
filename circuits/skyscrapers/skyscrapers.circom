pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";

template Skyscrapers() {
    signal input unsolved[5][5];
    signal input solved[5][5];

    // List of skyscrapers amount in the order: left, right, top and bottom (first rows and then columns) 
    // If there is not skyscraper in some position, the number will be 0  
    signal input skyscrapersAmount[20];



    // Check if the numbers of the solved skyscrapers are >=1 and <=5
    // Each number in the solved skyscrapers is checked to see if it is >=1 and <=5

    component getone[5][5];
    component letfive[5][5];

    
    for (var i = 0; i < 5; i++) {
       for (var j = 0; j < 5; j++) {
           letfive[i][j] = LessEqThan(32);
           letfive[i][j].in[0] <== solved[i][j];
           letfive[i][j].in[1] <== 5;

           getone[i][j] = GreaterEqThan(32);
           getone[i][j].in[0] <== solved[i][j];
           getone[i][j].in[1] <== 1;
           
           letfive[i][j].out ===  getone[i][j].out;
        }
    }
    

    // Check if unsolved is the initial state of solved
    // If unsolved[i][j] is not zero, it means that solved[i][j] is equal to unsolved[i][j]
    // If unsolved[i][j] is zero, it means that solved [i][j] is different from unsolved[i][j]

    component ieBoard[5][5];
    component izBoard[5][5];

    for (var i = 0; i < 5; i++) {
       for (var j = 0; j < 5; j++) {
            ieBoard[i][j] = IsEqual();
            ieBoard[i][j].in[0] <== solved[i][j];
            ieBoard[i][j].in[1] <== unsolved[i][j];

            izBoard[i][j] = IsZero();
            izBoard[i][j].in <== unsolved[i][j];

            ieBoard[i][j].out === 1 - izBoard[i][j].out;
        }
    }


    // Check if each row in solved has all the numbers from 1 to 5, both included 
    // For each element in solved, check that this element is not equal 
    // to previous elements in the same row

    // 50 = (1+2+3+4)*5
    component ieRow[50];

    var indexRow = 0;

    for (var i = 0; i < 5; i++) {
       for (var j = 0; j < 5; j++) {
            for (var k = 0; k < j; k++) {
                ieRow[indexRow] = IsEqual();
                ieRow[indexRow].in[0] <== solved[i][k];
                ieRow[indexRow].in[1] <== solved[i][j];
                ieRow[indexRow].out === 0;
                indexRow ++;
            }
        }
    }


    // Check if each column in solved has all the numbers from 1 to 5, both included
    // For each element in solved, check that this element is not equal 
    // to previous elements in the same column

    // 50 = (1+2+3+4)*5
    component ieCol[50];

    var indexCol = 0;

    for (var i = 0; i < 5; i++) {
       for (var j = 0; j < 5; j++) {
            for (var k = 0; k < i; k++) {
                ieCol[indexCol] = IsEqual();
                ieCol[indexCol].in[0] <== solved[k][j];
                ieCol[indexCol].in[1] <== solved[i][j];
                ieCol[indexCol].out === 0;
                indexCol ++;
            }
        }
    }


    // Check skyscrapers amount


    // Check left skyscrapersList. This is skyscrapersAmount indexed from 0 to 4, both included

    signal higherValueRowLeft[25];
    var posHigherValueRowLeft = 0;

    var amountRowLeft = 1;

    component gtNumberRowLeft[20];
    var posGtNumberRowLeft = 0; 

    component izSkyscrapersAmountRowLeft[5];
    component ieAmountRowLeft[5];

    for (var i = 0; i < 5; i++) {
        higherValueRowLeft[posHigherValueRowLeft] <== solved[i][0];
        posHigherValueRowLeft++;
        amountRowLeft = 1;
       for (var j = 1; j < 5; j++) {
            gtNumberRowLeft[posGtNumberRowLeft] = GreaterThan(32);
            gtNumberRowLeft[posGtNumberRowLeft].in[0] <== solved[i][j];
            gtNumberRowLeft[posGtNumberRowLeft].in[1] <== higherValueRowLeft[posHigherValueRowLeft-1];
            amountRowLeft += gtNumberRowLeft[posGtNumberRowLeft].out;
            higherValueRowLeft[posHigherValueRowLeft] <== higherValueRowLeft[posHigherValueRowLeft-1] + (solved[i][j]-higherValueRowLeft[posHigherValueRowLeft-1])*gtNumberRowLeft[posGtNumberRowLeft].out;
            posHigherValueRowLeft++;
            posGtNumberRowLeft++;
        }
        
        ieAmountRowLeft[i] = IsEqual();
        ieAmountRowLeft[i].in[0] <== amountRowLeft;
        ieAmountRowLeft[i].in[1] <== skyscrapersAmount[i];

        izSkyscrapersAmountRowLeft[i] = IsZero();
        izSkyscrapersAmountRowLeft[i].in <== skyscrapersAmount[i];


        ieAmountRowLeft[i].out === 1 - izSkyscrapersAmountRowLeft[i].out;
    }

    // Check right skyscrapersList. This is skyscrapersAmount indexed from 5 to 9, both included


    signal higherValueRowRight[25];
    var posHigherValueRowRight = 0;

    var amountRowRight = 1;

    component gtNumberRowRight[20];
    var posGtNumberRowRight = 0; 

    component izSkyscrapersAmountRowRight[5];
    component ieAmountRowRight[5];

    for (var i = 0; i < 5; i++) {
        higherValueRowRight[posHigherValueRowRight] <== solved[i][4];
        posHigherValueRowRight++;
        amountRowRight = 1;
       for (var j = 3; j >= 0; j--) {
            gtNumberRowRight[posGtNumberRowRight] = GreaterThan(32);
            gtNumberRowRight[posGtNumberRowRight].in[0] <== solved[i][j];
            gtNumberRowRight[posGtNumberRowRight].in[1] <== higherValueRowRight[posHigherValueRowRight-1];
            amountRowRight += gtNumberRowRight[posGtNumberRowRight].out;
            higherValueRowRight[posHigherValueRowRight] <== higherValueRowRight[posHigherValueRowRight-1] + (solved[i][j]-higherValueRowRight[posHigherValueRowRight-1])*gtNumberRowRight[posGtNumberRowRight].out;
            posHigherValueRowRight++;
            posGtNumberRowRight++;
        }
        
        ieAmountRowRight[i] = IsEqual();
        ieAmountRowRight[i].in[0] <== amountRowRight;
        ieAmountRowRight[i].in[1] <== skyscrapersAmount[i+5];

        izSkyscrapersAmountRowRight[i] = IsZero();
        izSkyscrapersAmountRowRight[i].in <== skyscrapersAmount[i+5];


        ieAmountRowRight[i].out === 1 - izSkyscrapersAmountRowRight[i].out;
    }


    // Check top skyscrapersList. This is skyscrapersAmount indexed from 10 to 14, both included

    signal higherValueColTop[25];
    var posHigherValueColTop = 0;

    var amountColTop = 1;

    component gtNumberColTop[20];
    var posGtNumberColTop = 0; 

    component izSkyscrapersAmountColTop[5];
    component ieAmountColTop[5];
    

    for (var i = 0; i < 5; i++) {
        higherValueColTop[posHigherValueColTop] <== solved[0][i];
        posHigherValueColTop++;
        amountColTop = 1;
       for (var j = 1; j < 5; j++) {
            gtNumberColTop[posGtNumberColTop] = GreaterThan(32);
            gtNumberColTop[posGtNumberColTop].in[0] <== solved[j][i];
            gtNumberColTop[posGtNumberColTop].in[1] <== higherValueColTop[posHigherValueColTop-1];
            amountColTop += gtNumberColTop[posGtNumberColTop].out;
            higherValueColTop[posHigherValueColTop] <== higherValueColTop[posHigherValueColTop-1] + (solved[j][i]-higherValueColTop[posHigherValueColTop-1])*gtNumberColTop[posGtNumberColTop].out;
            posHigherValueColTop++;
            posGtNumberColTop++;
        }
        
        ieAmountColTop[i] = IsEqual();
        ieAmountColTop[i].in[0] <== amountColTop;
        ieAmountColTop[i].in[1] <== skyscrapersAmount[i+10];

        izSkyscrapersAmountColTop[i] = IsZero();
        izSkyscrapersAmountColTop[i].in <== skyscrapersAmount[i+10];

        ieAmountColTop[i].out === 1 - izSkyscrapersAmountColTop[i].out;
    }


    // Check bottom skyscrapersList. This is skyscrapersAmount indexed from 15 to 19, both included


    signal higherValueColBottom[25];
    var posHigherValueColBottom = 0;

    var amountColBottom = 1;

    component gtNumberColBottom[20];
    var posGtNumberColBottom = 0; 

    component izSkyscrapersAmountColBottom[5];
    component ieAmountColBottom[5];

    for (var i = 0; i < 5; i++) {
        higherValueColBottom[posHigherValueColBottom] <== solved[4][i];
        posHigherValueColBottom++;
        amountColBottom = 1;
       for (var j = 3; j >= 0; j--) {
            gtNumberColBottom[posGtNumberColBottom] = GreaterThan(32);
            gtNumberColBottom[posGtNumberColBottom].in[0] <== solved[j][i];
            gtNumberColBottom[posGtNumberColBottom].in[1] <== higherValueColBottom[posHigherValueColBottom-1];
            amountColBottom += gtNumberColBottom[posGtNumberColBottom].out;
            higherValueColBottom[posHigherValueColBottom] <== higherValueColBottom[posHigherValueColBottom-1] + (solved[j][i]-higherValueColBottom[posHigherValueColBottom-1])*gtNumberColBottom[posGtNumberColBottom].out;
            posHigherValueColBottom++;
            posGtNumberColBottom++;
        }
        
        ieAmountColBottom[i] = IsEqual();
        ieAmountColBottom[i].in[0] <== amountColBottom;
        ieAmountColBottom[i].in[1] <== skyscrapersAmount[i+15];

        izSkyscrapersAmountColBottom[i] = IsZero();
        izSkyscrapersAmountColBottom[i].in <== skyscrapersAmount[i+15];


        ieAmountColBottom[i].out === 1 - izSkyscrapersAmountColBottom[i].out;
    }
    
}

// unsolved is a public input signal. It is the unsolved skyscrapers
// skyscrapersAmount is a public signal. It is the list of skyscrapers amount
component main {public [unsolved, skyscrapersAmount]} = Skyscrapers();