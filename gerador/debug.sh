#!/bin/bash


#usar : _debug $0 $LINENO nome_variavel "conteudo"

_debug()
{
    local a=`echo $1 | rev | cut -d '/' -f 1 | rev`
    echo "$a:$2 $3[$4]" >> debug.txt
}

