
#include <stdio.h>
#include <io.h>
#include <time.h>
#include <direct.h>
#include <conio.h>
#include <ctype.h>
#include <windows.h>

void Dir(const char* path , int recursivo, void (*callback)(const char*))
{

  struct _finddata_t c_file;
  long   hFile=0;

  _chdir(path);

  memset(&c_file,0,sizeof(c_file));

  hFile = _findfirst("*.*", &c_file);

  callback(c_file.name);
 
  void TheDir()
  {
    if (!strcmp(c_file.name,".")) return;
    if (!strcmp(c_file.name,"..")) return;

    Dir(c_file.name,recursivo,callback);
    _chdir("..");
  }

  while(_findnext(hFile, &c_file) == 0)
  {
    callback(c_file.name);
    ((c_file.attrib & 16) && recursivo)
    ? 
    TheDir()
    : 
    0;
  }
  _findclose(hFile);
}


