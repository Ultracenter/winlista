# This Makefile will build the MinGW Win32 application.

#HEADERS = include/callbacks.h include/resource.h
OBJS =	\
obj/asprintf.o\
obj/Dir.o\
obj/Lista.o\
obj/Trace.o\
obj/WinMain.o\
obj/WndProc.o

INCLUDE_DIRS = -I./include -I./res /usr/lib/gcc/x86_64-w64-mingw32/8.3-posix/include
#/usr/lib/gcc/i686-w64-mingw32/8.3-posix/include

WARNS = -Wall

#CC = i686-w64-mingw32-gcc
#CC = i686-w64-mingw32-gcc-win32
#CC = i686-w64-mingw32-gcc
CC = x86_64-w64-mingw32-gcc-win32

LDFLAGS = -s -lgdi32 -lcomctl32 -lcomdlg32 -Wl,--subsystem,windows 
RC = i686-w64-mingw32-windres
#RC = i686-w64-mingw32-windres

# Compile ANSI build only if CHARSET=ANSI
ifeq (${CHARSET}, ANSI)
  CFLAGS= -fdump-rtl-expand -O3 -std=c11 -D WINDOWS -D _WIN32_IE=0x0500 -D WINVER=0x500 ${WARNS}
else
  CFLAGS= -fdump-rtl-expand -O3 -std=c11 -D WINDOWS -D _WIN32_IE=0x0500 -D WINVER=0x500 ${WARNS}
endif


all: winmain.exe

winmain.exe: ${OBJS}
	${CC} ${CFLAGS} -o "$@" ${OBJS} ${LDFLAGS}

clean:
	rm -f obj/*.o "winmain.exe"

obj/%.o: src/%.c
#${HEADERS}
	${CC} ${CFLAGS} ${INCLUDE_DIRS} -c $< -o $@

obj/resource.o: res/resource.rc res/Application.manifest res/Application.ico res/resource.h
	${RC} -I.\include -I.\res -i $< -o $@



