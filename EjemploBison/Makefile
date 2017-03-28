calculadora: calculadora.tab.c lex.yy.c main.c lista.h lista.c
			gcc calculadora.tab.c lex.yy.c main.c lista.c -lfl -lm -o calculadora

calculadora.tab.c calculadora.tab.h: calculadora.y
			bison -t -v -d calculadora.y

lex.yy.c: calculadora.l calculadora.tab.h
			flex --yylineno calculadora.l

run:	prueba.txt calculadora
		./calculadora prueba.txt

clean:
		rm calculadora calculadora.tab.* lex.yy.c
