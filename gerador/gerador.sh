#!/bin/bash

. ./debug.sh


_shuffle() 
{
   local i tmp size max rand

   # $RANDOM % (i+1) is biased because of the limited range of $RANDOM
   # Compensate by using a range which is a multiple of the array size.
   size=${#vetor[*]}
   max=$(( 32768 / size * size ))

   for ((i=size-1; i>0; i--)); do
      while (( (rand=$RANDOM) >= max )); do :; done
      rand=$(( rand % (i+1) ))
      tmp=${vetor[i]} vetor[i]=${vetor[rand]} vetor[rand]=$tmp
   done
}

# Define the array named 'array'
#array=( 'a;' 'b;' 'c;' 'd;' 'e;' 'f;' )

#shuffle
#printf "%s" "${array[@]}"


_vetor()
{
	# Declaracao do vetor
	declare -a vetor
	# Associa o arquivo 10 com a entrada padrão
	exec 10<&0
	# Associa a entrada padrão com o primeiro argumento
	exec < cores.txt
	# inicia um contador
	i=0
	# faz a leitura do aquivo
	while read linha; do
	vetor[$i]=$linha
	((i++))
	done
#	n=${#vetor[@]}
#	echo "Numero de elementos: $n"
#	# echo "elementos do vetor"
#	i=0
#	while [ $i -lt $n ] ; do
#	echo "${vetor[$i]}"
#	((i++))
#	done
#	# recupera a entrada padrao
#	# e fecha o descritor de arquivos 10

	_shuffle

  vt=0
  for i in `ls *.expand 2> /dev/null`;
  do
    a=`echo $i | cut -d '.' -f 1`
	echo "${vetor[$vt]}" > "$a.cor"
	((vt++))
  done

  exec 0<&10 10<&-
  
}

grafos="grafos"

mkdir $grafos 2> /dev/null

dpi=50

_cabecalho()
{

echo "
digraph legenda {
        fontname = \"Sans\";
        rankdir=\"TB\";
        fontsize = 20;
        node [
                fontname = \"Sans\";
                fontsize = 20;
		       fontcolor = \"black\";
                shape = \"record\";
	       	       style=\"filled\";
	       	       fillcolor=\"white\";
		       nodesep=2.0;
        ]
        edge [
                fontname = \"Sans\";
                fontsize = 20;
        ]
		graph [ dpi = $dpi ];
"

}


_cluster_inicio()
{

  local label=$1
  local fontsize=$2
  local tipo=$3
  local cor=$4

  echo "
      subgraph cluster
    {
        rankdir=\"TB\";
	style=$tipo;
	color=\"$cor\";
	fontsize = $fontsize;
	label=\"\n$label\n\"
"
}

_cluster_final()
{
  echo "}"
  echo ""
}

_sem_prefixo()
{
	local sp=`echo $1 | cut -d '_' -f 2`
	len=${#sp}
	if [ $len -eq 0 ]
	then
	    let sp=$1
	fi
	echo $sp
}


_corte()
{
	local a=`grep " $1(" *.h | cut -d '.' -f 1  | cut -d ' ' -f 1 | tr '\n' '@'`
	local a1=`echo $a | cut -d '@' -f 1 `
	echo $a1
}

_nome()
{

	local a1=`_corte $1`

	local len=${#a1}
	if [ $len -eq 0 ]
	then
		a1=$1
	fi
	echo $a1
}

_cor1()
{
	# procura cor no arquivo .cor
	local b=$1".cor"
	local c=`cat $b 2> /dev/null`
	local len=${#c}
	if [ $len -gt 0 ]
	then
		echo $c
	fi
}

_cor2()
{
	# procura cor no header
	local a1=`_corte $1`
	local len=${#a1}
	if [ $len -gt 0 ]
	then
		_cor1 $a1
	fi
}

_cor()
{

	local len
	local nome
	local tam="26"
	local fonte="sans"
	local titulo

	local a=`_cor1 $1`


	len=${#a}
	if [ $len -gt 0 ]
	then
		nome=`_nome $1`

		echo "\"$1\" [ fontname=\"${fonte}\" fontsize =\"${tam}\" fillcolor=\"$a\" href=\"${nome}.html\" title=\"${titulo}\" target=\"_top\" ];"
		return
	fi

	local a=`_cor2 $1`

	local len=${#a}
	if [ $len -gt 0 ]
	then
		nome=`_nome $1`

		echo "\"$1\" [ fontname=\"${fonte}\" fontsize =\"${tam}\" fillcolor=\"$a\" href=\"${nome}.html\" title=\"${titulo}\" target=\"_top\"];"
		return
	fi
}

_palette()
{

  local tam="26"
  local fonte="sans"

  local cor
  local nome
  local len
  local arq_cor

  _cabecalho

  _cluster_inicio "" 20 dashed black

  local n=1

  for i in `cat cores.txt`;
  do
		echo "\"$n $i\" [ fontname=\"${fonte}\" fontsize =\"${tam}\" fillcolor=\"$i\"  title=\"${i}\" ];"
		echo "\"$n $i\" [ fontname=\"${fonte}\" fontsize =\"${tam}\" fillcolor=\"$i\"  title=\"${i}\" ];"
		let n=n+1
  done

  _cluster_final

  echo "}"
  echo ""

}


_legenda()
{

  local cor
  local nome
  local len
  local arq_cor

  local saida=$1

  _cabecalho

  _cluster_inicio "Legenda\n" 30 dashed gray40

  local a

  for i in `ls $grafos/*.html | cut -d '.' -f 1 2> /dev/null`;
  do
	a=`echo $i | cut -d '/' -f 2`
	_cor $a
  done

  _cluster_final

  echo "}"
  echo ""

}

_cores()
{

  _cluster_inicio "Cores" 1 filled white

  local cor=""

  for i in `cat $1 | cut -d ' ' -f 1  | sort | uniq | grep -v digraph | grep -v } | grep -v ^$ | cut -d '"' -f 2`;
  do
	_cor $i
  done

  for i in `cat $1 | cut -d ' ' -f 3  | sort | uniq | grep -v digraph | grep -v { | grep -v ^$ | cut -d '"' -f 2 | grep -v '#'`;
  do
	_cor $i
  done

  _cluster_final

  echo "}"
  echo ""

}


_corpo()
{

  local legenda=$1
  local titulo=$2
  local coringa=$3
  local saida=$4

  #_debug $0 $LINENO titulo $titulo
  #_debug $0 $LINENO coringa $coringa
  #_debug $0 $LINENO saida $saida
  

  local s=`ls $coringa  2> /dev/null`

  local pgm="dot"

  local len=${#s}

  if [ $len -gt 0 ]
  then

	  local convert="convert"

	  echo $titulo

	  # chamadas internas
	  ./egypt --include-external `ls $coringa` | grep -v __ | grep -v } | grep -v static | grep -v _Z | grep -v constprop > $saida.dot
	  _cores $saida.dot >> $saida.dot
	  ssed -i 's/dotted/solid/g' $saida.dot
	  cat $saida.dot | $pgm -Gdpi=$dpi -Gsplines=ortho -Grankdir=TB -Tsvg -o $saida"_int.svg"
	  cat $saida.dot | $pgm -Gdpi=$dpi*2 -Gsplines=ortho -Grankdir=TB -Tpng -o $saida"_int.png"

          # chamadas externas
	  ./egyptr --include-external `ls $coringa` | grep -v __ | grep -v } | grep -v static | grep -v _Z | grep -v constprop | sed "s/@4//g" | sed "s/@8//g" | sed "s/@12//g" | sed "s/@16//g" | sed "s/@20//g" | sed "s/@32//g" | sed "s/@64//g"     > $saida.dot
	  _cores $saida.dot >> $saida.dot
	  ssed -i 's/dotted/solid/g' $saida.dot
	  cat $saida.dot | $pgm -Gdpi=$dpi -Gsplines=true -Grankdir=LR -Tsvg -o $saida"_ext.svg"
	  cat $saida.dot | $pgm -Gdpi=$dpi*2 -Gsplines=true -Grankdir=LR -Tpng -o $saida"_ext.png"

	  local nome=`echo $saida | cut -d '/' -f 2`

	  echo "\
	  <html>\
		<style>\
			embed:focus { \
			outline: outset;\
		}\
		</style>\
	  	<center>\
			<table border=1>\
				<tr>\
					<td>\
						<font=Sans size=4>
						  	<center>\
								<font face=Sans size=5>\
			  					$nome\
								</font>\
						  	</center>\
				  		</font>\
					</td>\
				</tr>\
				<tr>\
					<td>\
						<big>\
						  	<center>\
								<embed type=\"image/svg+xml\" src=\"${nome}_int.svg\"/>\
						  	</center>\
						</big>\
					</td>\
				</tr>\
				<big>\
				<tr>\
					<td>\
					  	<center>\
							<embed type=\"image/svg+xml\" src=\"${nome}_ext.svg\"/>\
					  	</center>\
					</td>\
				</tr>\
				<tr>\
					<td>\
						<big>\
						</big>\
						<embed type=\"image/svg+xml\" src=\"legenda.svg\"/>\
					</td>\
				</tr>\
				<!--tr>\
					<td>\
						<big>\
						</big>\
						<embed type=\"image/svg+xml\" src=\"palette.svg\"/>\
					</td>\
				</tr-->\
				</iframe>\
			</table>\
		</td>
		</tr>
		</table>
	  	</center>\
	  </html>\
	  " > $saida".html"
  fi

}

_individual()
{
  for i in `ls *.cor | grep -v headers`;
  do
    a=`echo $i | cut -d '.' -f 1 | cut -d '/' -f 2`
    rm -f "$a.png" 2> /dev/null
    b=`echo $a | cut -d '/' -f 2`
    
        _corpo 0 $a "$b*.expand" $grafos/$a
#        _debug $0 $LINENO a $a
  done
}

_tudo()
{
   _corpo 0 "Tudo" "*.expand" $grafos/Tudo
}

make

ln -s obj/*.expand .
ln -s ./include/*.h .
ls -s ./src/*.c .

_vetor

rm *.dot 2> /dev/null

rm $grafos/* 2> /dev/null

len=${#1}
if [ $# -eq 1 ]
then
	for i in `echo $1`;
	do
	    #_debug $0 $LINENO i $i
	    _corpo 1 $i "$i*.expand" $grafos/$i
	done
else
	_individual
	_tudo
fi

_legenda "*.expand" > legenda.dot
cat legenda.dot | dot -Gdpi=$dpi -Gsplines=false -Grankdir=LR -Tsvg -o $grafos/legenda.svg

rm -f legenda.dot

#_palette > palette.dot
#cat palette.dot | dot -Gdpi=$dpi -Gsplines=false -Grankdir=LR -Tsvg -o $grafos/palette.svg

#cp cores.txt $grafos

_pwd=`pwd`
pwd=`echo $_pwd | rev | cut -c9- | rev`

echo "<big><big><center>$pwd</big></big></center><br><br>" > $grafos/index.tmp

echo "<br>" >> $grafos/index.tmp

for i in `ls $grafos/*.html`;
do
	a=`echo $i | cut -d '/' -f 2`
	b=`echo $a | cut -d '.' -f 1`
	echo "<li><a href=$a><font face=Sans size=4>$b</font></a></li><br>" >> $grafos/index.tmp
done

mv $grafos/index.tmp $grafos/index.html


rm -f $grafos/*.dot

rm -rf ../grafos
mv grafos ..

rm *.h 2> /dev/null
rm *.c 2> /dev/null
rm *.expand 2> /dev/null
rm *.cor 2> /dev/null


