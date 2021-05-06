
#include "Lista.h"

#define MAX 24
#define X 20
#define Y 20

char  atividade[MAX][500];
HWND  hatividade[MAX];

char  resultado[MAX][20];
HWND  hresultado[MAX];

HWND Cabecalho(HWND hWnd)
{
	CreateWindow("Static", " Hora", 	WS_CHILD | WS_VISIBLE, X+10,	Y+8, 	41,	20,	hWnd, NULL, NULL, NULL); 
	CreateWindow("Static", " Atividade", 	WS_CHILD | WS_VISIBLE, X+55,	Y+8, 	400,	20, 	hWnd, NULL, NULL, NULL); 
	CreateWindow("Static", " Resultado",	WS_CHILD | WS_VISIBLE, X+459,	Y+8,	100,	20, 	hWnd, NULL, NULL, NULL); 
	CreateWindow("Static", " Historico", 	WS_CHILD | WS_VISIBLE, X+565, 	Y+8,	100, 	20, 	hWnd, NULL, NULL, NULL); 

	HWND hWndListBox = CreateWindow(
            "listbox", 
            NULL, 
            WS_VISIBLE | WS_CHILD | LBS_STANDARD | LBS_NOTIFY, 
            X+565, 
            Y+35, 
            100, 
            544, 
            hWnd, 
            NULL, 
            (HINSTANCE)GetWindowLongPtr(hWnd, GWLP_HINSTANCE),
            NULL);

        if (!hWndListBox)
		MessageBox(NULL, "ListBox Failed.", "Error", MB_OK | MB_ICONERROR);

	return hWndListBox;
}

void Corpo(HWND hWnd)
{ 
	
	   static char titulo[21];
	   HWND hTitulo;
	
	   for (int x=0; x< MAX; x++)
	   {

		hTitulo=CreateWindow("Static", "Hora", 		WS_CHILD | WS_VISIBLE, X+10, Y+35+(x*24), 41, 18, hWnd, NULL, NULL, NULL); 

		sprintf(titulo," %d",x);

		SetWindowText(hTitulo,titulo);

		hatividade[x]=CreateWindow("Edit", "Conteudo", 	WS_CHILD | WS_VISIBLE | WS_BORDER, X+55,  Y+35+(x*24), 400, 18, hWnd, NULL, NULL, NULL); 
		hresultado[x]=CreateWindow("Edit", "resultado", WS_CHILD | WS_VISIBLE | WS_BORDER, X+459, Y+35+(x*24), 100, 18, hWnd, NULL, NULL, NULL); 

	   }

}


HWND Rodape(HWND hWnd)
{
	
		   HWND hWndButton = CreateWindow( 
		   "BUTTON",   // Predefined class; Unicode assumed 
		   "Gravar",   // Button text 
		   WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,  // Styles 
		   X+565,       // x position 
		   Y+MAX*24-3,  // y position 
		   100,         // Button width
		   33,          // Button height
		   hWnd,        // Parent window
		   NULL,        // No menu.
		   (HINSTANCE)GetWindowLongPtr(hWnd, GWLP_HINSTANCE), 
		   NULL);       // Pointer not needed.

		   return hWndButton;
}

char* ArqNovo()
{
		SYSTEMTIME s;
		GetSystemTime(&s); 

		char* hoje;
		asprintf(&hoje,"%04d%02d%02d.bin",s.wYear,s.wMonth,s.wDay);

		return hoje;
}

char* ArqLista(HWND hWndListBox)
{
	
	int posicao;
	const char a[101];
	char* arq;

	posicao=SendMessage(hWndListBox,LB_GETCURSEL,0,0);
	SendMessage(hWndListBox,LB_GETTEXT,posicao,(LPARAM)a);
	asprintf(&arq,"%c%c%c%c%c%c%c%c.bin",a[6],a[7],a[8],a[9],a[3],a[4],a[0],a[1]);

	return arq;
}

void PreencheListBox(HWND hWnd)
{

	void Preenche(const char* a)
	{
		if (strstr(a,".bin"))
		{
			char* p;
			asprintf(&p,"%c%c-%c%c-%c%c%c%c",a[6],a[7],a[4],a[5],a[0],a[1],a[2],a[3]);
			SendMessage(hWnd,LB_ADDSTRING,0,(LPARAM)p);
			free(p);
		}
	}

	Dir(".",NAO_RECURSIVO,Preenche);

	int total=SendMessage(hWnd,LB_GETCOUNT,0,0);

	SendMessage(hWnd,LB_SETCURSEL,total-1,0);

	SetFocus(hWnd);
}	

void Le(HWND hWndListBox)
{
	
	char* arq=ArqLista(hWndListBox);

	FILE* fd=fopen(arq,"rb");
	if (fd)
	{
		fread(&atividade,sizeof(atividade),1,fd);
		fread(&resultado,sizeof(resultado),1,fd);

		fclose(fd);
	}	
	free(arq);

	for (int x=0; x< MAX; x++)
	{
		SetWindowText(hatividade[x],atividade[x]);
		SetWindowText(hresultado[x],resultado[x]);
	}
}

void Grava(HWND hWndListBox)
{
    
	for (int x=0; x< MAX; x++)
	{
		GetWindowText(hatividade[x],atividade[x],sizeof(atividade[x]));
    		GetWindowText(hresultado[x],resultado[x],sizeof(resultado[x]));
	}

	char* arq=ArqLista(hWndListBox);

	FILE* fd=fopen(arq,"wb");
	if (fd)
	{
		fwrite(&atividade,sizeof(atividade),1,fd);
		fwrite(&resultado,sizeof(resultado),1,fd);
		fclose(fd);
	}	
	free(arq);
}

void Inicializa(HWND hWndListBox)
{
    
	char* arq=ArqNovo();

	if (access(arq,0))
	{
		FILE* fd=fopen(arq,"wb");
		if (fd)
		{
			fwrite(&atividade,sizeof(atividade),1,fd);
			fwrite(&resultado,sizeof(resultado),1,fd);
			fclose(fd);
		}	
		free(arq);
	}
}


