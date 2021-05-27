// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

void  hsG_0__0 (struct dummyq_struct * I1256, EBLK  * I1250, U  I676);
void  hsG_0__0 (struct dummyq_struct * I1256, EBLK  * I1250, U  I676)
{
    U  I1511;
    U  I1512;
    U  I1513;
    struct futq * I1514;
    struct dummyq_struct * pQ = I1256;
    I1511 = ((U )vcs_clocks) + I676;
    I1513 = I1511 & ((1 << fHashTableSize) - 1);
    I1250->I718 = (EBLK  *)(-1);
    I1250->I722 = I1511;
    if (I1511 < (U )vcs_clocks) {
        I1512 = ((U  *)&vcs_clocks)[1];
        sched_millenium(pQ, I1250, I1512 + 1, I1511);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I676 == 1)) {
        I1250->I724 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I718 = I1250;
        peblkFutQ1Tail = I1250;
    }
    else if ((I1514 = pQ->I1156[I1513].I736)) {
        I1250->I724 = (struct eblk *)I1514->I735;
        I1514->I735->I718 = (RP )I1250;
        I1514->I735 = (RmaEblk  *)I1250;
    }
    else {
        sched_hsopt(pQ, I1250, I1511);
    }
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
