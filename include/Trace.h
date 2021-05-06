
#include <stdio.h>
#include <windows.h>

char* Tmp();
void Trace(const char* file, int line, const char* nome, const char* conteudo);
void NTrace(const char* file, int line, const char* nome, int conteudo);

#define XXX(x) Trace(__FILE__,__LINE__,#x,x);
#define NNN(x) NTrace(__FILE__,__LINE__,#x,(int)x);



