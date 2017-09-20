#!/usr/bin/env bash

sp_dir=~/Documents/speise_mail
sp_file=spplan.pdf
date_file=date.txt
date_format="%m-%d-%y"
sp_url=http://pgi-jcns.fz-juelich.de/pub/downloads/Speiseplan_naechste_Woche.pdf
sp_pic=spplan
sp_file_png=spplan.png

######################

days=( "MO" "DI" "MI" "DO" "FR" )
dishes=( "PIZZA" "GRILL" "OVO" "REGIO" "BEI" )

######################

PIZZA_UPPER=506
PIZZA_LOWER=758
PIZZA_DIFF=252

GRILL_UPPER=790
GRILL_LOWER=963
GRILL_DIFF=173

OVO_UPPER=996
OVO_LOWER=1071
OVO_DIFF=75

REGIO_UPPER=1122
REGIO_LOWER=1197
REGIO_DIFF=75

BEI_UPPER=1212
BEI_LOWER=1411
BEI_DIFF=208

######################

MO_LEFT=82
MO_RIGHT=308
MO_DIFF=226

DI_LEFT=310
DI_RIGHT=534
DI_DIFF=224

MI_LEFT=537
MI_RIGHT=761
MI_DIFF=224

DO_LEFT=763
DO_RIGHT=986
DO_DIFF=223

FR_LEFT=988
FR_RIGHT=1213
FR_DIFF=225

######################

MO_email_attach="" -a ${sp_dir}/MO*
DI_email_attach="" -a ${sp_dir}/DI*
MI_email_attach="" -a ${sp_dir}/MI*
DO_email_attach="" -a ${sp_dir}/DO*
FR_email_attach="" -a ${sp_dir}/FR*

######################

if [ ! -d $sp_dir ]; then
	mkdir -p $sp_dir
fi

cd $sp_dir

if [ ! -e $date_file ]; then
	wget $sp_url -O $sp_file;
  pdftoppm -f 1 -singlefile -png $sp_file $sp_pic;
	date +${date_format}>${date_file};
fi

date_var=`cat ${date_file}`
day=`echo ${date_var} | cut -d '-' -f 1`; day=`expr ${day} + 0`
month=`echo ${date_var} | cut -d '-' -f 2`; month=`expr ${month} + 0`
year=`echo ${date_var} | cut -d '-' -f 3`; year=`expr ${year} + 0`

date_now_var=`date +${date_format}`
day_now=`echo ${date_now_var} | cut -d '-' -f 1`; day_now=`expr ${day_now} + 0`
month_now=`echo ${date_now_var} | cut -d '-' -f 2`; month_now=`expr ${month_now} + 0`
year_now=`echo ${date_now_var} | cut -d '-' -f 3`; year_now=`expr ${year_now} + 0`

if ( ((${month_now}>${month})) || (($(expr ${day_now} - 6) > ${day})) || ((${year_now}>${year})) || true ); then
	rm *.png;
	rm ${sp_file};
	rm ${sp_pic};
	wget ${sp_url} -O ${sp_file};
	pdftoppm -f 1 -singlefile -png ${sp_file} ${sp_pic};
	date +${date_format}>${date_file};

	for day in "${days[@]}"; do
		for dish in "${dishes[@]}"; do
			daY_diff=${day}_DIFF;
			disH_diff=${dish}_DIFF;
			daY_left=${day}_LEFT;
			disH_upper=${dish}_UPPER;
			cp $sp_file_png tmp.png;
			convert -crop ${!daY_diff}x${!disH_diff}+${!daY_left}+${!disH_upper} tmp.png ${day}_${dish}.png;
		done
	done
fi

email_body="Das heutige Essen: (" date %A ", the " date %d ". of " date %B ")"

#for day in "${days[@]}"; do
# implement some fancy emailing thingamadoo
