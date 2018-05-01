void figure(int n) {
    int i, j;
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) if (i == 0 || i == n - 1 || i + j == n - 1) printf("*");
            else printf(" ");
        printf("\\n");
    }
    printf("\\n\\n\\n");
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            if ((i == j || i + j == n - 1) || (i >= j && i + j < n - 1) || (i <= j && i + j > n - 1)) if (j % 2 == 0) printf("0");
                else printf("1");
            else printf(" ");
        }
        printf("\\n");
    }
}