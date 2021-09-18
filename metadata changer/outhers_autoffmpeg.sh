#!/bin/bash
f1()
{
	for i in *; do
		if [ 0 -ne $i ] 2>/dev/null; then
			cd $i
			for f in *.mp4; do
					echo "\e[31mcut '$i' sec. from the beginning of '$f'\e[0m"
					echo "\e[5m'$f' \e[25m"
					sleep 1
					titlemp4=$(echo $f | cut -d'-' -f 3)
					title=$(echo $titlemp4 | rev | cut -c5- | rev)
					echo "\e[33mnew metadata title is '$title'\e[0m"
					ffmpeg -i "$f" -map_metadata -1 -metadata title="$title" -ss "$i" -vcodec copy -acodec copy -y "../$f" 2>/dev/null
					mkdir -p "../finish"
					echo "\e[32mmove '$f' to '../finish/$f'\e[0m"
					mv "$f" "../finish/$f"
			done
			cd ..
		fi
	done
}

f2()
{
	for i in *; do
		if [ "$i" = "smeta" ] 2>/dev/null; then
			cd $i
			for f in *.mp4; do
					echo "\e[31mremove meta data from: '$f'\e[0m"
					echo "\e[5m'$f' \e[25m"
					sleep 1
					titlemp4=$(echo $f | cut -d'-' -f 3)
					title=$(echo $titlemp4 | rev | cut -c5- | rev)
					echo "\e[33mnew title '$title'\e[0m"
					ffmpeg -i "$f" -map_metadata -1 -metadata title="$title" -c:v copy -c:a copy -y "../$f" 2>/dev/null
					mkdir -p "../finish"
					echo "\e[32mmove "$f" to "../finish/$f"\e[0m"
					mv "$f" "../finish/$f"
			done
			cd ..
		fi
	done
}

for D in ./*; do
	if [ -d "$D" ]; then
			cd "$D"
			f1
			f2
		for DD in ./*; do
			if [ -d "$DD" ]; then
				cd "$DD"
				f1
				f2
				for DDD in ./*; do
					if [ -d "$DDD" ]; then
						cd "$DDD"
						f1
						f2
						pwd
						cd ..
					fi
				done
				pwd
				cd ..
			fi
		done
		pwd
		cd ..
	fi
done
