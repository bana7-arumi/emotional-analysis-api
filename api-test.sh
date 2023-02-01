#!/bin/bash

END_POINT="http://127.0.0.1:8000/inference"
CONTENT_TYPE="Content-Type: application/json"

function post() {
  curl -X POST -H "${CONTENT_TYPE}" \
    -d '{"text": "'$1'"}' "${END_POINT}" \
    -w "response_time:%{time_total}\n\n" \
    -o /dev/null -s 2>/dev/null
  sleep 1
}

function parallel_post() {
  seq $1 | xargs -I{} -P$1 \
    curl -X POST -H "${CONTENT_TYPE}" \
      -d '{"text": "'$2'"}' "${END_POINT}" \
      -w "%{time_total}\n" \
      -o /dev/null -s 2>/dev/null \
  | awk '{sum+=$1} END {print sum/NR}'
  sleep 1
}

# 8 characters
echo -e "8 characters"
post "親譲りの無鉄砲で"

# 32 characters
echo "32 characters"
post "親譲りの無鉄砲で小供の時から損ばかりしている。小学校に居る時分学"

# 128 characters
echo "128 characters"
post "親譲りの無鉄砲で小供の時から損ばかりしている。小学校に居る時分学校の二階から飛び降りて一週間ほど腰を抜かした事がある。なぜそんな無闇をしたと聞く人があるかも知れぬ。別段深い理由でもない。新築の二階から首を出していたら、同級生の一人が冗談に、いくら威張っても"

# 512 characters (tesnor size)
echo "512 characters (tensor size)"
post "親譲りの無鉄砲で小供の時から損ばかりしている。小学校に居る時分学校の二階から飛び降りて一週間ほど腰を抜かした事がある。なぜそんな無闇をしたと聞く人があるかも知れぬ。別段深い理由でもない。新築の二階から首を出していたら、同級生の一人が冗談に、いくら威張っても、そこから飛び降りる事は出来まい。弱虫やーい。と囃したからである。小使に負ぶさって帰って来た時、おやじが大きな眼をして二階ぐらいから飛び降りて腰を抜かす奴があるかと云ったから、この次は抜かさずに飛んで見せますと答えた。（青空文庫より）親譲りの無鉄砲で小供の時から損ばかりしている。小学校に居る時分学校の二階から飛び降りて一週間ほど腰を抜かした事がある。なぜそんな無闇をしたと聞く人があるかも知れぬ。別段深い理由でもない。新築の二階から首を出していたら、同級生の一人が冗談に、いくら威張っても、そこから飛び降りる事は出来まい。弱虫やーい。と囃したからである。小使に負ぶさって帰って来た時、おやじが大きな眼をして二階ぐらいから飛び降りて腰を抜かす奴があるかと云ったから、この次は抜かさずに飛んで見せますと答えた。（青空文庫より）親譲りの無鉄砲で小供の時から損ばかりしている"

# parallel request

TEXT="おやすみおはよう"

# 1 parallel
echo "1 parallel"
parallel_post 1 $TEXT

# 10 parallel
echo "10 parallel"
parallel_post 10 $TEXT

echo "100 parallel"
parallel_post 100 $TEXT

echo "1000 parallel"
parallel_post 1000 $TEXT
