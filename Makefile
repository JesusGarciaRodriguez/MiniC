analizador: minic.tab.c lex.yy.c main.c lista.h lista.c
			gcc minic.tab.c lex.yy.c main.c lista.c -lfl -lm -o minic

minic.tab.c minic.tab.h: minic.y
			bison -t -v -d minic.y

lex.yy.c: minic.l minic.tab.h
			flex --yylineno minic.l

run:	prueba.txt minic
		./analizador prueba.txt

clean:
		rm analizador minic.tab.* lex.yy.c
