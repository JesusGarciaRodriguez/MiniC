analizador : main.c lex.yy.c minic.h
	gcc main.c lex.yy.c -lfl -o analizador

lex.yy.c : minic.l
	flex --yylineno minic.l

clean :
	rm -f analizador lex.yy.c

run : analizador test
	./analizador test

