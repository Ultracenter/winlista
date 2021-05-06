
#include "Trace.h"

void Trace(const char* file, int line, const char* nome, const char* conteudo)
{
 
  FILE* fd=fopen("debug.txt","at");

  if(fd)
  {
    fprintf(fd,"[%s] %d %s: [%s]\n",file,line,nome,conteudo);
    fflush(fd);
    fclose(fd);
  }
}

 
void NTrace(const char* file, int line, const char* nome, int conteudo)
{
  FILE* fd=fopen("debug.txt","at");
 
  if(fd)
  {
    fprintf(fd,"[%s] %d %s: [%d]\n",file,line,nome,conteudo);
    fflush(fd);
    fclose(fd);
  }
}


