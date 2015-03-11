# Lex-Yacc-Parser

This is a concurrent Lex & Yacc parser. I developed this as an assignment in college. Here, the program reads values from a file, divides them into sets, and these sets are concurrently parsed. I have used pthreads to create threads. 

test.txt is the file to be parsed. It has 20 expressions in it for now.


To run this program:
- yacc -d parser.y
- lex parser.l
- cc lex.yy.c y.tab.c -o parser.exe -pthread


Keep the number of threads to be created high for concurrency to be visible. For example, 20 expressions will need 7 - 9 threads.
