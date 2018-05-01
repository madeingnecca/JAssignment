/* includere il file test_api.h situato durante il test in ../../test_api.h */
#include "../test_api.h"
#include "consegna.c"

int trustedSum( int* a, int len ) {
    int i, s = 0;
    for (i = 0; i < len; i++) {
        s += a[i];
    }
    return s;
}

int main() {

    int[] a = { 1,2,3,4,5,6 };
    int len = 6;
    
    if ( trustedSum(a,len) != sum(a,len) ) {
        test_error( "sum","sum_error","sum fallisce con input (%s,%d)", "{1,2,3,4,5,6}", 6 );
    }
        
    return no_errors();
}
