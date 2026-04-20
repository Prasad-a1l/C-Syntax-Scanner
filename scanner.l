%{
#include <stdio.h>
#include <string.h>

FILE *out;
%}

/* Definitions */
LETTER      [a-zA-Z]
DIGIT       [0-9]
ID          {LETTER}({LETTER}|{DIGIT})*
BADSTART    {DIGIT}+{LETTER}({LETTER}|{DIGIT})*
ILLEGALID   {LETTER}({LETTER}|{DIGIT})*[-@$]+({LETTER}|{DIGIT})*

%%

\#include[ ]*\<[^>]+\> {
    printf("Valid Preprocessor Directive: %s\n", yytext);
    fprintf(out,"Valid Preprocessor Directive: %s\n", yytext);
}

\"([^\\\"]|\\.)*\"   ;

int[ \t]+{ID}[ \t]*=[ \t]*{ID} {
    printf("Error: Integer variable assigned identifier value -> %s\n", yytext);
    fprintf(out,"Error: Integer variable assigned identifier value -> %s\n", yytext);
}

char[ \t]+{ID}[ \t]*=[ \t]*{ID} {
    printf("Error: Char variable assigned invalid identifier -> %s\n", yytext);
    fprintf(out,"Error: Char variable assigned invalid identifier -> %s\n", yytext);
}

{BADSTART} {
    printf("Error: Identifier cannot start with digit -> %s\n", yytext);
    fprintf(out,"Error: Identifier cannot start with digit -> %s\n", yytext);
}

{ILLEGALID} {
    printf("Error: Illegal character in identifier -> %s\n", yytext);
    fprintf(out,"Error: Illegal character in identifier -> %s\n", yytext);
}

{ID} {
    printf("Valid Identifier: %s\n", yytext);
    fprintf(out,"Valid Identifier: %s\n", yytext);
}

{DIGIT}+   ;

[=;,*(){}<>]   ;

[ \t\n]+   ;

\.   ;

. {
    printf("Unexpected character: %s\n", yytext);
    fprintf(out,"Unexpected character: %s\n", yytext);
}

%%

int main()
{
    FILE *in;

    in = fopen("Sinput.txt","r");
    if(in == NULL)
    {
        printf("Error: Cannot open Sinput.txt\n");
        return 1;
    }

    out = fopen("Soutput.txt","w");
    if(out == NULL)
    {
        printf("Error: Cannot create Soutput.txt\n");
        return 1;
    }

    yyin = in;

    yylex();

    fclose(in);
    fclose(out);

    printf("\nScanning completed. Output also saved in Soutput.txt\n");

    return 0;
}

int yywrap()
{
    return 1;
}