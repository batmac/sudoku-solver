#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


#define OMFG (-42)

/* int lint_test(){ int r; if (0) { return r; } } */

void print_sudoku( char b[9][9], char und);
int load_sudoku_from_file(const char * filename, char b[9][9]);
int resolvesudoku(char b[9][9]);
int constraints(char b[9][9], int x, int y);
int constraint_horiz(char b[9][9], int y);
int constraint_verti(char b[9][9], int x);
int constraint_regio(char b[9][9], int x, int y);

int rc_;
int bt_;

int main(int argc, char * argv[]) {

    int i,j;
    char * pathname = "sudoku.txt";
    char b[9][9] = {
        { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
        { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
        { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
        { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
        { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
        { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
        { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
        { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
        { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
    };


    if (argc > 1) pathname = argv[1];
    if (load_sudoku_from_file(pathname, b)) return -1;
    print_sudoku(b,'.');


    for (i=0; i<9; i++)
        for (j=0; j<9; j++)
            if (constraints(b, i, j)){
                printf("This board is not correct (%d,%d)\n", i, j);
                return -1;
            }

    printf("Working ...\n");
    rc_ = bt_ = 0;
    i = resolvesudoku(b);
    printf("(%dcalls[%d])\n", rc_,bt_);

    return (i == OMFG)?0:4;
}



void print_sudoku( char b[9][9], char und) {
    int i,j;
    char x, y, z;

    for (i=0; i< 9; i++) {
        if (!(i%3)) printf("+-------+-------+-------+\n");
        for (j=0; j<9; j+=3) {
            x=(b[i][j])?b[i][j]+0x30:und;
            y=(b[i][j+1])?b[i][j+1]+0x30:und;
            z=(b[i][j+2])?b[i][j+2]+0x30:und;
            printf("| %c %c %c ", x, y, z);
        }
        printf("|\n");
    }
    printf("+-------+-------+-------+\n");
}



int load_sudoku_from_file(const char * filename, char b[9][9]) {
    FILE * file;
    int i,j;

    file = fopen(filename, "r");
    if ( NULL == file ) {
        printf("unable to read %s\n", filename);
        return -1;
    }
    printf("Parsing %s ...\n", filename);

    for(i=0; i<9; i++) {
        int ret;
        ret = fscanf(file, "%c%c%c%c%c%c%c%c%c\n",
                     &b[i][0],&b[i][1],&b[i][2],&b[i][3],&b[i][4],
                     &b[i][5],&b[i][6],&b[i][7],&b[i][8]);
        if (ret!=9) {
            printf("KO, ret=%d", ret);
	    fclose(file);
            return -1;
        }
        if (ret == EOF) {
            printf("EOF (%d)\n", ret);
	    fclose(file);
            return -1;
        }
    }
    fclose(file);

    /* sanity check + conversion */
    for(i=0; i<9; i++)
        for(j=0; j<9; j++){
            if (b[i][j] < '0' || b[i][j] > '9'){
                printf("Parsing error\n");
                return -1;
            }
            b[i][j] = b[i][j] - 0x30 ; /* ascii code to integer */
        }
    return 0;
}




int resolvesudoku(char b[9][9]){
    /* BRUTE FORCE POWAAA :-s */

    int i,k,j;
    char b1[9][9];
    int m=0;

    rc_++;
    /*copie du tableau*/
    /*     memcpy(*b1,*b,9*9); */
    for (i=0; i<9; i++) {
        for (j=0; j<9; j++) {
            b1[i][j]=b[i][j] ;
        }
    }
    /* on cherche le premier element nul*/
    for (i=0; i<9  ; i++) {
        for (j=0; j<9 ; j++) {
            if (b1[i][j]==0){
                m=1;
                break;
            }
        }
        if (m==1) break;
    }
    if (i == 9 || j ==9 ) {
        printf(">_> <_< O_O ");
        printf("%d][%d\n",i,j);
        print_sudoku(b,'.');
        return OMFG;
    }

    for(k=1; k<=9; k++) {
        b1[i][j] = k;
        if (!constraints(b1, i, j)) {
            if (OMFG == resolvesudoku(b1)) 
                return OMFG;
            else {
                bt_++;
            }
        }
    }

    return -2; /* Nothing Found */
}


int constraints(char b[9][9], int x, int y){
    if (constraint_horiz(b, y)) return -1;
    if (constraint_verti(b, x)) return -1;
    if (constraint_regio(b, x, y)) return -1;
    return 0;
}

int constraint_horiz(char b[9][9], int y){
    char h[9];
    int i;
    for (i=0; i<9; i++) h[i]=0;
    for (i=0; i<9; i++) {
        if (b[i][y] != 0) {
            h[b[i][y]-1]++;
        }
    }
    for (i=0; i<9; i++) if (h[i] > 1) return -1;
    return 0;
}
int constraint_verti(char b[9][9], int x){
    char h[9];
    int i;
    for (i=0; i<9; i++) h[i]=0;
    for (i=0; i<9; i++) {
        if (b[x][i] != 0) {
            h[b[x][i]-1] ++;
        }
    }
    for (i=0; i<9; i++) if (h[i] > 1) return -1;
    return 0;
}
int constraint_regio(char b[9][9], int x, int y){
    char h[9];
    int i,j, region_x, region_y;
    for (i=0; i<9; i++) h[i]=0;

    region_x = x/3*3;
    region_y = y/3*3;

    for(i=0;i<3;i++)
        for(j=0;j<3;j++) {
            /*             printf("r_x=%d r_y=%d i=%d j=%d\n", region_x, region_y, i, j); */
            if (b[region_x+i][region_y+j] != 0) {
                h[b[region_x+i][region_y+j]-1] ++;
            }
        }
    for (i=0; i<9; i++) if (h[i] > 1) return -1;
    return 0;
}
