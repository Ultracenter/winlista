
#include <windows.h>
#include <winuser.h>

#include <stdio.h>

#include "asprintf.h"
#include "Dir.h"

#include "Trace.h"

char* ArqNovo();
char* ArqLista(HWND);

void Inicializa(HWND);
void PreencheListBox(HWND);
void Preenche(const char*);

void Cria(HWND);
void Le(HWND);
void Grava(HWND);

HWND Cabecalho(HWND);
void Corpo(HWND);
HWND Rodape(HWND);



