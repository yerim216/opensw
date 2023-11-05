echo "-------------------------- 
User Name : Park Yerim 
Student Number : 12212507 
[ MENU ]
1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
2. Get the data of action genre movies from 'u.item’
3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’
4. Delete the ‘IMDb URL’ from ‘u.item
5. Get the data about users from 'u.user’
6. Modify the format of 'release date' in 'u.item’
7. Get the data of movies rated by a specific 'user id' from 'u.data'
8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
9. Exit
--------------------------"

while true; do
    read -p "Enter your choice [ 1-9 ]: " number
    case "$number" in
        1)
	echo "Please enter 'movie id' (1~1682):"
	read movie_id

	awk -F '|' -v movie_id="$movie_id" '$1 == movie_id {print}' u.item

 	;;
        2)
	echo "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n)"
	read user_input

	if [ "$user_input" = "y" ]; then
		awk -F '|' '$7 == 1 {print $1, $2}' u.item | head -n 10

	fi
	;;

        3)
	echo "Please enter the 'movie id’(1~1682):"
	read movie_id
  	echo -n "average rating of ‘movie id’:"	
	average_rating=$(awk -F '\t' -v movie_id="$movie_id" '$2 == movie_id { sum += $3; count++ } END { if (count > 0) print sum / count; else print 0; }' u.data)
	
  	  printf "%.5f\n" $average_rating
        ;;
        4)
	echo "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n)"
        read user_input

        if [ "$user_input" = "y" ]; then
		sed 's/[^|]*|//5' u.item | head -n 10
	fi
        ;;
        5)
	echo "Do you want to get the data about users from ‘u.user’?(y/n)"
    	read user_input

	if [ "$user_input" = "y" ]; then
    		head -n 10 u.user | awk -F '|' '{
        	gender = ($3 == "F") ? "female" : "male"
        printf "user %s is %s years old %s %s\n", $1, $2, gender, $4
   	 }'
	fi

	;;
        6)
	echo "Do you want to Modify the format of ‘release data’ in ‘u.item’?(y/n)"
	 read user_input

	if [ "$user_input" = "y" ]; then
    	awk -F '|' '{
        	split($3, date, "-")
        	day = date[1]
        	year = date[3]

        	if (date[2] == "Jan") {
            	month_num = 1
        	} else if (date[2] == "Feb") {
            	month_num = 2
        	} else if (date[2] == "Mar") {
            	month_num = 3
        	} else if (date[2] == "Apr") {
            	month_num = 4
        	} else if (date[2] == "May") {
            	month_num = 5
        	} else if (date[2] == "Jun") {
            	month_num = 6
        	} else if (date[2] == "Jul") {
            	month_num = 7
        	} else if (date[2] == "Aug") {
            	month_num = 8
        	} else if (date[2] == "Sep") {
            	month_num = 9
        	} else if (date[2] == "Oct") {
            	month_num = 10
        	} else if (date[2] == "Nov") {
            	month_num = 11
        	} else if (date[2] == "Dec") {
            	month_num = 12
        	}	
		if($1>=1673 && $1<=1682){
 		printf "%s|%s|%d%02d%02d", $1, $2, year, month_num, day
            	for (i = 4; i <= NF; i++) {
                	printf "|%s", $i
            	}
            	printf "\n"
		}
 	}' u.item | head -n 10
	fi
            ;;
  7)
            echo "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n)"
            read user_input

            if [ "$user_input" = "y" ]; then
                echo "Please enter 'user id' (1~943):"
                read user_id

                if [ "$user_id" -ge 1 ] && [ "$user_id" -le 943 ]; then
                    # 사용자의 나이가 20에서 29 사이이고 직업이 'programmer'인 사용자를 필터링
                    user_ids=$(awk -F '|' -v user_id="$user_id" '($2 >= 20 && $2 <= 29) && ($4 == "programmer") {print $1}' u.user)

                    if [ -n "$user_ids" ]; then
                        # 해당 사용자들이 평가한 영화의 평점을 추출하여 평균을 계산
                        average_ratings=$(awk -F '\t' -v user_ids="$user_ids" '
                            BEGIN {
                                split(user_ids, ids, " ");
                                for (i in ids) {
                                    ratings[ids[i]] = 0;
                                    counts[ids[i]] = 0;
                                }
                            }
                            { if ($1 in ids) { ratings[$1] += $3; counts[$1]++; } }
                            END {
                                for (id in ids) {
                                    if (counts[id] > 0) {
                                        avg = ratings[id] / counts[id];
                                        printf "%d %.6f\n", id, avg;
                                    }
                                }
                            }
                        ' u.data | sort -n)

                        if [ -n "$average_ratings" ]; then
                            echo "Movie ID | Average Rating"
                            echo "$average_ratings"
                        else
                            echo "No ratings found for programmers in their 20s."
                        fi
                    else
                        echo "No programmers found with the specified criteria."
                    fi
                else
                    echo "Invalid user ID. Please enter a valid user ID (1~943)."
                fi
            fi
            ;;
        8)
            echo "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n)"
            read user_input

            if [ "$user_input" = "y" ]; then
                # 사용자의 나이가 20에서 29 사이이고 직업이 'programmer'인 사용자를 필터링하고 user IDs를 output.txt 파일에 저장
                awk -F '|' -v user_id="$user_id" '($2 >= 20 && $2 <= 29) && ($4 == "programmer") {print $1}' u.user > output.txt

                # output.txt 파일에 나열된 사용자의 영화 평점을 계산
                awk 'FNR==NR { userid[$1]=1; }
                FNR!=NR {
                    if ($1 in userid) {
                        sum_rating[$2] += $3;
                        count[$2]++;
                    }
                }
                END {
                    for (movieid in sum_rating) {
                        if (count[movieid] > 0) {
                            average = sum_rating[movieid] / count[movieid];
                            printf "%d %.6f\n", movieid, average;
                        }
                    }
                }' output.txt u.data | sort -n
            fi
            ;;
        9)
            echo "Bye!"
            break
            ;;
        *)
            echo "1부터 9까지의 유효한 수를 입력하세요."
            ;;
    esac
done
9)
    echo "Bye!"
    break
    ;;
*)
    echo "1부터 9까지의 유효한 수를 입력하세요."
    ;;
esac
