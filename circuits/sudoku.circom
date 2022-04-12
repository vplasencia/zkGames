pragma circom 2.0.0;

template Sudoku() {
    signal input unsolved[9][9];
    signal input solved[9][9];

    // check if unsolved is the initial state of solved


    var result = 1;
    
    for (var i = 0; i < 9; i++) {
       for (var j = 0; j < 9; j++) {
           if(unsolved[i][j] != 0) {
            result *= unsolved[i][j] == solved[i][j];
           }
        }
    }

    signal resultSignal;
    resultSignal <-- result;

    resultSignal === 1;


    // check if solved sudoku numbers are >=1 and <=9

    var range = 1;
    
    for (var i = 0; i < 9; i++) {
       for (var j = 0; j < 9; j++) {
           range *= solved[i][j] >=1 && solved[i][j] <=9;
        }
    }

    signal rangeSignal;
    rangeSignal <-- range;

    rangeSignal === 1;


    // check rows of solved sudoku

    // hasNumberRow[i][j] means that the number j+1 is in the row i

    var hasNumberRow[9][9];

    for (var i = 0; i < 9; i++) {
       for (var j = 0; j < 9; j++) {
           hasNumberRow[i][solved[i][j]-1] = 1;
        }
    }

    var MultResultRow = 1;

    for (var i = 0; i < 9; i++) {
       for (var j = 0; j < 9; j++) {
           MultResultRow *= hasNumberRow[i][j];
        }
    }

    signal MultResultRowSignal;
    MultResultRowSignal <-- MultResultRow;

    MultResultRowSignal === 1;


    // check columns of solved sudoku

    // hasNumberCol[i][j] means that the number i+1 is in the col j

    var hasNumberCol[9][9];

    for (var i = 0; i < 9; i++) {
       for (var j = 0; j < 9; j++) {
           hasNumberCol[solved[i][j]-1][j] = 1;
        }
    }

    var MultResultCol = 1;

    for (var i = 0; i < 9; i++) {
       for (var j = 0; j < 9; j++) {
           MultResultCol *= hasNumberCol[i][j];
        }
    }

    signal MultResultColSignal;
    MultResultColSignal <-- MultResultCol;

    MultResultColSignal === 1;


    // check squares of solved sudoku 

    // hasNumberSquare[i][j] means that the number j+1 is in the square i+1
    // Squares start from the top to the bottom, from the left to the right and from 1 to 9 both included 

    var hasNumberSquare[9][9];

    for (var i = 0; i < 9; i++) {
       for (var j = 0; j < 9; j++) {
           var k;
           if(i>=0 && i<=2 && j>=0 && j<=2){
               k = 0;
           }
           if(i>=0 && i<=2 && j>=3 && j<=5){
               k = 1;
           }
           if(i>=0 && i<=2 && j>=6 && j<=8){
               k = 2;
           }
           if(i>=3 && i<=5 && j>=0 && j<=2){
               k = 3;
           }
           if(i>=3 && i<=5 && j>=3 && j<=5){
               k = 4;
           }
           if(i>=3 && i<=5 && j>=6 && j<=8){
               k = 5;
           }
           if(i>=6 && i<=8 && j>=0 && j<=2){
               k = 6;
           }
           if(i>=6 && i<=8 && j>=3 && j<=5){
               k = 7;
           }
           if(i>=6 && i<=8 && j>=6 && j<=8){
               k = 8;
           }
           hasNumberSquare[k][solved[i][j]-1] = 1;
        }
    }

    var MultResultSquare = 1;

    for (var i = 0; i < 9; i++) {
       for (var j = 0; j < 9; j++) {
           MultResultSquare *= hasNumberSquare[i][j];
        }
    }

    signal MultResultSquareSignal;
    MultResultSquareSignal <-- MultResultSquare;

    MultResultSquareSignal === 1;
    
}

// unsolved is a public input signal. It is the unsolved sudoku
component main {public [unsolved]} = Sudoku();