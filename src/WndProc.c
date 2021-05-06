
#include "WndProc.h"

HWND hWndlistbox;
HWND hWndOk;

LRESULT CALLBACK  WndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
    switch (uMsg)
    {

		case  WM_CREATE:
				hWndlistbox=Cabecalho(hWnd);
				Corpo(hWnd);
				hWndOk=Rodape(hWnd);
				Inicializa(hWndlistbox);
				PreencheListBox(hWndlistbox);
				return 0;

    	case 	WM_COMMAND:
				if (lParam==(LPARAM)hWndOk)
				{
					Grava(hWndlistbox);        	
				}
				if (lParam==(LPARAM)hWndlistbox)
				{
					Le(hWndlistbox);        	
				}
				return 0;

    	case 	WM_PAINT:
				{
					PAINTSTRUCT ps;
					HDC hdc = BeginPaint(hWnd, &ps);
					FillRect(hdc, &ps.rcPaint, (HBRUSH) (COLOR_WINDOW+1));
					EndPaint(hWnd, &ps);
				}
				return 0;

    	case 	WM_DESTROY:
				PostQuitMessage(0);
        		return 0;
    }

    return DefWindowProc(hWnd, uMsg, wParam, lParam);
}



