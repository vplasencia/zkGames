pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/comparators.circom";

template Futoshiki() {
    signal input unsolved[4][4];
    signal input solved[4][4];

    // inequalities[i] = 0 means that there is no inequality in i. 
    // inequalities[i] = 1 means that there is the < inequality in i. 
    // inequalities[i] = 2 means that there is the > inequality in i. 
    signal input inequalities[24];



    // Check if the numbers of the solved futoshiki are >=1 and <=4
    // Each number in the solved futoshiki is checked to see if it is >=1 and <=4

    component getone[4][4];
    component letfour[4][4];

    
    for (var i = 0; i < 4; i++) {
       for (var j = 0; j < 4; j++) {
           letfour[i][j] = LessEqThan(32);
           letfour[i][j].in[0] <== solved[i][j];
           letfour[i][j].in[1] <== 4;

           getone[i][j] = GreaterEqThan(32);
           getone[i][j].in[0] <== solved[i][j];
           getone[i][j].in[1] <== 1;
           
           letfour[i][j].out ===  getone[i][j].out;
        }
    }
    

    // Check if unsolved is the initial state of solved
    // If unsolved[i][j] is not zero, it means that solved[i][j] is equal to unsolved[i][j]
    // If unsolved[i][j] is zero, it means that solved [i][j] is different from unsolved[i][j]

    component ieBoard[4][4];
    component izBoard[4][4];

    for (var i = 0; i < 4; i++) {
       for (var j = 0; j < 4; j++) {
            ieBoard[i][j] = IsEqual();
            ieBoard[i][j].in[0] <== solved[i][j];
            ieBoard[i][j].in[1] <== unsolved[i][j];

            izBoard[i][j] = IsZero();
            izBoard[i][j].in <== unsolved[i][j];

            ieBoard[i][j].out === 1 - izBoard[i][j].out;
        }
    }


    // Check if each row in solved has all the numbers from 1 to 4, both included 
    // For each element in solved, check that this element is not equal 
    // to previous elements in the same row

    // 24 = (1+2+3)*4
    component ieRow[24];

    var indexRow = 0;

    for (var i = 0; i < 4; i++) {
       for (var j = 0; j < 4; j++) {
            for (var k = 0; k < j; k++) {
                ieRow[indexRow] = IsEqual();
                ieRow[indexRow].in[0] <== solved[i][k];
                ieRow[indexRow].in[1] <== solved[i][j];
                ieRow[indexRow].out === 0;
                indexRow ++;
            }
        }
    }


    // Check if each column in solved has all the numbers from 1 to 4, both included
    // For each element in solved, check that this element is not equal 
    // to previous elements in the same column

    // 24 = (1+2+3)*4
    component ieCol[24];

    var indexCol = 0;

    for (var i = 0; i < 4; i++) {
       for (var j = 0; j < 4; j++) {
            for (var k = 0; k < i; k++) {
                ieCol[indexCol] = IsEqual();
                ieCol[indexCol].in[0] <== solved[k][j];
                ieCol[indexCol].in[1] <== solved[i][j];
                ieCol[indexCol].out === 0;
                indexCol ++;
            }
        }
    }


    // Check inequalities

    // ineqSolution[i] with i >= 0 and i < 12 relations in rows
    // ineqSolution[i] with i <= 12 and i < 24 relations in cols
    // if ineqSolution[i] is 1 or 2
    // if ineqSolution[i] = 1 means <
    // if ineqSolution[i] = 2 means >

    signal ineqSolution[24];
    var posIneqSolution = 0;

    // Compute inequalities for each row. 

    component gtRows[12];
    var pos = 0; 
    for(var i = 0; i < 4; i++){
        for(var j = 0; j < 3; j++) {
            gtRows[pos] = GreaterThan(32);
            gtRows[pos].in[0] <== solved[i][j];
            gtRows[pos].in[1] <== solved[i][j+1];

            // if solved[i][j] > solved[i][j+1] then ineqSolution[posIneqSolution] = 2
            // if solved[i][j] < solved[i][j+1] then ineqSolution[posIneqSolution] = 1

            ineqSolution[posIneqSolution] <== gtRows[pos].out + 1;
            posIneqSolution++;
            pos++;
        }
    }

    // Compute inequalities for each column

    component gtCols[12];
    signal ineqSolutionCols[12];
    pos = 0;
    for(var i = 0; i < 3; i++){
        for(var j = 0; j < 4; j++) {
            gtCols[pos] = GreaterThan(32);
            gtCols[pos].in[0] <== solved[i][j];
            gtCols[pos].in[1] <== solved[i+1][j];

            // if solved[i][j] > solved[i+1][j] then ineqSolution[posIneqSolution] = 2
            // if solved[i][j] < solved[i+1][j] then ineqSolution[posIneqSolution] = 1

            ineqSolution[posIneqSolution] <== gtCols[pos].out + 1;
            posIneqSolution++;
            pos++;
        }
    }

    // Check if(inequalities[i] != 0) then inequalities[i] == ineqSolution[i]

    component ieIneq[24];
    component izIneq[24];

    for(var i = 0; i < 24; i++) {
        ieIneq[i] = IsEqual();
        ieIneq[i].in[0] <== inequalities[i];
        ieIneq[i].in[1] <== ineqSolution[i];

        izIneq[i] = IsZero();
        izIneq[i].in <== inequalities[i];

        ieIneq[i].out === 1 - izIneq[i].out;

    }

    
}

// unsolved is a public input signal. It is the unsolved sudoku
component main {public [unsolved, inequalities]} = Futoshiki();