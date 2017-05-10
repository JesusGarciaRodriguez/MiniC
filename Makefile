analizador: minic.tab.c lex.yy.c main.c listaVar.h listaVar.c codigo.h codigo.c listaStr.h listaStr.c
			gcc minic.tab.c lex.yy.c main.c listaVar.c codigo.c listaStr.c -lfl -lm -o analizador

minic.tab.c minic.tab.h: minic.y
			bison -t -v -d minic.y

lex.yy.c: minic.l minic.tab.h
			flex --yylineno minic.l

run:	prueba.txt analizador
		./analizador prueba.txt


clean:
		rm analizador minic.tab.* lex.yy.c
